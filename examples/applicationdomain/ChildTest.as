package
{
	import gs.display.GSClip;
	import gs.managers.AssetManager;

	public class ChildTest extends GSClip
	{
		public function ChildTest()
		{
			super();
			addChild(AssetManager.getMovieClip("Child2"));
			trace(AssetManager.getSound("OdeTo"));
		}
	}
}