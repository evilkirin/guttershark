package net.guttershark.support.eventmanager
{
	import fl.controls.LabelButton;
	import fl.events.ComponentEvent;
	
	/**
	 * The LabelButtonEventListenerDelegate implements event listener logic
	 * for LabelButton instances.
	 */
	final public class LabelButtonEventListenerDelegate extends EventListenerDelegate 
	{

		/**
		 * @inheritDoc
		 */
		override public function addListeners(obj:*):void
		{
			super.addListeners(obj);
			if(obj is LabelButton)
			{
				if(callbackPrefix + "LabelChange" in callbackDelegate || cycleAllThroughTracking)  obj.addEventListener(ComponentEvent.LABEL_CHANGE, onLabelChange);
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
			super.removeEventListeners();
			obj.removeEventListener(ComponentEvent.LABEL_CHANGE,onLabelChange);
		}

		private function onLabelChange(ce:ComponentEvent):void
		{
			handleEvent(ce,"LabelChange",true);
		}	}}