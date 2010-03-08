package
{
	import gs.control.DocumentController;
	import gs.http.HTTPCall;
	import gs.http.HTTPCallResult;

	public class Main extends DocumentController
	{
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"model.xml"};
		}
		
		override protected function onModelReady():void
		{
			var hc:HTTPCall=model.getHTTPCallById("google","home");
			hc.setCallbacks({onResult:result});
			hc.send();
		}
		
		protected function result(r:HTTPCallResult):void
		{
			trace(r.text);
		}
	}
}