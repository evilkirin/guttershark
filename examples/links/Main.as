package
{
	import gs.control.DocumentController;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class Main extends DocumentController
	{
		
		public var launch:MovieClip;
		
		public function Main()
		{
			super();
			launch.addEventListener(MouseEvent.CLICK,onLaunch);
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"model.xml"};
		}
		
		override protected function onModelReady():void
		{
			super.onModelReady();
			trace(model.getLink("google"));
			trace(model.getLink("google").url);
		}
		
		private function onLaunch(e:MouseEvent):void
		{
			model.navigateToLink("google");
		}
	}
}