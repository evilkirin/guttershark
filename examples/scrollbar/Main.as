package 
{
	import gs.display.GSSprite;
	import gs.display.ScrollBar;

	import flash.display.MovieClip;

	public class Main extends GSSprite
	{

		public var contentMask:MovieClip;
		public var content:MovieClip;
		public var handle:MovieClip;
		public var track:MovieClip;
		public var upArrow:MovieClip;
		public var downArrow:MovieClip;
		
		public var content2:MovieClip;
		public var contentMask2:MovieClip;
		public var leftArrow:MovieClip;
		public var rightArrow:MovieClip;
		public var handle2:MovieClip;
		public var track2:MovieClip;
		
		public var scrollBar:ScrollBar;
		public var scrollBar2:ScrollBar;
		
		public function Main()
		{
			scrollBar=new ScrollBar(stage,content,contentMask,handle,track,upArrow,downArrow);
			scrollBar2=new ScrollBar(stage,content2,contentMask2,handle2,track2,leftArrow,rightArrow,ScrollBar.HORIZONTAL);
		}	}}