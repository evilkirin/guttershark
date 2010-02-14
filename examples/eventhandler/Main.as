package
{
	import gs.util.EventHandler;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class Main extends Sprite
	{
		
		public var mc:MovieClip;
		private var eh:EventHandler;
		private var eh2:EventHandler;
		
		public function Main()
		{
			eh=new EventHandler(mc,this,"onMC");
			eh2=new EventHandler(mc,this,"onMC2");
		}
		
		public function onMCClick():void
		{
			trace("CLICK");
		}
		
		public function onMC2Click():void
		{
			trace("clicked from 2");
			eh2.dispose();
			eh2 = null;
		}
	}
}
