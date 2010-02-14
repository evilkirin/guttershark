package gs.display 
{
	import flash.display.Sprite;
	
	/**
	 * The Scale9Clip is a sprite that manages scale 9.
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
		}
		
		/**
		 * Set references to each piece.
		 * 
		 * @param l The left section.
		 * @param r The right section.
		 * @param t The top section.
		 * @param b The bottom section.
		 * @param m The middle section.
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
		}
		
		/**
		 * Height
		 */
		override public function set height(val:Number):void
		{
			mid.height=val-top.height;
			left.height=right.height=mid.height+top.height+bottom.height;
			bottom.y=top.y+top.height+mid.height;
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
			top.width=mid.width=bottom.width=val-right.width;
			right.x=left.x+top.width+left.width;
		}
		
		/**
		 * Width
		 */
		override public function get width():Number
		{
			return left.width+mid.width+right.width;
		}
		
		/**
		 * x
		 */
		override public function set x(val:Number):void
		{
		}
		
		/**
		 * x
		 */
		override public function get x():Number
		{
			return left.x;
		}
		
		/**
		 * y
		 */
		override public function set y(val:Number):void
		{
			
		}
		
		/**
		 * y
		 */
		override public function get y():Number
		{
			return left.y;
		}
	}
}
