package net.guttershark.display.buttons 
{
	import net.guttershark.display.buttons.MovieClipToggleButton;	
	import net.guttershark.managers.SoundManager;	
	
	/**
	 * The MovieClipCheckBox class inherits from MovieClipToggleButton
	 * mostly for cosmetics purposes - a getter and setter for "checked." 
	 * As well as 2 sound property additions.
	 */
	public class MovieClipCheckBox extends MovieClipToggleButton
	{

		/**
		 * The sound to play when the button becomes "checked.";
		 */
		public var checkedSound:String;
		
		/**
		 * The sound to play when the button is "unchecked."
		 */
		public var uncheckedSound:String;
		
		/**
		 * Set the checked state of the button. Note that this is a 
		 * convenience method if you need to "check" this button through
		 * code. But by default "checked" toggling happens by default with
		 * mouse interaction.
		 */
		public function set checked(state:Boolean):void
		{
			_toggled = state;
			if(state && checkedSound) SoundManager.gi().playSound(checkedSound);
			else if(!state && uncheckedSound) SoundManager.gi().playSound(uncheckedSound);
			if(_toggled) gotoAndStop(normalToggledFrame);
			else gotoAndStop(normalFrame);
		}

		/**
		 * Read the checked state of the button.
		 */
		public function get checked():Boolean
		{
			return _toggled;
		}	}}