package
{
	import gs.control.DocumentController;
	import gs.http.HTTPCall;
	import gs.http.HTTPCallResponseFormat;
	import gs.http.HTTPCallResult;

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
			hc.setCallbacks({onResult:result});
			hc.send();
			
			HTTPCall.set("test",hc);
			trace(HTTPCall.get("test"));
		}
		
		protected function result(r:HTTPCallResult):void
		{
			trace(r.text);
		}
	}
}