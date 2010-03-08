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
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class EventUtil
	{
		
		/**
		 * MouseEvent.CLICK.
		 */
		public static function click(obj:IEventDispatcher, handler:Function, priority:int = 0, useCapture:Boolean = false, useWeakReference:Boolean = false):void
		{
			obj.addEventListener(MouseEvent.CLICK,handler,useCapture,priority,useWeakReference);
		}
		
		/**
		 * remove MoseEvent.CLICK.
		 */
		public static function unclick(obj:IEventDispatcher,handler:Function):void
		{
			obj.removeEventListener("click",handler);
		}
		
		/**
		 * MouseEvent.MOUSE_OVER.
		 */
		public static function mouseover(obj:IEventDispatcher,handler:Function,priority:int = 0, useCapture:Boolean = false, useWeakReference:Boolean = false):void
		{
			obj.addEventListener(MouseEvent.MOUSE_OVER,handler,useCapture,priority,useWeakReference);
		}
		
		/**
		 * Remove MouseEvent.MOUSE_OVER.
		 */
		public static function unmouseover(obj:IEventDispatcher,handler:Function):void
		{
			obj.removeEventListener(MouseEvent.MOUSE_OVER,handler);
		}
		
		/**
		 * MouseEvent.MOUSE_OUT.
		 */
		public static function mouseout(obj:IEventDispatcher,handler:Function,priority:int = 0, useCapture:Boolean = false, useWeakReference:Boolean = false):void
		{
			obj.addEventListener(MouseEvent.MOUSE_OUT,handler,useCapture,priority,useWeakReference);
		}
		
		/**
		 * Remove MouseEvent.MOUSE_OUT.
		 */
		public static function unmouseout(obj:IEventDispatcher,handler:Function):void
		{
			obj.removeEventListener(MouseEvent.MOUSE_OUT,handler);
		}
		
		/**
		 * Shortcut to handle common mouse events.
		 */
		public static function mouse(obj:IEventDispatcher,_click:Function,_down:Function,_up:Function,_over:Function,_out:Function):void
		{
			if(_click!=null)click(obj,_click);
			if(_over!=null)mouseover(obj,_over);
			if(_out!=null)mouseout(obj,_out);
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