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
		
		public var bar:MovieClip;
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"assets/model.xml"};
		}
		
		override protected function onModelReady():void
		{
			super.onModelReady();
			
		}
		
		override protected function startPreload():void
		{
			preloader=new Preloader(550);
			preloader.addItems(model.getAssetsForPreload());
			preloader.addEventListener(PreloadProgressEvent.PROGRESS,onPCProgress);
			preloader.addEventListener(Event.COMPLETE,onPreloadComplete);
			preloader.start();
		}
		
		public function onPCProgress(e:PreloadProgressEvent):void
		{
			TweenMax.to(bar,1,{width:e.pixels});
		}
		
		override protected function onPreloadComplete(e:Event):void
		{
			addChild(AssetManager.getMovieClipFromSWFLibrary("swftest","Test"));
		}
	}
}