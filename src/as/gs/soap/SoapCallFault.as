package gs.soap
{	
	import gs.util.XMLNamespaceProxy;

	/**
	 * The SoapCallFault class wraps soap faults and
	 * is passed to your onFault handlers.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.soap.SoapService
	 */
	final public class SoapCallFault
	{
		
		/**
		 * Whether or not this is a fault because the
		 * soap response is invalid xml.
		 */
		public var invalidXML:Boolean;
		
		/**
		 * The raw request response data.
		 */
		public var raw:String;
		
		/**
		 * The soap response as xml.
		 */
		public var xml:XML;
		
		/**
		 * The soap namespace.
		 */
		public var nspace:Namespace;
		
		/**
		 * The fault object inside of the soap body.
		 */
		public var fault:XML;
		
		/**
		 * An xml namespace proxy that accesses the fault object.
		 */
		public var nspaceProxy:XMLNamespaceProxy;
		
		/**
		 * Constructor for SoapCallFault instances.
		 * 
		 * @param _raw The raw request response.
		 * @param _invalidXML Whether or not this is a fault because the soap response is invalid xml.
		 */
		public function SoapCallFault(_raw:String,_invalidXML:Boolean=false)
		{
			raw=_raw;
			invalidXML=_invalidXML;
			if(!invalidXML)
			{
				xml=new XML(_raw);
				nspace=xml.namespace();
				var body:XML=new XML(xml.nspace::Body);
				try{fault=new XML(body.Fault);}catch(e:*){}
				try{if(!fault)fault=new XML(body.nspace::Fault);}catch(e:*){}
			}
		}
		
		/**
		 * Set the namespace proxy namespace uri.
		 */
		public function set namespaceProxyURI(uri:String):void
		{
			nspaceProxy=new XMLNamespaceProxy(fault,new Namespace("",uri));
		}
		
		/**
		 * Dispose of this soap call result.
		 */
		public function dispose():void
		{
			raw=null;
			invalidXML=false;
			nspace=null;
			fault=null;
			if(nspace)nspaceProxy.dispose();
		}
	}
}