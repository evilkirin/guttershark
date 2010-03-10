package gs.util 
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	/**
	 * The XMLNamespaceProxy class relieves you from having
	 * to access xml with the correctly qualified namespace
	 * every time.
	 * 
	 * <p>When you access xml nodes, it will return another
	 * XMLNamespaceProxy to you, so you can parse through
	 * the xml like normal</p>
	 * 
	 * <p>However - when you access a node that's an XMLList,
	 * it returns that XMLList to you.</p>
	 * 
	 * @example
	 * <listing>	
	 * //go from this:
	 * var ns:Namespace=xml.namespace();
	 * trace(xml.ns::node.ns::node);
	 * 
	 * //to this:
	 * var ns:Namespace=xml.namespace();
	 * var xns:XMLNamespaceProxy=new XMLNamespaceProxy(xml,ns);
	 * trace(xns.node.node);
	 * </listing>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	dynamic public class XMLNamespaceProxy extends Proxy
	{
		
		/**
		 * The xml being proxied to.
		 */
		public var xml:*;
		
		/**
		 * The namespace all calls are proxied into.
		 */
		public var ns:Namespace;
		
		/**
		 * Constructor for XMLNamespaceProxy instances.
		 * 
		 * @param xml The xml object.
		 * @param the namespace.
		 */
		public function XMLNamespaceProxy(xml:*,ns:Namespace)
		{
			this.xml=xml;
			this.ns=ns;
		}
		
		/**
		 * Calls toString on the internal xml.
		 */
		public function toString():String
		{
			return xml.toString();
		}
		
		/**
		 * Calls toXMLString on the internal xml.
		 */
		public function toXMLString():String
		{
			return xml.toXMLString();
		}
		
		/**
		 * Returns a string with an object description, and namespace.
		 * 
		 * @example
		 * <listing>	
		 * "[XMLNamespaceProxy http://example.com/]";
		 * </listing>
		 */
		public function info():String
		{
			return "[XMLNamespaceProxy "+ns.toString()+"]";
		}
		
		/**
		 * Dispose of this xml namespace proxy.
		 */
		public function dispose():void
		{
			xml=null;
			ns=null;
		}

		/**
		 * Forwards a property lookup to the internal xml,
		 * prefixed by the namespace.
		 */
		flash_proxy override function getProperty(name:*):*
		{
			var x:* =xml.ns::[name];
			if(x.length()>1)return new XMLList(x);
			return new XMLNamespaceProxy(xml.ns::[name],ns);
		}
		
		/**
		 * @private
		 * setProperty is not implemented.
		 */
		flash_proxy override function setProperty(name:*,value:*):void
		{
			throw new Error("XMLNamespaceProxy does not implement setProperty.");
		}
		
		/**
		 * Forwards the call to xml.hasOwnProperty(name).
		 */
		flash_proxy override function hasProperty(name:*):Boolean
		{
			return (xml.ns::[name].length()>0);
		}
		
		/**
		 * Forwards property calls onto the internal xml.
		 */
		flash_proxy override function callProperty(name:*,...rest:Array):*
		{
			var l:int=rest.length;
			switch(l)
			{
				case 0:
					return xml.ns::[name]();
					break;
				case 1:
					return xml.ns::[name](rest[0]);
					break;
				case 2:
					return xml.ns::[name](rest[0],rest[1]);
					break;
				case 3:
					return xml.ns::[name](rest[0],rest[1],rest[2]);
					break;
				case 4:
					return xml.ns::[name](rest[0],rest[1],rest[2],rest[3]);
					break;
				case 5:
					return xml.ns::[name](rest[0],rest[1],rest[2],rest[3],rest[4]);
					break;
				default:
					return xml.ns::[name]();
					break;
			}
			
			throw new Error("XMLNamespaceProxy does not implement callProperty.");
			return null;
		}
	}
}