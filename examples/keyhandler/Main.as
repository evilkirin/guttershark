package
{
	import gs.util.KeyHandler;
	import gs.util.StageRef;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.setTimeout;

	public class Main extends Sprite
	{
		
		public var mc:MovieClip;
		private var kh:KeyHandler;
		private var kh2:KeyHandler;
		private var kh3:KeyHandler;
		private var kh4:KeyHandler;
		
		public function Main():void
		{
			//the stage ref needs to be set somewhere
			StageRef.stage=stage;
			
			//create key handlers.
			kh=new KeyHandler("SHIFT+M",onShiftM);
			kh2=new KeyHandler("UP",onUp);
			kh3=new KeyHandler("f",onLetter);
			kh4=new KeyHandler("as",onSequence);
			
			//set and get
			KeyHandler.set("key1",kh);
			trace(KeyHandler.get("key1"));
			
			//toggle enabled.
			kh.enabled=false;
			kh.enabled=true;
			KeyHandler.disable("key1");
			KeyHandler.enable("key1");
			
			//auto target example (enabled/disabled depending on if the target is on the stage)
			//the "kh" keyHandler won't work when the clip is off the stage.
			kh.autoTarget=mc;
			setTimeout(removeChild,2000,mc);
			setTimeout(addChild,4000,mc);
		}
		
		private function onSequence():void
		{
			trace("sequence as");
		}
		
		private function onLetter():void
		{
			trace("letter f");
		}
		
		private function onShiftM():void
		{
			trace("SHIFT+M");
		}
		
		private function onUp():void
		{
			trace("UP");
		}
	}
}
