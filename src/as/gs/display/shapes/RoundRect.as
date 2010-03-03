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
		 * The stroke.
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
		 * Corner radius for all four corners of the fill.
		 */
		public var fillCornerRadius:Number;
		
		/**
		 * Corner radius for all four corners of the stroke.
		 */
		public var strokeCornerRadius:Number;
		
		/**
		 * Top left fill radius if using complex corners.
		 */
		protected var fillTopLeftRadius:Number;
		
		/**
		 * Top right fill radius if using complex corners.
		 */
		protected var fillTopRightRadius:Number;
		
		/**
		 * Bottom left fill radius if using complex corners.
		 */
		protected var fillBottomLeftRadius:Number;
		
		/**
		 * Bottom right fill radius if using complex corners.
		 */
		protected var fillBottomRightRadius:Number;
		
		/**
		 * Top left stroke radius if using complex corners.
		 */
		protected var strokeTopLeftRadius:Number;
		
		/**
		 * Top right stroke radius if using complex corners.
		 */
		protected var strokeTopRightRadius:Number;
		
		/**
		 * Bottom left stroke radius if using complex corners.
		 */
		protected var strokeBottomLeftRadius:Number;
		
		/**
		 * Bottom right stroke radius if using complex corners.
		 */
		protected var strokeBottomRightRadius:Number;
		
		/**
		 * Whether or not to draw the fill with complex radiuses (individual radiuses for each corner).
		 */
		protected var useComplexFill:Boolean;
		
		/**
		 * Whether or not to draw the stroke with complex radiuses (individiaul radiuses for each corner).
		 */
		protected var useComplexStroke:Boolean;
		
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
		public function RoundRect(_width:Number,_height:Number,_fillCornerRadius:Number=5,_strokeCornerRadius:Number=5,_fillColor:Number=0xff0066,_strokeColor:Number=NaN,_strokeWeight:Number=NaN,drawAfterInit:Boolean=false)
		{
			super();
			fill=new Sprite();
			stroke=new Sprite();
			addChild(stroke);
			addChild(fill);
			fillCornerRadius=_fillCornerRadius;
			strokeCornerRadius=_strokeCornerRadius;
			fillColor=_fillColor;
			this._strokeColor=0;
			this._strokeWeight=0;
			this._width=_width;
			this._height=_height;
			if(!isNaN(_strokeColor))this._strokeColor=_strokeColor;
			if(!isNaN(_strokeWeight))this._strokeWeight=_strokeWeight;
			if(drawAfterInit)draw();
		}
		
		/**
		 * Set the complex corner radiuses for the fill.
		 * 
		 * @param topleft The top left radius.
		 * @param topright The top right radius.
		 * @param bottomleft The bottom left radius.
		 * @param bottomright The bottom right radius.
		 */
		public function setFillComplexCornerRadiuses(topleft:Number,topright:Number,bottomleft:Number,bottomright:Number):void
		{
			useComplexFill=true;
			var sd:Boolean=false;
			if(fillTopLeftRadius!=topleft||fillTopRightRadius!=topright||fillBottomLeftRadius!=bottomleft||fillBottomRightRadius!=bottomright)sd=true;
			fillTopLeftRadius=topleft;
			fillTopRightRadius=topright;
			fillBottomLeftRadius=bottomleft;
			fillBottomRightRadius=bottomright;
			if(sd)draw();
		}
		
		/**
		 * Set the complex corner radiuses for the stroke.
		 * 
		 * @param topleft The top left radius.
		 * @param topright The top right radius.
		 * @param bottomleft The bottom left radius.
		 * @param bottomright The bottom right radius.
		 */
		public function setStrokeComplexCornerRadiuses(topleft:Number,topright:Number,bottomleft:Number,bottomright:Number):void
		{
			useComplexStroke=true;
			var sd:Boolean=false;
			if(strokeTopLeftRadius!=topleft||strokeTopRightRadius!=topright||strokeBottomLeftRadius!=bottomleft||strokeBottomRightRadius!=bottomright)sd=true;
			strokeTopLeftRadius=topleft;
			strokeTopRightRadius=topright;
			strokeBottomLeftRadius=bottomleft;
			strokeBottomRightRadius=bottomright;
			if(sd)draw();
		}
		
		/**
		 * Clears the use of complex radiuses.
		 */
		public function clearComplexCornerRadiuses():void
		{
			useComplexFill=false;
			useComplexStroke=false;
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
			if(w!=_width||h!=_height) sd=true;
			_width=w;
			_height=h;
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
			if(useComplexFill)fill.graphics.drawRoundRectComplex(strokeWeight,strokeWeight,_width-(strokeWeight*2),_height-(strokeWeight*2),fillTopLeftRadius,fillTopRightRadius,fillBottomLeftRadius,fillBottomRightRadius);
			else fill.graphics.drawRoundRect(strokeWeight,strokeWeight,_width-(strokeWeight*2),_height-(strokeWeight*2),fillCornerRadius);
		}
		
		/**
		 * Draws the stroke.
		 */
		private function drawStroke():void
		{
			stroke.graphics.beginFill(strokeColor);
			if(useComplexStroke)stroke.graphics.drawRoundRectComplex(0,0,_width,_height,strokeTopLeftRadius,strokeTopRightRadius,strokeBottomLeftRadius,strokeBottomRightRadius);
			else stroke.graphics.drawRoundRect(0,0,_width,_height,strokeCornerRadius);
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
			fillCornerRadius=NaN;
			strokeCornerRadius=NaN;
			fillTopLeftRadius=NaN;
			fillTopRightRadius=NaN;
			fillBottomLeftRadius=NaN;
			fillBottomRightRadius=NaN;
			strokeTopLeftRadius=NaN;
			strokeTopRightRadius=NaN;
			strokeBottomLeftRadius=NaN;
			strokeBottomRightRadius=NaN;
			useComplexFill=false;
			useComplexStroke=false;
			_width=NaN;
			_height=NaN;
		}
	}
}