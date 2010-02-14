package gs.support.servicemanager.remoting
{
	import flash.events.TimerEvent;
	import flash.net.Responder;
	import flash.utils.*;
	
	import gs.support.servicemanager.remoting.RemotingService;
	import gs.support.servicemanager.shared.BaseCall;
	import gs.support.servicemanager.shared.CallFault;
	import gs.support.servicemanager.shared.CallResult;		

	/**
	 * The RemotingCall class executes remoting calls.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class RemotingCall extends BaseCall
	{
		
		/**
		 * The remoting service to make calls to.
		 */	
		private var rs:RemotingService;
		
		/**
		 * Constructor for RemotingCall instances.
		 * 
		 * @param rs The RemotingService this call is going to.
		 * @param callProps The callproperties to use for this call.
		 */
		public function RemotingCall(rs:RemotingService, callProps:Object)
		{
			super(callProps);
			this.rs=rs;
		}
		
		/**
		 * Execute this call.
		 */
		override public function execute():void
		{
			super.execute();
			if(!completed)
			{
				attempts = props.attempts;
				var operation:String = props.endpoint + "." + props.method;
				var responder:Responder = new Responder(onResult, onFault);
				var callArgs:Array = new Array(operation, responder);
				if(!callTimer)
				{
					callTimer = new Timer(props.timeout,attempts);
					callTimer.addEventListener(TimerEvent.TIMER,onTick, false, 0, true);
				}
				tries++;
				if(!callTimer.running) callTimer.start();
				rs.rc.connection.call.apply(null, callArgs.concat(props.params));
				if(limiter) limiter.lockCall(id);
			}
		}
		
		private function onResult(resObj:Object):void
		{
			if(!completed && rs)
			{
				callComplete();
				var re:CallResult = new CallResult(resObj);
				if(!checkForOnResultCallback()) return;
				(props.returnArgs && props.params.length>0 && props.params!=undefined) ? props.onResult(re,props.params) : props.onResult(re);
				dispose();
			}
		}
		
		private function onFault(resObj:Object):void
		{
			if(!completed && rs)
			{
				callComplete();
				var fe:CallFault = new CallFault(resObj);
				if(!checkForOnFaultCallback()) return;
				(props.returnArgs && props.params.length>0 && props.params!=undefined) ? props.onFault(fe,props.params) : props.onFault(fe);
				dispose();
			}
		}
		
		/**
		 * Dispose of this RemotingCall.
		 */
		override public function dispose():void
		{
			super.dispose();
			rs = null;
		}
	}
}