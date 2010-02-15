package
{
	import fl.controls.TextArea;

	import gs.core.DocumentController;
	import gs.util.ObjectUtils;

	public class Main extends DocumentController
	{
		
		public var ta:TextArea;
		
		override protected function flashvarsForStandalone():Object
		{
			return  {
				model:"model.xml",
				tracking:"tracking.xml",
				strings:"strings.xml"
			};
		}
		
		override protected function initFlashvars():void
		{
			super.initFlashvars();
			ta.appendText(ObjectUtils.rdump(flashvars));
		}
		
		override protected function initModel():void
		{
			//don't load any model... were just looking at flashvars
		}
	}
}
