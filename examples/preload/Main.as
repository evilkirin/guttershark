package  
{
	import gs.core.DocumentController;
	import gs.core.Preloader;
	import gs.managers.AssetManager;
	import gs.support.preloading.events.PreloadProgressEvent;

	import com.greensock.TweenMax;

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
			addChild(AssetManager.getMovieClipFromSWFLibrary("swftest","Test"));
			addChild(AssetManager.getBitmap("jpg1"));
		}
		
		public function onPCProgress(pe:PreloadProgressEvent):void
		{
			TweenMax.to(pre,.5,{width:pe.pixels,overwrite:false});
		}
	}
}