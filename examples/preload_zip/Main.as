package  
{
	import gs.control.DocumentController;
	import gs.events.PreloadProgressEvent;
	import gs.managers.AssetManager;
	import gs.preloading.Preloader;

	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;

	public class Main extends DocumentController
	{
		
		public var pre:MovieClip;
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"assets/model.xml"};
		}
		
		override protected function startPreload():void
		{
			preloader=new Preloader(400);
			preloader.addItems(model.getAssetsForPreload());
			preloader.addEventListener(Event.COMPLETE,onPreloadComplete);
			preloader.addEventListener(PreloadProgressEvent.PROGRESS,onPCProgress);
			preloader.start();
		}
		
		override protected function onPreloadComplete(e:Event):void
		{
			AssetManager.getBitmapFromFZip( AssetManager.getFZip("zip1") ,"icons/accept.png", _receiveBitmap);
		}
		
		private function _receiveBitmap(filename:String,bitmap:Bitmap):void
		{
			trace(filename);
			addChild(bitmap);
		}
		
		public function onPCProgress(pe:PreloadProgressEvent):void
		{
			pre.width=pe.pixels;
		}
	}
}