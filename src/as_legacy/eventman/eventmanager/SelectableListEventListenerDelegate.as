package net.guttershark.support.eventmanager
{
	import flash.events.Event;
	
	import fl.controls.SelectableList;
	import fl.events.ListEvent;
	
	/**
	 * The SelectableListEventListenerDelegate Class implements event listener
	 * logic for SelectableList instances.
	 */
	final public class SelectableListEventListenerDelegate extends EventListenerDelegate 
	{
		
		/**
		 * @inheritDoc
		 */
		override public function addListeners(obj:*):void
		{
			super.addListeners(obj);
			if(obj is SelectableList)
			{
				if(callbackPrefix + "Change" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.CHANGE, onChange,false,0,true);
				if(callbackPrefix + "Click" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(ListEvent.ITEM_CLICK, onItemClick,false,0,true);
				if(callbackPrefix + "DoubleClick" in callbackDelegate || cycleAllThroughTracking) obj.addEventlistener(ListEvent.ITEM_DOUBLE_CLICK, onItemDoubleClick,false,0,true);
				if(callbackPrefix + "ItemRollOut" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(ListEvent.ITEM_ROLL_OUT, onRollOut,false,0,true);
				if(callbackPrefix + "ItemRollOver" in callbackDelegate || cycleAllThroughTracking) obj.addEventlistener(ListEvent.ITEM_ROLL_OVER, onRollOver,false,0,true);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function removeEventListeners():void
		{
			obj.removeEventListener(Event.CHANGE, onChange);
			obj.removeEventListener(ListEvent.ITEM_CLICK, onItemClick);
			obj.removeEventListener(ListEvent.ITEM_DOUBLE_CLICK, onItemDoubleClick);
			obj.removeEventListener(ListEvent.ITEM_ROLL_OUT, onRollOut);
			obj.removeEventListener(ListEvent.ITEM_ROLL_OVER, onRollOver);
		}
		
		private function onChange(e:Event):void
		{
			handleEvent(e,"Change");
		}
		
		private function onItemClick(le:ListEvent):void
		{
			handleEvent(le,"ItemClick");
		}
		
		private function onItemDoubleClick(le:ListEvent):void
		{
			handleEvent(le,"ItemDoubleClick");
		}
		
		private function onRollOut(le:ListEvent):void
		{
			handleEvent(le,"ItemRollOut");
		}
		
		private function onRollOver(le:ListEvent):void
		{
			handleEvent(le,"ItemRollOver");
		}	}}