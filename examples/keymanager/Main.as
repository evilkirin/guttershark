package 
{
	import gs.display.GSSprite;
	import gs.managers.KeyManager;

	import flash.text.TextField;

	public class Main extends GSSprite
	{
		
		public var textfeeld:TextField;
		private var keys:KeyManager;
		
		public function Main()
		{
			super();
			keys=KeyManager.gi();
			init();
		}
		
		protected function init():void
		{
			keys.addMapping(stage,"CONTROL+SHIFT+M",onWhatever);
			keys.addMapping(stage,"Whatup",onWordup);
			keys.addMapping(stage,"f",onW);
			keys.addMapping(stage," ",onSpace);
			keys.addMapping(stage,"CONTROL+SHIFT+F", onWhatever);
			keys.addMapping(stage,"CONTROL+SHIFT+F+M",onWhatever);
			keys.addMapping(stage,"CONTROL",onControl);
			keys.addMapping(stage,"CONTROL+m",onm);
			keys.addMapping(stage,"SHIFT",onW);
			keys.addMapping([textfeeld,stage],"ENTER",onTFEnter);
			//keys.addMapping(stage,"ENTER",onTFEnter);
			//keys.am(stage,"RIGHT",onRight,true,onRightRepeat);
		}
		
		private function onRight():void
		{
			trace("right down");
		}
		
		
		private function onRightRepeat():void
		{
			trace("right down repeat");
			textfeeld.x+=1;
		}
		
		public function onTFEnter():void
		{
			trace("YOU PRESSED ENTER");
		}

		private function onm():void
		{
			trace("on ctrl m");
		}
		
		private function onControl():void
		{
			trace("on control");
		}
		
		private function onWhatever():void
		{
			trace("sequence matched");
		}
		
		private function onW():void
		{
			trace("on f");
		}
		
		private function onWordup():void
		{
			trace("typed wordup");
		}
		
		private function onSpace():void
		{
			trace("space pressed");
		}
	}}