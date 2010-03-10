package gs.remoting
{
	
	/**
	 * The RemotingCallResult class wraps a result object returned
	 * from a remoting call.
	 * 
	 * <p>Remoting call results are passed to your onResult handler
	 * from a remoting call.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.remoting.RemotingCall
	 */
	public class RemotingCallResult 
	{
		
		/**
		 * The result object.
		 */
		public var result:Object;
		
		/**
		 * Dispose of this remoting call result.
		 */
		public function dispose():void
		{
			result=null;
		}
	}
}