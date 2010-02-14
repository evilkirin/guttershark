package gs.support.servicemanager.shared
{
	import flash.utils.Dictionary;		

	/**
	 * The Limiter class stops duplicate calls in RemotingServices
	 * when a call has been made, but no response has happened yet.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class Limiter
	{

		/**
		 * The lookup for calls.
		 */
		private var callsInProgress:Dictionary;

		/**
		 * New RemotinCallLimiter.
		 */
		public function Limiter()
		{
			callsInProgress = new Dictionary();
		}
		
		/**
		 * Locks a call so that no further calls can be made to it
		 * until it's unlocked.
		 * 
		 * @param uniquePath A unique identifier for a remoting call.
		 */
		public function lockCall(uniquePath:String):void
		{
			callsInProgress[uniquePath] = true;
		}
		
		/**
		 * Releases a call from the call pool.
		 * 
		 * @param uniquePath The unique identifier for a remoting call.
		 */
		public function releaseCall(uniquePath:String):void
		{
			if(!uniquePath) return;				
			callsInProgress[uniquePath] = false;
		}
		
		/**
		 * Test whether or not a call can be executed.
		 * 
		 * @param uniquePath The unique identifier for a remoting call.
		 */
		public function canExecute(uniquePath:String):Boolean
		{
			return (!callsInProgress[uniquePath]);
		}
		
		/**
		 * Clears all currently locked calls.
		 */
		public function releaseAllCalls():void
		{
			callsInProgress = new Dictionary();
		}
		
		/**
		 * Dispose of this RemotingCallLimiter.
		 */
		public function dispose():void
		{
			releaseAllCalls();
			callsInProgress = null;
		}
	}
}