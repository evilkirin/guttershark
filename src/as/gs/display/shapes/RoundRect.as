package gs.display.shapes
{
	import flash.display.Sprite;

	/**
	 * The RoundRect class creates round rectangles.
	 * 
	 * <p>This simplifies creating vector round rectangles
	 * with optional strokes, and gives you access to the
	 * fill and stroke as seperate sprites</p>
	 */
	public class RoundRect extends Sprite
	{
		
		/**
		 * The fill.
		 */
		public var fill:Sprite;
		
		/**
		 * The Stroke.
		 */
		public var stroke:Sprite;
		
		/**
		 * The stroke weight.
		 */
		protected var _strokeWeight:Number;
		
		/**
		 * The stroke color.
		 */
		protected var _strokeColor:Number;
		
		/**
		 * The fill color.
		 */
		public var fillColor:Number;
		
		/**
		 * Corner radius for all four corners.
		 */
		public var cornerRadius:Number;
		
		/**
		 * Top left radius if using complex corners.
		 */
		protected var topLeftRadius:Number;
		
		/**
		 * Top right radius if using complex corners.
		 */
		protected var topRightRadius:Number;
		
		/**
		 * Bottom left radius if using complex corners.
		 */
		protected var bottomLeftRadius:Number;
		
		/**
		 * Bottom right radius if using complex corners.
		 */
		protected var bottomRightRadius:Number;
		
		/**
		 * Whether or not to draw with complex radiuses (individual radiuses for each corner.).
		 */
		protected var useComplex:Boolean;
		
		/**
		 * Width.
		 */
		protected var _width:Number;
		
		/**
		 * Height.
		 */
		protected var _height:Number;
		
		/**
		 * Constructor for RoundRect instances.
		 * 
		 * @param _width Width.
		 * @param _height Height.
		 * @param _cornerRadius The corner radius for all four corners.
		 * @param _fillColor The fill color.
		 * @param _strokeColor The stroke color if any (pass NaN if you don't want any stroke).
		 * @param _strokeWeight The stroke weight if a stroke is used (pass NaN if you don't want any stroke).
		 * @param drawAfterInit Whether or not to draw the vectors after initialization.
		 */
		public function RoundRect(_width:Number,_height:Number,_cornerRadius:Number=5,_fillColor:Number=0xff0066,_strokeColor:Number=NaN,_strokeWeight:Number=NaN,drawAfterInit:Boolean=false)
		{
			super();
			fill=new Sprite();
			stroke=new Sprite();
			this._strokeColor=0;
			this._strokeWeight=0;
			addChild(stroke);
			addChild(fill);
			this._width=_width;
			this._height=_height;
			cornerRadius=_cornerRadius;
			fillColor=_fillColor;
			if(!isNaN(_strokeColor))this._strokeColor=_strokeColor;
			if(!isNaN(_strokeWeight))this._strokeWeight=_strokeWeight;
			if(drawAfterInit)draw();
		}
		
		/**
		 * Set the complex corner radiuses.
		 * 
		 * @param topleft The top left radius.
		 * @param topright The top right radius.
		 * @param bottomleft The bottom left radius.
		 * @param bottomright The bottom right radius.
		 */
		public function setComplexCornerRadiuses(topleft:Number,topright:Number,bottomleft:Number,bottomright:Number):void
		{
			useComplex=true;
			topLeftRadius=topleft;
			topRightRadius=topright;
			bottomLeftRadius=bottomleft;
			bottomRightRadius=bottomright;
		}
		
		/**
		 * Clears the use of complex radiuses.
		 */
		public function clearComplexCornerRadiuses():void
		{
			useComplex=false;
		}

		/**
		 * Draws the rounded rectangle.
		 */
		public function draw():void
		{
			drawFill();
			drawStroke();
		}
		
		/**
		 * Set the size, and trigger a draw().
		 * 
		 * @param w The width.
		 * @param h The height.
		 */
		public function setSize(w:Number,h:Number):void
		{
			var sd:Boolean=false;
			if(w!=width||h!=height) sd=true;
			width=w;
			height=h;
			if(sd)draw();
		}
		
		/**
		 * The stroke color.
		 */
		public function set strokeColor(val:Number):void
		{
			if(_strokeColor==val)return;
			_strokeColor=val;
			draw();
		}
		
		/**
		 * The stroke color.
		 */
		public function get strokeColor():Number
		{
			return _strokeColor;
		}
		
		/**
		 * The stroke weight.
		 */
		public function set strokeWeight(val:Number):void
		{
			if(_strokeWeight==val)return;
			_strokeWeight=val;
			draw();
		}
		
		/**
		 * The stroke weight.
		 */
		public function get strokeWeight():Number
		{
			return _strokeWeight;
		}
		
		/**
		 * Height
		 */
		override public function set height(val:Number):void
		{
			if(_height==val)return;
			_height=val;
			draw();
		}
		
		/**
		 * Width
		 */
		override public function set width(val:Number):void
		{
			if(_width==val)return;
			_width=val;
			draw();
		}
		
		/**
		 * Draws the fill.
		 */
		private function drawFill():void
		{
			fill.graphics.beginFill(fillColor);
			if(useComplex)fill.graphics.drawRoundRectComplex(strokeWeight,strokeWeight,_width-(strokeWeight*2),_height-(strokeWeight*2),cornerRadius,cornerRadius,cornerRadius,cornerRadius);
			else fill.graphics.drawRoundRect(strokeWeight,strokeWeight,_width-(strokeWeight*2),_height-(strokeWeight*2),cornerRadius);
		}
		
		/**
		 * Draws the stroke.
		 */
		private function drawStroke():void
		{
			stroke.graphics.beginFill(strokeColor);
			if(useComplex)stroke.graphics.drawRoundRectComplex(0,0,_width,_height,cornerRadius,cornerRadius,cornerRadius,cornerRadius);
			else stroke.graphics.drawRoundRect(0,0,_width,_height,cornerRadius);
		}
		
		/**
		 * Dispose of this round rectangle.
		 */
		public function dispose():void
		{
			stroke.graphics.clear();
			fill.graphics.clear();
			fill=null;
			stroke=null;
			_strokeWeight=NaN;
			_strokeColor=NaN;
			fillColor=NaN;
			cornerRadius=NaN;
			topLeftRadius=NaN;
			topRightRadius=NaN;
			bottomLeftRadius=NaN;
			bottomRightRadius=NaN;
			useComplex=false;
			_width=NaN;
			_height=NaN;
		}
	}
}