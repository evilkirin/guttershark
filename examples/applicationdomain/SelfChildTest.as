package
{
	import gs.display.GSClip;
	import gs.managers.AssetManager;

	public class SelfChildTest extends GSClip
	{
		public function SelfChildTest()
		{
			super();
			trace(AssetManager.getSound("OdeTo"));
		}
	}
}