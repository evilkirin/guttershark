package
{
	import gs.core.DocumentController;
	import gs.core.Preloader;
	import gs.support.preloading.Asset;

	import flash.events.Event;

	public class Main extends DocumentController
	{
		
		override protected function flashvarsForStandalone():Object
		{
			return {
				model:"model.xml",
				strings:"strings.xml"
			};
		}
		
		override protected function startPreload():void
		{
			preloader=new Preloader();
			preloader.addEventListener(Event.COMPLETE,onPreloadComplete);
			preloader.addItems([new Asset(flashvars.strings,"strings")]);
			preloader.start();
		}
		
		override protected function onPreloadComplete(e:Event):void
		{
			super.onPreloadComplete(e);
			trace(model.strings.getStringFromID("test"));
		}
	}
}
