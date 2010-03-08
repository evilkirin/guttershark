package gs.http 
{
	import flash.utils.Dictionary;

	/**
	 * The HTTPService class is a simple wrapper around
	 * sending HTTPCalls to the same server.
	 * 
	 * <p>This class spawns HTTPCall instances internally.</p>
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.http.HTTPCall
	 */
	public class HTTPService 
	{
		
		/**
		 * Internal HTTPService lookup.
		 */
		private static var _hts:Dictionary=new Dictionary();
		
		/**
		 * @private
		 * service id.
		 */
		public var id:String;
		
		/**
		 * Base url.
		 */
		private var baseurl:String;
		
		/**
		 * Timeouts
		 */
		private var timeout:int;
		
		/**
		 * Retries.
		 */
		private var retries:int;
		
		/**
		 * Get an http service.
		 * 
		 * @param id The http service id.
		 */
		public static function get(id:String):HTTPService
		{
			return _hts[id];
		}
		
		/**
		 * Save an http service.
		 * 
		 * @param id The service id.
		 * @param hs The http service.
		 */
		public static function set(id:String,hs:HTTPService):void
		{
			if(!id||!hs)return;
			if(!hs.id)hs.id=id;
			_hts[id]=hs;
		}
		
		/**
		 * Unset (delete) an http service.
		 * 
		 * @param id The http service id.
		 */
		public static function unset(id:String):void
		{
			if(!id)return;
			HTTPService(_hts[id]).id=null;
			delete _hts[id];
		}
		
		/**
		 * Constructor for HTTPService instances.
		 * 
		 * @param _baseurl The base url for the service - usually the domain like http://www.google.com/.
		 * @param _timeout The time to allow each call.
		 * @param _retries The number of retries allowed for each call.
		 */
		public function HTTPService(_baseurl:String,_timeout:int=3000,_retries:int=1):void
		{
			if(!_baseurl || _baseurl == "") throw new ArgumentError("ERROR: Parameter {_baseurl} cannot be null.");
			baseurl=_baseurl;
			timeout=_timeout;
			retries=_retries;
		}
		
		/**
		 * Send an http call.
		 * 
		 * <p>The call props object supports these properties:</p>
		 * 
		 * <ul>
		 * <li>method (String) (required) - Either GET or POST</li>
		 * <li>data (Object) - The data to submit for either get or post operations</li>
		 * <li>timeout (int) - The amount of time to allow each call</li>
		 * <li>retries (int) - The number of retries to allow</li>
		 * <li>resFormat (String) - The response format (see HTTPCallResponseFormat).</li>
		 * <li>responseFormat (String) - The response format (see HTTPCallResponseFormat).</li>
		 * <li>resultHandler (Class) - A result handler class. See HTTPCallResultHandler.</li>
		 * <li>onResult (Function) - The on result handler.</li>
		 * <li>onFault (Function) - The on fault handler.</li>
		 * <li>onTimeout (Function) - The timeout handler.</li>
		 * <li>onRetry (Function) - The on retry handler.</li>
		 * <li>onFirstCall (Function) - The on first call handler.</li>
		 * <li>onProgress (Function) - The on progress handler.</li>
		 * <li>onHTTPStatus (Function) - The on http status handler.</li>
		 * <li>onOpen (Function) - The on open handler.</li>
		 * <li>onIOError (Function) - The on io error handler.</li>
		 * <li>onSecurityError (Function) - The on security error handler.</li>
		 * </ul>
		 */
		public function send(urlpath:String,callProps:Object):void
		{
			if(!urlpath||urlpath=="")throw new ArgumentError("ERROR: Parameter {urlpath} cannot be null.");
			if(!callProps.method)throw new ArgumentError("ERROR: The callProps arguments must have a 'method' property set to either GET or POST.");
			var path:String=baseurl+urlpath;
			var time:int=callProps.timeout||timeout;
			var retry:int=callProps.retries||retries;
			var hc:HTTPCall=new HTTPCall(path,callProps.method,callProps.data,time,retry,callProps.responseFormat||callProps.resFormat,callProps.resultHandler);
			hc.setCallbacks(callProps);
			hc.send();
		}
	}
}