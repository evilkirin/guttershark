package 
{
	import gs.core.DocumentController;
	import gs.core.Preloader;
	import gs.util.MathUtils;
	
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
		
		override protected function initTracking():void
		{
			super.initTracking();
			tracking.showTraces=true;
			
			var options:Object = {
				assertMethod:test1,
				dynamicData:dd1
			};
			
			tracking.register(clip,MouseEvent.CLICK,"onClipClick",options);
			//setTimeout(tracking.unregister,5000,clip,"click");
		}
		
		private function test1():Boolean
		{
			return MathUtils.randBool();
		}
		
		private function dd1():Array
		{
			return [null,null,"_test"];
		}
	}
}