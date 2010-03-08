package gs.display.accordion
{
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**
	 * The Accordion class is a controller that implements
	 * an accordion component.
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class Accordion extends MovieClip
	{
		
		/**
		 * The ease speed to show/hide panes.
		 */
		public var speed:Number=0.25;
		
		/**
		 * Whether or not to size the accordion
		 * to the open pange, and all headers. This
		 * essentially makes everything elastic, vs
		 * static heights
		 */
		public var sizeToContentPanes:Boolean;
		
		/**
		 * Whether or not you can close all panels - this
		 * is only useful if you enable sizeToContentPanes
		 * as well.
		 */
		public var canCloseAll:Boolean;
		
		/**
		 * The panes container.
		 */
		private var panesContainer:MovieClip;
		
		/**
		 * The panes mask.
		 */
		private var panesMask:MovieClip;
		
		/**
		 * Panes added to the accordion.
		 */
		private var panes:Array;
		
		/**
		 * Pane lookup.
		 */
		private var paneLookup:Dictionary;
		
		/**
		 * Index by pane lookup.
		 */
		private var indexLookup:Dictionary;
		
		/**
		 * Initial height of the accordion, taken
		 * from the first pane added.
		 */
		private var initialHeight:Number;
		
		/**
		 * Initial width of the accordion, taken
		 * from the first pane added.
		 */
		private var initialWidth:Number;
		
		/**
		 * Current active index.
		 */
		private var _currentIndex:int;
		
		/**
		 * Constructor for Accordion instances.
		 */
		public function Accordion()
		{
			panes=new Array();
			paneLookup=new Dictionary();
			indexLookup=new Dictionary();
			panesContainer=new MovieClip();
			panesMask=new MovieClip();
			addChild(panesContainer);
			addChild(panesMask);
			panesContainer.mask=panesMask;
			_currentIndex=0;
		}
		
		/**
		 * Current active index.
		 */
		public function get currentIndex():Number
		{
			return _currentIndex;
		}
		
		/**
		 * Draws the mask over the panes holder.
		 */
		private function drawMask():void
		{
			panesMask.graphics.beginFill(0x000000);
			panesMask.graphics.drawRect(0,0,this.initialWidth,this.initialHeight);
			panesMask.graphics.endFill();
		}
		
		/**
		 * Add a pane to the accordion.
		 * 
		 * @param pane A BaseAccordionPane.
		 * @param paneName Optionally save the pane with a name.
		 */
		public function addPane(pane:BaseAccordionPane):void
		{
			pane.x=0;
			pane.y=0;
			if(!initialWidth)
			{
				initialWidth=pane.width;
				initialHeight=pane.height + pane.labelBar.height;
				drawMask();
			}
			panes.push(pane);
			var pl:int=panes.length;
			if(pl==1) panesContainer.addChild(pane);
			else if(pl==2)
			{
				pane.y=panesMask.height-pane.labelBarHeight;
				panesContainer.addChild(pane);
			}
			else if(pl>2)
			{
				var restpanes:Array=panes.slice(1,panes.length);
				var i:int=0;
				var l:int=restpanes.length;
				var pn:BaseAccordionPane;
				var lp:BaseAccordionPane;
				i=0;
				restpanes.reverse();
				for(;i<l;i++)
				{
					pn=restpanes[int(i)];
					if(lp) pn.y=lp.y-pn.labelBarHeight;
					else pn.y=panesMask.height-pn.labelBarHeight;
					if(panesContainer.contains(pn))panesContainer.removeChild(pn);
					lp=pn;
				}
				restpanes.reverse();
				i=0;
				for(;i<l;i++)
				{
					pn=restpanes[int(i)];
					panesContainer.addChild(pn);
				}
			}
			paneLookup[pane.labelBar]=pane;
			handlePaneBar(pane);
			updateIndexLookup();
		}
		
		/**
		 * Updates the index lookup.
		 */
		private function updateIndexLookup():void
		{
			var i:int=0;
			var l:int=panes.length;
			var pn:BaseAccordionPane;
			for(;i<l;i++)
			{
				pn=panes[int(i)];
				indexLookup[pn]=i;
			}
		}
		
		/**
		 * Close all panes - only if canCloseAll and
		 * sizeToContentPanes is enabled.
		 */
		public function closeAll():void
		{
			if(canCloseAll && sizeToContentPanes)
			{
				var i:int=0;
				var len:int=panes.length;
				var targetys:Array=[];
				var lty:Number;
				var lastpane:BaseAccordionPane;
				var p:BaseAccordionPane;
				for(;i<len;i++)
				{
					targetys[int(i)] = Math.floor ( (lastpane) ? lty + lastpane.labelBar.height : 0 );
					lastpane=panes[int(i)];
					lty=targetys[targetys.length-1];
				}
				i=0;
				for(;i<len;i++)
				{
					p=panes[int(i)];
					TweenLite.to(p,speed,{y:targetys[int(i)],ease:Quad.easeOut});
					p.enabled=false;
				}
				if(sizeToContentPanes)
				{
					panesMask.height=getTotalLabelBarHeights();
					dispatchEvent(new Event("change"));
				}
				_currentIndex=-1;
			}
		}
		
		/**
		 * Adds listener to pane bar.
		 */
		private function handlePaneBar(pane:BaseAccordionPane):void
		{
			pane.labelBar.addEventListener(MouseEvent.CLICK,onBarClick);
		}
		
		/**
		 * On bar click.
		 */
		private function onBarClick(e:MouseEvent):void
		{
			var targetPane:BaseAccordionPane=paneLookup[e.currentTarget];
			var targetIndex:int=indexLookup[targetPane];
			var i:int=0;
			var len:int=panes.length;
			var p:BaseAccordionPane;
			if(_currentIndex>-1 && targetIndex==_currentIndex && canCloseAll && sizeToContentPanes) closeAll();
			else
			{
				if(sizeToContentPanes)
				{
					var targetys:Array=[];
					var lty:Number;
					var ty:Number;
					var lastpane:BaseAccordionPane;
					for(;i<len;i++)
					{
						p=panes[int(i)];
						if(i<=targetIndex)
						{
							ty = (lastpane) ? lty + lastpane.labelBar.height : 0;
							targetys[i]=Math.floor(ty);
						}
						else if(int(i)==(targetIndex+1))
						{
							ty = (lastpane) ? lty + lastpane.height : 0;
							targetys[int(i)]=Math.floor(ty);
						}
						else if(int(i)>(targetIndex+1))
						{
							ty = lty + lastpane.labelBar.height;
							targetys[int(i)]=Math.floor(ty);
						}
						lastpane=p;
						lty=targetys[int(targetys.length)-1];
					}
					i=0;
					for(;i<len;i++)TweenLite.to(panes[int(i)],speed,{y:targetys[int(i)],ease:Quad.easeOut});
					var t:Number=getTotalLabelBarHeights();
					t+=targetPane.content.height;
					panesMask.height=t;
					dispatchEvent(new Event("change"));
				}
				else
				{
					for(;i<len;i++)
					{
						p=panes[int(i)];
						if(i>_currentIndex && i<=targetIndex)TweenLite.to(p,speed,{y:targetUpY(i),ease:Quad.easeOut});
						else if(i>targetIndex)TweenLite.to(p,speed,{y:targetDownY(i),ease:Quad.easeOut});
					}
				}
				if(targetIndex != _currentIndex && _currentIndex > -1) (panes[_currentIndex] as BaseAccordionPane).enabled=false;
				_currentIndex=targetIndex;
			}
		}
		
		private function getTotalLabelBarHeights():Number
		{
			var i:int=0;
			var l:int=panes.length;
			var t:Number=0;
			for(;i<l;i++)t+=panes[int(i)].labelBar.height;
			return t;
		}
		
		/**
		 * Finds the y position.
		 */
		private function targetUpY(index:int):Number
		{
			var i:int=0;
			var total:Number=0;
			for(;i<index;i++)
			{
				total+=BaseAccordionPane(panes[int(i)]).labelBar.height;
			}
			return total;
		}
		
		/**
		 * Finds the y position.
		 */
		private function targetDownY(index:int):Number
		{
			var i:int =panes.length-1;
			var total:Number=0;
			for(;i>=index;i--)
			{
				total+=BaseAccordionPane(panes[int(i)]).labelBar.height;
			}
			return panesMask.height-total;
		}
		
		/**
		 * The accordion height.
		 */
		override public function set height(h:Number):void
		{
			panesMask.height=h;
		}
		
		/**
		 * The accordion height.
		 */
		override public function get height():Number
		{
			return panesMask.height;
		}
		
		/**
		 * The accordion width.
		 */
		override public function set width(w:Number):void
		{
			panesMask.width=w;
		}
		
		/**
		 * The accordion width.
		 */
		override public function get width():Number
		{
			return panesMask.width;
		}
	}
}