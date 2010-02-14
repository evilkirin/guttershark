package 
{
	import gs.core.DocumentController;
	import gs.core.Preloader;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Main extends DocumentController
	{
		
		public var clip:MovieClip;
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"model.xml"};
		}
		
		override protected function onModelReady():void
		{
			preloader=new Preloader();
			preloader.addItems(model.getAssetsForPreload());
			preloader.addEventListener(Event.COMPLETE,onPreloadComplete);
			preloader.start();
		}
		
		override protected function onPreloadComplete(e:Event):void
		{
			initTracking();
		}
		
		override protected function initTracking():void
		{
			super.initTracking();
			tracking.showTraces=true;
			tracking.register(clip,MouseEvent.CLICK,"onClipClick");
		}
	}
}