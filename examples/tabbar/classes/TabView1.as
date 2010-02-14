package 
{
	import gs.display.tabbar.BaseTabView;
	
	import flash.events.Event;
	import flash.utils.setTimeout;		

	public class TabView1 extends BaseTabView
	{
		
		public function TabView1()
		{
			super();
		}
		
		override public function waitForEvent():String
		{
			return null;
			return "ready";
		}
		
		override public function tabBarIsWaiting():void
		{
			setTimeout(dispatchReady,3000);
		}
		
		private function dispatchReady():void
		{
			dispatchEvent(new Event("ready"));
		}	}}