package gs.display 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * The Scale3Clip is a sprite that manages scale 3.
	 */
	public class Scale3Clip extends MovieClip
	{
		
		/**
		 * The left edge.
		 */
		public var left:Sprite;
		
		/**
		 * The mid section.
		 */
		public var mid:Sprite;
		
		/**
		 * The right edge.
		 */
		public var right:Sprite;
		
		/**
		 * Constructor for Scale3Clip instances.
		 */
		public function Scale3Clip():void
		{
			if(left && right && mid)
			{
				mid.x=left.x+left.width;
				right.x=mid.x+mid.width;
			}
		}
		
		/**
		 * Set references to each piece.
		 * 
		 * @param l The left edge.
		 * @param m The middle section.
		 * @param r The right edge.
		 */
		public function setRefs(l:Sprite,m:Sprite,r:Sprite):void
		{
			left=l;
			mid=m;
			right=r;
			mid.x=left.x+left.width;
			right.x=mid.x+mid.width;
		}
		
		/**
		 * Height
		 */
		override public function set height(val:Number):void
		{
			left.height=val;
			mid.height=val;
			right.height=val;
		}
		
		/**
		 * Height
		 */
		override public function get height():Number
		{
			return left.height+mid.height+right.height;
		}
		
		/**
		 * Width
		 */
		override public function set width(val:Number):void
		{
			mid.width=Math.max(1,val-(right.width+left.width));
			right.x=mid.x+mid.width; 
		}
		
		/**
		 * Width
		 */
		override public function get width():Number
		{
			return left.width+mid.width+right.width;
		}
		
		/**
		 * x position.
		 */
		override public function set x(val:Number):void
		{
			left.x=val;
			mid.x=left.x+left.width;
			right.x=mid.x+mid.width;
		}
		
		/**
		 * x position
		 */
		override public function get x():Number
		{
			return left.x;
		}
		
		/**
		 * y position
		 */
		override public function set y(val:Number):void
		{
			left.y=val;
			mid.y=val;
			right.y=val;
		}
		
		/**
		 * y position
		 */
		override public function get y():Number
		{
			return left.y;
		}
		
		/**
		 * Dispose of this scale 3 clip.
		 */
		public function dispose():void
		{
			left=null;
			mid=null;
			right=null;
		}
	}
}