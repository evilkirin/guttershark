package
{
	import flash.utils.setTimeout;
	import gs.audio.AudioGroup;
	import gs.control.DocumentController;
	import gs.managers.AssetManager;
	import gs.preloading.Preloader;

	import flash.events.Event;

	public class Main extends DocumentController
	{
		
		private var ag:AudioGroup;
		
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
			ag=new AudioGroup();
			
			//save for later
			AudioGroup.set("myGroup",ag);
			trace(AudioGroup.get("myGroup"));
			
			ag.addObject("sparkle",AssetManager.getSound("sparkle1"));
			ag.addObject("sparkle2",AssetManager.getSound("sparkle1"));
			
			//ag.sparkle.play(); 		//AudioObject is accessible by dynamic property.
			//ag.playSound("sparkle"); 	//Or you can access an AudioObject by id.
			
			//ag.play(); 				//play the entire group of sounds.
			
			//setTimeout(ag.mute,300); 	//some random functions
			//setTimeout(ag.unmute,700);
			//setTimeout(ag.volumeTo,100,0);
			//ag.volumeTo(.2,.2);
			
			ag.playSound("sparkle");	//use a group to play the same sound more than once..
			setTimeout(ag.playSound,300,"sparkle2");
			setTimeout(ag.playSound,600,"sparkle");
		}
	}
}