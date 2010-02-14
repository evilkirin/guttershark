package
{	
	import gs.display.GSClip;
	import gs.managers.AssetManager;

	public class ShellClip extends GSClip 
	{
		public function ShellClip()
		{
			super();
			trace(AssetManager.getSound("OdeTo"));
		}
	}
}