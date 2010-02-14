package net.guttershark.support.eventmanager
{
	import fl.controls.DataGrid;
	import fl.controls.SelectableList;
	import fl.core.UIComponent;
	import fl.events.DataGridEvent;
	
	/**
	 * The DataGridEventlistenerDelegate Class implements event listener
	 * logic for DataGrid components.
	 */
	final public class DataGridEventListenerDelegate extends EventListenerDelegate
	{

		/**
		 * Composite object for UIComponent event delegation.
		 */
		private var uic:UIComponentEventListenerDelegate;
		
		/**
		 * Composite object for SelectableList events.
		 */
		private var sl:SelectableListEventListenerDelegate;
		
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
			
			if(obj is SelectableList)
			{
				sl = new SelectableListEventListenerDelegate();
				sl.eventHandlerFunction = this.handleEvent;
				sl.callbackDelegate = callbackDelegate;
				sl.callbackPrefix = callbackPrefix;
				sl.cycleAllThroughTracking = cycleAllThroughTracking;
				sl.addListeners(obj);
			}
			
			if(obj is DataGrid)
			{
				if(callbackPrefix + "ColumnStretch" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(DataGridEvent.COLUMN_STRETCH, onColumnStretch);
				if(callbackPrefix + "HeaderRelease" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(DataGridEvent.HEADER_RELEASE, onHeaderRelease);
				if(callbackPrefix + "ItemEditBegin" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(DataGridEvent.ITEM_EDIT_BEGIN, onItemEditBegin);
				if(callbackPrefix + "ItemEditBeginning" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(DataGridEvent.ITEM_EDIT_BEGINNING, onItemEditBeginning);
				if(callbackPrefix + "ItemEditEnd" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(DataGridEvent.ITEM_EDIT_END, onItemEditEnd);
				if(callbackPrefix + "ItemFocusIn" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(DataGridEvent.ITEM_FOCUS_IN, onItemFocusIn);
				if(callbackPrefix + "ItemFocusOut" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(DataGridEvent.ITEM_FOCUS_OUT, onItemFocusOut);
			}
		}
		
		private function onItemFocusOut(dge:DataGridEvent):void
		{
			handleEvent(dge,"ItemFocusOut");
		}
		
		private function onItemFocusIn(dge:DataGridEvent):void
		{
			handleEvent(dge,"ItemFocusIn");
		}
		
		private function onItemEditEnd(dge:DataGridEvent):void
		{
			handleEvent(dge,"ItemEditEnd");
		}
		
		private function onItemEditBeginning(dge:DataGridEvent):void
		{
			handleEvent(dge,"ItemEditBeginning");
		}
		
		private function onItemEditBegin(dge:DataGridEvent):void
		{
			handleEvent(dge,"ItemEditBegin");
		}
		
		private function onHeaderRelease(dge:DataGridEvent):void
		{
			handleEvent(dge,"HeaderRelease");
		}
		
		private function onColumnStretch(dge:DataGridEvent):void
		{
			handleEvent(dge,"ColumnStretch");
		}

		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			super.dispose();
			if(uic) uic.dispose();
			if(sl) sl.dispose();
			uic = null;
			sl = null;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function removeEventListeners():void
		{
			super.removeEventListeners();
			obj.removeEventListener(DataGridEvent.COLUMN_STRETCH, onColumnStretch);
			obj.removeEventListener(DataGridEvent.HEADER_RELEASE, onHeaderRelease);
			obj.removeEventListener(DataGridEvent.ITEM_EDIT_BEGIN, onItemEditBegin);
			obj.removeEventListener(DataGridEvent.ITEM_EDIT_BEGINNING, onItemEditBeginning);
			obj.removeEventListener(DataGridEvent.ITEM_EDIT_END, onItemEditEnd);
			obj.removeEventListener(DataGridEvent.ITEM_FOCUS_IN, onItemFocusIn);
			obj.removeEventListener(DataGridEvent.ITEM_FOCUS_OUT, onItemFocusOut);
		}
	}
}
