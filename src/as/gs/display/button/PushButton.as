package gs.display.button 
{
	import flash.events.MouseEvent;
	public class PushButton extends ClipButton
	{
		
		protected var _pushed:Boolean;
		
		public function get pushed():Boolean
		{
			return _pushed;
		}
		
		public function set pushed(val:Boolean):void
		{
			_pushed=val;
		}
		
		override protected function _onMouseOut(e:MouseEvent):void
		{
			if(pushed && useFrames) gotoAndStop(2);
		}
		
		override protected function _onMouseOver(e:MouseEvent):void
		{
			if(useFrames)gotoAndStop(2);
		}
	}
}
