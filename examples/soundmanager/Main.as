package
{
	import gs.core.DocumentController;
	import gs.core.Preloader;
	import gs.managers.AssetManager;
	import gs.managers.SoundManager;

	import flash.events.Event;
	import flash.utils.setTimeout;

	public class Main extends DocumentController
	{
		
		private var sound:SoundManager;
		
		public function Main()
		{
			sound=SoundManager.gi();
		}
		
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
			sound.createGroup("group1");
			sound.group1.addObject("sparkle1",AssetManager.getSound("sparkle1")); //sparkle1 is preloaded
			sound.group1.addObject("sparkle2",AssetManager.getSound("sparkle2")); //sparkle2 comes out of the fla
			setTimeout(sound.group1.play,300); //play an entire group. (same as sound.group1.play());
			setTimeout(sound.group1.sparkle2.play,1000); //play a single audio object from a group (same as sound.group1.sparkle1.play());
			trace(sound.group1);
			trace(sound.group1.sparkle1);
		}
	}
}
