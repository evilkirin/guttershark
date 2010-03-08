package gs.remoting
{
	
	/**
	 * The RemotingCallResultHandler class processes a RemotingCall response.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.remoting.RemotingCall
	 */
	public class RemotingCallResultHandler
	{
		
		/**
		 * Process the returned object.
		 * 
		 * @param returned The returned object from the remoting call.
		 * @param isFault Whether or not the returned object was returned as an already known fault object.
		 */
		public function process(returned:Object,isFault:Boolean=false):*
		{
			var result:RemotingCallResult=new RemotingCallResult();
			var fault:RemotingCallFault=new RemotingCallFault();
			if(isFault || returned.hasOwnProperty("faultString") || returned.hasOwnProperty("faultMessage") || returned.hasOwnProperty("fault"))
			{
				fault.fault=returned;
				return fault;
			}
			result.result=returned;
			return result;
		}
	}
}