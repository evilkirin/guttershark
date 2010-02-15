package gs.util 
{
	import flash.text.StyleSheet;

	/**
	 * The StyleSheetUtils class contains utility methods for working
	 * with stylesheets.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class StyleSheetUtils
	{
		
		/**
		 * Merge any number of stylesheets into one new
		 * style sheet. If the same style is declared in
		 * more than one stylesheet, they will be overwritten
		 * with the last stylesheet object, that declares it.
		 * 
		 * @example Calling mergeStyleSheets:
		 * <listing>	
		 * var myStyleSheet1=new StyleSheet();
		 * //.. add some styles to style 1
		 * var myStyleSheet2=new StyleSheet();
		 * //.. add some styles to style 2
		 * 
		 * var newStyle:StyleSheet;
		 * //merge
		 * newStyle=StyleSheetUtils.mergeStyleSheets(myStyleSheet1,myStyleSheet2);
		 * 
		 * //or you can call with an array.
		 * var a:Array=[myStyleSheet1,myStyleSheet2];
		 * newStyle=StyleSheetUtils.mergeStyleSheets(a);
		 * </listing>
		 */
		public static function mergeStyleSheets(...sheets:Array):StyleSheet
		{
			if(sheets[0] is Array)sheets=sheets[0];
			var newstyles:StyleSheet=new StyleSheet();
			var i:int=0;
			var l:int=sheets.length;
			var k:int;
			var j:int;
			var sn:String;
			for(;i<l;i++)
			{
				var s:StyleSheet=StyleSheet(sheets[int(i)]); 
				var nm:Array=s.styleNames;
				k=0;
				j=nm.length;
				for(k;k<j;k++)
				{
					sn=nm[int(k)];
					newstyles.setStyle(sn,s.getStyle(sn));
				}
			}
			return newstyles;
		}
	}
}