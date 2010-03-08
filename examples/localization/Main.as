package
{
	import gs.control.DocumentController;
	import gs.preloading.Preloader;

	import flash.events.Event;

	public class Main extends DocumentController
	{
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"model.xml"};
		}
		
		override protected function startPreload():void
		{
			preloader=new Preloader();
			preloader.addEventListener(Event.COMPLETE,onPreloadComplete);
			preloader.addItems(model.getAssetsForPreload());
			preloader.start();
		}
		
		override protected function onPreloadComplete(e:Event):void
		{
			super.onPreloadComplete(e);
			trace(model.strings.getStringFromID("test"));
		}
	}
}
