package gs.soap
{
	import flash.events.SecurityErrorEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	/**
	 * The SoapService class simplifies making soap requests.
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class SoapService
	{
		
		/**
		 * Internal lookup for soap services.
		 */
		private static var _ss:Dictionary=new Dictionary();
		
		/**
		 * @private
		 * soap service id.
		 */
		public var id:String;
		
		/**
		 * On wsdl ready callback.
		 */
		public var onWSDLReady:Function;
		
		/**
		 * On io error callback - you get passed an IOErrorEvent.
		 */
		public var onIOError:Function;
		
		/**
		 * On security error callback - you get passed a SecurityErrorEvent.
		 */
		public var onSecurityError:Function;
		
		/**
		 * On http status callback. You'll only get passed the
		 * event if the status is not 0 and not 200. You'll get
		 * passed an HTTPStatusEvent.
		 */
		public var onHTTPStatus:Function;
		
		/**
		 * The wsdl url.
		 */
		public var wsdl:String;
		
		/**
		 * The raw wsdl xml.
		 */
		public var rawWSDL:XML;
		
		/**
		 * Number of retries allowed.
		 */
		private var retries:int;
		
		/**
		 * Time to allow a service call before timing out.
		 */
		private var timeout:int;
		
		/**
		 * Available methods found from the soap service.
		 */
		private var methods:Array;
		
		/**
		 * Methods lookup.
		 */
		private var methodsLookup:Dictionary;
		
		/**
		 * The loader for wsdl loading.
		 */
		private var loader:URLLoader;
		
		/**
		 * The port type.
		 */
		private var _portType:String;
		
		/**
		 * The binding amount.
		 */
		private var _binding:String;
		
		/**
		 * Service path.
		 */
		private var _servicePath:String;
		
		/**
		 * Get a soap service.
		 * 
		 * @param id The soap service id.
		 */
		public static function get(id:String):SoapService
		{
			if(!id)return null;
			return _ss[id];
		}
		
		/**
		 * Set a soap service.
		 * 
		 * @param id The soap service id.
		 * @param ss The soap service.
		 */
		public static function set(id:String,ss:SoapService):void
		{
			if(!id||!ss)return;
			if(!ss.id)ss.id=id;
			_ss[id]=ss;
		}
		
		/**
		 * Unset (delete) a soap service.
		 * 
		 * @param id The soap service id.
		 */
		public static function unset(id:String):void
		{
			if(!id)return;
			SoapService(_ss[id]).id=null;
			delete _ss[id];
		}
		
		/**
		 * Constructor for SoapService instances.
		 */
		public function SoapService(_wsdl:String,_timeout:int=3000,_retries:int=1):void
		{
			wsdl=_wsdl;
			retries=_retries;
			timeout=_timeout;
			methods=new Array();
			methodsLookup=new Dictionary(true);
		}
		
		/**
		 * Set callbacks.
		 * 
		 * <p>You can pass these callback properties:</p>
		 * 
		 * <ul>
		 * <li>onWSDLReady (Function) - The on wsdl ready callback.</li>
		 * <li>onIOError (Function) - The on io error callback.</li>
		 * <li>onSecurityError (Function) - The on security error callback.</li>
		 * <li>onHTTPStatus (Function) - The on http status callback.</li>
		 * </ul>
		 * 
		 * @param callbacks The callbacks.
		 */
		public function setCallbacks(callbacks:Object):void
		{
			onWSDLReady=callbacks.onWSDLReady;
			onIOError=callbacks.onIOError;
			onSecurityError=callbacks.onSecurityError;
			onHTTPStatus=callbacks.onHTTPStatus;
		}

		/**
		 * Send a soap call.
		 * 
		 * <p>This method returns the SoapCall instance that's doing the work for
		 * you. You only need to hold onto the reference if for some
		 * reason you need to close the soap call.</p>
		 * 
		 * <p>You can pass these callProps properties:</p>
		 * 
		 * <ul>
		 * <li>args (Object) - The call arguments</li>
		 * <li>arguments (Object) - The call arguments</li>
		 * <li>timeout (int) - The timeout for the call.</li>
		 * <li>retries (int) - The number of retries to allow.</li>
		 * <li>traceSoapRequest (Boolean) - Whether or not to trace the soap request</li>
		 * <li>resultHandler (Class) - A result handler class.</li>
		 * <li>onResult (Function) - The on result callback.</li>
		 * <li>onFault (Function) - The on fault callback.</li>
		 * <li>onTimeout (Function) - The on timeout callback.</li>
		 * <li>onRetry (Function) - The on retry callback.</li>
		 * <li>onFirstCall (Function) - The on first call callback.</li>
		 * <li>onSecurityError (Function) - The on security error callback.</li>
		 * <li>onIOError (Function) - The on io error callback.</li>
		 * <li>onHTTPStatus (Function) - The http status callback.</li>
		 * </ul>
		 * 
		 * @param method The method to call.
		 * @param callProps Call properties.
		 */
		public function send(method:String,callProps:Object):SoapCall
		{
			if(!callProps)callProps={};
			if(!methodsLookup[method])
			{
				if(callProps.onMethodNotAvailable)callProps.onMethodNotAvailable();
				trace("WARNING: Soap method {"+method+"} is not available. Not doing anything.");
				return null;
			}
			var time:int=callProps.timeout||timeout;
			var retry:int=callProps.retries||retries;
			var sc:SoapCall=new SoapCall(this,methodsLookup[method],time,retry,callProps.resultHandler,callProps.traceSoapRequest);
			sc.setCallbacks(callProps);
			sc.send(callProps.args||callProps.arguments);
			return sc;
		}
		
		/**
		 * Sets the _portType variable after connecting.
		 */
		private function setPortType():void
		{
			var wsdl:Namespace=rawWSDL.namespace();
			var portType:XMLList=rawWSDL.wsdl::portType;
			var portTypeAmount:Number=portType.length();
			if(portTypeAmount == 1) _portType=portType.@name;
			else _portType=portType[0].@name;
		}
		
		/**
		 * Sets the _binding property.
		 */
		private function setBinding():void
		{
			var wsdl:Namespace=rawWSDL.namespace();
			var service:XMLList=rawWSDL.wsdl::service;
			var binding:XMLList=rawWSDL.wsdl::binding.(@type.substr(@type.indexOf(":")+1)==_portType);
			var addressNS:Namespace=service.wsdl::port.children()[0].namespace();
			_servicePath=service.wsdl::port.addressNS::address.@location;
			var bindingAmount:Number=binding.length();
			if(bindingAmount==1) _binding=binding.@name;
			else _binding=binding[0].@name;
		}
		
		/**
		 * Sets this soap services' method list.
		 */
		private function setMethodList():void
		{
			var wsdl:Namespace=rawWSDL.namespace();
			var binding:XMLList=rawWSDL.wsdl::binding.(@name == _binding);
			var methodList:XMLList=binding.wsdl::operation;
			var s:Namespace=rawWSDL.wsdl::types.children()[0].namespace();
			var schema:XMLList=rawWSDL.wsdl::types.s::schema;
			var elements:XMLList=schema.s::element;
			var names:XMLList=methodList.@name;
			var ns:String=rawWSDL.@targetNamespace;
			var a:Number;
			for(a=0;a<names.length();a++)
			{
				var tempMethod:XMLList=methodList.(@name==names[a]);
				var tempNS:Namespace=tempMethod.children()[0].namespace();
				var action:String=tempMethod.tempNS::operation.@soapAction;
				var b:Number;
				for(b=0;b<elements.length();b++)
				{
					if(names[a]==elements[b].@name)
					{
						var params:XMLList=elements[b].s::complexType.s::sequence.s::element.@name;
						var parameters:Array=new Array();
						var c:Number;
						for(c=0;c<params.length();c++)parameters.push(params[c]);
						var mi:SoapMethodInfo=new SoapMethodInfo(names[a],parameters,ns,_servicePath,action);
						methods.push(mi);
					}
				}
			}
		}
		
		/**
		 * Traces out the methods found from the wsdl,
		 * in array format.
		 */
		public function listMethods():void
		{
			var names:Array=[];
			var i:int=0;
			var l:int=methods.length;
			//for(;i<l;i++)names.push(methods[int(i)].name);
			for(;i<l;i++)trace(methods[i]);
			//trace("Available Methods:");
			//trace(names);
		}
		
		/**
		 * Builds a method lookup dictionary.
		 */
		private function buildMethodLookup():void
		{
			var i:int=0;
			var l:int=methods.length;
			for(;i<l;i++)methodsLookup[methods[int(i)].name]=methods[int(i)];
		}
		
		/**
		 * Load and parse the wsdl.
		 */
		public function loadWSDL():void
		{
			loader=new URLLoader();
			loader.addEventListener(Event.COMPLETE,_complete);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,_status);
			loader.addEventListener(IOErrorEvent.NETWORK_ERROR,_ioerror);
			loader.addEventListener(IOErrorEvent.DISK_ERROR,_ioerror);
			loader.addEventListener(IOErrorEvent.IO_ERROR,_ioerror);
			loader.addEventListener(IOErrorEvent.VERIFY_ERROR,_ioerror);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,_security);
			loader.load(new URLRequest(wsdl));
		}
		
		/**
		 * On security error event.
		 */
		private function _security(e:SecurityErrorEvent):void
		{
			if(onSecurityError!=null)onSecurityError(e);
		}
		
		/**
		 * On http status for the wsdl download.
		 */
		private function _status(e:HTTPStatusEvent):void
		{
			if(e.status==0 || e.status==200)return;
			if(onHTTPStatus!=null)onHTTPStatus(e);
		}
		
		/**
		 * On fault of the wsdl download.
		 */
		private function _ioerror(e:Event):void
		{
			if(onIOError!=null)onIOError(e);
		}
		
		/**
		 * On complete of the wsdl load.
		 */
		private function _complete(e:Event):void
		{
			rawWSDL=new XML(loader.data);
			setPortType();
			setBinding();
			setMethodList();
			buildMethodLookup();
			if(onWSDLReady!=null)onWSDLReady();
		}
		
		/**
		 * Dispose of this service.
		 */
		public function dispose():void
		{
		}
	}
}