package net.guttershark.display.combo
{
	import net.guttershark.display.list.IListItem;
	import net.guttershark.display.list.List;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;	

	/**
	 * The ComboBox class controls a drop down
	 * component - you supply the pieces.
	 */
	public class ComboBox extends EventDispatcher
	{
		
		private var msk:Sprite;
		
		private var list:List;
		
		private var content:Sprite;

		/**
		 * Constructor for ComboBox instances.
		 * 
		 * @param content The content container.
		 * @param list A reference to a list component.
		 * @param trigger A sprite that reveals items.
		 */
		public function ComboBox(content:Sprite,list:List,trigger:Sprite,revealNumItems:int)
		{
			if(list.numItems<1)list.addEventListener(Event.CHANGE,onListChange);
			else
			{
				var zi:IListItem=list.getItemAt(0);
				width=zi.width;
				height=zi.height;
			}
			createMask();
		}
		
		private function createMask():void
		{
			msk=new Sprite();
			msk.graphics.beginFill(0x000000,1);
			msk.graphics.drawRect(0,0,25,25);
			msk.graphics.endFill();
			content.mask=msk;
		}
		
		private function onListChange(e:Event):void
		{
			var zi:IListItem=list.getItemAt(0);
			list.removeEventListener(Event.CHANGE,onListChange);
			width=zi.width;
			height=zi.height;
		}
		
		public function set height(height:Number):void
		{
			if(msk.height==height)return;
			msk.height=height;
		}
		
		public function set width(width:Number):void
		{
			if(msk.width==width)return;
			msk.width=width;
		}
	}}