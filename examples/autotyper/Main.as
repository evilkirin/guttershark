package
{
	import gs.util.text.AutoTyper;

	import flash.display.Sprite;
	import flash.text.TextField;

	public class Main extends Sprite
	{
		
		public var tf:TextField;
		public var at:AutoTyper;
		
		public function Main()
		{
			at=new AutoTyper(tf);
			at.type("Hello World",45);
		}
	}
}