package 
{
	import gs.util.BindingUtils;
	import gs.display.GSSprite;
	import gs.display.VolumeSlider;

	import flash.display.MovieClip;
	import flash.events.Event;

	public class Main extends GSSprite 
	{

		public var highlight1:MovieClip;
		public var hit1:MovieClip;
		public var highlight2:MovieClip;
		public var hit2:MovieClip;
		
		private var bind:BindingUtils;
		private var vw1:VolumeSlider;
		private var vw2:VolumeSlider;

		public function Main()
		{
			super();
			bind=BindingUtils.gi();
			vw1=new VolumeSlider(hit1,highlight1);
			vw1.addEventListener(VolumeSlider.UPDATE,onUpdate);
			vw2=new VolumeSlider(hit2,highlight2);
			bind.property(vw1,"volume",vw2,"volume"); //binding example.
		}
		
		private function onUpdate(e:Event):void
		{
			trace(vw1.volume);
		}	}}