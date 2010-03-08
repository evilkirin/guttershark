package 
{
	import gs.control.DocumentController;

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
			super.onModelReady();
			
			//manual
			test.defaultTextFormat=model.getTextFormatById("theTF");
			test.text="TESTING";
			
			//helper
			model.getTextAttributeById("test").apply(test);
		}
	}
}