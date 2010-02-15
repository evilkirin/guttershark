package
{
	import gs.display.GSClip;
	import gs.managers.TabManager;
	import gs.util.SetterUtils;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class Main extends GSClip
	{

		public var t1:TextField;
		public var t2:TextField;
		public var t3:TextField;
		public var t4:MovieClip;
		public var t5:TextField;
		public var t6:MovieClip;
		public var b1:MovieClip;
		public var b2:MovieClip;
		public var b3:MovieClip;
		
		public function Main()
		{
			super();
			b1.addEventListener(MouseEvent.CLICK,onB1Click);
			b2.addEventListener(MouseEvent.CLICK,onB2Click);
			b3.addEventListener(MouseEvent.CLICK,onB3Click);
			SetterUtils.buttonMode(true,b1,b2,b3);
			TabManager.set("test1",t1,t2,t3);
			TabManager.set("test2",t4.t4,t5,t6.t6);
			TabManager.set("test3",t1,t3,t4.t4,t6.t6);
			TabManager.activate("test1");
		}
		
		public function onB1Click(e:MouseEvent):void
		{
			TabManager.activate("test1");
		}
		
		public function onB2Click(e:MouseEvent):void
		{
			TabManager.activate("test2");
		}
		
		public function onB3Click(e:MouseEvent):void
		{
			TabManager.activate("test3");
		}	}}