package gs.remoting
{
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * The RemotingCall class simplifies making remoting calls.
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class RemotingCall
	{
		
		/**
		 * Internal lookup for remoting calls.
		 */
		private static var _rcs:Dictionary = new Dictionary(true);
		
		/**
		 * Internal gateway lookup.
		 */
		private static var _gas:Dictionary = new Dictionary(false);
		
		/**
		 * @private
		 * id for this call.
		 */
		public var id:String;
		
		/**
		 * On result callback.
		 */
		public var onResult:Function;
		
		/**
		 * On fault callback.
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
		 * The last status event that was dispatched off of
		 * the internal net connection.
		 */
		public var statusEvent:NetStatusEvent;
		
		/**
		 * On connection callback.
		 */
		public var onConnect:Function;
		
		/**
		 * On connect failed callback.
		 */
		public var onConnectFailed:Function;
		
		/**
		 * On closed callback.
		 */
		public var onClosed:Function;
		
		/**
		 * On io error event callback.
		 */
		public var onIOError:Function;
		
		/**
		 * On security error callback.
		 */
		public var onSecurityError:Function;
		
		/**
		 * On bad version callback.
		 */
		public var onBadVersion:Function;
		
		/**
		 * On prohibited callback.
		 */
		public var onProhibited:Function;
		
		/**
		 * Net connection for the remoting call.
		 */
		public var connection:NetConnection;
		
		/**
		 * The remoting gateway.
		 */
		public var gateway:String;
		
		/**
		 * The service endpoint.
		 */
		public var endpoint:String;
		
		/**
		 * The service method.
		 */
		public var method:String;
		
		/**
		 * The time to allow for each call before another
		 * retry is sent (default is 3000, 3 seconds).
		 */
		public var timeout:int;
		
		/**
		 * The number of retries to allow (default is 1).
		 */
		public var retries:int;
		
		/**
		 * Whether or not to return the args back to your onResult or
		 * onFault callback.
		 */
		public var returnArgs:Boolean;
		
		/**
		 * The handler class that processes the returned result - this
		 * should be an instance or subclass of RemotingCallResultHandler.
		 */
		public var resultHandler:Class;
		
		/**
		 * The handler for when you close this call
		 * by calling close().
		 */
		public var onClose:Function;
		
		/**
		 * Arguments to send to the method.
		 */
		private var args:Array;
		
		/**
		 * Whether or not this call is complete.
		 */
		private var complete:Boolean;
		
		/**
		 * Whether or not the call has sent.
		 */
		private var sent:Boolean;
		
		/**
		 * How many tries have occured.
		 */
		private var tries:int;
		
		/**
		 * Timeout interval id.
		 */
		private var timeoutid:Number;
		
		/**
		 * Connection timeout id.
		 */
		private var connectTimeoutId:Number;
		
		/**
		 * Whether or not the connect method has called.
		 */
		private var connected:Boolean;
		
		/**
		 * Save a gateway by name.
		 * 
		 * <p>If you save a gateway you can use the shortcut name when
		 * creating new RemotingCall instances.</p>
		 * 
		 * @example Saving gateways.
		 * <listing>	
		 * RemotingCall.setGateway("amfphp","http://guttershark_amfphp/gateway.php");
		 * var rc:RemotingConnection = new RemotingConnection("amfphp","Echoer","echoString");
		 * 
		 * //if you don't save the gateway, you have to provide the gateway url like this:
		 * var rc:RemotingConnection = new RemotingConnection("http://guttershark_amfphp/gateway.php","Echoer","echoString");
		 * </listing>
		 * 
		 * @param name The shortcut name for the gateway (something like amfphp).
		 * @param url The gateay url.
		 */
		public static function setGateway(name:String,url:String):void
		{
			_gas[name]=url;
		}
		
		/**
		 * Get a remoting call.
		 * 
		 * @param id The remoting call id.
		 */
		public static function get(id:String):RemotingCall
		{
			if(!id)return null;
			return _rcs[id];
		}
		
		/**
		 * Set a remoting call instance.
		 * 
		 * @param id The remoting call id.
		 * @param rc The remoting call instance.
		 */
		public static function set(id:String,rc:RemotingCall):void
		{
			if(!id||!rc)return;
			if(!rc.id)rc.id=id;
			_rcs[id]=rc;
		}
		
		/**
		 * Unset (delete) a remoting call instance.
		 * 
		 * @param id The remoting call id.
		 */
		public static function unset(id:String):void
		{
			if(!id)return;
			RemotingCall(_rcs[id]).id=null;
			delete _rcs[id];
		}
		
		/**
		 * Constructor for RemotingCall instances.
		 * 
		 * @param _gateway The remoting gateway url.
		 * @param _endpoint The endpoint.
		 * @param _method The method to call.
		 * @param _timeout The timeout for this call.
		 * @param _retryes The number of retries for this call.
		 * @param _resultHandler A result handler class to process result or fault objects before
		 * passing it back to your onResult or onFault callback.
		 */
		public function RemotingCall(_gateway:String,_endpoint:String,_method:String,_objectEncoding:int=3,_timeout:int=3000,_retries:int=1,_resultHandler:Class=null):void
		{
			resultHandler=_resultHandler;
			if(resultHandler==null)resultHandler=RemotingCallResultHandler;
			if(_gas[_gateway])_gateway=_gas[_gateway];
			gateway=_gateway;
			timeout=_timeout;
			retries=_retries;
			endpoint=_endpoint;
			method=_method;
			complete=false;
			sent=false;
			tries=0;
			connection=new NetConnection();
			connection.objectEncoding=_objectEncoding;
			connection.addEventListener(NetStatusEvent.NET_STATUS,_status);
			connection.addEventListener(IOErrorEvent.DISK_ERROR,_ioerror);
			connection.addEventListener(IOErrorEvent.IO_ERROR,_ioerror);
			connection.addEventListener(IOErrorEvent.NETWORK_ERROR,_ioerror);
			connection.addEventListener(IOErrorEvent.VERIFY_ERROR,_ioerror);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,_securityError);
		}
		
		/**
		 * Add a credentials header.
		 * 
		 * @param username The username.
		 * @param password The password.
		 */
		public function setCredentials(username:String,password:String):void
		{
			connection.addHeader("Credentials",false,{userid:username,password:password});
		}
		
		/**
		 * Send the call.
		 * 
		 * @param _service The remoting servie to send the call to.
		 * @param _args The arguments for the call.
		 */
		public function send(..._args):void
		{
			if(!connected)connection.connect(gateway);
			if(sent)return;
			complete=false;
			tries=0;
			args=_args;
			setTimeout(execute,0);
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
		 * <li>onConnectFailed (Function) - The callback for failed connections.</li>
		 * <li>onBadVersion (Function) - The on bad version callback.</li>
		 * <li>onClosed (Function) - The closed connection callback.</li>
		 * <li>onSecurityError (Function) - The on security error callback.</li>
		 * <li>onIOError (Function) - The on io error callback.</li>
		 * </ul>
		 * 
		 * @param callbacks An object with properties for callbacks you
		 * want.
		 */
		public function setCallbacks(callbacks:Object):void
		{
			if(!callbacks)return;
			onResult=callbacks.onResult;
			onFault=callbacks.onFault;
			onTimeout=callbacks.onTimeout;
			onRetry=callbacks.onRetry;
			onFirstCall=callbacks.onFirstCall;
			onConnectFailed=callbacks.onConnectFailed;
			onBadVersion=callbacks.onBadVersion;
			onClosed=callbacks.onClosed;
			onProhibited=callbacks.onProhibited;
			onSecurityError=callbacks.onSecurityError;
			onClose=callbacks.onClose;
		}
		
		/**
		 * Closes the internal net connection and cancels
		 * the request.
		 */
		public function close():void
		{
			try{if(connection)connection.close();}catch(e:*){}
			sent=false;
			complete=true;
			tries=0;
			if(onClose!=null)onClose();
		}

		/**
		 * On io error.
		 */
		private function _ioerror(event:ErrorEvent):void
		{
			sent=false;
			complete=true;
			if(onIOError!=null)onIOError();
			else trace("WARNING: An IOError occured but the onIOError callback is not set.");
			if(onConnectFailed!=null)onConnectFailed();
			else trace("WARNING: The connection failed but the onConnectFail callback is not set.");
			connection.close();
			connection=null;
		}
		
		/**
		 * On security error.
		 */
		private function _securityError(event:SecurityErrorEvent):void
		{
			sent=false;
			complete=true;
			if(onSecurityError!=null)onSecurityError();
			else trace("WARNING: A security error occured but the onSecurityError callback is not set.");
			connection.close();
			connection=null;
		}
		
		/**
		 * onConnectionStatus
		 */
		private function _status(event:NetStatusEvent):void
		{
			statusEvent=event;
			switch(event.info.code)
			{
				case "NetConnection.Connect.Success":
					clearTimeout(connectTimeoutId);
					if(onConnect!=null)onConnect();
					else trace("WARNING: The connection was successful but the onConnect callback is not set.");
					break;
				case "NetConnection.Connect.Failed":
					sent=false;
					complete=true;
					clearTimeout(connectTimeoutId);
					if(onConnectFailed!=null)onConnectFailed();
					else trace("WARNING: The connection failed but the onConnectFail callback is not set.");
					break;
				case "NetConnection.Call.BadVersion":
					sent=false;
					complete=true;
					clearTimeout(connectTimeoutId);
					clearTimeout(timeoutid);
					if(onBadVersion!=null)onBadVersion();
					else trace("WARNING: Received a BadVersion error but the onBadVersion callback is not set.");
					var msg:String = "NetConnection.Call.BadVersion Error.";
					msg+=" Usually this indicates that there's an unhandled exception on the server.";
					msg+=" You won't be able to see what the exception is from Flash.";
					msg+=" You'll need to check the logs for server errors.";
					trace(msg);
					break;
				case "NetConnection.Call.Prohibited":
					sent=false;
					complete=true;
					clearTimeout(connectTimeoutId);
					clearTimeout(timeoutid);
					if(onProhibited!=null)onProhibited();
					else trace("WARNING: Received a probibited error but the onProhibited callback is not set.");
					break;
				case "NetConnection.Connect.Closed":
					sent=false;
					complete=true;
					clearTimeout(connectTimeoutId);
					clearTimeout(timeoutid);
					if(onClosed!=null)onClosed();
					else trace("WARNING: The connection closed but the onClosed callback is not set.");
					break;
				case "NetConnection.Call.Failed":
					sent=false;
					complete=true;
					clearTimeout(connectTimeoutId);
					clearTimeout(timeoutid);
					if(onConnectFailed!=null)onConnectFailed();
					else trace("WARNING: The connection failed but the onConnectFail callback is not set.");
					break;
				default:
					trace("Unknown Status Event {" + event.info.code + "}");
					break;
			}
		}
		
		/**
		 * Does the real sending work.
		 */
		private function execute():void
		{
			if(complete)return;
			if(tries==0 && onFirstCall!=null)onFirstCall();
			if(tries>retries && onTimeout!=null)
			{
				onTimeout();
				return;
			}
			else if(tries>retries)
			{
				complete=true;
				return;
			}
			else if(tries>0&&onRetry!=null)onRetry();
			sent=true;
			tries++;
			var operation:String=endpoint+"."+method;
			var responder:Responder=new Responder(_result,_fault);
			var callArgs:Array=new Array(operation,responder);
			if(timeout<50)timeout=1500;
			clearTimeout(timeoutid);
			timeoutid=setTimeout(_timeout,timeout);
			connection.call.apply(null,callArgs.concat(args));
		}
		
		/**
		 * On result.
		 */
		private function _result(val:Object):void
		{
			complete=true;
			clearInterval(timeoutid);
			var handler:* =new resultHandler();
			var res:* =handler.process(val);
			if(res is RemotingCallFault)
			{
				if(onFault==null)return;
				(returnArgs && args && args.length > 0) ? onFault(res,args) : onFault(res);
				return;
			}
			else if(res is RemotingCallResult)
			{
				if(onResult==null)return;
				(returnArgs && args && args.length > 0) ? onResult(res,args) : onResult(res);
			}
		}
		
		/**
		 * On fault.
		 */
		private function _fault(val:Object):void
		{
			complete=true;
			clearInterval(timeoutid);
			var handler:* =new resultHandler();
			var res:* =handler.process(val,true);
			if(onFault==null)return;
			(returnArgs && args && args.length > 0) ? onFault(res,args) : onFault(res);
		}
		
		/**
		 * Timeout closure.
		 */
		private function _timeout():void
		{
			if(complete)return;
			execute();
		}
	}
}