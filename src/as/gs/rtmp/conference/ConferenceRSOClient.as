package gs.rtmp.conference
{
	import gs.rtmp.rso.RemoteSharedObjectClient;
	
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	/**
	 * The ConferenceRSOClient is a base remote shared object
	 * client for conferences. This class implements enough
	 * logic to manage users in a room and synchronize the room's
	 * connected users.
	 */
	public class ConferenceRSOClient extends RemoteSharedObjectClient
	{
		
		/**
		 * The ident time to wait before considering
		 * the ident complete, and removing users that
		 * didn't respond.
		 */
		public static var identTimeout:int;
		
		/**
		 * Current users in the room.
		 */
		protected var users:Array;
		
		/**
		 * My ConferenceUser.
		 */
		public var me:ConferenceUser;
		
		/**
		 * Whether or not i'm the one who sent the
		 * "ident" request.
		 */
		protected var sentIdent:Boolean;
		
		/**
		 * A duplicate of the users variable right
		 * before an ident is sent.
		 */
		protected var usersAtIdentTime:Array;
		
		/**
		 * The ident timeout id.
		 */
		protected var identTimeoutId:Number;
		
		//bunch of vars for ping - will com back to it.
		protected var sentPingRequest:Boolean;
		protected var usersNotResponding:Array;
		protected var usersAtPingTime:Array;
		protected var pingCompleteTimeoutId:Number;
		protected var pingCompleteTimeout:int=2000;
		protected var completedPings:int;
		protected var pingsToCompleteBeforeSync:int;
		protected var pingInterval:int=4000;
		protected var pingIntervalId:Number;
		protected var hasCompletedPing:Boolean;
		protected var sentStopPinging:Boolean;
		protected var canResetPingTimeUsers:Boolean;
		
		/**
		 * Constructor for ConferenceRSOClient instances.
		 */
		public function ConferenceRSOClient()
		{
			super();
			hasCompletedPing=true;
			canResetPingTimeUsers=true;
			usersNotResponding=[];
			completedPings=0;
			pingsToCompleteBeforeSync=3;
			if(!identTimeout)identTimeout=2000;
		}
		
		public function startPing():void
		{
			return;
			sentStopPinging=true;
			rso.send("stopPinging");
			pingIntervalId=setInterval(sendPing,pingInterval);
		}
		
		public function stopPinging():void
		{
			sentPingRequest=false;
			if(sentStopPinging)
			{
				sentStopPinging=false;
				return;
			}
			clearInterval(pingIntervalId);
		}
		
		protected function sendPing():void
		{
			if(!hasCompletedPing) return;
			if(canResetPingTimeUsers)
			{
				if(users)usersAtPingTime=users.concat();
				else usersAtPingTime=[];
				var i:int=0;
				var l:int=usersAtPingTime.length;
				var cu:ConferenceUser;
				for(i;i<l;i++)
				{
					//if(!usersAtPingTime)break;
					cu=ConferenceUser(usersAtPingTime[i]);
					if(cu.isEqual(me)) usersAtPingTime.splice(i,1); 
				}
				canResetPingTimeUsers=false;
			}
			hasCompletedPing=false;
			sentPingRequest=true;
			pingCompleteTimeoutId=setTimeout(onPingComplete,pingCompleteTimeout);
			rso.send("ping");
		}
		
		public function ping():void
		{
			if(sentPingRequest) return;
			trace("received ping, sending response");
			rso.send("pingResponse",me);
		}
		
		public function pingResponse(respondingUser:ConferenceUser):void
		{
			if(!sentPingRequest)return;
			//if(!usersAtPingTime)return;
			trace("ping response from user:",respondingUser.username);
			var i:int=0;
			var l:int=usersAtPingTime.length;
			var cu:ConferenceUser;
			for(i;i<l;i++)
			{
				//if(!usersAtPingTime)break;
				cu=ConferenceUser(usersAtPingTime[i]);
				if(!cu)continue;
				if(cu.isEqual(respondingUser)) usersAtPingTime.splice(i,1);
			}
		}
		
		protected function onPingComplete():void
		{
			if(!sentPingRequest) return;
			trace("onPingComplete()");
			trace("USERS AT PING TIME:",usersAtPingTime);
			clearTimeout(pingCompleteTimeoutId);
			usersNotResponding.concat(usersAtPingTime);
			completedPings++;
			hasCompletedPing=true;
			if(completedPings == pingsToCompleteBeforeSync)
			{
				trace("INVALIDATE USERS");
				trace("users not responding: ",usersNotResponding);
				var cu:ConferenceUser;
				var i:int=0;
				var l:int=usersNotResponding.length;
				for(i;i<l;i++)
				{
					cu=usersNotResponding[i];
					//if(me.isEqual(cu)) continue;
					trace("SHOULD REMOVE USER: ",cu.username);
					removeUser(usersNotResponding[i]);
				}
				usersNotResponding=[];
				canResetPingTimeUsers=true;
				completedPings=0;
			}
		}
		
		/**
		 * Initiates sending the ident message request.
		 */
		public function sendIdent():void
		{
			if(users)usersAtIdentTime=users.concat();
			else usersAtIdentTime=[];
			if(users && users.length < 1) dispatchEvent(new ConferenceEvent(ConferenceEvent.USER_IDENT_COMPLETE,true,false));
			else
			{
				sentIdent=true;
				identTimeoutId=setTimeout(onIdentComplete,identTimeout);
				dispatchEvent(new ConferenceEvent(ConferenceEvent.USER_IDENT,true,false));
				rso.send("ident");
			}
		}
		
		/**
		 * Ident message - this is a callback for the RSO.
		 */
		public function ident():void
		{
			if(sentIdent) return;
			rso.send("identResponse",me);
		}
		
		/**
		 * Ident response message - this is a callback for the RSO.
		 */
		public function identResponse(respondingUser:ConferenceUser):void
		{
			if(!sentIdent) return;
			if(!usersAtIdentTime) return;
			var i:int=0;
			var l:int=usersAtIdentTime.length;
			var cu:ConferenceUser;
			for(i;i<l;i++)
			{
				if(!usersAtIdentTime)break;
				cu=ConferenceUser(usersAtIdentTime[i]);
				if(!cu)continue;
				if(cu.isEqual(respondingUser))usersAtIdentTime.splice(i,1);
			}
			if(usersAtIdentTime.length<1)
			{
				sentIdent=false;
				onIdentComplete();
			}
		}
		
		/**
		 * When the ident is complete.
		 */
		protected function onIdentComplete():void
		{
			clearTimeout(identTimeoutId);
			sentIdent=false;
			if(usersAtIdentTime.length>0)
			{
				var i:int=0;
				var l:int=usersAtIdentTime.length;
				for(i;i<l;i++)removeUser(ConferenceUser(usersAtIdentTime[i]));
			}
			usersAtIdentTime=null;
			dispatchEvent(new ConferenceEvent(ConferenceEvent.USER_IDENT_COMPLETE,true,false));
		}
		
		/**
		 * Check if a user is in the room.
		 */
		public function isUserInRoom(user:ConferenceUser):Boolean
		{
			if(findUser(user) > -1) return true;
			return false;
		}
		
		/**
		 * Returns an array of usernames.
		 */
		public function getUserNames():Array
		{
			if(!users) return[];
			if(users.length<1)return [];
			var a:Array=[];
			var i:int=0;
			var l:int=users.length;
			for(i;i<l;i++) a.push(users[i].username);
			return a;
		}
		
		/**
		 * Adds a user to the room.
		 */
		public function addUser(user:ConferenceUser):void
		{
			if(findUser(user) > -1)return;
			me=user;
			users.push(user);
			rso.setProperty("users",users);
			rso.setDirty("users");
		}
		
		/**
		 * Removes a user from the room.
		 */	
		public function removeUser(user:ConferenceUser):void
		{
			var idx:int=findUser(user);
			if(idx<0)return;
			users.splice(idx,1);
			dirtyUsers();
		}
		
		/**
		 * Find a user - this is a helper to find the index of
		 * a user in the users array.
		 */
		protected function findUser(user:ConferenceUser):int
		{
			if(!users) users=[];
			if(users.length < 1) return -1;
			var i:int=0;
			var l:int=users.length;
			var au:ConferenceUser;
			for(i;i<l;i++) 
			{
				au=newConferenceUserFromObject(users[i]);
				if(au.isUsernameEqual(user)) return i;
			}
			return -1;
		}
		
		/**
		 * Helper to create a new ConfereneUser from a object.
		 */
		protected function newConferenceUserFromObject(o:*):ConferenceUser
		{
			var c:ConferenceUser = new ConferenceUser();
			c.initFromObject(o);
			return c;
		}
		
		/**
		 * Sets the users property on the RSO, and marks
		 * it dirty which will cause a sync.
		 */
		protected function dirtyUsers():void
		{
			rso.setProperty("users",users);
			rso.setDirty("users");
		}
		
		/**
		 * A helper you can use to manually kill all users - 
		 * this is mostly for testing.
		 */
		public function reset():void
		{
			users=null;
		}
	}
}