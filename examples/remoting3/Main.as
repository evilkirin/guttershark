package
{
	import gs.control.DocumentController;
	import gs.remoting.RemotingCallFault;
	import gs.remoting.RemotingCallResult;
	import gs.remoting.RemotingService;

	public class Main extends DocumentController
	{
		
		private var rs:RemotingService;
		
		override protected function flashvarsForStandalone():Object
		{
			return {
				model:"model.xml"
			};
		}
		
		override protected function onModelReady():void
		{
			super.onModelReady();
			rs=model.getRemotingServiceById("amfphp");
			
			rs.send("echoString",{
				onResult:onres,onFault:onfal,onConnectFail:fail,
				arguments:["hello world"]
			});
		}
		
		private function fail():void
		{
			trace("gateway connection fault");
		}
		
		private function onres(r:RemotingCallResult):void
		{
			trace(r.result.toString());
		}
		
		private function onfal(f:RemotingCallFault):void
		{
			trace(f,f.fault,"fault");
		}
	}
}