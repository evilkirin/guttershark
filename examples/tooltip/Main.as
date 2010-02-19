package
{
	import gs.managers.ToolTipManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class Main extends Sprite
	{
		
		public var clip:Sprite;
		public var toolTip:ToolTip;
		
		private var holder:MovieClip;
		private var ttm:ToolTipManager;
		
		public function Main()
		{
			holder=new MovieClip(); //we need a tooltip holder
			addChild(holder);
			
			ttm=new ToolTipManager(holder);
			ttm.register(clip,toolTip);//register the clip for a tooltip
			
			ToolTipManager.set("test",ttm); //save one for later
			trace(ToolTipManager.get("test"));
		}
	}
}