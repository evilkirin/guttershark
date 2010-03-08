package
{
	import gs.control.DocumentController;
	import gs.managers.AssetManager;
	import gs.preloading.Preloader;

	import flash.events.Event;

	public class Main extends DocumentController
	{
		
		override protected function flashvarsForStandalone():Object
		{
			return {
				model:"model.xml"
			};
		}
		
		override protected function startPreload():void
		{
			super.startPreload();
			preloader=new Preloader();
			preloader.addItems(model.getAssetsForPreload());
			preloader.addEventListener(Event.COMPLETE,onPreloadComplete);
			preloader.start();
		}
		
		override protected function onPreloadComplete(e:Event):void
		{
			trace(AssetManager.getJSON("testJSON").hello);
		}
	}
}