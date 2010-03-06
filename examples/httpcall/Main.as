package
{
	import gs.core.DocumentController;
	import gs.service.http.HTTPCall;
	import gs.service.http.HTTPCallResponseFormat;
	import gs.service.http.HTTPCallResult;

	public class Main extends DocumentController
	{
		
		private var hc:HTTPCall;
		
		public function Main()
		{
			super();
		}
		
		override protected function setupComplete():void
		{
			hc=new HTTPCall("http://www.google.com/");
			hc.responseFormat=HTTPCallResponseFormat.TEXT;
			hc.setCallbacks(onResult);
			hc.send();
			
			HTTPCall.set("test",hc);
			trace(HTTPCall.get("test"));
		}
		
		protected function onResult(r:HTTPCallResult):void
		{
			trace(r.text);
		}
	}
}