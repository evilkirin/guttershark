package gs.rtmp.conference
{
	import gs.rtmp.core.RTMPClient;
	
	import flash.utils.Dictionary;
	
	/**
	 * The Conference class is an RTMPClient you can use
	 * to connect to a server - you use this class as
	 * the connector. It provides a layer
	 * to save ConferenceRoom objects by name.
	 */
	public class Conference extends RTMPClient
	{
		
		/**
		 * Rooms lookup.
		 */
		protected var rooms:Dictionary;
		
		/**
		 * Constructor for Conference instances.
		 */
		public function Conference()
		{
			rooms=new Dictionary();
		}
		
		/**
		 * Add a room.
		 */
		public function addRoom(room:ConferenceRoom):void
		{
			rooms[room.room]=room;
		}
		
		/**
		 * Get a room.
		 */
		public function getRoom(name:String):ConferenceRoom
		{
			return rooms[name];
		}
		
		/**
		 * Whether or not a room is available.
		 */
		public function hasRoom(name:String):Boolean
		{
			return !(rooms[name]==null);
		}
		
		/**
		 * This causes the user to leave the room, and disconnects
		 * the room object.
		 */
		public function leaveRoom(room:ConferenceRoom):void
		{
			if(!room)return;
			rooms[room.room]=null;	
			delete rooms[room.room];
			room.leaveRoom();
			room.dispose();
		}
		
		/**
		 * For each room saved, leaveRoom() and dispose()
		 * is called.
		 */
		public function leaveAndDisposeAllRooms():void
		{
			var r:String;
			for(r in rooms)
			{
				rooms[r].leaveRoom();
				rooms[r].dispose();
				delete rooms[r];
			}
			rooms=null;
		}
		
		/**
		 * Returns room names.
		 */
		public function getRoomNames():Array
		{
			var a:Array=[];
			var r:String;
			for(r in rooms)a.push(r);
			return a;
		}
		
		/**
		 * Disconnects and disposes of everything.
		 */
		override public function dispose():void
		{
			leaveAndDisposeAllRooms();
			super.dispose();
		}
	}
}