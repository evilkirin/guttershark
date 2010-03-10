package gs.http
{
	import flash.utils.ByteArray;

	/**
	 * The HTTPCallFault class is a fault wrapper for faulty http calls.
	 * 
	 * <p>Properties on this object will be set according
	 * to the http call instance's responseFormat.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.http.HTTPCall
	 */
	public class HTTPCallFault
	{
		
		/**
		 * The raw data from the url loader.
		 */
		public var rawResult:*;
		
		/**
		 * The fault message.
		 */
		public var fault:String;
		
		/**
		 * The json fault object.
		 */
		public var json:Object;
		
		/**
		 * The vars fault object.
		 */
		public var vars:Object;
		
		/**
		 * The xml fault object.
		 */
		public var xml:XML;
		
		/**
		 * The binary fault object.
		 */
		public var binary:ByteArray;
		
		/**
		 * The text fault object.
		 */
		public var text:String;
		
		/**
		 * Dispose of this http call fault.
		 */
		public function dispose():void
		{
			rawResult=null;
			fault=null;
			json=null;
			vars=null;
			xml=null;
			binary=null;
			text=null;
		}
	}
}