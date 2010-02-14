package gs.util 
{
	import flash.display.DisplayObject;
	import flash.geom.Point;	

	/**
	 * The DisplayListUtils class contains utlility methods for display
	 * list manipulation.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class DisplayListUtils
	{
		
		/**
		 * Translate the display object container position in a new container.
		 */
		public static function localToLocal(from:DisplayObject, to:DisplayObject):Point
		{
			var point:Point=new Point();
			point=from.localToGlobal(point);
			point=to.globalToLocal(point);
			return point;
		}
		
		/**
		 * Set the scale of an object - updates the x and y.
		 * 
		 * @param target The target item to scale. 
		 * @param scale	The scale percentage.
		 */
		public static function scale(target:DisplayObject,scale:Number):void
		{
			target.scaleX=scale;
			target.scaleY=scale;
		}

		/**
		 * Scale target item to fit within target confines.
		 * 
		 * @param target The item to be aligned.
		 * @param targetW The target item width.
		 * @param targetH The target item height.
		 * @param center Center the object within the targetW and targetH.
		 */
		public static function scaleToFit(target:DisplayObject,targetW:Number,targetH:Number,center:Boolean=false):void
		{
			if(target.width<targetW && target.width>target.height)
			{
				target.width=targetW;
				target.scaleY=target.scaleX;
			}
			else
			{
				target.height=targetH;
				target.scaleX=target.scaleY;
			}
			if(center) 
			{
				target.x=int(targetW/2-target.width/2);
				target.y=int(targetH/2-target.height/2);
			}
		}

		/**
		 * Scale while retaining original w:h ratio.
		 * 
		 * @param target The item to be scaled.
		 * @param targetW The target item width.
		 * @param targetH The target item height.
		 */
		public static function scaleRatio(target:DisplayObject,targetW:Number,targetH:Number):void
		{
			if(targetW/targetH<target.height/target.width) targetW=targetH * target.width / target.height; 
			else targetH=targetW * target.height / target.width;
			target.width=targetW;
			target.height=targetH;
		}
		
		/**
		 * Flip an object on the x or y axis.
		 * 
		 * @param obj The object to flip
		 * @param axis The axis to flip on - "x" or "y"
		 */
		public static function flip(obj:Object,axis:String="y"):void
		{
			if(axis != "x" && axis != "y") 
			{
				throw new Error("Error: flip expects axis param: 'x' or 'y'.");
				return;
			}
			var _scale:String=axis == "x" ? "scaleX" :"scaleY";
			var _prop:String=axis == "x" ? "width" : "height";
			obj[_scale]=-obj[_scale];
			obj[axis] += obj[_prop];
		}
	}
}