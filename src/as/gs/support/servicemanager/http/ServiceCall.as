package gs.support.servicemanager.http
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import gs.support.servicemanager.shared.BaseCall;
	import gs.support.servicemanager.shared.CallFault;
	import gs.support.servicemanager.shared.CallResult;		

	/**
	 * The ServiceCall class makes the http calls that a service class requests.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class ServiceCall extends BaseCall
	{
		
		/**
		 * The url
		 */
		private var url:String;
		
		/**
		 * The loader.
		 */
		private var loader:URLLoader;
		
		/**
		 * A request.
		 */
		private var request:URLRequest;
		
		/**
		 * A file reference, which must be a member variable in
		 * order to fix async issues with responses from files.
		 */
		private var file:FileReference;
		
		/**
		 * the upload data from a file upload.
		 */
		private var uploadDataResponse:*;

		/**
		 * Constructor for ServiceCall instances.
		 */
		public function ServiceCall(url:String,callProps:Object)
		{
			super(callProps);
			this.url = url;
			request = new URLRequest(url);
		}
		
		/**
		 * Executes the service call (for non file uploads).
		 */
		override public function execute():void
		{
			super.execute();
			if(!completed)
			{
				attempts = props.attempts;
				request.method = props.method;
				if(!callTimer)
				{
					callTimer = new Timer(props.timeout,attempts);
					callTimer.addEventListener(TimerEvent.TIMER,onTick,false,0,true);
				}
				if(!loader)
				{
					if(props.routes && props.routes.length > 0)
					{
						var route:String = "";
						for each(var n:String in props.routes) route = route + n + "/";
						request.url += route;
					}
					if(props.data)
					{
						var t:URLVariables = new URLVariables();
						for(var key:String in props.data) t[key] = props.data[key];
						request.data = t;
						if(props.method=="get") request.url += "?";
					}
				}
				tries++;
				if(loader)
				{
					loader.close();
					loader.removeEventListener(Event.COMPLETE, onComplete);
					loader.removeEventListener(IOErrorEvent.IO_ERROR,onError);
				}
				loader = new URLLoader();
				if(!loader.hasEventListener(Event.COMPLETE))
				{
					loader.addEventListener(Event.COMPLETE,onComplete);
					loader.addEventListener(IOErrorEvent.IO_ERROR,onError);
				}
				var rf:String = props.responseFormat;
				if(rf == ResponseFormat.XML) rf = ResponseFormat.TEXT;
				loader.dataFormat = rf;
				if(!callTimer.running) callTimer.start();
				loader.load(request);
			}
		}
		
		/**
		 * Execute this service for file uploads.
		 */
		public function uploadFile():void
		{
			attempts = 1;
			file = props.file;
			request = new URLRequest(url);
			if(!completed)
			{
				if(props.routes && props.routes.length > 0)
				{
					var route:String = "";
					for each(var n:String in props.routes) route = route + n + "/";
					request.url += route;
				}
				if(props.data)
				{
					var t:URLVariables = new URLVariables();
					var k:String;
					for(k in props.data) t[k] = props.data[k];
					request.data = t;
					if(props.method=="get") request.url += "?";
				}
				file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,onUploadCompleteData);
				file.addEventListener(Event.COMPLETE,onFileComplete);
				file.addEventListener(IOErrorEvent.IO_ERROR,onFileIOError);
				if(props.uploadDataFieldName) file.upload(request,props.uploadDataFieldName);
				else file.upload(request);
			}
		}
		
		/**
		 * On io error.
		 */
		private function onFileIOError(ie:IOErrorEvent):void
		{
			completed = true;
			if(props.onFault) props.onFault(new CallFault(ie.text));
		}

		/**
		 * Generic shared on file complete method.
		 */
		private function fileComplete():void
		{
			if(completed)
			{
				dispose();
				return;
			}
			completed = true;
			if(uploadDataResponse) onCompleteSequence(uploadDataResponse);
			else
			{
				onCompleteSequence(null);
				dispose();
			}
		}

		/**
		 * On upload data complete event.
		 */
		private function onUploadCompleteData(de:DataEvent):void
		{
			uploadDataResponse = de.data;
			setTimeout(fileComplete,100);
		}
		
		/**
		 * On file complete.
		 */
		private function onFileComplete(e:Event):void
		{
			setTimeout(fileComplete,300);
		}
		
		/**
		 * on error.
		 */
		private function onError(e:*):void
		{
			if(!completed && !url) return;
			if(completed) return;
			callComplete();
			var fal:CallFault = new CallFault(e);
			if(!checkForOnFaultCallback()) return;
			props.onFault(fal);
			dispose();
		}
		
		/**
		 * on complete of the service call.
		 */
		private function onComplete(e:Event):void
		{
			if(!completed && !url) return;
			if(completed) return;
			callComplete();
			onCompleteSequence(loader.data);
		}
		
		/**
		 * Generic on complete sequence for http / file.
		 */
		private function onCompleteSequence(rawData:*):void
		{
			var res:CallResult;
			var fal:CallFault;
			var nodata:Boolean;
			var emptyres:CallResult = new CallResult();
			if(!rawData) nodata = true;
			if(props.responseFormat == ResponseFormat.VARS)
			{
				if(file) rawData = new URLVariables(rawData);
				if(!nodata && rawData.result)
				{
					res = new CallResult(rawData.result);
					if(rawData.result.toLowerCase() == "true") res.result = true;
					else if(rawData.result.toLowerCase() == "false") res.result = false;
					if(!checkForOnResultCallback()) return;
					props.onResult(res);
				}
				else if(!nodata && rawData.fault)
				{
					fal = new CallFault(rawData.fault);
					fal.fault = rawData.fault;
					if(!checkForOnFaultCallback()) return;
					props.onFault(fal);
				}
				else
				{
					if(nodata) res = emptyres;
					else res = new CallResult(rawData);
					//if(!checkForOnResultCallback()) return;
					props.onResult(res);
				}
			}
			else if(props.responseFormat == ResponseFormat.XML)
			{
				if(rawData)
				{
					var x:XML = new XML(rawData);
					if(x.fault != undefined)
					{
						fal = new CallFault(x.fault.toString());
						if(!checkForOnFaultCallback()) return;
						props.onFault(fal);
					}
					else
					{
						res = new CallResult(x);
						if(!checkForOnResultCallback()) return;
						props.onResult(res);
					}
				}
				else
				{
					res = emptyres;
					if(!checkForOnResultCallback()) return;
					props.onResult(res);
				}
			}
			else if(props.responseFormat == ResponseFormat.TEXT)
			{
				if(rawData) res = new CallResult(rawData);
				else res = emptyres;
				if(!checkForOnResultCallback()) return;
				props.onResult(res);
			}
			else if(props.responseFormat == ResponseFormat.BINARY)
			{
				if(rawData) res = new CallResult(rawData as ByteArray);
				else res = emptyres;
				if(!checkForOnResultCallback()) return;
				props.onResult(res);
			}
			if(!file) dispose();
		}
		
		/**
		 * Dispose of this call.
		 */
		override public function dispose():void
		{
			super.dispose();
			url = null;
			if(loader)
			{
				loader.close();
				loader.removeEventListener(Event.COMPLETE, onComplete);
				loader.removeEventListener(IOErrorEvent.IO_ERROR,onError);
				loader = null;
			}
			if(file)
			{
				uploadDataResponse = null;
				file.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA,onUploadCompleteData);
				file.removeEventListener(Event.COMPLETE,onFileComplete);
				file.removeEventListener(IOErrorEvent.IO_ERROR,onFileIOError);
				file = null;
			}
			request = null;
		}
	}
}