package gs.display.button
{
	import gs.display.GSClip;

	import flash.events.MouseEvent;

	/**
	 * The ClipButton class is a simple button that uses events or 
	 * frames for button states.
	 */
	public class ClipButton extends GSClip implements IButton
	{
		
		/**
		 * Whether or not to use frames as the button states.
		 * 
		 * <p><b>States</b></p>
		 * <ul>
		 * <li>1 = normal</li>
		 * <li>2 = over</li>
		 * <li>3 = down</li>
		 * </ul>
		 */
		public var useFrames:Boolean;
		
		/**
		 * Whether or not the mouse is over the clip.
		 */
		protected var over:Boolean;
		
		/**
		 * Button state.
		 */
		protected var _state:Boolean;
		
		/**
		 * Constructor for clip button instances.
		 */
		public function ClipButton()
		{
			super();
			stop();
			addEventListener(MouseEvent.MOUSE_OVER,_onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,_onMouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN,_onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP,_onMouseUp);
		}
		
		/**
		 * Button state.
		 */
		public function set state(val:Boolean):void
		{
			_state=val;
		}
		
		/**
		 * Button state.
		 */
		public function get state():Boolean
		{
			return _state;
		}
		
		/**
		 * Mouse over.
		 */
		protected function _onMouseOver(e:MouseEvent):void
		{
			over=true;
			stage.addEventListener(MouseEvent.MOUSE_UP,_onMouseUpOutside);
			if(useFrames)gotoAndStop(2);
		}
		
		/**
		 * Mouse out.
		 */
		protected function _onMouseOut(e:MouseEvent):void
		{
			over=false;
			stage.removeEventListener(MouseEvent.MOUSE_UP,_onMouseUpOutside);
			if(useFrames)gotoAndStop(1);
		}
		
		/**
		 * Mouse down.
		 */
		protected function _onMouseDown(e:MouseEvent):void
		{
			if(useFrames)gotoAndStop(3);
		}
		
		/**
		 * Mouse up
		 */
		protected function _onMouseUp(e:MouseEvent):void
		{
			if(useFrames && over)gotoAndStop(2);
			if(useFrames && !over)gotoAndStop(1);
		}
		
		/**
		 * Mouse up outside.
		 */
		protected function _onMouseUpOutside(e:MouseEvent):void
		{
			if(useFrames)gotoAndStop(1);
		}
	}
}