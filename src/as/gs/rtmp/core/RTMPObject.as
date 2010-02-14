package gs.rtmp.core
{
	import flash.events.EventDispatcher;

	/**
	 * The RTMPObject class is a base class for
	 * other RTMP objects that need access to 
	 * the same pieces.
	 */
	public class RTMPObject extends EventDispatcher
	{
		
		/**
		 * Connection store.
		 */
		protected var connections:RTMPConnections;
		
		/**
		 * Constructor for RTMPObject instances.
		 */
		public function RTMPObject()
		{
			connections=RTMPConnections.gi();
		}
		
		/**
		 * Dispose of RTMPObject instances.
		 */
		public function dispose():void
		{
		}
	}
}