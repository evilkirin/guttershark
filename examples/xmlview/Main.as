package
{
	import gs.control.DocumentController;
	import gs.display.xmlview.XMLView;
	import gs.display.xmlview.XMLViewManager;

	public class Main extends DocumentController 
	{
		
		var vxm:XMLViewManager;
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"model.xml"};
		}
		
		override protected function setupComplete():void
		{
			vxm=new XMLViewManager(model.xml.xmlviews,model.xml.xmldata);
			//addChild(vxm.get("Test1") as XMLView);
			//addChild(vxm.get("Test2") as XMLView);
			//addChild(vxm.get("Test2WithPropset") as XMLView);
			//addChild(vxm.get("Test1WithXData") as XMLView);
			addChild(vxm.get("Test3") as XMLView);
		}	}}