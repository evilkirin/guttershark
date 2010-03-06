package
{
	import gs.service.http.HTTPCallResult;
	import gs.service.http.HTTPCall;
	import gs.core.DocumentController;
	
	public class Main extends DocumentController
	{
		
		override protected function flashvarsForStandalone():Object
		{
			return {
				model:"model.xml"
			};
		}
		
		override protected function onModelReady():void
		{
			var hc:HTTPCall = model.getHTTPCallById("google",onResult);
			hc.send();
		}
		
		protected function onResult(r:HTTPCallResult):void
		{
			trace(r.text);
		}
	}
}