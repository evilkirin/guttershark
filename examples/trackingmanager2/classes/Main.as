package 
{
	import gs.core.DocumentController;
	import gs.core.Preloader;
	import gs.support.preloading.Asset;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Main extends DocumentController
	{
		
		public var clip:MovieClip;
		
		override protected function flashvarsForStandalone():Object
		{
			return {
				model:"model.xml",
				tracking:"tracking.xml"
			};
		}
		
		override protected function onModelReady():void
		{
			preloader=new Preloader();
			preloader.addItems(model.getAssetsForPreload());
			preloader.addItems([new Asset(flashvars.tracking,"tracking")]);
			preloader.addEventListener(Event.COMPLETE,onPreloadComplete);
			preloader.start();
		}
		
		override protected function initTracking():void
		{
			super.initTracking();
			tracking.showTraces=true;
			tracking.register(clip,MouseEvent.CLICK,"onClipClick");
		}
	}
}