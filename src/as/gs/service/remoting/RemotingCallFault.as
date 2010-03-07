package gs.service.remoting 
{
	
	/**
	 * The RemotingCallFault class wraps a fault object returned
	 * from a remoting call.
	 * 
	 * <p>Remoting call faults are passed to your onFault handler
	 * from a remoting call.</p>
	 */
	public class RemotingCallFault 
	{
		
		/**
		 * The fault object.
		 */
		public var fault:Object;
	}
}