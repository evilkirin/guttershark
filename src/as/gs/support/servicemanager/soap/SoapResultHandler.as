package gs.support.servicemanager.soap 
{

	/**
	 * The SoapResultHandler is a base class you should
	 * follow to implement your own soap result handlers.
	 * 
	 * <p>Generally, when a new instance is created. You
	 * want to do some processing with the soap response,
	 * so data is accessible in the result handler from
	 * the original service call.</p>
	 * 
	 * <p>There are a few helper methods which attempt to
	 * find, and set some default properties. Like soap body,
	 * fault, etc.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class SoapResultHandler 
	{
		
		/**
		 * The soap result object.
		 */
		protected var soapResult:SoapResult;
		
		/**
		 * A parsed xml object, which contains
		 * the entire soap envelope response.
		 */
		protected var xml:XML;
		
		/**
		 * The soap body xml, if found.
		 */
		protected var soapBody:XML;
		
		/**
		 * The soap fault xml if found, in the body.
		 */
		protected var soapFault:XML;
		
		/**
		 * The soap envelope namespace.
		 */
		protected var soapNamespace:Namespace;
		
		/**
		 * Constructor for SoapResultHandler instances.
		 * 
		 * @param soapResult A SoapResult object.
		 */	
		public function SoapResultHandler(soapResult:SoapResult):void
		{
			this.soapResult=soapResult;
			process();
		}
		
		/**
		 * A method you should override to do some processing
		 * with the soap result.
		 * 
		 * <p>When you process the response, you should also try and
		 * find any soap faults that are part of the response. If you
		 * do, you can throw a SoapFaultException so that the guttershark
		 * soap library will call you onfault handler.</p>
		 */
		protected function process():void{}
		
		/**
		 * Set's the soapNamespace property.
		 */
		protected function setNamespace():void
		{
			soapNamespace=xml.namespace();
		}
		
		/**
		 * Set's the soapBody property.
		 */
		protected function setBody():void
		{
			soapBody=new XML(xml.soapNamespace::Body);
		}
		
		/**
		 * Set's the soap fault property.
		 */
		protected function setFault():void
		{
			if(soapBody.hasOwnProperty("Fault"))soapFault=new XML(soapBody.Fault);
		}
		
		/**
		 * Check whether or not a fault is in the body. You
		 * should first call setFault();
		 */
		protected function hasFault():Boolean
		{
			return !(soapFault);
		}
	}
}