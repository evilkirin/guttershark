package gs.util
{
	import flash.events.Event;
	import flash.events.EventDispatcher;	

	/**
	 * The EventBroadcaster is a static class, and wraps an instance of
	 * an event dispatcher.
	 * 
	 * <p>Using this class is not recommended, as it leads to spaghetti
	 * events - but is here for those who feel the need.</p>
	 * 
	 * <p>This class really should only be used when you need
	 * swf to swf communication, without needing a reference to
	 * a swf.</p>
	 * 
	 * @example	Using the EventBroadcaster:
	 * <listing>	
	 * private function onTest(e:Event):void
	 * {
	 *   trace("event received");
	 * }
	 * EventBroadcaster.addEventListener("test",onTest);
	 * EventBroadcaster.broadcastEvent(new Event("test"));
	 * </listing>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class EventBroadcaster
	{
		
		private static var dispatcher:EventDispatcher=new EventDispatcher();
		
		/**
		 * Add a listener the the event broadcaster.
		 * 
		 * @param type The type of event listener
		 * @param listener The callback function when event is fired
		 * @param useCapture UseCapture or not.
		 * @param priority Priority of the event.
		 * @param useWeakReferences Use weak references.
		 */
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			dispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		/**
		 * Broadcast an event.
		 * 
		 * @param event Any Event.
		 */
		public static function broadcastEvent(event:Event):void
		{
			dispatcher.dispatchEvent(event);
		}
		
		/**
		 * Remove an event listener from the broadcaster.
		 * 
		 * @param type The listener type.
		 * @param listener The callback listening function.
		 * @param useCapture UseCapture of not.
		 */
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			dispatcher.removeEventListener(type,listener,useCapture);
		}
		
		/**
		 * Check to see if there is a listener of specified type on the broadcaster.
		 * 
		 * @param type The event type.
		 */
		public static function hasEventListener(type:String):Boolean
		{
			return dispatcher.hasEventListener(type);
		}
		
		/**
		 * Test to see if an event will fire of type.
		 * 
		 * @param type The event type.
		 */
		public static function willTrigger(type:String):Boolean
		{
			return dispatcher.willTrigger(type);
		}
	}
}