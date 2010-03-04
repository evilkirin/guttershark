package 
{
	import gs.core.*;
	import gs.support.preloading.Asset;

	public class Main extends DocumentController
	{
		
		public function Main()
		{
			super();
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {
				model:"model.xml",
				bitmaps:"bitmaps/"
			};
		}
		
		override protected function initPaths():void
		{
			super.initPaths();
			model.addPath("bitmaps",flashvars.bitmaps);
		}
		
		override protected function onModelReady():void
		{
			super.onModelReady();
			var a:Asset = model.getAssetByLibraryName("test");
			trace(a.source); //YAY! PATHS
		}
	}
}
