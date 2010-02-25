package gs.util 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;

	/**
	 * The EventUtils class contains utility methods to
	 * simplify adding and removing events.
	 * 
	 * <p>This class is literally just a wrapper around
	 * calling ".addEventLitener(TYPE, handler)"</p>
	 */
	public class EventUtil
	{
		
		/**
		 * MouseEvent.CLICK
		 */
		public static function click(obj:IEventDispatcher, handler:Function, priority:int = 0, useCapture:Boolean = false, useWeakReference:Boolean = false):void
		{
			obj.addEventListener(MouseEvent.CLICK,handler,useCapture,priority,useWeakReference);
		}
		
		/**
		 * remove MoseEvent.CLICK
		 */
		public static function unclick(obj:IEventDispatcher,handler:Function):void
		{
			obj.removeEventListener("click",handler);
		}
		
		/**
		 * Event.COMPLETE
		 */
		public static function complete(obj:IEventDispatcher,handler:Function, priority:int = 0, useCapture:Boolean = false, useWeakReference:Boolean = false):void
		{
			obj.addEventListener(Event.COMPLETE,handler,useCapture,priority,useWeakReference);
		}
		
		/**
		 * remove Event.COMPLETE
		 */
		public static function uncomplete(obj:IEventDispatcher,handler:Function):void
		{
			obj.removeEventListener(Event.COMPLETE,handler);
		}
	}
}
