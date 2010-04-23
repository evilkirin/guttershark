package 
{
	import gs.control.DocumentController;
	import gs.managers.AssetManager;
	import gs.preloading.Preloader;
	import gs.tracking.Atlas;
	import gs.tracking.Tracking;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Main extends DocumentController 
	{
		
		public var button1:MovieClip;
		private var track:Tracking;
		
		override protected function flashvarsForStandalone():Object
		{
			return { model:"model.xml" };
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
			//now configure tracking
			track = new Tracking(AssetManager.getXML("tracking"));
			Tracking.set("default",track);//save for later
			trace(Tracking.get("default"));
			
			//atlas
			var a:Atlas = new Atlas();
			a.traces=true;
			track.atlas=a;
			
			//let the tracking instance handle the button for you.
			track.register(button1,MouseEvent.CLICK,"trackTest1");
			
			//...or fire it manually from a click.
			button1.addEventListener(MouseEvent.CLICK,onButton1Click);
		}
		
		private function onButton1Click(e:Event):void
		{
			track.track("trackTest1");
		}
	}
}