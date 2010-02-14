package gs.rtmp.conference
{
	import gs.rtmp.core.RTMPClient;
	import gs.rtmp.core.RTMPEvent;
	import gs.rtmp.rso.RSOEvent;
	import gs.rtmp.rso.RemoteSharedObject;
	
	import flash.events.EventDispatcher;
	import flash.net.registerClassAlias;
	
	/**
	 * The ConferenceRoom class is a base room you
	 * that uses a remote shared object as a room.
	 */
	public class ConferenceRoom extends EventDispatcher
	{
		
		/**
		 * The room name.
		 */
		public var room:String;
		
		/**
		 * The remote shared object.
		 */
		protected var rso:RemoteSharedObject;
		
		/**
		 * A RemoteSharedObjectClient.
		 */
		protected var client:*;
		
		/**
		 * A user queue for adding new users before
		 * the room is connected.
		 */
		protected var userQueue:Array;
		
		/**
		 * Constructor for ConferenceRoom instances.
		 */
		public function ConferenceRoom(roomName:String,syncFrequency:int=31)
		{
			registerClassAliases();
			room=roomName;
			rso=new RemoteSharedObject(true,false);
			rso.name=roomName;
			rso.syncFrequency=syncFrequency;
			initRSOClient();
			setRSOClient();
		}
		
		/**
		 * Set's the rso client.
		 */
		private function setRSOClient():void
		{
			rso.client=client;
		}
		
		/**
		 * A hook you should override to setup your own
		 * client variable.
		 */
		protected function initRSOClient():void
		{
			client=new ConferenceRSOClient();
		}
		
		/**
		 * Initialize this room from another RTMP client.
		 */
		public function initFromRTPMClient(client:RTMPClient):void
		{
			rso.initFromOtherClient(client);
		}
		
		/**
		 * A hook you should use to register class aliases
		 * (flash.net.registerClassAlias) for deserialization.
		 */
		protected function registerClassAliases():void
		{
			registerClassAlias("gs.rtmp.conference.ConferenceUser",ConferenceUser);
		}
		
		/**
		 * Whether or not this room is connected.
		 */
		public function get connected():Boolean
		{
			if(!rso) return false;
			return rso.connected;
		}
		
		/**
		 * Connect this room.
		 */
		public function connect():void
		{
			if(!rso) return;
			addListeners();
			dispatchEvent(new ConferenceEvent(ConferenceEvent.ROOM_CONNECTING,true,false,null,room));
			rso.connect();
		}
		
		/**
		 * Add a new user.
		 */
		public function addUser(user:ConferenceUser):void
		{
			if(!user) return;
			client.addUser(user);
		}
		
		/**
		 * Remove a user from the room.
		 */
		public function removeUser(user:ConferenceUser):void
		{
			if(!user) return;
			client.removeUser(user);
		}
		
		/**
		 * Causes the client.me user ro leave this room.
		 */
		public function leaveRoom():void
		{
			if(!client)return;
			removeUser(client.me);
		}
		
		/**
		 * Check if a user is in the room.
		 */
		public function isUserInRoom(user:ConferenceUser):Boolean
		{
			return client.isUserInRoom(user);
		}
		
		/**
		 * Enqueue a user to be added.
		 */
		public function queueUser(user:ConferenceUser):void
		{
			if(!userQueue)userQueue=[];
			userQueue.unshift(user);
		}
		
		/**
		 * Dequeue all users (call addUser() for each user).
		 */
		public function dequeueUsers():void
		{
			while(userQueue.length > 0) client.addUser(userQueue.pop());
		}
		
		/**
		 * Get an array of usernames.
		 */
		public function getUserNames():Array
		{
			return client.getUserNames();
		}
		
		/**
		 * Reset the room.
		 */
		public function reset():void
		{
			client.reset();
		}
		
		/**
		 * Removes listeners from the rso.
		 */
		protected function removeListeners():void
		{
			if(!rso) return;
			rso.removeEventListener(RTMPEvent.CONNECTED,onRSOConnected);
			rso.removeEventListener(RTMPEvent.CONNECTION_ATTEMPT,onRSOAttempt);
			rso.removeEventListener(RTMPEvent.CONNECTION_FAILED,onRSOConnectFailed);
			rso.removeEventListener(ConferenceEvent.FIRST_SYNC,onFirstSync);
			rso.removeEventListener(RSOEvent.SYNC_TIMEOUT,onFirstSyncTimeout);
		}
		
		/**
		 * Adds listeners to the rso.
		 */
		protected function addListeners():void
		{
			if(!rso) return;
			rso.addEventListener(RTMPEvent.CONNECTED,onRSOConnected,false,10,true);
			rso.addEventListener(RTMPEvent.CONNECTION_ATTEMPT,onRSOAttempt,false,10,true);
			rso.addEventListener(RTMPEvent.CONNECTION_FAILED,onRSOConnectFailed,false,10,true);
			rso.addEventListener(ConferenceEvent.FIRST_SYNC,onFirstSync,false,10,true);
			rso.addEventListener(RSOEvent.SYNC_TIMEOUT,onFirstSyncTimeout,false,10,true);
		}
		
		/**
		 * When the first sync times out (never happens).
		 */
		protected function onFirstSyncTimeout(r:RSOEvent):void
		{
			r.stopImmediatePropagation();
			r.stopPropagation();
			if(!rso) return;
			dispatchEvent(new ConferenceEvent(ConferenceEvent.ROOM_CONNECT_FAILED,true,false,null,rso.name));
		}
		
		/**
		 * After first sync.
		 */
		protected function onFirstSync(e:ConferenceEvent):void
		{
			if(!room) return;
			dispatchEvent(new ConferenceEvent(ConferenceEvent.FIRST_SYNC,true,false,null,room));
		}
		
		/**
		 * When an attempt to connect to the server happens
		 * in from the RSO.
		 */
		protected function onRSOAttempt(re:RTMPEvent):void
		{
			re.stopImmediatePropagation();
			re.stopPropagation();
			if(!room) return;
			dispatchEvent(new ConferenceEvent(ConferenceEvent.ROOM_CONNECT_ATTEMPT,true,false,null,room));
		}
		
		/**
		 * When the rso is connected. This method does not dispatch
		 * a complete event immediatley, it first requests all
		 * connected clients to send an IDENT to synchronize who's
		 * in the room.
		 */
		protected function onRSOConnected(e:RTMPEvent):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			if(!rso) return;
			if(!client)
			{
				trace("WARNING: The {client} property wasn't set on the ConferenceRoom");
				return;
			}
			client.addEventListener(ConferenceEvent.USER_IDENT,onUserIdent);
			client.addEventListener(ConferenceEvent.USER_IDENT_COMPLETE,onUserIdentComplete);
			client.sendIdent();
			//dispatchEvent(new ConferenceEvent(ConferenceEvent.ROOM_CONNECTED,true,false,null,rso.name));
		}
		
		/**
		 * When the RSO connection fails.
		 */
		protected function onRSOConnectFailed(e:RTMPEvent):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			if(!rso) return;
			dispatchEvent(new ConferenceEvent(ConferenceEvent.ROOM_CONNECT_FAILED,true,false,null,rso.name));
		}
		
		/**
		 * When an ident message initiates.
		 */
		private function onUserIdent(e:ConferenceEvent):void
		{
			dispatchEvent(new ConferenceEvent(ConferenceEvent.USER_IDENT,true,false));
		}
		
		/**
		 * After the ident messaging is complete.
		 */
		private function onUserIdentComplete(e:ConferenceEvent):void
		{
			client.removeEventListener(ConferenceEvent.USER_IDENT_COMPLETE,onUserIdentComplete);
			dispatchEvent(new ConferenceEvent(ConferenceEvent.USER_IDENT_COMPLETE,true,false,null,rso.name));
			dispatchEvent(new ConferenceEvent(ConferenceEvent.ROOM_CONNECTED,true,false,null,rso.name));
			client.startPing();
		}
		
		/**
		 * Dispose of this room.
		 */
		public function dispose():void
		{
			removeListeners();
			if(client)client.dispose();
			if(rso)rso.dispose();
			rso=null;
			room=null;
			client=null;
		}
	}
}