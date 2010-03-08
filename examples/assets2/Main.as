package
{
	import gs.control.Document;
	import gs.managers.AssetManager;

	public class Main extends Document
	{
		
		public function Main()
		{
			addChild( AssetManager.getMovieClip("clip") );
			trace(AssetManager.getMovieClip("clip"));
		}
	}
}