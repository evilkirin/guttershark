package
{
	import gs.audio.AudioObject;
	import gs.control.DocumentController;
	import gs.managers.AssetManager;
	import gs.preloading.Preloader;

	import flash.events.Event;
	import flash.utils.setTimeout;

	public class Main extends DocumentController
	{
		
		private var ao1:AudioObject;
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"model.xml"};
		}
		
		override protected function onModelReady():void
		{
			preloader=new Preloader();
			preloader.addEventListener(Event.COMPLETE,onPreloadComplete);
			preloader.addItems(model.getAssetsForPreload());
			preloader.start();
		}
		
		override protected function onPreloadComplete(e:Event):void
		{
			ao1=new AudioObject(AssetManager.getSound("sparkle1"));
			
			//save it for later
			AudioObject.set("sparkle1",ao1);
			trace(AudioObject.get("sparkle1"));
			
			ao1.volume=1.4;
			ao1.play({loops:100});
			
			setTimeout(ao1.pause,200);
			setTimeout(ao1.resume,400);
			//setTimeout(ao1.stop,1200);
			setTimeout(ao1.volumeTo,1500,0);
			//setTimeout(ao1.panTo,1600,-1);
			setTimeout(ao1.volumeTo,2500,1);
			
			trace(ao1.isPlaying);
			trace(ao1.isPaused);
		}
	}
}
