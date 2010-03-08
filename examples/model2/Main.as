package
{
	import gs.model.Model;

	import flash.display.Sprite;

	public class Main extends Sprite 
	{
		
		private var model:Model;
		
		public function Main()
		{
			model=new Model();
			model.load("model.xml",onModelReady);
		}
		
		private function onModelReady():void
		{
			trace(model.xml);
			
			//save it for later use.
			Model.set("myModel",model);
			
			//...later
			trace(Model.get("myModel"));
		}
	}
}