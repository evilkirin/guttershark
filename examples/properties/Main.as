package 
{
	import gs.control.DocumentController;
	import gs.util.SetterUtils;
	import gs.util.Strings;

	import flash.display.MovieClip;
	import flash.text.TextField;

	public class Main extends DocumentController
	{
		
		public var tfield:TextField;
		public var mc1:MovieClip;
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"model.xml"};
		}
		
		override protected function onModelReady():void
		{
			model.strings=new Strings(new XML(model.xml.strings));
			mc1=new MovieClip();
			mc1.graphics.beginFill(0xff0066);
			mc1.graphics.drawRect(0,0,40,40);
			mc1.graphics.endFill();
			addChild(mc1);
			SetterUtils.propsFromModel(model,mc1,"test");
			SetterUtils.propsFromModel(model,tfield,"tfieldTest");
		}
	}
}