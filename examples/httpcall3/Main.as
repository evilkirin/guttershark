package
{
	import gs.control.DocumentController;
	import gs.http.HTTPCallResponseFormat;
	import gs.http.HTTPCallResult;
	import gs.http.HTTPService;

	public class Main extends DocumentController
	{
		
		private var hs:HTTPService;
		
		public function Main()
		{
			super();
		}
		
		override protected function setupComplete():void
		{
			hs=new HTTPService("http://www.codeendeavor.com/");
			hs.send("archives/814",{method:"GET",onResult:result,resFormat:HTTPCallResponseFormat.TEXT});
		}
		
		protected function result(r:HTTPCallResult):void
		{
			trace(r.text);
		}
	}
}