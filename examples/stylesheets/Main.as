package 
{
	import gs.core.DocumentController;

	import flash.text.StyleSheet;
	import flash.text.TextField;

	public class Main extends DocumentController
	{
		
		public var test:TextField;
		
		public function Main()
		{
			super();
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"model.xml"};
		}
		
		override protected function onModelReady():void
		{
			var s:StyleSheet=model.getStyleSheetById("colors");
			trace(s);
			trace(s.getStyle(".pink").color);
			var tx:String="<span class='body'>hello <span class='pink'>world</span></span>";
			
			//manually setting stylesheet and text
			
			//test.styleSheet=s;
			test.htmlText=tx;
			
			//use a helper
			model.getTextAttributeById("test1").apply(test);
			test.htmlText=tx;
		}
	}
}
