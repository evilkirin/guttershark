package
{
	import gs.core.DocumentController;

	public class Main extends DocumentController
	{
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"model.xml"};
		}
		
		override protected function onModelReady():void
		{
			trace( model.getAssetsForPreload() );
			trace( model.getAssetGroup("sounds") );
			trace( model.getAssetByLibraryName("asset2") );
			trace( model.getAssetsByLibraryNames("asset1","asset2") );
			trace( model.getAssetByLibraryName("asset3").source );
		}
	}
}
