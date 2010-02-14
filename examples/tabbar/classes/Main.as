package 
{
	import gs.display.GSSprite;
	import gs.display.tabbar.BaseTabView;
	import gs.display.tabbar.TabBar;

	public class Main extends GSSprite
	{
		
		private var tabBar:TabBar;
		public var tb1:TabButton;
		public var tb2:TabButton;
		public var v1:TabView1;
		public var v2:BaseTabView;
		
		public function Main()
		{
			super();
			tabBar = new TabBar();
			tabBar.addTab(tb1,v1);
			tabBar.addTab(tb2,v2);
			tabBar.hideAllAndSelectIndex(0);
		}	}}