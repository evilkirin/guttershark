package
{
	import gs.core.DocumentController;
	import gs.service.http.HTTPCall;
	import gs.service.http.HTTPCallResult;

	public class Main extends DocumentController
	{
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"model.xml"};
		}
		
		override protected function onModelReady():void
		{
			var hc:HTTPCall=model.getHTTPCallById("google");
			hc.setCallbacks({onResult:result});
			hc.send();
		}
		
		protected function result(r:HTTPCallResult):void
		{
			trace(r.text);
		}
	}
}