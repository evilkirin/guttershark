package net.guttershark.display
{
	
	import flash.text.TextField;	
	import flash.display.MovieClip;	
	
	/**
	 * The LocalizableClip class is used with the LanguageManager
	 * to add language support at runtime.
	 */
	public class LocalizableClip extends MovieClip
	{
	
		/**
		 * An instance of a text field that sould
		 * be on the stage.
		 */
		public var tfield:TextField;
		
		/**
		 * The text id.
		 */
		private var textID:String;
		
		/**
		 * Constructor for LocalizableClip instances - you should
		 * bind this class to a movie clip in the library, or
		 * if you need to create one through code, pass in
		 * a text field instance in the constructor.
		 * 
		 * @param tf The text field to store internally that displays the text.
		 */
		public function LocalizableClip(tf:TextField=null)
		{
			super();
			this.tfield=tf;
			addChild(tfield);
			if(!this.tfield)throw new Error("The movie clip, {"+this.name+"} must have an instance of a Textfield on the stage called 'tfield'.");
		}
		
		/**
		 * The text content for this clip.
		 */
		public function set localizedText(value:String):void
		{
			tfield.htmlText=value;
		}
		
		/**
		 * The text content for this clip.
		 */
		public function get localizedText():String
		{
			return tfield.htmlText;
		}
		
		/**
		 * The localized id of this clip, which correlates
		 * to a text node in a language xml file.
		 */
		public function get localizedID():String
		{
			return textID;
		}
		
		/**
		 * The localized id of this clip, which correlates
		 * to a text node in a language xml file.
		 */
		public function set localizedID(value:String):void
		{
			textID=value;
		}
	}
}
