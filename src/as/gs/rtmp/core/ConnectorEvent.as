package gs.rtmp.core
{
	import flash.events.Event;
	
	/**
	 * The ConnectorEvent class is an enumeration of
	 * event type constants that the RTMPConnector
	 * class dispatches.
	 */
	public class ConnectorEvent extends Event
	{
		
		/**
		 * Dispatched when a connection has been made.
		 */
		public static const CONNECTED:String = "connected";
		
		/**
		 * Dispatched for each attempt at a connection.
		 */
		public static const ATTEMPT:String = "attempt";
		
		/**
		 * Dispatched when an RTMPConnector completely fails.
		 */
		public static const FAILED:String = "failed";
		
		/**
		 * The url that was is an attempt to connect.
		 */
		public var url:String;
		
		/**
		 * Constructor for ConnectoEvent instances.
		 */
		public function ConnectorEvent(type:String,url:String=null,bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type,bubbles,cancelable);
			this.url=url;
		}
	}
}