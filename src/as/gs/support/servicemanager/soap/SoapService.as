package gs.support.servicemanager.soap 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	/**
	 * Dispatched after the wsdl file has been downloaded, and parsed.
	 * 
	 * @eventType flash.events.Event
	 */
	[Event("complete", type="flash.events.Event")]
	
	/**
	 * The SoapService class is a service access point for Soap.
	 * It represents a wsdl file, and interacting with the methods
	 * exposed from the wsdl.
	 * 
	 * @example Calling a soap service method.
	 * <listing>	
	 * sm.createSOAPService("someService","http://example.com/?wsdl");
	 * sm.someService.myMethod({params:{ xmlInput:myXMLObject } },resultHandlerClass:MySoapResultHandlerClass,onResult:callback,onFault:callback,onCreate:callback});
	 * </listing>
	 * 
	 * <p>In the above example, the "xmlInput" parameter is not specific
	 * to this soap library, it's a parameter that's specific to
	 * the soap service. Which takes a chunck of raw xml.</p>
	 * 
	 * @example Calling another soap service method.
	 * <listing>	
	 * var sm:ServiceManager=ServiceManager.gi();
	 * sm.createSOAPService("geoip","http://www.geoip.com/soap?wsdl");	
	 * sm.geoip.findLocation({params:{zipCode:"94111"}},onResult:callback,onFault:callback);
	 * </listing>
	 * 
	 * <p>Supported properties on the callProps object:</p>
	 * <li>params (Object) - The parameters for the soap method.</li>
	 * <li>resultHandlerClass (Class) - A class to use for handling the soap result. This is used to process the result, before any onResult, or onFault callbacks occur.
	 * Which gives you hooks into processing the raw response first.</li> 
	 * <li>onCreate (Function) - A function to call, as soon as a remoting call instance was created (the request hasn't gone out yet though.).</li>
	 * <li>onResult (Function) - A function to call, and pass a CallResult object to.</li>
	 * <li>onFault (Function) - A function to call, and pass a CallFault object to.</li>
	 * <li>onRetry (Function) - A function to call for every retry of a service call.</li>
	 * <li>onTimeout (Function) - A function to call after every retry has been attempted, and no result or fault was returned.</li>
	 * <li>onMethodNotAvailable (Function) - A function to call if the soap method is not available.</li>
	 * <li>attempts (int) - The number of retry attempts allowed.</li>
	 * <li>timeout (int - milliseconds) - The amount of time allowed for each call before another attempt is made.</li>
	 * </ul>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final dynamic public class SoapService extends Proxy implements IEventDispatcher
	{
		
		/**
		 * Internal event dispatcher.
		 */
		private var ed:EventDispatcher;
		
		/**
		 * The service utl.
		 */
		private var url:String;
		
		/**
		 * Attempts allowed.
		 */
		private var attempts:int;
		
		/**
		 * Call time before retry.
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
		 * Whether or not the raw wsdl file had
		 * completely downloaded.
		 */
		public var connected:Boolean;
		
		/**
		 * Service path.
		 */
		private var _servicePath:String;
		
		/**
		 * raw wsdl xml.
		 */
		private var _rawWSDL:XML;
		
		/**
		 * Used as a caching mechanism to not loop
		 * through methods names more than once, when
		 * calling listMethods.
		 */
		private var methodNamesCache:Array;
		
		/**
		 * Constructor for SoapService instances.
		 */
		public function SoapService(wsdlEndpoint:String,attempts:int=3,timeout:int=4000):void
		{
			ed=new EventDispatcher();
			url=wsdlEndpoint;
			this.attempts=attempts;
			this.timeout=timeout;
			connect();
			methods=new Array();
			methodsLookup=new Dictionary(true);
		}
		
		/**
		 * Get the raw WSDL xml file.
		 */
		public function get rawWSDL():XML
		{
			return _rawWSDL;
		}
		
		/**
		 * Provides ways to call methods from strings.:
		 * 
		 * sm.soapService.call("SoapMethod",{});
		 */
		public function call(methodName:String,...args):void
		{
			this[methodName](args);
		}
		
		/**
		 * Override flash_proxy for easy use.
		 * 
		 * You can call a soap service like so:
		 * services.serviceEndpoint.MethodName(soapRequest)
		 */
		flash_proxy override function callProperty(methodName:*, ...args):*
		{
			if(args[0] is Array) args=args[0]; //came from internal callMethod.
			var callProps:Object=args[0];
			if(!methodsLookup[methodName])
			{
				if(callProps.onMethodNotAvailable)callProps.onMethodNotAvailable();
				trace("WARNING: Soap method {"+methodName+"} is not available. Not doing anything.");
				return null;
			}
			if(!callProps.timeout) callProps.timeout=timeout;
			if(!callProps.attempts) callProps.attempts=attempts;
			var sc:SoapCall=new SoapCall(this,methodsLookup[methodName],callProps);
			if(callProps.onCreate) callProps.onCreate();
			sc.execute();
			return null;
		}
		
		/**
		 * Sets the _portType variable after connecting.
		 */
		private function setPortType():void
		{
			var wsdl:Namespace=_rawWSDL.namespace();
			var portType:XMLList=_rawWSDL.wsdl::portType;
			var portTypeAmount:Number=portType.length();
			if(portTypeAmount == 1) _portType=portType.@name;
			else _portType=portType[0].@name;
		}
		
		/**
		 * Sets the _binding property.
		 */
		private function setBinding():void
		{
			var wsdl:Namespace=_rawWSDL.namespace();
			var service:XMLList=_rawWSDL.wsdl::service;
			var binding:XMLList=_rawWSDL.wsdl::binding.(@type.substr(@type.indexOf(":")+1)==_portType);
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
			var wsdl:Namespace=_rawWSDL.namespace();
			var binding:XMLList=_rawWSDL.wsdl::binding.(@name == _binding);
			var methodList:XMLList=binding.wsdl::operation;
			var s:Namespace = _rawWSDL.wsdl::types.children()[0].namespace();
			var schema:XMLList = _rawWSDL.wsdl::types.s::schema;
			var elements:XMLList = schema.s::element;
			var names:XMLList=methodList.@name;
			var ns:String=_rawWSDL.@targetNamespace;
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
			if(methodNamesCache)
			{
				trace("Available Methods:");
				trace(methodNamesCache);
				return;
			}
			methodNamesCache=[];
			var i:int=0;
			var l:int=methods.length;
			for(i;i<l;i++)methodNamesCache.push(methods[i].name);
			trace("Available Methods:");
			trace(methodNamesCache);
		}
		
		/**
		 * Builds a method lookup dictionary.
		 */
		private function buildMethodLookup():void
		{
			var i:int=0;
			var l:int=methods.length;
			for(i;i<l;i++)methodsLookup[methods[i].name]=methods[i];
		}
		
		/**
		 * Grabs the wsdl file. On complete
		 * it parses out available methods.
		 */
		protected function connect():void
		{
			loader=new URLLoader();
			loader.addEventListener(Event.COMPLETE,onComplete);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,onStatus);
			loader.addEventListener(IOErrorEvent.NETWORK_ERROR,onFault);
			loader.addEventListener(IOErrorEvent.DISK_ERROR,onFault);
			loader.addEventListener(IOErrorEvent.IO_ERROR,onFault);
			loader.addEventListener(IOErrorEvent.VERIFY_ERROR,onFault);
			loader.load(new URLRequest(url));
		}
		
		/**
		 * On http status for the wsdl download.
		 */
		private function onStatus(e:HTTPStatusEvent):void
		{
			if(e.status!=0 && e.status!=200)connected=false;
		}
		
		/**
		 * On fault of the wsdl download.
		 */
		private function onFault(e:Event):void
		{
			connected=false;
		}
		
		/**
		 * On complete of the wsdl load.
		 */
		private function onComplete(e:Event):void
		{
			connected=true;
			_rawWSDL=new XML(loader.data);
			setPortType();
			setBinding();
			setMethodList();
			buildMethodLookup();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * Add event listener.
		 */
		public function addEventListener(type:String,listener:Function,useCapture:Boolean=false,priority:int=0,useWeakReference:Boolean=false):void
		{
			ed.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		/**
		 * Remove event listener.
		 */
		public function removeEventListener(type:String,listener:Function,useCapture:Boolean=false):void
		{
			ed.removeEventListener(type,listener,useCapture);
		}
		
		/**
		 * Dispatch event.
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return ed.dispatchEvent(event);
		}
		
		/**
		 * Has event listener.
		 */
		public function hasEventListener(type:String):Boolean
		{
			return ed.hasEventListener(type);
		}
		
		/**
		 * Will trigger.
		 */
		public function willTrigger(type:String):Boolean
		{
			return ed.willTrigger(type);
		}
		
		/**
		 * Dispose of this service.
		 */
		public function dispose():void
		{
			ed=null;
			url=null;
			attempts=NaN;
			timeout=NaN;
			methods=null;
			methodsLookup=null;
			loader=null;
			_portType=null;
			_binding=null;
			_rawWSDL=null;
			_servicePath=null;
		}
	}
}