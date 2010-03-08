package 
{
	import gs.control.DocumentController;
	import gs.display.decorators.NavigateToLink;

	import flash.display.MovieClip;

	public class Main extends DocumentController
	{
		
		public var bt:MovieClip;
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"model.xml"};
		}
		
		override protected function onModelReady():void
		{
			super.onModelReady();
			//google is a link id in the model.
			var nvt:NavigateToLink=new NavigateToLink(model,bt,"google");
			nvt.x=0;
			nvt.y=0;
		}	}}