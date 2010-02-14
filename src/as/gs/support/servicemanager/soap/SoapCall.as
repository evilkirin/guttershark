package gs.support.servicemanager.soap 
{
	import gs.support.servicemanager.shared.BaseCall;

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.utils.Timer;

	/**
	 * The SoapCall class executes soap service calls.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class SoapCall extends BaseCall
	{
		
		/**
		 * The soap method info object.
		 */
		private var mi:SoapMethodInfo;
		
		/**
		 * The soap service instance.
		 */
		private var ss:SoapService;
		
		/**
		 * Loader for soap service.
		 */
		private var loader:URLLoader;
		
		/**
		 * Request for soap request.
		 */
		private var request:URLRequest;
		
		/**
		 * The request xml.
		 */
		private var requestXML:XML;
		
		/**
		 * Constructor for SoapCall instances.
		 * 
		 * @param service The SoapService instance.
		 * @param soapMethod The SoapService method.
		 * @param request The request xml.
		 * @param callProps Any call properties to apply.
		 */
		public function SoapCall(service:SoapService,methodInfo:SoapMethodInfo,callProps:Object):void
		{
			super(callProps);
			this.ss=service;
			this.mi=methodInfo;
		}
		
		/**
		 * Executes the call.
		 */
		override public function execute():void
		{
			super.execute();
			if(!completed)
			{
				if(!props.params)
				{
					trace("No params were specified to SoapCal, not doing anything.");
					return;
				}
				attempts=props.attempts;
				request=new URLRequest();
				request.contentType="text/xml; charset=utf-8";
				request.method="POST";
				request.url=mi.servicePath;
				var soapAction:URLRequestHeader=new URLRequestHeader("SOAPAction",mi.action);
				request.requestHeaders.push(soapAction);
				var params:String="";
				var paramName:String="";
				var value:String="";
				var i:int=0;
				for(i=0;i<mi.params.length;i++)
				{
					paramName=mi.params[i].toString();
					value=props.params[paramName];
					if(value is XML) value=value.toString();
					params+='<'+paramName+'>'+value+'</'+paramName+'>';
				}
				var soapXML:String="";
				soapXML += '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">';
				soapXML += '<soap:Body>';
				soapXML += '<' + mi.name + ' xmlns="' + mi.targetNS + '">';
				soapXML += params;
				soapXML += '</' + mi.name + '>';
				soapXML += '</soap:Body>';
				soapXML += '</soap:Envelope>';
				requestXML=new XML(soapXML);
				if(props.showSoapRequest)
				{
					trace("####SOAP REQUEST####");
					trace(soapXML);	
				}
				request.data=requestXML;
				loader=new URLLoader();
				loader.addEventListener(Event.COMPLETE,onComplete);
				loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,onStatus);
				loader.addEventListener(IOErrorEvent.NETWORK_ERROR,onFault);
				loader.addEventListener(IOErrorEvent.DISK_ERROR,onFault);
				loader.addEventListener(IOErrorEvent.IO_ERROR,onFault);
				loader.addEventListener(IOErrorEvent.VERIFY_ERROR,onFault);
				if(!callTimer)
				{
					callTimer=new Timer(props.timeout,attempts);
					callTimer.addEventListener(TimerEvent.TIMER,onTick,false,0,true);
				}
				tries++;
				if(!callTimer.running)callTimer.start();
				loader.load(request);
			}
		}
		
		/**
		 * On http status.
		 */
		private function onStatus(e:HTTPStatusEvent):void
		{
			if(e.status!=0 && e.status!=200 && props.onFault) props.onFault(new SoapFault());
		}
		
		/**
		 *  After soap call is complete.
		 */
		private function onComplete(e:Event):void
		{
			if(!completed)
			{
				callComplete();
				var raw:String=String(loader.data);
				var soapXML:XML;
				try{ soapXML=new XML(raw); }
				catch(e:Error){} //not valid xml.
				var result:SoapResult=new SoapResult(raw,soapXML);
				if(props.resultHandlerClass)
				{
					var clsf:Class=props.resultHandlerClass;
					try{ var handler:* =new clsf(result); }
					catch(e:SoapFaultError)
					{
						if(!checkForOnFaultCallback())return;
						props.onFault(e.fault);
						dispose();
						return;
					}
					result.handler=handler;
				}
				if(soapXML)
				{
					//try to find soap fault soapXML
					//if fault, create new SoapFault and call props.onFault()
				}
				if(!checkForOnResultCallback()) return;
				props.onResult(result);
				dispose();
			}
		}
		
		/**
		 * On soap service fault.
		 */
		private function onFault(e:Event):void
		{
			if(!completed)
			{
				callComplete();
				var fault:SoapFault=new SoapFault();
				if(!checkForOnFaultCallback())return;
				props.onFault(fault);
				dispose();
			}
		}
		
		/**
		 * Dispose of this SoapCall.
		 */
		override public function dispose():void
		{
			super.dispose();
			//mi.dispose(); //not disposed, this is needed still in SoapService.
			ss=null;
			mi=null;
			loader=null;
			request=null;
			requestXML=null;
		}
	}
}