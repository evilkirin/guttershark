package gs.rtmp.core
{
	
	import flash.events.Event;
	
	/**
	 * The RTMPEvent class is an enumeration of constants
	 * for the type property.
	 */
	public class RTMPEvent extends Event
	{
		
		/**
		 * Dispatched when a NetStream has failed, do to some
		 * unknown condition with flash media server.
		 */
		public static const FAILED_NET_STREAM:String = "failedNetStream";
		
		/**
		 * Dispatched when a connection to a flash media server
		 * fails because the app was incorrect.
		 */
		public static const INVALID_APP:String = "invalidApp";
		
		/**
		 * Dispatched when the client does not have sufficient
		 * bandwidth to play the data at normal speed.
		 */
		public static const INSUFFICIENT_BW:String = "insufficientBW";
		
		/**
		 * Dispatched when a connection attempt occurs.
		 */
		public static const CONNECTION_ATTEMPT:String = "connectionAttempt";
		
		/**
		 * Dispatched whten the net connection has connected.
		 */
		public static const CONNECTED:String = "connected";
		
		/**
		 * Dispatched when all connection attempts have failed.
		 */
		public static const CONNECTION_FAILED:String = "connectionFailed";
		
		/**
		 * Dispatched from RTMPConnections class when a connection is
		 * terminated.
		 */
		public static const CONNECTION_TERMINATED:String = "connectionTerminated";
		
		/**
		 * Dispatched when an RTMPClient is trying to connect, but a
		 * connection is already available to the endpoint through
		 * some other NetConnection. This is just to inform you that it
		 * has a connected connection, the RTMPClient uses that connection
		 * internally.
		 */
		public static const CONNECTION_AVAILABLE:String = "connectionAvailable";
		
		/**
		 * Dispatched when the net connection has closed.
		 */
		public static const CLOSED:String = "closed";
		
		/**
		 * Dispatched when a net stream starts.
		 */
		public static const START:String = "start";
		
		/**
		 * Dispatched when a net stream plays.
		 */
		public static const PLAY:String = "play";
		
		/**
		 * Dispatched after all attempts to subscribe to a
		 * net stream have failed.
		 */
		public static const STREAM_NOT_FOUND:String = "streamNotFound";
		
		/**
		 * Dispatched when an attempt to publish a stream happens.
		 */
		public static const PUBLISH_ATTEMPT:String = "publishAttempt";
		
		/**
		 * Dispatched when a stream has started publishing.
		 */
		public static const STARTED_PUBLISHING:String = "startedPublishing";
		
		/**
		 * Dispatched when the stream is publishing.
		 */
		public static const PUBLISHING:String = "publishing";
		
		/**
		 * Dispatched after all attempts to publish a stream fail.
		 */
		public static const PUBLISH_FAILED:String = "publishFailed";
		
		/**
		 * Dispatched when an attempt to subsrcibe to a stream happens.
		 */
		public static const SUBSCRIBE_ATTEMPT:String = "subsribeAttempt";
		
		/**
		 * Dispatched when a stream is successfully being subscribed to.
		 */
		public static const STARTED_SUBSCRIBING:String = "startedSubscribing";
		
		/**
		 * Dispatched when a stream is subscribing.
		 */
		public static const SUBSCRIBING:String = "subscribing";
		
		/**
		 * The URI for connection related events.
		 */
		public var uri:String;
		
		/**
		 * A stream name.
		 */
		public var stream:String;
		
		/**
		 * Constructor for RTMPEvent instances.
		 * 
		 * @param type The event type.
		 */
		public function RTMPEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false,uri:String=null,stream:String=null)
		{
			super(type,bubbles,cancelable);
			this.uri=uri;
			this.stream=stream;
		}
	}
}
