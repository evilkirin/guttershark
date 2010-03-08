package
{
	import gs.display.text.SmartText;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.setTimeout;

	public class Main extends Sprite 
	{
		
		public var tf:TextField;
		public var st:SmartText;
		
		public function Main()
		{
			st=new SmartText(tf);
			addChild(st);
			setTimeout(t,2000);
			setTimeout(s,4000);
		}
		
		private function t():void
		{
			//it's bitmapped here
			st.text="word";
		}
		
		private function s():void
		{
			//back to normal text field
			st.text="adsfasdfasdf";
		}
	}
}