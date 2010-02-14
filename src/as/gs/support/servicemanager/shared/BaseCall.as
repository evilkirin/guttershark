package gs.support.servicemanager.shared
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;	

	/**
	 * The BaseCall class is the base for any service call,
	 * and implements the base logic for attempts and timeout
	 * handling.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class BaseCall 
	{
		
		/**
		 * The id of this call.
		 */
		public var id:String;
		
		/**
		 * Limiter
		 */
		public var limiter:Limiter;
		
		/**
		 * Whether or not this call is complete.
		 */
		protected var completed:Boolean;
		
		/**
		 * How many tries have occured.
		 */
		protected var tries:int;
		
		/**
		 * How many attempts to allows.
		 */
		protected var attempts:int;
		
		/**
		 * The call timer.
		 */
		protected var callTimer:Timer;
		
		/**
		 * Call properties for this call.
		 */
		protected var props:Object;
		
		/**
		 * Whether or not a call has been made yet.
		 */
		protected var hasCalledYet:Boolean;
		
		/**
		 * Constructor for BaseCall instances.
		 * 
		 * @param callProps An object with call properties.
		 */
		public function BaseCall(callProps:Object)
		{
			props = callProps;
			tries = 0;
			attempts = 1;
		}
		
		/**
		 * Stub method for executing this service call.
		 */
		public function execute():void
		{
			if(!completed && !hasCalledYet && props.onFirstCall)
			{
				hasCalledYet=true;
				props.onFirstCall();
			}
		}
		
		/**
		 * On timer tick.
		 */
		protected function onTick(e:TimerEvent):void
		{
			if(!completed)
			{
				if(tries >= attempts)
				{
					completed = true;
					if(!props.onTimeout)
					{
						trace("WARNING: Call timed out, but onTimeout callback was not defined. You will not receive a fault event, or result event when a timeout occurs.");
						return;
					}
					props.onTimeout();
					return;
				}
				if(!props.onRetry) trace("WARNING: Call is retrying, but no onRetry callback is defined.");
				else props.onRetry();
				execute();
			}
		}
		
		/**
		 * On service call complete.
		 */
		protected function callComplete():void
		{
			if(!completed && props && props.onComplete)props.onComplete();
			completed=true;
			if(callTimer) callTimer.stop();
			if(limiter) limiter.releaseCall(id);
		}
		
		/**
		 * Checks if an onResult function was defined in the callProps object.
		 */
		protected function checkForOnResultCallback():Boolean
		{
			if(!props.onResult)
			{
				trace("WARNING: A result was recieved, but no onResult callback was defined.");
				dispose();
				return false;
			}
			return true;
		}
		
		/**
		 * Checks if an onFault functionw as defined in the callProps object.
		 */
		protected function checkForOnFaultCallback():Boolean
		{
			if(!props.onFault)
			{
				trace("WARNING: A fault was recieved, but no onFault callback was defined.");
				dispose();
				return false;
			}
			return true;
		}
		
		/**
		 * Dispose of this service.
		 */
		public function dispose():void
		{
			hasCalledYet=false;
			tries = 0;
			attempts = 0;
			completed = false;
			callTimer = null;
			limiter = null;
			id = null;
			props = null;
		}
	}
}
