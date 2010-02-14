package net.guttershark.display.carousel 
{
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import net.guttershark.display.CoreClip;

	public class Carousel extends CoreClip
	{
		public static const HORIZONTAL:String="horizontal";
		public static const VERTICAL:String="vertical";
		
		private var curCount:int;
		private var totalItems:int;
		private var items:Array;
		private var contentContainer:MovieClip;
		private var msk:MovieClip;
		private var nxt:MovieClip;
		private var prv:MovieClip;
		private var padding:int=10;
		
		public function Carousel()
		{
			super();
			curCount=0;
		}
		
		public function init(items:Array,contentContainer:MovieClip,mask:MovieClip,prevButton:MovieClip,nextButton:MovieClip,direction:String="horizontal"):void
		{
			this.items=items.concat(); //copy the array, so ouside code doesn't taint it.
			this.contentContainer=contentContainer;
			totalItems=this.items.length;
			msk=mask;
			nxt=nextButton;
			prv=prevButton;
			nxt.addEventListener(MouseEvent.CLICK,onNextClick);
			prv.addEventListener(MouseEvent.CLICK,onPrevClick);
			layout();
		}

		private function layout():void
		{
			contentContainer.mask=msk;
			var i:int=0;
			var l:int=items.length;
			var lastItem:*;
			var item:*;
			for(i;i<l;i++)
			{
				item=items[i];
				item.x = (lastItem) ? (lastItem.x+lastItem.width) : 0;
				contentContainer.addChild(item);
				lastItem=item;
			}
		}
		
		//moves all items right.
		private function onPrevClick(e:MouseEvent):void
		{
			var l:int = items.length;
			var item:*;
			
			if(curCount==0) //first figure out if we need to shift an item over to the beginning.
			{
				item = items[l];
				item.x = (items[0].x-items[0].width)+padding; //this just moves the item, in preperation for the movement below
				items.unshift(items.pop()); //bring the item on the end of the array back to the front.
			}
			if(curCount>0) curCount--;
			
			//now shift everything over to the right.
			var i:int=0;
			for(i;i<l;i++)
			{
				item=items[i];
				//item.x += //do this.
			}
		}
		
		//moves all items left
		private function onNextClick(e:MouseEvent):void
		{
			var l:int = items.length;
			
			//if the curCount is equal to the total items, shift the left item over to the right.
			if(curCount == totalItems)
			{
				var item:* = items[0];
				item.x = (items[l].x+items[l].width)+padding; //this just moves the item, in preperation for the movement below
				items.push(items.unshift()); //bring the left most item, back to the last item.
			}
			if(curCount < totalItems) curCount++; //we're not at the end, so just increment the count.
			
			//now shift everything over to the left
			var i:int=0;
			var item:*;
			for(i;i<l;i++)
			{
				item=items[i];
				//item.x -= //do this.
			}
		}
	}}