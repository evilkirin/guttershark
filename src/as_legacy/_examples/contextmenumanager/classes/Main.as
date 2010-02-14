package
{
	import flash.display.MovieClip;
	
	import net.guttershark.control.DocumentController;
	import net.guttershark.managers.ContextMenuManager;	

	public class Main extends DocumentController 
	{
		
		private var mc:MovieClip;
		private var mc2:MovieClip;
		
		public function Main()
		{
			super();
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"model.xml"};
		}
		
		override protected function setupComplete():void
		{
			var cmm:ContextMenuManager = ContextMenuManager.gi();
			
			mc = new MovieClip();
			mc.graphics.beginFill(0xff0066);
			mc.graphics.drawRect(0,0,100,15);
			mc.graphics.endFill();
			addChild(mc);
			
			mc2 = new MovieClip();
			mc2.graphics.beginFill(0xff0099);
			mc2.graphics.drawRect(0,25,100,15);
			mc2.graphics.endFill();
			addChild(mc2);
			
			//use the cmm directly.
			//cmm.createMenu("menu1",[{id:"home",label:"home"},{id:"back",label:"GO BACK",sep:true}]);
			//mc.contextMenu=cmm.getMenu("menu1");
			//mc2.contextMenu=cmm.getMenu("menu1");
			
			//use model
			mc.contextMenu=ml.createContextMenuById("menu1");
			mc2.contextMenu=ml.createContextMenuById("menu1");
			
			//events
			em.handleEvents(mc.contextMenu,this,"onCM");
			
			//dispose if needed.
			//cmm.disposeMenu("menu1");
			//trace(cmm.getMenu("menu1"));
		}
		
		public function onCMhome():void
		{
			trace("on home");
		}
		
		public function onCMback():void
		{
			trace("go back");
		}	}}