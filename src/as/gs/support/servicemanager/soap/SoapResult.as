package gs.support.servicemanager.soap 
{
	
	/**
	 * The SoapResult class is a message wrapper,
	 * which contains the raw soap request result and
	 * optionally an instance of a SoapResultHandler.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class SoapResult
	{
		
		/**
		 * The raw request responses data.
		 */
		public var raw:String;
		
		/**
		 * Any handler class for the result. See the
		 * SoapResultHandler class for more info.
		 */
		public var handler:*;
		
		/**
		 * If the soap resonse is valid XML, a new
		 * XML instance can be instantiated from it,
		 * this will be a valid XML object.
		 * 
		 * <p>If the soap response cannot be turned
		 * into a valid XML object, this will be null.</p>
		 */
		public var soapXML:XML;
		
		/**
		 * Constructor for SoapResult instances.
		 * 
		 * @param rawResult The raw result from a soap service call.
		 * @param soapXML An xml instance created from the raw soap response.
		 */
		public function SoapResult(raw:String,soapXML:XML=null)
		{
			this.raw=raw;
			if(soapXML)this.soapXML=soapXML;
		}
		
		/**
		 * Check whether or not the soap response was
		 * successfully created into an XML object, which
		 * would be saved in the soapXML property.
		 */
		public function wasValidXMLResponse():Boolean
		{
			return !(soapXML==null);
		}
	}
}