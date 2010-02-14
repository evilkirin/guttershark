package 
{
	import gs.display.text.GradientLabel;

	import flash.display.Sprite;
	import flash.text.TextField;

	public class Main extends Sprite
	{
		
		public var hw:GradientLabel; //setup through flash IDE
		
		private var gl:GradientLabel;
		public var t2:TextField;
		
		public function Main()
		{
			//manual gradient setup
			gl=new GradientLabel(t2);
			gl.colors=[0x000000,0xFF0066];
			gl.updateGradientBox(25,10,Math.PI/4);
			gl.update();
			addChild(gl);
		}
	}
}