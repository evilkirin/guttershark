package gs.rtmp.conference
{
	import flash.events.Event;
	
	/**
	 * The ConferenceEvent class is an enumeration for
	 * event types.
	 */
	public class ConferenceEvent extends Event
	{
		
		/**
		 * Dispatched when a new stream is available that should be subscribed to.
		 */
		public static const SUBSCRIBE_TO_STREAM:String = "subscribeToStream";
		
		/**
		 * Dispatched when the current client should start publishing their stream.
		 */
		public static const START_PUBLISHING:String = "startPublishing";
		
		/**
		 * Dispatched to notify that a client should be publishing.
		 */
		public static const SHOULD_BE_PUBLISHING:String =  "shouldBePublishing";
		
		/**
		 * Dispatched to notify that a client shouldn't be publishing.
		 */
		public static const SHOULD_NOT_BE_PUBLISHING:String = "shouldNotBePublishing";
		
		/**
		 * Dispatched when the current client should stop publishing their stream.
		 */
		public static const STOP_PUBLISHING:String = "stopPublishing";
		
		/**
		 * Dispatched whan a stream should be dropped.
		 */
		public static const DROP_STREAM:String = "dropStream";
		
		/**
		 * Dispatched when a room has connected.
		 */
		public static const ROOM_CONNECTED:String = "roomConnected";
		
		/**
		 * Dispatched when a room has failed to connect.
		 */
		public static const ROOM_CONNECT_FAILED:String = "roomConnectFailed";
		
		/**
		 * Dispatched when a call to conferenceRoom.connect is made.
		 */
		public static const ROOM_CONNECTING:String = "roomConnecting";
		
		/**
		 * Dispatched when a connection to a room is attempted.
		 */
		public static const ROOM_CONNECT_ATTEMPT:String = "roomConnectAttempt";
		
		/**
		 * Dispatched when an IDENT complete. Idents occur before a user
		 * connects into a room.
		 */
		public static const USER_IDENT_COMPLETE:String = "userIdentComplete";
		
		/**
		 * Dispatched when an IDENT is about to take off.
		 */
		public static const USER_IDENT:String = "userIdent";
		
		/**
		 * Dispatched from a RemoteSharedObject when the first sync happend.
		 */
		public static const FIRST_SYNC:String = "firstSync";
		
		/**
		 * A stream name, used for a few events.
		 */
		public var stream:String;
		
		/**
		 * The room name for events related to rooms.
		 */
		public var room:String;
		
		/**
		 * Constructor for ConferenceRoomEvent instances.
		 * 
		 * @param type The event type.
		 * @param stream The stream name.
		 */
		public function ConferenceEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false,stream:String=null,room:String=null)
		{
			super(type,bubbles,cancelable);
			this.stream=stream;
			this.room=room;
		}
	}
}