package 
{
	import gs.util.FrameUtils;
	import flash.display.MovieClip;

	public class Main extends MovieClip 
	{
		
		public var test:MovieClip;
		
		public function Main():void
		{
			FrameUtils.addFrameScript(test,20,onFrame20);
		}
		
		private function onFrame20():void
		{
			trace("on frame 20");
		}
	}
}
