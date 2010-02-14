package net.guttershark.display.buttons
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import net.guttershark.display.buttons.IToggleable;
	import net.guttershark.display.buttons.MovieClipButton;
	import net.guttershark.managers.SoundManager;

	/**
	 * The MovieClipToggleButton class is a basic button that
	 * toggles between two states, using frames as the states.
	 * 
	 * <p>Default frame states:</p>
	 * <ul>
	 * <li>1 = normal state</li>
	 * <li>2 = normal over state</li>
	 * <li>3 = toggled normal state</li>
	 * <li>4 = toggled over state</li>
	 * </ul>
	 * 
	 * <p>There is also 1 sound property added.</p>
	 * <ul>
	 * <li>toggledStateChangeSound</li>
	 * </ul>
	 * 
	 * <p>The <code><em>locked</em></code> is not supported on this class</p>
	 * 
	 * <p>There is an example of this class in the examples/ui/controls/buttons folder.</p>
	 */
	public class MovieClipToggleButton extends MovieClipButton implements IToggleable
	{
		
		/**
		 * The frame to go to for the out toggled state.
		 */
		public var normalToggledFrame:int = 3;
		
		/**
		 * The frame to go to for the toggled over state.
		 */
		public var overToggledFrame:int = 4;
		
		/**
		 * Flag indicator for the toggled state
		 */
		protected var _toggled:Boolean;
		
		/**
		 * The sound to play when a change to the toggle state
		 * happens. 
		 */
		public var toggleStateChangeSound:String;
		
		/**
		 * Constructor for MovieClipCheckBox instances. Generally this class should be 
		 * bound to a movie clip in the library.
		 */
		public function MovieClipToggleButton()
		{
			//EventManager.gi().handleEvents(this,this,"onThis");
		}
		
		public function onThisFocusIn():void
		{
			//KeyboardEventManager.gi().addMapping(this, " ", onSpace);
		}

		public function onThisFocusOut():void
		{
			//KeyboardEventManager.gi().removeMapping(this, " ");
		}
		
		/*private function onSpace():void
		{
			this.toggled = !this.toggled;
		}*/

		/**
		 * @private
		 * overrides to ignore lock feature.
		 */
		override public function set locked(value:Boolean):void
		{
			return;
		}
		
		/**
		 * @private
		 * Overrides the getter to always return false. as locked is
		 * not supported
		 */
		override public function get locked():Boolean
		{
			return false;
		}
		
		/**
		 * @private
		 * Overrides the onMouseOver for custom logic dealing with
		 * toggled state.
		 */
		override protected function __onMouseOver(me:MouseEvent):void
		{
			if(overSound) SoundManager.gi().playSound(overSound);
			over = true;
			if(_toggled) gotoAndStop(overToggledFrame);
			else gotoAndStop(overFrame);
		}

		/**
		 * @private
		 * Overrides the onMouseOver for custom logic dealing with
		 * toggled state.
		 */
		override protected function __onMouseUp(me:MouseEvent):void
		{
			if(upSound) SoundManager.gi().playSound(upSound);
			if(_toggled && over) gotoAndStop(overToggledFrame);
			else if(_toggled) gotoAndStop(normalToggledFrame);
			else if(!_toggled && over) gotoAndStop(overFrame);
			else gotoAndStop(normalFrame);
			down = false;
		}
		
		/**
		 * @private
		 * When the mouse button is released outside of the clip. This is not supported in Flex.
		 */
		override protected function __onMouseUpOutside(me:MouseEvent):void
		{
			if(!over)
			{
				me.stopPropagation();
				down = false;
				return;
			}
			if(upSound) SoundManager.gi().playSound(upSound);
			if(_toggled) gotoAndStop(overToggledFrame);
			else gotoAndStop(normalFrame);
			down = false;
		}
		
		/**
		 * @private
		 * Overrides the onMouseOver for custom logic dealing with
		 * toggled state.
		 */
		override protected function __onMouseOut(me:MouseEvent):void
		{
			if(outSound) SoundManager.gi().playSound(outSound);
			over = false;
			if(_toggled) gotoAndStop(normalToggledFrame);
			else gotoAndStop(normalFrame);
		}

		/**
		 * @private
		 * Overrides the default super implementation to automatically
		 * toggle between the toggled / (down|over|normal) frames.
		 */
		override protected function __onMouseDown(me:MouseEvent):void
		{
			if(_locked) return;
			this.toggled = !this.toggled;
			if(_toggled) gotoAndStop(normalToggledFrame);
			down = true;
		}
		
		/**
		 * @private
		 * Interface compliance
		 */
		public function get toggled():Boolean
		{
			return _toggled;
		}
		
		/**
		 * @private
		 * interface compliance
		 */
		public function set toggled(val:Boolean):void
		{
			_toggled = val;
		}
	}
}