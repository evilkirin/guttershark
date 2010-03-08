package gs.util 
{
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	/**
	 * The TextAttributes class is a helper object to set
	 * text related properties on a text field.
	 * 
	 * <p>You can't set both the stylesheet, and textformat
	 * on this class - use one or the other.</p>
	 * 
	 * @example Using this class directly
	 * <listing>	
	 * var tf:TextField = new TextField();
	 * var s:StyleSheet = model.getStyleSheetById("myStylesheet");
	 * var ta:TextAttributes = new TextAttributes(s,null,"advanced","left");
	 * ta.apply(tf);
	 * addChild(tf);
	 * </listing>
	 * 
	 * <b>Example</b><br/>
	 * Using the helper from the model.
	 * <listing>	
	 * var tf:TextField = new TextField();
	 * model.getTextAttribute("attr1").apply(tf);
	 * </listing>
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.model.Model
	 */
	public class TextAttributes 
	{
		
		/**
		 * A stylesheet.
		 */
		public var styleSheet:StyleSheet;
		
		/**
		 * A textformat.
		 */
		public var textFormat:TextFormat;
		
		/**
		 * The text to set on the text field.
		 * 
		 * <p>This is an optional property. If this is set, the text fields' text will
		 * be replaced with this. If it's not set, the text field will be updated
		 * with the right attributes, but the text will be set to whatever was
		 * there before the update.</p>
		 */
		public var text:String;
		
		/**
		 * The anti alias type for the text field.
		 */
		public var antiAliasType:String;
		
		/**
		 * The text autosizing.
		 */
		public var autoSize:String;
		
		/**
		 * Whether or not to wrap HTML text in a &lt;span class="body"&gt; tag.
		 */
		public var wrapInBodySpan:Boolean;
		
		/**
		 * Whether or not to clear the text that this TextAttributes
		 * instance applies - after it's been applied once.
		 */
		public var clearsTextAfterApply:Boolean;
		
		/**
		 * lookup
		 */
		private static var _tas:Dictionary = new Dictionary(true);
		
		/**
		 * Get a saved text attributes instance.
		 * 
		 * @param id The text attributes id.
		 */
		public static function get(id:String):TextAttributes
		{
			if(!id)
			{
				trace("WARNING: Parameter {id} is null, returning null");
				return null;
			}
			return _tas[id];
		}
		
		/**
		 * Set a text attributes instance.
		 * 
		 * @param id The id for the text attributes instance.
		 * @param ta The text attributes instance.
		 */
		public static function set(id:String, ta:TextAttributes):void
		{
			if(!id||!ta)return;
			_tas[id]=ta;
		}
		
		/**
		 * Unset a text attributes instance.
		 * 
		 * @param id The id for the text attributes instance.
		 */
		public static function unset(id:String):void
		{
			if(!id)return;
			delete _tas[id];
		}
		
		/**
		 * Constructor for TextAttributes instances.
		 * 
		 * @param styleSheet A StyleSheet object.
		 * @param textFormat A TextFormat object.
		 * @param antiAliasType The anti alias type for the text field.
		 * @param autoSize The auto size for the text field.
		 * @param text The text to use for this text field.
		 */
		public function TextAttributes(styleSheet:StyleSheet =null,textFormat:TextFormat=null, antiAliasType:String=null, autoSize:String=null, text:String=null)
		{
			if(styleSheet && textFormat) throw new Error("TextAttributes cannot have both textFormat and styleSheets set. Use one or the other.");
			this.styleSheet=styleSheet;
			this.textFormat=textFormat;
			this.antiAliasType=antiAliasType;
			this.autoSize=autoSize;
			this.text=text;
		}
		
		/**
		 * Apply these text attributes to text fields.
		 * 
		 * @param ...fields Any text fields you want to apply these text attributes to.
		 */
		public function apply(...fields):void
		{
			if(!fields)return;
			if(fields[0] is Array)fields=fields[0];
			var i:int=0;
			var l:int=fields.length;
			for(;i<l;i++)_apply(fields[int(i)]);
		}
		
		/**
		 * Internal helper that actually does the work.
		 */
		private function _apply(tf:TextField):void
		{
			var tmp:String=text;
			if(!text)tmp=tf.text;
			if(textFormat&&styleSheet) trace("WARNING: TextAttributes can't apply both text formats and stylesheets, stylesheets will take precedence over text formats");
			if(textFormat)
			{
				tf.defaultTextFormat=textFormat;
				tf.setTextFormat(textFormat);
				if(antiAliasType)tf.antiAliasType=antiAliasType;
				if(autoSize)tf.autoSize=autoSize;
				tf.embedFonts=true;
				tf.text=tmp;
			}
			if(styleSheet)
			{
				tf.embedFonts=true;
				tf.styleSheet=styleSheet;
				if(antiAliasType)tf.antiAliasType=antiAliasType;
				if(autoSize)tf.autoSize=autoSize;
				if(wrapInBodySpan)tf.htmlText="<span class='body'>"+tmp+"<span>";
				else tf.htmlText=tmp;
			}
			if(clearsTextAfterApply)text=null;
		}
		
		/**
		 * Dispose of this TextAttributes instance.
		 */
		public function dispose():void
		{
			wrapInBodySpan=false;
			clearsTextAfterApply=false;
			antiAliasType=null;
			autoSize=null;
			styleSheet=null;
			textFormat=null;
			text=null;
		}

		/**
		 * @private
		 */
		public function toString():String
		{
			return "["+ textFormat + "," + styleSheet + "," + antiAliasType + "," + autoSize + "," + wrapInBodySpan + "]";
		}
	}
}