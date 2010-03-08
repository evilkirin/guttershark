package
{
	import gs.util.QueryString;

	import flash.display.Sprite;

	public class Main extends Sprite
	{
		
		private var qs:QueryString;
		
		public function Main()
		{
			qs=new QueryString();
			trace(qs.helloWorld);
		}
	}
}