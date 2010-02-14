package net.guttershark.support.eventmanager
{
	import flash.events.Event;
	
	import fl.controls.ComboBox;
	import fl.core.UIComponent;
	import fl.events.ComponentEvent;
	import fl.events.ListEvent;
	import fl.events.ScrollEvent;	

	/**
	 * The ComboBoxEventListenerDelegate Class implements event listener
	 * logic for ComboBox components.
	 */
	final public class ComboBoxEventListenerDelegate extends EventListenerDelegate
	{

		/**
		 * Composite object for UIComponent event delegation.
		 */
		private var uic:UIComponentEventListenerDelegate;
		
		/**
		 * @inheritDoc
		 */
		override public function addListeners(obj:*):void
		{
			super.addListeners(obj);
			if(obj is UIComponent)
			{
				uic = new UIComponentEventListenerDelegate();
				uic.cycleAllThroughTracking = cycleAllThroughTracking;
				uic.callbackDelegate = callbackDelegate;
				uic.callbackPrefix = callbackPrefix;
				uic.eventHandlerFunction = this.handleEvent;
				uic.addListeners(obj);
			}
			
			if(obj is ComboBox)
			{
				if(callbackPrefix + "Change" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.CHANGE, onChange, false, 0, true);
				if(callbackPrefix + "Close" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.CLOSE, onClose, false, 0, true);
				if(callbackPrefix + "Open" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.OPEN, onOpen, false, 0, true);
				if(callbackPrefix + "Enter" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(ComponentEvent.ENTER, onEnter, false, 0, true);
				if(callbackPrefix + "ItemRollOut" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(ListEvent.ITEM_ROLL_OUT, onItemRollOut, false, 0, true);
				if(callbackPrefix + "ItemRollOver" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(ListEvent.ITEM_ROLL_OVER, onItemRollOver, false, 0, true);
				if(callbackPrefix + "Scroll" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(ScrollEvent.SCROLL, onScroll, false, 0, true);
			}
		}
		
		private function onScroll(se:ScrollEvent):void
		{
			handleEvent(se,"Scroll",true);
		}

		private function onClose(e:Event):void
		{
			handleEvent(e,"Close");
		}

		private function onOpen(cp:Event):void
		{
			handleEvent(cp,"Open");
		}
		
		private function onEnter(cp:ComponentEvent):void
		{
			handleEvent(cp,"Enter");
		}
		
		private function onItemRollOut(cp:ListEvent):void
		{
			handleEvent(cp,"ItemRollOut");
		}
		
		private function onItemRollOver(cp:ListEvent):void
		{
			handleEvent(cp,"ItemRollOver");
		}
		
		private function onChange(cp:Event):void
		{
			handleEvent(cp,"Change");
		}

		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			super.dispose();
			if(uic) uic.dispose();
			uic = null;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function removeEventListeners():void
		{
			super.removeEventListeners();
			obj.removeEventListener(Event.CHANGE, onChange);
			obj.removeEventListener(Event.CLOSE, onClose);
			obj.removeEventListener(Event.OPEN, onOpen);
			obj.removeEventListener(ComponentEvent.ENTER, onEnter);
			obj.removeEventListener(ListEvent.ITEM_ROLL_OUT, onItemRollOut);
			obj.removeEventListener(ListEvent.ITEM_ROLL_OVER, onItemRollOver);
			obj.removeEventListener(ScrollEvent.SCROLL, onScroll);
		}
	}
}
