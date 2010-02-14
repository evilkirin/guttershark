package net.guttershark.support.eventmanager
{
	import flash.events.Event;
	
	import fl.controls.ColorPicker;
	import fl.core.UIComponent;
	import fl.events.ColorPickerEvent;
	
	/**
	 * The ColorPickerEventListenerDelegate Class implements event handling
	 * logic for ColorPicker components.
	 */
	final public class ColorPickerEventListenerDelegate extends EventListenerDelegate
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
				uic.eventHandlerFunction = this.handleEvent;
				uic.callbackDelegate = callbackDelegate;
				uic.callbackPrefix = callbackPrefix;
				uic.cycleAllThroughTracking = cycleAllThroughTracking;
				uic.addListeners(obj);
			}
			
			if(obj is ColorPicker)
			{
				obj.addEventListener(ColorPickerEvent.CHANGE, onChange,false,0,true);
				obj.addEventListener(ColorPickerEvent.ENTER, onEnter,false,0,true);
				obj.addEventListener(ColorPickerEvent.ITEM_ROLL_OUT, onItemRollOut,false,0,true);
				obj.addEventListener(ColorPickerEvent.ITEM_ROLL_OVER, onItemRollOver,false,0,true);
				obj.addEventListener(Event.OPEN, onOpen,false,0,true);
			}
		}
		
		private function onOpen(cp:ColorPickerEvent):void
		{
			handleEvent(cp,"Open");
		}
		
		private function onEnter(cp:ColorPickerEvent):void
		{
			handleEvent(cp,"Enter");
		}
		
		private function onItemRollOut(cp:ColorPickerEvent):void
		{
			handleEvent(cp,"ItemRollOut");
		}
		
		private function onItemRollOver(cp:ColorPickerEvent):void
		{
			handleEvent(cp,"ItemRollOver");
		}
		
		private function onChange(cp:ColorPickerEvent):void
		{
			handleEvent(cp,"Change",true);
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
			obj.removeEventListener(ColorPickerEvent.CHANGE, onChange);
			obj.removeEventListener(ColorPickerEvent.ENTER, onEnter);
			obj.removeEventListener(ColorPickerEvent.ITEM_ROLL_OUT, onItemRollOut);
			obj.removeEventListener(ColorPickerEvent.ITEM_ROLL_OVER, onItemRollOver);
			obj.removeEventListener(Event.OPEN, onOpen);
		}
	}}