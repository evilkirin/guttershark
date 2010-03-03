package gs.display.shapes
{
	import flash.display.Sprite;
	
	public class RoundRect extends Sprite 
	{
		
		public var fill:Sprite;
		public var stroke:Sprite;
		public var strokeWeight:Number;
		public var strokeColor:Number;
		public var fillColor:Number;
		public var cornerRadius:Number;
		protected var topLeftRadius:Number;
		protected var topRightRadius:Number;
		protected var bottomLeftRadius:Number;
		protected var bottomRightRadius:Number;
		protected var useComplex:Boolean;
		private var _width:Number;
		private var _height:Number;
		
		public function RoundRect()
		{
			super();
			fill=new Sprite();
			stroke=new Sprite();
			strokeColor=0;
			strokeWeight=0;
			addChild(stroke);
			addChild(fill);
		}
		
		public function init(_width:Number,_height:Number,_cornerRadius:Number=5,_fillColor:Number=0xff0066,_strokeColor:Number=NaN,_strokeWeight:Number=NaN,drawAfterInit:Boolean=false):void
		{
			width=_width;
			height=_height;
			cornerRadius=_cornerRadius;
			fillColor=_fillColor;
			if(!isNaN(_strokeColor))strokeColor=_strokeColor;
			if(!isNaN(_strokeWeight))strokeWeight=_strokeWeight;
			if(drawAfterInit)draw();
		}
		
		public function setComplexCornerRadiuses(topleft:Number,topright:Number,bottomleft:Number,bottomright:Number):void
		{
			useComplex=true;
			topLeftRadius=topleft;
			topRightRadius=topright;
			bottomLeftRadius=bottomleft;
			bottomRightRadius=bottomright;
		}
		
		public function draw():void
		{
			drawFill();
			drawStroke();
		}
		
		public function setSize(w:Number,h:Number):void
		{
			var sd:Boolean=false;
			if(w != width || h != height) sd=true;
			width=w;
			height=h;
			if(sd)draw();
		}
		
		override public function set height(val:Number):void
		{
			_height=val;
		}
		
		override public function set width(val:Number):void
		{
			_width=val;
		}
		
		private function drawFill():void
		{
			fill.graphics.beginFill(fillColor);
			if(useComplex)fill.graphics.drawRoundRectComplex(strokeWeight,strokeWeight,_width-(strokeWeight*2),_height-(strokeWeight*2),cornerRadius,cornerRadius,cornerRadius,cornerRadius);
			else fill.graphics.drawRoundRect(strokeWeight,strokeWeight,_width-(strokeWeight*2),_height-(strokeWeight*2),cornerRadius);
		}
		
		private function drawStroke():void
		{
			stroke.graphics.beginFill(strokeColor);
			if(useComplex)stroke.graphics.drawRoundRectComplex(0,0,_width,_height,cornerRadius,cornerRadius,cornerRadius,cornerRadius);
			else stroke.graphics.drawRoundRect(0,0,_width,_height,cornerRadius);
		}
	}
}