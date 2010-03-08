package
{
	import gs.control.DocumentController;
	import gs.http.HTTPCallResponseFormat;
	import gs.http.HTTPCallResult;
	import gs.http.HTTPService;

	public class Main extends DocumentController
	{
		
		private var hs:HTTPService;
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"model.xml"};
		}
		
		override protected function onModelReady():void
		{
			hs=model.getHTTPServiceById("codeendeavor");
			hs.send("archives/814",{method:"GET",onResult:result,resFormat:HTTPCallResponseFormat.TEXT});
		}
		
		protected function result(r:HTTPCallResult):void
		{
			trace(r.text);
		}
	}
}