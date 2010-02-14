package net.guttershark.display.list
{
	import net.guttershark.display.CoreClip;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**
	 * The List class is a component that
	 * simplifies mask logic, and provides properties
	 * you can give to a scrollbar to make the list
	 * scrollable.
	 * 
	 * <p>The component is purposfully left simple.
	 * It makes no assumptions about what you need it
	 * to look like, or how it should behave.</p>
	 * 
	 * <p>Afer you've setup a list component instance,
	 * you can use the listChildren() method to get
	 * an array of the items that are on the display
	 * list - which you can use for show/hide loops.</p>
	 */
	public class List extends CoreClip
	{
		
		/**
		 * content mask.
		 */
		private var msk:Sprite;
		
		/**
		 * content container.
		 */
		private var cnt:Sprite;
		
		/**
		 * data provider
		 */
		private var dp:Array;
		
		/**
		 * current selected item.
		 */
		private var selItem:*;
		
		/**
		 * current selected index.
		 */
		private var selIndex:int;
		
		/**
		 * item to index lookup.
		 */
		private var itemToIndex:Dictionary;
		
		/**
		 * Selectable flag.
		 */
		private var _selectable:Boolean;
		
		/**
		 * Whether or not multiple items can be selected.
		 */
		private var _multiple:Boolean;
		
		/**
		 * The use mask flag.
		 */
		private var _useMask:Boolean;
		
		/**
		 * Activatable flag.
		 */
		private var _activatable:Boolean;
		
		/**
		 * Constructor for List instance.
		 */
		public function List():void
		{
			itemToIndex=new Dictionary(true);
			_selectable=true;
			msk=new Sprite();
			cnt=new Sprite();
			addChild(cnt);
			addChild(msk);
		}
		
		/**
		 * draws a mask
		 */
		private function drawMask():void
		{
			msk.graphics.beginFill(0x000000,1);
			msk.cacheAsBitmap=true;
			msk.graphics.drawRect(0,0,cnt.width,cnt.height);
			msk.graphics.endFill();
			mask=msk;
		}
		
		/**
		 * Whether or not the active and deactive methods
		 * are called on click for a list item.
		 */
		public function set activatable(val:Boolean):void
		{
			_activatable=val;
			if(_activatable)invalidate();
		}
		
		/**
		 * Whether or not to apply a mask to this list.
		 */
		public function set useMask(val:Boolean):void
		{
			_useMask=val;
			if(!_useMask)
			{
				mask=null;
				return;
			}
			drawMask();
		}
		
		/**
		 * The data provider for the list.
		 */
		public function set dataProvider(items:Array):void
		{
			if(dp===items)return;
			dispatchEvent(new Event(Event.CHANGE));
			dp=items;
			invalidate();
		}
		
		/**
		 * The data provider for the list.
		 */
		public function get dataProvider():Array
		{
			return dp;
		}
		
		/**
		 * Whether or not the "activate" and "deactivate"
		 * methods are called on list items.
		 */
		public function set selectable(b:Boolean):void
		{
			_selectable=b;
		}
		
		/**
		 * Whether or not to allow multiple selection.
		 */
		public function set multipleSelect(b:Boolean):void
		{
			_multiple=b;
		}
		
		/**
		 * Whether or not to allow multiple selection.
		 */
		public function get multipleSelect():Boolean
		{
			return _multiple;
		}
		
		/**
		 * An array of all the children in the list. This
		 * can be used when you need to tween each item
		 * in or out.
		 */
		public function get listChildren():Array
		{
			return lm.getAllChildren(cnt);
		}
		
		/**
		 * A reference to the list items content
		 * container. You can use this, in combination
		 * with the "contentMask" property,
		 * for a scrollbar.
		 */
		public function get contentClip():Sprite
		{
			return cnt;
		}
		
		/**
		 * A reference to the content container mask.
		 */
		public function get contentMask():Sprite
		{
			return msk;
		}
		
		/**
		 * Rebuild's the item to index lookup.
		 */
		private function rebuildLookup(fromIndex:int):void
		{
			var i:int=fromIndex;
			var l:int=dp.length;
			for(i;i<l;i++)itemToIndex[dp[i]]=i;
		}
		
		/**
		 * Invalidate's the list, re-attaching
		 * the data provider items to the content
		 * container.
		 */
		private function invalidate():void
		{
			if(!dp || dp.length<1) return;
			var i:int=0;
			var l:int=dp.length;
			var item:*;
			var lastItem:*;
			for(i;i<l;i++)
			{
				item=dp[i];
				itemToIndex[item]=i;
				item.y=(lastItem)?lastItem.y+lastItem.height:0;
				if(_activatable && !item.hasEventListener(MouseEvent.CLICK)) item.addEventListener(MouseEvent.CLICK,onItemClick);
				cnt.addChild(item);
				lastItem=item;
			}
		}
		
		/**
		 * On an item click.
		 */
		private function onItemClick(me:MouseEvent):void
		{
			if(!_selectable)return;
			var tar:* =me.currentTarget||me.target;
			if(selItem==tar)return;
			if(selItem)selItem.deactivate();
			selItem=tar;
			selItem.activate();
			selIndex=itemToIndex[tar];
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set width(w:Number):void
		{
			if(_useMask)msk.width=w;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(h:Number):void
		{
			if(_useMask)msk.height=h;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get height():Number
		{
			if(!_useMask)return cnt.height;
			return msk.height;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get width():Number
		{
			if(!_useMask)return cnt.width;
			return msk.width;
		}
		
		/**
		 * Adjusts the height to reflect how many
		 * rows you want visible. It uses the first
		 * items' height in the dataProvider to calculate
		 * overall height (dataProvider[0].heightXrowsVisible).
		 */
		public function set rowsVisible(rows:Number):void
		{
			if(!_useMask)
			{
				trace("WARNING: The rowsVisible method doesn't work when useMask is false.");
				return;
			}
			if(rows<1)
			{
				trace("At least 1 row must be visible.");
				return;
			}
			var i:int=0;
			var h:Number=0;
			for(i;i<rows;i++)h+=dp[i].height;
			height=h;
		}
		
		/**
		 * The selected index.
		 */
		public function get selectedIndex():Number
		{
			return selIndex;
		}
		
		/**
		 * Select an item at the specified index.
		 * 
		 * @param i The index to select.
		 */
		public function selectItemAt(i:int):void
		{
			if(i<0)return;
			if(!dp||dp.length<i)return;
			if(selItem)selItem.deactivate();
			selItem=dp[i];
			selItem.activate();
			selIndex=i;
		}
		
		/**
		 * The number of items in the list.
		 */
		public function get numItems():int
		{
			return dp.length;
		}
		
		/**
		 * Get an item from the list at the specified index.
		 * 
		 * @param i The index of the item to retrieve.
		 */
		public function getItemAt(i:int):IListItem
		{
			if(i<0)return null;
			if(!dp||dp.length<i)return null;
			return dp[i];
		}
		
		/**
		 * Get the data object associated with an IListItem
		 * at the specified index.
		 * 
		 * @param i The index of the items' data.
		 */
		public function getDataAt(i:int):Object
		{
			if(i<0)return null;
			if(!dp||dp.length<i)return null;
			return dp[i].data;
		}
		
		/**
		 * Update the data object associated with an IListItem
		 * at the specified index.
		 * 
		 * @param i The index of the items' data to update.
		 * @param data An object with keys/vals.
		 */
		public function setDataAt(i:int,data:Object):void
		{
			if(!dp||dp.length<i)return;
			dp[i].data=data;
		}
		
		/**
		 * Remove an item from the list at the specified index.
		 * 
		 * @param index The index of the list item to remove.
		 */
		public function removeItemAt(index:int):void
		{
			if(index<0)return;
			var item:* =dp.splice(index,1)[0];
			item.removeEventListener(MouseEvent.CLICK,onItemClick);
			cnt.removeChildAt(index);
			itemToIndex[index]=null;
			delete itemToIndex[index];
			invalidate();
		}
		
		/**
		 * Add an item to the bottom of the list.
		 * 
		 * @param item The item to add to the list.
		 */
		public function addItem(item:IListItem):void
		{
			if(!item)return;
			dp.push(item);
			itemToIndex[dp.length-1]=item;
			invalidate();
		}
		
		/**
		 * Add an item at the specified index.
		 * 
		 * @param index The index to insert the item at.
		 * @param item The item to add to the list.
		 */
		public function addItemAt(index:int,item:IListItem):void
		{
			if(index<0||!item)return;
			dp.splice(index,0,item);
			rebuildLookup(index);
			invalidate();
		}
		
		/**
		 * Deselect all selected items.
		 */
		public function deselectAll():void
		{
			if(!selItem)return;
			selItem.deactivate();
			selItem=null;
		}

		/**
		 * Dispose of this list.
		 */
		override public function dispose():void
		{
			super.dispose();
		}
	}
}