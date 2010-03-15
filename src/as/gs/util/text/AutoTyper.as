package gs.util.text 
{
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;

	/**
	 * The AutoTyper class will auto type some
	 * text into a text field at delayed times.
	 */
	public class AutoTyper 
	{
		
		/**
		 * The text field.
		 */
		private var tf:TextField;
		
		/**
		 * Timer for typing.
		 */
		private var timer:Timer;
		
		/**
		 * The text to type.
		 */
		private var text:String;
		
		/**
		 * Text split into array.
		 */
		private var splits:Array;
		
		/**
		 * Constructor for AutoTyper instances.
		 * 
		 * @param _tf The text field to type to.
		 */
		public function AutoTyper(_tf:TextField):void
		{
			if(!_tf)throw new ArgumentError("ERROR: Parameter {_tf} cannot be null.");
			tf=_tf;
		}
		
		/**
		 * Type some text.
		 * 
		 * @param _text The text to type.
		 * @param _timePerChar The time in milliseconds to wait before typing each char.
		 */
		public function type(_text:String,_timePerChar:Number):void
		{
			text=_text;
			splits=text.split("");
			tf.text="";
			timer=new Timer(_timePerChar);
			timer.addEventListener(TimerEvent.TIMER,_tick);
			timer.start();
		}
		
		/**
		 * tick handler.
		 */
		private function _tick(e:TimerEvent):void
		{
			if(splits.length<1)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER,_tick);
				return;
			}
			var s:String=splits.shift();
			while(s == " ")
			{
				tf.appendText(" ");
				s=splits.shift();
			}
			tf.appendText(s);
		}
	}
}