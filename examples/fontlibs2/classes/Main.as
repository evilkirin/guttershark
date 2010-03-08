package
{
	import gs.control.DocumentController;
	import gs.preloading.Preloader;

	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class Main extends DocumentController
	{
		
		//bunch of fields on stage..
		public var stylesheetsLabel:TextField;
		public var textFormatsLabel:TextField;
		public var txf1:TextField;
		public var txf2:TextField;
		public var txf3:TextField;
		public var txf4:TextField;
		public var txf5:TextField;
		public var txf6:TextField;
		public var txf7:TextField;
		public var ss1:TextField;
		public var ss2:TextField;
		public var ss3:TextField;
		public var ss4:TextField;
		public var ss5:TextField;
		public var ss6:TextField;
		public var ss7:TextField;
		
		override protected function startPreload():void
		{
			preloader=new Preloader();
			preloader.addItems(model.getAssetsForPreload());
			preloader.addEventListener(Event.COMPLETE,onComplete);
			preloader.start();
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"model.xml"};
		}
		
		private function onComplete(e:Event):void
		{
			//this registers every font that is declared in XML.
			model.registerFonts();
			
			//set up the labels.
			var labelTF:TextFormat = model.getTextFormatById("labelText");
			stylesheetsLabel.embedFonts=true;
			stylesheetsLabel.setTextFormat(labelTF);
			textFormatsLabel.embedFonts=true;
			textFormatsLabel.setTextFormat(labelTF);
			
			//TEXTFIELDS
			
			txf1.embedFonts=true;
			txf1.setTextFormat(model.getTextFormatById("lucidaGBold10"));
			
			txf2.embedFonts=true;
			txf2.setTextFormat(model.getTextFormatById("lucidaGBold12"));
			
			//use text attributes for other text formats
			model.getTextAttributeById("ta1").apply(txf3);
			model.getTextAttributeById("ta2").apply(txf4);
			
			//another shortcut type.
			model.getTextAttributeById("ta1").apply(txf5,txf6,txf7);
			
			//STYLESHEETS
			
			ss1.embedFonts=true;
			ss1.styleSheet=model.getStyleSheetById("example");
			ss1.htmlText="<span class=\"body\">"+ss1.text+"</span>";
			
			ss2.embedFonts=true;
			ss2.styleSheet=model.getStyleSheetById("example2");
			ss2.htmlText="<span class=\"body\">"+ss2.text+"<span class=\"bold\">. and this is bold.</span></span>";
			
			//stylsheet shortcuts
			model.getTextAttributeById("ta3").apply(ss3);
			model.getTextAttributeById("ta4").apply(ss4);
			model.getTextAttributeById("ta3").apply(ss5,ss6,ss7);
		}
	}
}
