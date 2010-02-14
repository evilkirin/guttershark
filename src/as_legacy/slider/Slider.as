package net.guttershark.display.slider
{
	import net.guttershark.display.CoreSprite;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class Slider extends CoreSprite
	{

		public static const VERTICAL:String="vertical";
		public static const HORIZONTAL:String="horizontals";
		private var orientation:String;
		private var content:Sprite;
		private var handles:Array;
		
		public function Slider(track:Sprite,orientation:String="horizontal")
		{
			this.orientation=orientation;
			content=new Sprite();
			addChild(content);
			track.x=0;
			track.y=0;
			content.addChild(track);
		}
		
		public function addHandle(handle:Sprite,initialPosition:Number):void
		{
			if(orientation==HORIZONTAL)handle.x=initialPosition; //clamp values to track first.
			else handle.y=initialPosition;
			content.addChild(handle);
		}
		
		private function onHandleClick(me:MouseEvent):void
		{
			//start drag, limit to surrounding handles.
		}
		
		private function onStageMouseMove(me:MouseEvent):void
		{
		}	}}