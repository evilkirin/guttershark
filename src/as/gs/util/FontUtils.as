package gs.util 
{
	import flash.text.Font;
	import flash.text.TextFormat;

	/**
	 * The FontUtils class contains utility methods for fonts.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class FontUtils 
	{
		
		/**
		 * Finds the Font instance associated with a text format.
		 * 
		 * @param tf A text format.
		 */
		public static function getFontFromTextFormat(tf:TextFormat):Font
		{
			var fnts:Array=Font.enumerateFonts();
			var i:int=0;
			var l:int=fnts.length;
			for(;i<l;i++)if(Font(fnts[int(i)]).fontName==tf.font)return Font(fnts[int(i)]);
			return null;
		}
		
		/**
		 * Finds the Font instance associated with a text format, and returns the fontName.
		 * 
		 * @param tf A text format.
		 */
		public static function getFontNameFromTextFormat(tf:TextFormat):String
		{
			var fnts:Array=Font.enumerateFonts();
			var i:int=0;
			var l:int=fnts.length;
			for(;i<l;i++)if(Font(fnts[int(i)]).fontName==tf.font)return Font(fnts[int(i)]).fontName;
			return null;
		}
		
		/**
		 * Finds the Font instance associated with a text format, and returns the fontStyle.
		 * 
		 * @param tf A text format.
		 */
		public static function getFontStyleFromTextFormat(tf:TextFormat):String
		{
			var fnts:Array=Font.enumerateFonts();
			var i:int=0;
			var l:int=fnts.length;
			for(;i<l;i++)if(Font(fnts[int(i)]).fontName==tf.font)return Font(fnts[int(i)]).fontStyle;
			return null;
		}
		
		/**
		 * Finds the Font instance associated with a text format, and returns the fontType.
		 * 
		 * @param tf A text format.
		 */
		public static function getFontTypeFromTextFormat(tf:TextFormat):String
		{
			var fnts:Array=Font.enumerateFonts();
			var i:int=0;
			var l:int=fnts.length;
			for(;i<l;i++)if(Font(fnts[int(i)]).fontName==tf.font)return Font(fnts[int(i)]).fontType;
			return null;
		}
	}
}