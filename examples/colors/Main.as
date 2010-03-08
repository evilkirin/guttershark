package 
{
	import gs.control.DocumentController;

	public class Main extends DocumentController
	{
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"model.xml"};
		}
		
		override protected function onModelReady():void
		{
			super.onModelReady();
			
			/**
			 * The model needs to have a stylesheet with the id "colors" so
			 * the color helper methods know where to pull from.
			 * 
			 * See the model.xml file for example
			 */
			trace(model.getColorAsInt(".pink"));
			trace(model.getColorAs0xHexString(".pink"));
			trace(model.getColorAsPoundHexString(".pink"));
		}
	}
}