package gs.display 
{
	import flash.display.Sprite;
	
	/**
	 * The Scale9Clip is a sprite that manages scale 9.
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class Scale9Clip extends Sprite
	{
		
		/**
		 * The top left section.
		 */
		public var topLeft:Sprite;
		
		/**
		 * The top section.
		 */
		public var top:Sprite;
		
		/**
		 * The top right section.
		 */
		public var topRight:Sprite;
		
		/**
		 * The left section.
		 */
		public var left:Sprite;
		
		/**
		 * The middle section.
		 */
		public var mid:Sprite;
		
		/**
		 * The right section.
		 */
		public var right:Sprite;
		
		/**
		 * The bottom left section.
		 */
		public var bottomLeft:Sprite;
		
		/**
		 * The bottom section.
		 */
		public var bottom:Sprite;
		
		/**
		 * The bottom right section.
		 */
		public var bottomRight:Sprite;
		
		/**
		 * Constructor for Scale9Clip instances.
		 */
		public function Scale9Clip()
		{
			initPositions();
		}
		
		/**
		 * Initializes positions.
		 */
		private function initPositions():void
		{
			if(topLeft && top && topRight && left && mid && right && bottomLeft && bottom && bottomRight)
			{
				//top row
				top.y = topLeft.y;
				top.x = topLeft.x+topLeft.width;
				topRight.y = topLeft.y;
				topRight.x = top.x+top.width;
				//middle row
				left.y=topLeft.y+topLeft.height;
				left.x=topLeft.x;
				mid.x=left.x+left.width;
				mid.y=topLeft.y+topLeft.height;
				right.y=topLeft.y+topLeft.height;
				right.x=mid.x+mid.width;
				//bottom row
				bottomLeft.y=left.y+left.height;
				bottomLeft.x=topLeft.x;
				bottom.y=left.y+left.height;
				bottom.x=topLeft.x+topLeft.width;
				bottomRight.y=right.y+right.height;
				bottomRight.x=bottom.x+bottom.width;
			}
		}
		
		/**
		 * Set's the size for width and height.
		 * 
		 * @param width The new width.
		 * @param height The new height.
		 */
		public function setSize(width:Number,height:Number):void
		{
			this.width=width;
			this.height=height;
		}
		
		/**
		 * Set references to each piece.
		 * 
		 * @param tl The top left piece.
		 * @param t The top piece.
		 * @param tr The top right piece.
		 * @param l The left piece.
		 * @param m The mid piece.
		 * @param r The right piece.
		 * @param bl The bottom left piece.
		 * @param b The bottom piece.
		 * @param br The bottom right piece.
		 */
		public function setRefs(tl:Sprite,t:Sprite,tr:Sprite,l:Sprite,m:Sprite,r:Sprite,bl:Sprite,b:Sprite,br:Sprite):void
		{
			topLeft=tl;
			top=t;
			topRight=tr;
			left=l;
			mid=m;
			right=r;
			bottomLeft=bl;
			bottom=b;
			bottomRight=br;
			initPositions();
		}
		
		/**
		 * Height
		 */
		override public function set height(val:Number):void
		{
			left.height=mid.height=right.height=val-(top.height+bottom.height);
			bottomLeft.y=bottom.y=bottomRight.y=mid.y+mid.height;
		}
		
		/**
		 * Height
		 */
		override public function get height():Number
		{
			return top.height+mid.height+bottom.height;
		}
		
		/**
		 * Width
		 */
		override public function set width(val:Number):void
		{
			top.width = mid.width =bottom.width = val-(left.width+right.width);
			top.x = mid.x = bottom.x = topLeft.x + topLeft.width;
			topRight.x = right.x = bottomRight.x = top.x + top.width;
		}
		
		/**
		 * Width
		 */
		override public function get width():Number
		{
			return left.width+mid.width+right.width;
		}
		
		/**
		 * x position
		 */
		override public function set x(val:Number):void
		{
			topLeft.x=left.x=bottomLeft.x=val;
			top.x=mid.x=bottom.x=topLeft.x+topLeft.width;
			topRight.x=right.x=bottomRight.x=top.x+top.width;
		}

		/**
		 * x position
		 */
		override public function get x():Number
		{
			return topLeft.x;
		}
		
		/**
		 * y position
		 */
		override public function set y(val:Number):void
		{
			topLeft.y=top.y=topRight.y=val;
			left.y=mid.y=right.y=topLeft.y+topLeft.height;
			bottomLeft.y=bottom.y=bottomRight.y=mid.y+mid.height;
		}
		
		/**
		 * y position
		 */
		override public function get y():Number
		{
			return topLeft.y;
		}
		
		/**
		 * Dispose of this scale 9 clip.
		 */
		public function dispose():void
		{
			topLeft=null;
			top=null;
			topRight=null;
			left=null;
			mid=null;
			right=null;
			bottomLeft=null;
			bottom=null;
			bottomRight=null;
		}
	}
}