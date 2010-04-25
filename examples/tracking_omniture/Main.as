package 
{
	import gs.control.DocumentController;
	import gs.managers.AssetManager;
	import gs.preloading.Preloader;
	import gs.tracking.Omniture;
	import gs.tracking.Tracking;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.omniture.ActionSource;
	
	public class Main extends DocumentController 
	{
		
		public var actionsource:ActionSource;
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
			//first we need to configure the actionsource object.
			//usually you will get this code from someone in
			//your analytics department. typically they'll tell
			//you to copy and paste into the main timeline. that's
			//so Flash 5. use the below snippet or pieces of it.
			actionsource = new ActionSource();
			var waEnv:String = flashvars.waEnv||"test";
			var waRS:String = flashvars.waRS||"";
			var waOrg1:String = flashvars.waOrg1||"cim";
			actionsource.channel = waOrg1;
			if((waEnv.toLowerCase()) == "prod")actionsource.account = "intelcorp,"+waRS;
			else actionsource.account = "intelhcodetest";
			actionsource.charSet = "UTF-8";
			actionsource.trackClickMap = true;
			actionsource.movieID = "";
			actionsource.debugTracking = true;
			actionsource.trackLocal = true;
			actionsource.dc="112";
			actionsource.trackingServer = "www91.intel.com";
			actionsource.trackingServerSecure = "www90.intel.com";
			addChild(actionsource);
			
			//now configure tracking
			track = new Tracking(AssetManager.getXML("tracking"));
			Tracking.set("default",track);//save for later
			trace(Tracking.get("default"));
			
			//now setup omniture with the Tracking instance.
			var omniture:Omniture=new Omniture(actionsource);
			omniture.traces=true;
			track.omniture=omniture;
			
			//let the tracking instance handle the button for you.
			track.register(button1,MouseEvent.CLICK,"trackTest1");
			track.register(button1,MouseEvent.CLICK,"trackTest2");
			
			//...or fire it manually from a click.
			button1.addEventListener(MouseEvent.CLICK,onButton1Click);
		}
		
		private function onButton1Click(e:Event):void
		{
			track.track("trackTest1");
			track.track("trackTest2");
		}
	}
}