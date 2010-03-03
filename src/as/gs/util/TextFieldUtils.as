package gs.util
{
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * The TextFieldUtils class contains utility methods for common operations with TextFields.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class TextFieldUtils
	{
		
		/**
		 * Create a TextField.
		 * 
		 * @param selectable Whether or not the new text field should be selectable.
		 * @param multiline Whether or not the new text field is multiline.
		 * @param border Whether or not to show the 1 px black border around the new textfield.
		 * @param embedFonts Whether or not to embed fonts.
		 * @param autoSize The autosize value.
		 */
		public static function create(selectable:Boolean=false,multiline:Boolean=false,border:Boolean=false,embedFonts:Boolean=false,autoSize:String='left'):TextField
		{
			var tf:TextField=new TextField();
			tf.selectable=selectable;
			tf.multiline=multiline;
			tf.border=border;
			tf.embedFonts=embedFonts;
			tf.autoSize=autoSize;
			return tf;
		}
		
		/**
		 * Sets the <em><code>TextField</code></em> leading formatting.
		 * 
		 * @param tf The textfield.
		 * @param space The leading space.
		 */
		public static function setLeading(tf:TextField,space:Number=0):void
		{
			if(!tf)throw new ArgumentError("Parameter {tf} cannot be null");
			var fmt:TextFormat=tf.getTextFormat();
			fmt.leading=space;
			tf.setTextFormat(fmt);
		}
		
		/**
		 * Restrict a text field to email only characters.
		 * 
		 * @param tf The text field to restrict.
		 */
		public static function restrictToEmail(tf:TextField):void
		{
			if(!tf)throw new ArgumentError("Parameter {tf} cannot be null");
			tf.restrict="a-zA-Z0-9@._-";
		}
		
		/**
		 * Restrict a text field to a list of emails (emails with "," or " ").
		 * 
		 * @param tf The text field to restrict.
		 */
		public static function restrictToListOfEmails(tf:TextField):void
		{
			if(!tf)throw new ArgumentError("Parameter {tf} cannot be null");
			tf.restrict=" \,a-zA-Z0-9@._-";
		}
		
		/**
		 * Restrict a text field to file path only characters (win|unix).
		 * 
		 * @param tf The text field to restrict.
		 */
		public static function restrictToFilePath(tf:TextField):void
		{
			if(!tf)throw new ArgumentError("Parameter {tf} cannot be null");
			tf.restrict="a-zA-Z0-9./\ ";
		}
		
		/**
		 * Restrict a text field to class path characters only (a-zA-Z0-9_.).
		 * 
		 * @param tf The text field to restrict.
		 */
		public static function restrictToClassPaths(tf:TextField):void
		{
			if(!tf)throw new ArgumentError("Parameter {tf} cannot be null");
			tf.restrict="a-zA-Z0-9_.";
		}
		
		/**
		 * Restrict a text field to file URI format only (file:///).
		 */
		public static function restrictToFilURI(tf:TextField):void
		{
			if(!tf)throw new ArgumentError("Parameter {tf} cannot be null");
			tf.restrict="a-zA-Z0-9";
		}
		
		/**
		 * Restrict a text field to letters (lower/upper) and numbers only.
		 * 
		 * @param tf The text field to restrict.
		 */
		public static function restrictLettersAndNumbers(tf:TextField):void
		{
			if(!tf)throw new ArgumentError("Parameter {tf} cannot be null");
			tf.restrict="a-zA-Z0-9";
		}
		
		/**
		 * Select all the text in a text field.
		 * 
		 * @param tf The TextField to select all in.
		 */
		public static function selectAll(tf:TextField):void
		{
			if(!tf)throw new ArgumentError("Parameter {tf} cannot be null");
			tf.setSelection(0,tf.length);
		}
		
		/**
		 * Deselect a text field.
		 * 
		 * @param tf The TextField to deselect.
		 */
		public static function deselect(tf:TextField):void
		{
			if(!tf)throw new ArgumentError("Parameter {tf} cannot be null");
			tf.setSelection(0,0);
		}
		
		/**
		 * Set the stage focus to the target text field and select all text in it.
		 * 
		 * @param stage The stage instance.
		 * @param tf The text field.
		 */
		public static function focusAndSelectAll(stage:Stage,tf:TextField):void
		{
			if(!stage)throw new ArgumentError("Parameter {stage} cannot be null");
			if(!tf)throw new ArgumentError("Parameter {tf} cannot be null");
			stage.focus=tf;
			selectAll(tf);
		}
		
		/**
		 * Restrict the text field to lower case, upper case,
		 * and spaces.
		 */
		public static function restrictLowerUpperAndSpace(tf:TextField):void
		{
			tf.restrict="a-zA-Z ";
		}
	}
}