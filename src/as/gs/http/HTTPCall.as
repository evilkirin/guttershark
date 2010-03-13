package gs.http
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * The HTTPCall class simplifies making http requests.
	 * 
	 * <p>The HTTPCall class also adds timeouts, retries, and gives you the
	 * option of setting callback functions for events instead of
	 * using addEventListener.</p>
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class HTTPCall
	{
		
		/**
		 * Internal lookup.
		 */
		private static var _htc:Dictionary = new Dictionary(true);
		
		/**
		 * @private
		 * 
		 * The http call id.
		 */
		public var id:String;
		
		/**
		 * A callback for when the first attempt is made.
		 */
		public var onFirstCall:Function;
		
		/**
		 * A callback to handle the result - you get passed an HTTPCallResult.
		 */
		public var onResult:Function;
		
		/**
		 * A callback to handle a fault - you get passed an HTTPCallFault.
		 */
		public var onFault:Function;
		
		/**
		 * A callback when a retry happens.
		 */
		public var onRetry:Function;
		
		/**
		 * A callback to call when all retries have tried but no
		 * result is available.
		 */
		public var onTimeout:Function;
		
		/**
		 * A callback to handle security errors - you get passed a SecurityErrorEvent.
		 */
		public var onSecurityError:Function;
		
		/**
		 * A callback for progress events - you get passed a ProgressEvent.
		 */
		public var onProgress:Function;
		
		/**
		 * A callback for io error events - you get passed an IOErrorEvent.
		 */
		public var onIOError:Function;
		
		/**
		 * A callback for when the request is opened.
		 */
		public var onOpen:Function;
		
		/**
		 * A callback for http status events. You'll only get passed
		 * the event if the status is not 0 and not 200. You'll get
		 * passed an HTTPStatusEvent.
		 */
		public var onHTTPStatus:Function;
		
		/**
		 * A callback to handle closing of this http call.
		 */
		public var onClose:Function;
		
		/**
		 * The time each attempt is given before timeing out,
		 * and trying again.
		 */
		public var timeout:int;
		
		/**
		 * The number of retries allowed.
		 */
		public var retries:int;
		
		/**
		 * The response format.
		 */
		public var responseFormat:String;
		
		/**
		 * A result handler class - the default is HTTPCallResultHandler.
		 * 
		 * <p>You can create your own handler classes to intercept
		 * a result and process it accordingly. Read through the
		 * source of HTTPCallResultHandler to customize</p>
		 */
		public var resultHandler:Class;
		
		/**
		 * Internal loader for the request.
		 */
		public var loader:URLLoader;
		
		/**
		 * Internal request for the call.
		 */
		public var request:URLRequest;
		
		/**
		 * Request method.
		 */
		protected var _method:String;
		
		/**
		 * Request data.
		 */
		protected var _data:Object;
		
		/**
		 * Whether or not this service has been sent yet.
		 */
		private var sent:Boolean;
		
		/**
		 * Try counter.
		 */
		private var tries:int;
		
		/**
		 * setTimeout id.
		 */
		private var timeoutid:Number;
		
		/**
		 * Whether or not this call is complete.
		 */
		private var complete:Boolean;
		
		/**
		 * Internal request url.
		 */
		private var _requestURL:String;
		
		/**
		 * Get an HTTPCall instance.
		 * 
		 * @param id The id of the http call.
		 */
		public static function get(id:String):HTTPCall
		{
			if(!id)return null;
			return _htc[id];
		}
		
		/**
		 * Save an HTTPCall instance.
		 * 
		 * @param id The id for the http call.
		 * @param call The http call.
		 */
		public static function set(id:String,call:HTTPCall):void
		{
			if(!id||!call)return;
			if(!call.id)call.id=id;
			_htc[id]=call;
		}
		
		/**
		 * Unset (delete) and HTTPCall instance.
		 * 
		 * @param id The http call id.
		 */
		public static function unset(id:String):void
		{
			if(!id)return;
			delete _htc[id];
		}
		
		/**
		 * Constructor for HTTPCall instances.
		 * 
		 * @param _url The URL endpoint.
		 * @param _method The request method (URLRequestMethod.POST or URLRequestMethod.GET).
		 * @param _timeout The time given to each attempt before retrying.
		 * @param _retries The numer of retries allowed.
		 * @param _responseFormat The response format for the call. (HTTPCallResponseFormat).
		 * @param _resultHandler A class to use as the result handler. The default is HTTPCallResultHandler.
		 */
		public function HTTPCall(_url:String,_method:String="GET",_data:Object=null,_timeout:int=5000,_retries:int=1,_responseFormat:String="variables",_resultHandler:Class=null)
		{
			if(!_url)throw new Error("ERROR: Parameter {url} cannot be null.");
			sent=false;
			tries=0;
			timeout=_timeout;
			retries=_retries;
			resultHandler=_resultHandler || HTTPCallResultHandler;
			request=new URLRequest(_url);
			request.requestHeaders=[];
			loader=new URLLoader();
			responseFormat=_responseFormat;
			data=_data;
			method=_method;
		}

		/**
		 * Set callbacks for events.
		 * 
		 * <p>You can supply these callbacks:</p>
		 * 
		 * <ul>
		 * <li>onResult (Function) - The on result handler.</li>
		 * <li>onFault (Function) - The on fault handler.</li>
		 * <li>onTimeout (Function) - The timeout handler.</li>
		 * <li>onRetry (Function) - The on retry handler.</li>
		 * <li>onFirstCall (Function) - The on first call handler.</li>
		 * <li>onProgress (Function) - The on progress handler.</li>
		 * <li>onHTTPStatus (Function) - The on http status handler.</li>
		 * <li>onOpen (Function) - The on open handler.</li>
		 * <li>onClose (Function) - The on close handler.</li>
		 * <li>onIOError (Function) - The on io error handler.</li>
		 * <li>onSecurityError (Function) - The on security error handler.</li>
		 * </ul>
		 * 
		 * @param callbacks The callbacks.
		 */
		public function setCallbacks(callbacks:Object):void
		{
			onClose=callbacks.onClose;
			onOpen=callbacks.onOpen;
			onHTTPStatus=callbacks.onHTTPStatus;
			onIOError=callbacks.onIOError;
			onResult=callbacks.onResult;
			onFault=callbacks.onFault;
			onTimeout=callbacks.onTimeout;
			onRetry=callbacks.onRetry;
			onFirstCall=callbacks.onFirstCall;
			onSecurityError=callbacks.onSecurityError;
			onProgress=callbacks.onProgress;
		}
		
		/**
		 * Add a header to the request.
		 * 
		 * @param name The header name.
		 * @param value The header value.
		 */
		public function addHeader(name:String,value:String):void
		{
			var header:URLRequestHeader=new URLRequestHeader(name,value);
			request.requestHeaders.push(header);
		}
		
		/**
		 * Removes all headers.
		 */
		public function clearHeaders():void
		{
			request.requestHeaders=[];
		}
		
		/**
		 * The request method.
		 */
		public function set method(val:String):void
		{
			_method=val;
			request.method=val;
		}
		
		/**
		 * The request method.
		 */
		public function get method():String
		{
			return _method;
		}
		
		/**
		 * The request data to submit for either POST or GET.
		 */
		public function set data(val:Object):void
		{
			_data=val;
			var key:String;
			var urlv:URLVariables=new URLVariables();
			for(key in val) urlv[key]=val;
			request.data=urlv;
		}
		
		/**
		 * The request data to submit for either POST or GET.
		 */
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 * The url for the internal request.
		 */
		public function set requestURL(val:String):void
		{
			_requestURL=val;
			request=new URLRequest(val);
			request.requestHeaders=[];
		}
		
		/**
		 * The url for the internal request.
		 */
		public function get requestURL():String
		{
			return _requestURL;
		}
		
		/**
		 * Close this HTTPCall and stop any load operation.
		 */
		public function close():void
		{
			try{if(loader)loader.close();}catch(e:*){}
			removeEventListeners();
			sent=false;
			complete=true;
			tries=0;
			if(onClose!=null)onClose();
		}
		
		/**
		 * Executes this call.
		 */
		public function send():void
		{
			if(sent && !complete)return;
			setTimeout(execute,0);
		}
		
		/**
		 * Real execution logic.
		 */
		private function execute():void
		{
			if(tries==0 && onFirstCall!=null)onFirstCall();
			if(tries>retries && onTimeout!=null)
			{
				onTimeout();
				return;
			}
			else if(tries > retries)return;
			removeEventListeners();
			loader=null;
			loader=new URLLoader();
			if(responseFormat == HTTPCallResponseFormat.TEXT) loader.dataFormat=URLLoaderDataFormat.TEXT;
			if(responseFormat == HTTPCallResponseFormat.JSON) loader.dataFormat=URLLoaderDataFormat.TEXT;
			if(responseFormat == HTTPCallResponseFormat.XML) loader.dataFormat=URLLoaderDataFormat.TEXT;
			if(responseFormat == HTTPCallResponseFormat.VARIABLES) loader.dataFormat=URLLoaderDataFormat.VARIABLES;
			if(responseFormat == HTTPCallResponseFormat.BINARY) loader.dataFormat=URLLoaderDataFormat.BINARY;
			addEventListeners();
			sent=true;
			if(tries>0&&onRetry!=null)onRetry();
			tries++;
			try{loader.load(request);}catch(e:*){}
			clearTimeout(timeoutid);
			if(timeout<50)timeout=1500;
			timeoutid=setTimeout(_timeout,timeout);
		}
		
		/**
		 * Internal call timeout handler.
		 */
		private function _timeout():void
		{
			if(complete)return;
			execute();
		}
		
		/**
		 * Internal call complete handler.
		 */
		private function _complete(e:Event):void
		{
			clearTimeout(timeoutid);
			complete=true;
			var reshandler:* =new resultHandler();
			var res:* =reshandler.process(this);
			if(res is HTTPCallResult && onResult!=null)onResult(res);
			if(res is HTTPCallFault && onFault!=null)onFault(res);
		}
		
		/**
		 * Internal progress handler.
		 */
		private function _onProgress(e:ProgressEvent):void
		{
			if(onProgress!=null)onProgress(e);
		}
		
		/**
		 * Internal open handler.
		 */
		protected function _onOpen(e:Event):void
		{
			if(onOpen!=null)onOpen();
		}
		
		/**
		 * Internal http status handler.
		 */
		private function _onHTTPStatus(e:HTTPStatusEvent):void
		{
			if(e.status!=0&&e.status!=200)return;
			if(onHTTPStatus!=null)onHTTPStatus(e);
		}
		
		/**
		 * Internal io error handler.
		 */
		private function _onIOError(e:IOErrorEvent):void
		{
			if(onIOError!=null)onIOError(e);
		}
		
		/**
		 * Internal security error event handler.
		 */
		private function _onSecurityError(e:SecurityErrorEvent):void
		{
			if(onSecurityError!=null)onSecurityError(e);
		}

		/**
		 * Removes listeners.
		 */
		private function removeEventListeners():void
		{
			if(!loader)return;
			loader.removeEventListener(Event.COMPLETE,_complete);
			loader.removeEventListener(Event.OPEN,_onOpen);
			loader.removeEventListener(ProgressEvent.PROGRESS,_onProgress);
			loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,_onHTTPStatus);
			loader.removeEventListener(IOErrorEvent.DISK_ERROR,_onIOError);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,_onIOError);
			loader.removeEventListener(IOErrorEvent.NETWORK_ERROR,_onIOError);
			loader.removeEventListener(IOErrorEvent.VERIFY_ERROR,_onIOError);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,_onSecurityError);
		}
		
		/**
		 * Adds listeners.
		 */
		private function addEventListeners():void
		{
			if(!loader)return;
			loader.addEventListener(Event.COMPLETE,_complete);
			loader.addEventListener(Event.OPEN,_onOpen);
			loader.addEventListener(ProgressEvent.PROGRESS,_onProgress);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,_onHTTPStatus);
			loader.addEventListener(IOErrorEvent.DISK_ERROR,_onIOError);
			loader.addEventListener(IOErrorEvent.IO_ERROR,_onIOError);
			loader.addEventListener(IOErrorEvent.NETWORK_ERROR,_onIOError);
			loader.addEventListener(IOErrorEvent.VERIFY_ERROR,_onIOError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,_onSecurityError);
		}
		
		/**
		 * Dispose of this http call.
		 */
		public function dispose():void
		{
			removeEventListeners();
			HTTPCall.unset(id);
			id=null;
			request=null;
			loader=null;
			tries=0;
			retries=0;
			onResult=null;
			onFault=null;
			onFirstCall=null;
			onTimeout=null;
			onRetry=null;
			onIOError=null;
			onHTTPStatus=null;
			onOpen=null;
			onClose=null;
			onSecurityError=null;
			responseFormat=null;
			resultHandler=null;
			sent=false;
			timeoutid=NaN;
			complete=false;
			_requestURL=null;
			_method=null;
			_data=null;
		}
	}
}