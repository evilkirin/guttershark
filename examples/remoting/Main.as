package
{
	import gs.control.DocumentController;
	import gs.remoting.RemotingCall;
	import gs.remoting.RemotingCallFault;
	import gs.remoting.RemotingCallResult;

	public class Main extends DocumentController
	{
		
		private var rc:RemotingCall;
		private var r:RemotingCall;
		
		override protected function setupComplete():void
		{
			//you can save the gateway, and use a shortcut.
			RemotingCall.setGateway("amfphp","http://guttershark_amfphp/gateway.php");
			rc=new RemotingCall("amfphp","Echoer","echoString");
			
			//or use the entire gateway url
			rc=new RemotingCall("http://guttershark_amfphp/gateway.php","Echoer","echoString");
			rc.setCallbacks({
				onResult:onres,onFault:onfal,onTimeout:timeout,onRetry:retry,
				onFirstCall:firstcall,onConnectFail:fail,onBadVersion:badversion
			});
			rc.send("hello world");
			
			//this is just a demonstration of the error you get with BadVersion errors.
			r=new RemotingCall("amfphp","Echoer","badVersion");
			r.send();
		}
		
		private function badversion():void
		{
			trace("server error");
		}
		
		private function firstcall():void
		{
			trace("first call");
		}
		
		private function timeout():void
		{
			trace("timedout");
		}
		
		private function retry():void
		{
			trace("retrying");
		}
		
		private function fail():void
		{
			trace("connection failed");
		}
		
		private function onres(r:RemotingCallResult):void
		{
			trace(r.result.toString());
		}
		
		private function onfal(f:RemotingCallFault):void
		{
			trace(f,"fault");
		}
	}
}