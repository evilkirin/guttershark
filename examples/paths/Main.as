package 
{
	import fl.controls.Button;

	import gs.core.*;

	import flash.events.MouseEvent;

	public class Main extends DocumentController
	{
		
		public var test:Button;
		
		public function Main()
		{
			super();
			test.addEventListener(MouseEvent.CLICK,onTestClick);
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {
				root:"http://www.whitehouse.com/",
				assets:"assets/",
				bitmaps:"bitmaps/",
				absolutePath:"http://www.google.com/someFile.xml"
			};
		}
		
		override protected function initPaths():void
		{
			super.initPaths();
			model.addPath("root",flashvars.root);
			model.addPath("assets",flashvars.assets);
			model.addPath("bitmaps",flashvars.bitmaps);
			model.addPath("absolutePath",flashvars.absolutePath);
		}
		
		public function onTestClick(e:MouseEvent):void
		{
			trace(model.getPath("root","assets","bitmaps","bitmaps"));
			trace(model.getPath("absolutePath"));
		}
	}
}
