package gs.display.button 
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class GSButton 
	{
		
		protected var strokeHolder:Sprite;
		protected var fillHolder:Sprite;
		protected var _stroke:DisplayObject;
		protected var _fill:DisplayObject;
		protected var _label:TextField;
		protected var _icon:DisplayObject;
		protected var _multiLine:Boolean;
		
		public function GSButton()
		{
			strokeHolder=new Sprite();
			fillHolder=new Sprite();
		}
		
		public function set stroke(val:DisplayObject):void
		{
			_stroke=val;
			strokeHolder.addChild(_stroke);
		}
		
		public function set fill(val:MovieClip):void
		{
			_fill=val;
			fillHolder.addChild(_fill);
		}
		
		public function set label(val:TextField):void
		{
			
		}
		
		public function set icon(val:DisplayObject):void
		{
			
		}
		
		public function set multiLine(val:Boolean):void
		{
			
		}
	}
}