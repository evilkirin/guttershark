package gs.util
{
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	 * The MouseUtils class has utility methods for working with mouse positions.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class MouseUtils
	{
		
		/**
		 * Check to see if the mouse is within the bounds of a rectangle.
		 * 
		 * @param scope The scope of mouse coordinates to use.
		 * @param rectangle The bounds in wich to check the mouse position against.
		 */
		public static function inRectangle(scope:DisplayObject,rectangle:Rectangle):Boolean
		{
			if(!scope) throw new ArgumentError("Parameter scope cannot be null.");
			if(!rectangle) throw new ArgumentError("Parameter rectangle cannot be null");
			var ym:Number=scope.mouseY;
			var xm:Number=scope.mouseX;
			if(xm > rectangle.x && xm < rectangle.right && ym > rectangle.y && ym < rectangle.bottom) return true;
			return false;
		}
	}
}