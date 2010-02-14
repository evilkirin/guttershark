package gs.rtmp.conference
{
	import com.adobe.crypto.MD5;
	
	/**
	 * The ConferenceUser class represents a user
	 * in the conference classes.
	 */
	public class ConferenceUser extends Object
	{
		
		/**
		 * The username.
		 */
		public var username:String;
		
		/**
		 * A stream name that this user is currently
		 * publishing.
		 */
		public var publishedStream:String;
		
		/**
		 * Helper to create a new user - this always generates an MD5
		 * for publishedStream, if you don't pass a userName, it will
		 * also generate an MD5 for username.
		 */
		public static function createNewUser(userName:String = null):ConferenceUser
		{
			var u:ConferenceUser=new ConferenceUser();
			var rand:String;
			var md:String;
			if(userName) u.username=userName;
			if(!userName)
			{
				rand=String(new Date().time + (Math.random()*10000-1));
				md=MD5.hash(rand);
				u.username=md.substring(0,18);
			}
			rand=String(new Date().time + (Math.random()*10000-1));
			md=MD5.hash(rand);
			u.publishedStream=md.substring(0,18);
			return u;
		}
		
		/**
		 * Shortcut to set both properties.
		 */
		public function setUserNameAndStream(username:String,stream:String):void
		{
			this.username=username;
			this.publishedStream=stream;
		}
		
		/**
		 * Initialize this user from an object.
		 */
		public function initFromObject(o:*):void
		{
			username=o.username;
			publishedStream=o.publishedStream;
		}
		
		/**
		 * Check if another user is equal.
		 */
		public function isEqual(au:ConferenceUser):Boolean
		{
			if(!au) return false;
			return (au.publishedStream==publishedStream && au.username == username);
		}
		
		/**
		 * Check if only the username is equal.
		 */
		public function isUsernameEqual(au:ConferenceUser):Boolean
		{
			return (au.username == username);
		}
		
		/**
		 * Clone me.
		 */
		public function clone():*
		{
			var a:ConferenceUser = new ConferenceUser();
			a.username=username;
			a.publishedStream=publishedStream;
			return a;
		}
	}
}