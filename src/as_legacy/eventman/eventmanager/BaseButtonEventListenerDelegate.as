package net.guttershark.support.eventmanager
{
	import flash.events.Event;
	
	import fl.controls.BaseButton;
	import fl.events.ComponentEvent;

	/**
	 * The BaseButtonEventListenerDelegate Class implements
	 * event listener logic for BaseButton events. This class
	 * is only used as a composite object for Classes that
	 * extend BaseButton, like the Button component.
	 */
	final public class BaseButtonEventListenerDelegate extends EventListenerDelegate
	{

		/**
		 * @inheritDoc
		 */
		override public function addListeners(obj:*):void
		{
			super.addListeners(obj);
			if(obj is BaseButton)
			{
				if(callbackPrefix + "Change" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.CHANGE, onChange,false,0,true);
				if(callbackPrefix + "ButtonDown" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(ComponentEvent.BUTTON_DOWN,onButtonDown,false,0,true);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function removeEventListeners():void
		{
			super.removeEventListeners();
			obj.removeEventListener(Event.CHANGE, onChange);
			obj.removeEventListener(ComponentEvent.BUTTON_DOWN, onButtonDown);
		}
		
		private function onChange(e:Event):void
		{
			handleEvent(e,"Change");
		}
		
		private function onButtonDown(ce:ComponentEvent):void
		{
			handleEvent(ce,"ButtonDown");
		}
	}
}
