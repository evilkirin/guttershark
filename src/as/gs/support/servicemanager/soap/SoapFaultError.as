package gs.support.servicemanager.soap 
{
	
	/**
	 * The SoapFaultError class should be used inside
	 * of a SoapResultHandler.process() method. If you
	 * find a soap fault in the response, you can throw
	 * this error -  it will trigger the guttershark soap
	 * library to call you onFault handler if specified.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class SoapFaultError extends Error
	{
		
		/**
		 * A soap fault instance.
		 */
		public var fault:SoapFault;
		
		/**
		 * Constructor for SoapFaultError instances.
		 * 
		 * @param soapFault A valid soap fault object.
		 */
		public function SoapFaultError(soapFault:SoapFault):void
		{
			super();
			fault=soapFault;
		}
		
		/**
		 * Dispose of this fault error.
		 */
		public function dispose():void
		{
			fault.dispose();
			fault=null;
		}
	}
}