package
{
	import gs.control.DocumentController;
	import gs.remoting.RemotingCall;
	import gs.remoting.RemotingCallFault;
	import gs.remoting.RemotingCallResult;

	public class Main extends DocumentController
	{
		
		private var rc:RemotingCall;
		
		override protected function flashvarsForStandalone():Object
		{
			return {
				model:"model.xml"
			};
		}
		
		override protected function onModelReady():void
		{
			super.onModelReady();
			rc=model.getRemotingCallById("amfphp","Echoer.echoString");
			rc.setCallbacks({onResult:onres,onFault:onfal,onConnectFail:fail});
			rc.send("hello world");
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