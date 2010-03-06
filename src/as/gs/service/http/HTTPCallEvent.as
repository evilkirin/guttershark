package gs.service.http 
{
	import flash.events.Event;
	
	/**
	 * The HTTPCallEvent is dispatched from HTTPCall instances.
	 */
	public class HTTPCallEvent extends Event
	{
		
		/**
		 * Timeout.
		 */
		public static const TIMEOUT:String = "timeout";
		
		/**
		 * Retry.
		 */
		public static const RETRY:String = "retry";
		
		/**
		 * First call.
		 */
		public static const FIRST_CALL:String = "firstCall";
		
		/**
		 * Fault
		 */
		public static const FAULT:String = "fault";
		
		/**
		 * Complete.
		 */
		public static const COMPLETE:String = "complete";
		
		/**
		 * A result object.
		 */
		public var result:HTTPCallResult;
		
		/**
		 * A fault object.
		 */
		public var fault:HTTPCallFault;
		
		/**
		 * Constructor for HTTPCallEvent instances.
		 * 
		 * @param type The event type.
		 * @param bubbles Whether or not the event bubbles.
		 * @param cancelable Whether or not the event is cancelable.
		 * @param _result A result object.
		 * @param _fault A fault object.
		 */
		public function HTTPCallEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false,_result:HTTPCallResult=null,_fault:HTTPCallFault=null)
		{
			super(type,bubbles,cancelable);
			result=_result;
			fault=_fault;
		}
	}
}