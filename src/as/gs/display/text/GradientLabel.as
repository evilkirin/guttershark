package gs.display.text 
{
	import gs.util.TextAttributes;

	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.text.TextField;

	/**
	 * The GradientLabel class creates gradiated text,
	 * it uses a text field as a mask applied to a gradient.
	 * 
	 * <p>Read about drawing gradiends, and read the Matrix
	 * class' createGradientBox method for more information
	 * about how properties on this class are mapped to the
	 * actual gradient.</p>
	 */
	public class GradientLabel extends MovieClip 
	{
		
		/**
		 * The text field to use as the mask.
		 * 
		 * <p>If you bind a movie clip in the flash IDE to
		 * an instance of GradientLabel, set the text field
		 * instance name to "field"</p>
		 */
		public var field:TextField;
		
		/**
		 * A matrix
		 */
		public var matrix:Matrix;
		
		/**
		 * An array of colors to apply in the gradient.
		 */
		public var colors:Array;
		
		/**
		 * Color alphas.
		 */
		public var alphas:Array;
		
		/**
		 * Color ratios.
		 */
		public var ratios:Array;
		
		/**
		 * Gradient movie clip.
		 */
		private var grad:MovieClip;
		
		/**
		 * A text attributes instance.
		 */
		private var ta:TextAttributes;
		
		/**
		 * Constructor for GradientText instances.
		 * 
		 * @param field (Optional) The text field to use as the mask.
		 */
		public function GradientLabel(tf:TextField = null)
		{
			if(tf)
			{
				field=tf;
				addChild(tf);
				y=tf.y;
				x=tf.x;
				tf.x=0;
				tf.y=0;
			}
			if(field && !field.embedFonts)trace("WARNING: Fonts aren't embedded for gradient label.");
			matrix=new Matrix();
			grad=new MovieClip();
			if(field)
			{
				grad.mask=field;
				matrix.createGradientBox(field.textWidth+2,field.textHeight+2,Math.PI/2);
			}
			colors=[0x00CBFF,0xFF0066];
			alphas=[1,1];
			ratios=[0,255];
			addChild(grad);
			draw();
		}
		
		/**
		 * Triggers an update (draw)
		 */
		public function update():void
		{
			draw();
		}
		
		/**
		 * The text field for the mask.
		 */
		public function set textField(tf:TextField):void
		{
			if(!tf)return;
			field=tf;
			x=tf.x;
			y=tf.y;
			tf.x=0;
			tf.y=0;
			addChild(tf);
			grad.mask=field;
			updateGradientBox(field.textWidth,field.textHeight,Math.PI/2);
			draw();
		}
		
		/**
		 * The text field for the mask.
		 */
		public function get textField():TextField
		{
			return field;
		}
		
		/**
		 * A shortcut to set the gradient box on the matrix.
		 * 
		 * @param width The width
		 * @param height The height
		 * @param rotation The rotation
		 * @param tx The distance, in pixels, to translate to the right along the x axis. This value is offset by half of the width parameter
		 * @param ty The distance, in pixels, to translate down along the y axis. This value is offset by half of the height parameter.
		 */
		public function updateGradientBox(width:int,height:int,rotation:Number=1.57,tx:Number=0,ty:Number=0):void
		{
			matrix.createGradientBox(width,height,rotation,tx,ty);
		}
		
		/**
		 * The text.
		 */
		public function set text(str:String):void
		{
			var tmp:String=field.text;
			field.text=str;
			if(tmp!=str)draw();
		}
		
		/**
		 * The text.
		 */
		public function get text():String
		{
			return field.text;
		}
		
		/**
		 * The text attributes instance to apply to the text field.
		 * 
		 * @param ta The text attributes instance.
		 */
		public function set textAttributes(ta:TextAttributes):void
		{
			this.ta=ta;
			ta.apply(field);
			draw();
		}
		
		/**
		 * The text attributes instance to apply to the text field.
		 * 
		 * @param ta The text attributes instance.
		 */
		public function get textAttributes():TextAttributes
		{
			return ta;
		}
		
		/**
		 * Draws the gradient.
		 */
		protected function draw():void
		{
			if(!grad) return;
			if(!field) return;
			grad.graphics.clear();
			grad.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,matrix);
			grad.graphics.drawRect(0,0,field.textWidth+2,field.textHeight+2);
			grad.graphics.endFill();
		}
		
		/**
		 * Dispose of this GradientLabel.
		 */
		public function dispose():void
		{
			colors=null;
			ratios=null;
			alphas=null;
			matrix=null;
			removeChild(grad);
			grad.mask=null;
			grad=null;
			field=null;
			ta.dispose();
			ta=null;
		}
	}
}