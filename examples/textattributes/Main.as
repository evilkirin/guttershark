package 
{
	import gs.control.DocumentController;
	import gs.preloading.Preloader;

	import flash.events.Event;
	import flash.text.TextField;

	public class Main extends DocumentController
	{
		
		public var t1:TextField;
		public var t2:TextField;
		
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
			model.getTextAttributeById("attr1").apply(t1,t2);
		}
	}
}