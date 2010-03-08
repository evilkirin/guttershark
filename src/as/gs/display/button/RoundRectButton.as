package gs.display.button
{
	import gs.display.shapes.RoundRect;
	import gs.util.ColorUtils;
	import gs.util.EventUtil;
	import gs.util.TextFieldUtils;
	
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class RoundRectButton extends Sprite
	{
		
		public var hit:Sprite;
		public var field:TextField;
		public var rr:RoundRect;
		public var fillColor:Number;
		public var fillOverColor:Number;
		public var strokeColor:Number;
		public var strokeOverColor:Number;
		public var labelColor:Number;
		public var labelOverColor:Number;
		
		public function RoundRectButton(label:String,width:Number,height:Number,fillColor:Number,fillOverColor:Number=NaN,strokeColor:Number=NaN,strokeOverColor:Number=NaN,labelColor:Number=NaN,labelOverColor:Number=NaN,strokeWeight:Number=NaN,fillRectRadius:Number=12,strokeRectRadius:Number=12)
		{
			this.fillColor=fillColor;
			this.fillOverColor=fillOverColor;
			this.strokeColor=strokeColor;
			this.strokeOverColor=strokeOverColor;
			this.labelColor=labelColor;
			this.labelOverColor=labelOverColor;
			field=TextFieldUtils.create();
			field.text=label;
			field.x=(width-field.width)/2;
			field.y=(height-field.height)/2;
			ColorUtils.setColor(field,labelColor);
			rr=new RoundRect(width,height,fillRectRadius,strokeRectRadius,fillColor,strokeColor,strokeWeight);
			addChild(rr);
			addChild(field);
			update();
		}
		
		public function setSize(w:Number,h:Number):void
		{
			rr.setSize(w,h);
		}
		
		public function onHitOver(e:MouseEvent):void
		{
			if(!isNaN(fillOverColor)) TweenMax.to(rr.fill,.1,{tint:fillOverColor});
			if(!isNaN(strokeOverColor)) TweenMax.to(rr.stroke,.1,{tint:strokeOverColor});
			if(!isNaN(labelOverColor)) TweenMax.to(field,.1,{tint:labelOverColor});
		}
		
		public function onHitOut(e:MouseEvent):void
		{
			if(!isNaN(fillColor)) TweenMax.to(rr.fill,.1,{tint:fillColor});
			if(!isNaN(strokeColor)) TweenMax.to(rr.stroke,.1,{tint:strokeColor});
			TweenMax.to(field,.1,{removeTint:true});
		}
		
		public function update():void
		{
			updateHit();
		}
		
		private function updateHit():void
		{
			if(!hit)
			{
				hit=new Sprite();
				EventUtil.mouseover(hit,onHitOver);
				hit.addEventListener(MouseEvent.MOUSE_OUT,onHitOut);
			}
			else hit.graphics.clear();
			hit.buttonMode=true;
			hit.useHandCursor=true;
			hit.graphics.beginFill(0xffffff);
			hit.graphics.drawRect(0,0,width,height);
			hit.alpha=0;
			addChild(hit);
		}
		
		override public function set width(val:Number):void
		{
			rr.width=val;
			rr.draw();
		}
		
		override public function set height(val:Number):void
		{
			rr.height=val;
			rr.draw();
		}
	}
}