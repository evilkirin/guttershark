package gs.display.tooltip
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;

	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * The BaseToolTip class is the base class for a
	 * tooltip displayed over a display object. You
	 * should extend this when you implement your
	 * own tool tips.
	 * 
	 * <p>You use the ToolTipManager to manage creating
	 * tooltips for you.</p>
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class BaseToolTip extends Sprite
	{
		
		/**
		 * Coordinates to move to.
		 */
		protected var newCoords:Point;
		
		/**
		 * Constructor for BaseToolTip intances.
		 */
		public function BaseToolTip()
		{
			super();
		}
		
		/**
		 * Show the tooltip - use the point parameter
		 * for x, and y values.
		 * 
		 * @param point The cordinates this tooltip should move to.
		 */
		public function show(point:Point):void
		{
			newCoords=point;
			if(this.x!=newCoords.x)
			{
				this.x=newCoords.x;
				this.y=newCoords.y;
			}
			alpha=0;
			visible=true;
			TweenMax.to(this,.2,{autoAlpha:1,ease:Quad.easeOut});
		}
		
		/**
		 * Hide the tooltip.
		 */
		public function hide():void
		{
			visible=false;
		}
	}
}