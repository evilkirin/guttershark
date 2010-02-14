package 
{
	import fl.video.VideoPlayer;

	import gs.display.GSSprite;
	import gs.util.akamai.*;

	import flash.events.Event;

	public class Main extends GSSprite
	{

		private var ident:Ident;

		public function Main():void
		{
			super();
			ident=new Ident();
			ident.contentLoader.addEventListener(Event.COMPLETE,akamaiIdentComplete);
			ident.findBestIPForAkamaiApplication("http://cp44952.edgefcs.net/");
		}
		
		protected function akamaiIdentComplete(e:Event):void
		{
			trace(ident.ip);
			AkamaiNCManager.FMS_IP = ident.ip;
			VideoPlayer.iNCManagerClass = "net.guttershark.akamai.AkamaiNCManager";
		}	}}