package
{
	import gs.display.GSSprite;
	import gs.managers.AssetManager;
	import gs.preloading.Asset;
	import gs.preloading.Preloader;

	import flash.events.Event;

	public class ShellMain extends GSSprite
	{
		
		private var pc:Preloader;
		
		public function ShellMain():void
		{
			super();
			preload();
		}
		
		private function preload():void
		{
			pc=new Preloader(100);
			pc.addEventListener(Event.COMPLETE,onPCComplete);
			pc.addItems([new Asset("child.swf","childSWF")]);
			pc.start();
		}
		
		public function onPCComplete(e:Event):void
		{
			trace("complete");
			trace("shellClipTest from current domain:",AssetManager.getMovieClip("shellClipTest"));
			trace("child clip test from child domain", AssetManager.getMovieClipFromSWFLibrary("childSWF","Child"));
			trace("child clip test from current domain",AssetManager.getMovieClip("Child"));
			addChild(AssetManager.getMovieClip("Child") as ChildTest);
			trace(AssetManager.getSound("OdeTo"));
		}
	}
}