package
{
	import gs.display.GSSprite;
	import gs.display.Scale9Clip;

	import flash.display.MovieClip;
	import flash.utils.setTimeout;

	public class Main extends GSSprite
	{
		
		public var s9:Scale9Clip;
		public var s92:MovieClip;
		private var s93:Scale9Clip;
		
		public function Main():void
		{
			setTimeout(s9.setSize,1000,100,100);
			s93=new Scale9Clip();
			s93.setRefs(s92.topLeft,s92.top,s92.topRight,s92.left,s92.mid,s92.right,s92.bottomLeft,s92.bottom,s92.bottomRight);
			setTimeout(s93.setSize,2000,250,200);
		}
	}
}