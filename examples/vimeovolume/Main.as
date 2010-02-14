package 
{
	import gs.display.VimeoVolume;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	public class Main extends Sprite 
	{
		
		public var barsMask:MovieClip;
		public var slider:MovieClip;
		public var blue:MovieClip;
		public var gray:MovieClip;
		public var hit:MovieClip;
		public var wrapped:MovieClip;
		private var vbs:VimeoVolume;

		public function Main():void
		{
			vbs=new VimeoVolume(barsMask,hit,blue);
			vbs.addEventListener(VimeoVolume.UPDATE,onUpdate);
			//setTimeout(setVol,2000);
		}
		
		private function onUpdate(e:Event):void
		{
			//trace(vbs.volume);
		}
		
		private function setVol():void
		{
			//vbs.volume=.6;
		}	}}