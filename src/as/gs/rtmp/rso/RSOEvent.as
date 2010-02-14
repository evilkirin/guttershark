package gs.rtmp.rso
{
	import flash.events.Event;
	
	/**
	 * The RSOEvent class is an enumeration for
	 * event types.
	 */
	public class RSOEvent extends Event
	{
		
		/**
		 * Dispatched when the very first sync timesout - meaning
		 * it never happened.
		 */
		public static const SYNC_TIMEOUT:String = "syncTimeout";
		
		/**
		 * Dispatched when sync invalidation is complete.
		 */
		public static const SYNC_COMPLETE:String = "syncComplete";
		
		/**
		 * Constructor for RSOEvent instances.
		 */
		public function RSOEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type,bubbles,cancelable);
		}
	}
}