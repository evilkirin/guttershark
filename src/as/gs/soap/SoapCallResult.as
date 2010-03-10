package gs.soap
{
	import gs.util.XMLNamespaceProxy;

	/**
	 * The SoapCallResult class wraps soap results and
	 * is passed to your onResult handlers.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.soap.SoapService
	 */
	final public class SoapCallResult
	{
		
		/**
		 * The raw request response data.
		 */
		public var raw:String;
		
		/**
		 * The soap response as xml.
		 */
		public var xml:XML;
		
		/**
		 * The soap body.
		 */
		public var body:XML;
		
		/**
		 * The soap namespace.
		 */
		public var nspace:Namespace;
		
		/**
		 * An xml namespace proxy that accesses the body object.
		 */
		public var nspaceProxy:XMLNamespaceProxy;
		
		/**
		 * Constructor for SoapCallResult instances.
		 * 
		 * @param _raw The raw result from a soap service call.
		 */
		public function SoapCallResult(_raw:String)
		{
			raw=_raw;
			xml=new XML(_raw);
			nspace=xml.namespace();
			body=new XML(xml.nspace::Body);
		}

		/**
		 * Set the namespace proxy namespace uri.
		 */
		public function set namespaceProxyURI(uri:String):void
		{
			nspaceProxy=new XMLNamespaceProxy(body,new Namespace("",uri));
		}
		
		/**
		 * Dispose of this soap call result.
		 */
		public function dispose():void
		{
			raw=null;
			xml=null;
			nspace=null;
			body=null;
		}
	}
}