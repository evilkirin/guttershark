package gs.soap
{
	import flash.events.SecurityErrorEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * The SoapCall class is used in a soap service to execute a call.
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.soap.SoapService
	 */
	final public class SoapCall
	{
		
		/**
		 * On result callback - you get passed a SoapCallResult.
		 */
		public var onResult:Function;
		
		/**
		 * On fault callback - you get passed a SoapCallFault.
		 */
		public var onFault:Function;
		
		/**
		 * On first call callback.
		 */
		public var onFirstCall:Function;
		
		/**
		 * On timeout callback.
		 */
		public var onTimeout:Function;
		
		/**
		 * On retry callback.
		 */
		public var onRetry:Function;
		
		/**
		 * On security error callback - you get passed a SecurityErrorEvent.
		 */
		public var onSecurityError:Function;
		
		/**
		 * On io error callback - you get passed an IOErrorEvent.
		 */
		public var onIOError:Function;
		
		/**
		 * On http status callback. This is only called if the
		 * http status is not 0 and not 200. You'll get passed
		 * an HTTPStatusEvent.
		 */
		public var onHTTPStatus:Function;
		
		/**
		 * A callback to handle closing of this soap call.
		 */
		public var onClose:Function;
		
		/**
		 * Whether or not to trace the soap request before sending.
		 */
		public var traceSoapRequest:Boolean;
		
		/**
		 * Time allowed for each call before retrying.
		 */
		public var timeout:int;
		
		/**
		 * The number of retries to allow.
		 */
		public var retries:int;
		
		/**
		 * The result handler class (ses SoapCallResultHandler).
		 */
		public var resultHandler:Class;
		
		/**
		 * The soap service this call is sent to.
		 */
		private var service:SoapService;
		
		/**
		 * The soap method info.
		 */
		private var methodinfo:SoapMethodInfo;
		
		/**
		 * Call arguments.
		 */
		private var args:Object;
		
		/**
		 * The request loader.
		 */
		private var loader:URLLoader;
		
		/**
		 * The soap request.
		 */
		private var request:URLRequest;
		
		/**
		 * The soap xml in the request.
		 */
		private var requestXML:XML;
		
		/**
		 * Number of tries.
		 */
		private var tries:int;
		
		/**
		 * Whether or not this call has completed.
		 */
		private var completed:Boolean;
		
		/**
		 * The timeout id.
		 */
		private var timeoutid:Number;
		
		/**
		 * Whether or not the call was sent.
		 */
		private var sent:Boolean;
		
		/**
		 * Constructor for SoapCall instances.
		 * 
		 * @param _service The SoapService this call is sent to.
		 * @param _methodInfo The SoapMethodInfo for this call.
		 * @param _timeout The time allowed for each call.
		 * @param _retries The number of retries to allow.
		 * @param _resultHandler The soap result handler.
		 * @param _traceSoapRequest Whether or not to trace the soap request before sending.
		 */
		public function SoapCall(_service:SoapService,_methodInfo:SoapMethodInfo,_timeout:int=3000,_retries:int=1,_resultHandler:Class=null,_traceSoapRequest:Boolean=false):void
		{
			traceSoapRequest=_traceSoapRequest;
			service=_service;
			methodinfo=_methodInfo;
			timeout=_timeout;
			retries=_retries;
			resultHandler=_resultHandler;
			if(resultHandler==null)resultHandler=SoapCallResultHandler;
			tries=0;
		}
		
		/**
		 * Set callbacks.
		 * 
		 * <p>You can pass these callback properties:</p>
		 * 
		 * <ul>
		 * <li>onResult (Function) - The on result callback.</li>
		 * <li>onFault (Function) - The on fault callback.</li>
		 * <li>onTimeout (Function) - The on timeout callback.</li>
		 * <li>onRetry (Function) - The on retry callback.</li>
		 * <li>onFirstCall (Function) - The on first call callback.</li>
		 * <li>onSecurityError (Function) - The on security error callback.</li>
		 * <li>onIOError (Function) - The on io error callback.</li>
		 * <li>onHTTPStatus (Function) - The http status callback.</li>
		 * <li>onClose (Function) - The on close handler.</li>
		 * </ul>
		 * 
		 * @param callbacks The callback.
		 */
		public function setCallbacks(callbacks:Object):void
		{
			onResult=callbacks.onResult;
			onFault=callbacks.onFault;
			onFirstCall=callbacks.onFirstCall;
			onTimeout=callbacks.onTimeout;
			onRetry=callbacks.onRetry;
			onHTTPStatus=callbacks.onHTTPStatus;
			onIOError=callbacks.onIOError;
			onSecurityError=callbacks.onSecurityError;
			onClose=callbacks.onCallback;
		}
		
		/**
		 * Builds the request xml.
		 */
		private function buildRequestXML():void
		{
			loader=new URLLoader();
			request=new URLRequest();
			request.contentType="text/xml; charset=utf-8";
			request.method="POST";
			request.url=methodinfo.servicePath;
			request.requestHeaders.push(new URLRequestHeader("SOAPAction",methodinfo.action));
			var params:String="";
			var paramName:String="";
			var rawvalue:*;
			var value:String="";
			var i:int=0;
			var l:int=methodinfo.params.length;
			for(;i<l;i++)
			{
				paramName=methodinfo.params[int(i)].toString();
				rawvalue=args[paramName];
				if(rawvalue is XML) value=rawvalue.toXMLString();
				else value=rawvalue.toString();
				params+='<'+paramName+'>'+value+'</'+paramName+'>';
			}
			var soapXML:String="";
			soapXML+='<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body>';
			soapXML+='<'+methodinfo.name+' xmlns="'+methodinfo.targetNS+'">';
			soapXML+=params;
			soapXML+='</'+methodinfo.name+'>';
			soapXML+='</soap:Body></soap:Envelope>';
			requestXML=new XML(soapXML);
			if(traceSoapRequest)
			{
				trace(">> SOAP REQUEST <<");
				trace(requestXML.toXMLString());
				trace(">> END SOAP REQUEST <<");
			}
			request.data=requestXML;
		}
		
		/**
		 * Send this soap call.
		 * 
		 * @param args The soap service arguments.
		 */
		public function send(_args:Object):void
		{
			if(sent&&!completed)return;
			sent=true;
			args=_args;
			buildRequestXML();
			execute();
		}
		
		/**
		 * Close this SoapCall and stop any load operation.
		 */
		public function close():void
		{
			try{if(loader)loader.close();}catch(e:*){}
			completed=true;
			sent=false;
			tries=0;
			if(onClose!=null)onClose();
		}

		/**
		 * Executes the call.
		 */
		private function execute():void
		{
			if(completed)return;
			if(tries==0 && onFirstCall!=null)onFirstCall();
			if(tries>retries && onTimeout!=null)
			{
				onTimeout();
				return;
			}
			else if(tries>retries)
			{
				completed=true;
				return;
			}
			else if(tries>0&&onRetry!=null)onRetry();
			removeLoaderListeners();
			loader=new URLLoader();
			addLoaderListeners();
			tries++;
			timeoutid=setTimeout(_timeout,timeout);
			loader.load(request);
		}
		
		/**
		 * Removes listeners from loader.
		 */
		private function removeLoaderListeners():void
		{
			if(!loader)return;
			loader.removeEventListener(Event.COMPLETE,_complete);
			loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,_status);
			loader.removeEventListener(IOErrorEvent.NETWORK_ERROR,_ioerror);
			loader.removeEventListener(IOErrorEvent.DISK_ERROR,_ioerror);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,_ioerror);
			loader.removeEventListener(IOErrorEvent.VERIFY_ERROR,_ioerror);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,_security);
		}
		
		/**
		 * Adds listeners to loader.
		 */
		private function addLoaderListeners():void
		{
			loader.addEventListener(Event.COMPLETE,_complete);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,_status);
			loader.addEventListener(IOErrorEvent.NETWORK_ERROR,_ioerror);
			loader.addEventListener(IOErrorEvent.DISK_ERROR,_ioerror);
			loader.addEventListener(IOErrorEvent.IO_ERROR,_ioerror);
			loader.addEventListener(IOErrorEvent.VERIFY_ERROR,_ioerror);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,_security);
		}
		
		/**
		 * Timeout handler.
		 */
		private function _timeout():void
		{
			clearTimeout(timeoutid);
			execute();
		}
		
		/**
		 * On security error.
		 */
		private function _security(e:SecurityErrorEvent):void
		{
			if(completed)return;
			completed=true;
			sent=false;
			clearTimeout(timeoutid);
			if(onSecurityError!=null)onSecurityError(e);
		}
		
		/**
		 * On http status.
		 */
		private function _status(e:HTTPStatusEvent):void
		{
			if(completed)return;
			completed=true;
			sent=false;
			clearTimeout(timeoutid);
			if(e.status==0 || e.status==200)return;
			if(onHTTPStatus!=null)onHTTPStatus(e);
		}
		
		/**
		 *  After soap call is complete.
		 */
		private function _complete(e:Event):void
		{
			//if(completed)return;
			completed=true;
			sent=false;
			clearTimeout(timeoutid);
			var raw:String=String(loader.data);
			var handler:* =new resultHandler();
			var res:* =handler.process(raw);
			if(res is SoapCallResult && onResult!=null)onResult(res);
			else if(res is SoapCallFault && onFault!=null)onFault(res);
		}
		
		/**
		 * On soap service fault.
		 */
		private function _ioerror(e:Event):void
		{
			if(completed)return;
			completed=true;
			sent=false;
			clearTimeout(timeoutid);
			if(onIOError!=null)onIOError(e);
		}
	}
}