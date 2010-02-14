package
{
	import gs.display.GSSprite;
	import gs.util.SocialShares;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class Main extends GSSprite
	{
		
		public var autodigg:MovieClip;
		public var manualdigg:MovieClip;
		
		public function Main()
		{
			SocialShares.handleDigg(autodigg,"http://www.google.com/","Google");
			
			//manually setup event listener to send digg social share
			manualdigg.addEventListener(MouseEvent.CLICK,onManDigg);
		}
		
		private function onManDigg(e:MouseEvent):void
		{
			SocialShares.digg("http://www.google.com/","Google");
		}
	}
}
