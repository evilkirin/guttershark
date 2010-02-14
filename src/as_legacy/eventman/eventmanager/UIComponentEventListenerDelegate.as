package net.guttershark.support.eventmanager
{
	import flash.events.Event;
	
	import fl.core.UIComponent;
	import fl.events.ComponentEvent;
	
	/**
	 * The UIComponentEventListenerDelegate implements event listener logic
	 * for UIComponent instances.
	 */
	final public class UIComponentEventListenerDelegate extends EventListenerDelegate
	{

		/**
		 * @inheritDoc
		 */
		override public function addListeners(obj:*):void
		{
			super.addListeners(obj);
			if(obj is UIComponent)
			{
				if(callbackPrefix + "Move" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(ComponentEvent.MOVE, onMove, false, 0, true);
				if(callbackPrefix + "Resize" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(ComponentEvent.RESIZE,onResize,false,0, true);
				if(callbackPrefix + "Show" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(ComponentEvent.SHOW,onShow,false,0,true);
				if(callbackPrefix + "Hide" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(ComponentEvent.HIDE,onHide,false,0,true);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			super.dispose();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function removeEventListeners():void
		{
			obj.removeEventListener(ComponentEvent.MOVE, onMove);
			obj.removeEventListener(ComponentEvent.RESIZE,onResize);
			obj.removeEventListener(ComponentEvent.SHOW,onShow);
			obj.removeEventListener(ComponentEvent.HIDE,onHide);
		}
		
		private function onMove(ce:ComponentEvent):void
		{
			handleEvent(ce,"Move");
		}
		
		private function onResize(e:Event):void
		{
			handleEvent(e,"Resize");
		}
		
		private function onHide(ce:ComponentEvent):void
		{
			handleEvent(ce,"Hide");
		}
		
		private function onShow(ce:ComponentEvent):void
		{
			handleEvent(ce,"Show",true);
		}
		
	}}