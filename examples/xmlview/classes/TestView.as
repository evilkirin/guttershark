package
{
	import gs.core.Model;
	import gs.display.xmlview.XMLView;
	import gs.util.SetterUtils;

	public class TestView extends XMLView
	{
		
		public var testNameOut:XMLView;
		public var testAnotherName:XMLView;

		private var model:Model;

		override public function initFromXML(xml:*):void
		{
			trace("init view");
			model=Model.get("main");
			if(attributes)
			{
				//trace(attributes);
				if(attributes.@propset!=undefined) SetterUtils.propsFromModel(model,this,attributes.@propset);
				else
				{
					if(attributes.@x)x=attributes.@x;
					if(attributes.@y)y=attributes.@y;
				}
			}
			//if(data)trace(data);
		}
		
		override public function creationComplete():void
		{
			trace("creationComplete for this:",this);
			if(testNameOut||testAnotherName)
			{
				trace(testNameOut);
				trace(testAnotherName);
			}
		}
	}}