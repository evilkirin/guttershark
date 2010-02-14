package gs.support.servicemanager.shared 
{
	
	/**
	 * The CallResult class stores a result object from the server
	 * for any successful service call, and is passed back
	 * to the onResult callback function of a service call.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class CallResult 
	{
		
		/**
		 * The result object.
		 */
		public var result:*;
		
		/**
		 * Constructor for CallResult instances.
		 * @param res The result object.
		 */
		public function CallResult(res:*=null)
		{
			result = res;
		}
	}
}