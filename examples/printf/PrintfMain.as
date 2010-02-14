package 
{
	import gs.util.printf;
	import flash.display.Sprite;
	
	public class PrintfMain extends Sprite
	{
		
		public var d:Date=new Date(1978, 2, 10, 14, 35, 5, 6);
		
		public function PrintfMain()
		{
			printf("%Y",d);
		}
	}
}