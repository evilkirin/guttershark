package gs.remoting 
{
	import flash.utils.Dictionary;

	/**
	 * The RemotingService class is a simple wrapper around
	 * sending remoting calls to the same gateway and endpoint.
	 * 
	 * <p>This class spawns RemotingCall instances internally.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.remoting.RemotingCall
	 */
	public class RemotingService 
	{
		
		/**
		 * Internal lookup for remoting service.
		 */
		private static var _rs:Dictionary=new Dictionary(true);
		
		/**
		 * @private
		 * the id.
		 */
		public var id:String;
		
		/**
		 * The gateway.
		 */
		private var gateway:String;
		
		/**
		 * The endpoint.
		 */
		private var endpoint:String;
		
		/**
		 * The timeout.
		 */
		private var timeout:int;
		
		/**
		 * Number of retries.
		 */
		private var retries:int;
		
		/**
		 * AMF Object encoding.
		 */
		private var objectEncoding:int;
		
		/**
		 * The username for credentials.
		 */
		private var user:String;
		
		/**
		 * The password for credentials.
		 */
		private var pass:String;
		
		/**
		 * Get a remoting service.
		 * 
		 * @param id The remoting service id.
		 */
		public static function get(id:String):RemotingService
		{
			if(!id)return null;
			return _rs[id];
		}
		
		/**
		 * Save a remoting service.
		 * 
		 * @param id The remoting service id.
		 * @param rs The remoting service.
		 */
		public static function set(id:String,rs:RemotingService):void
		{
			if(!id||!rs)return;
			if(!rs.id)rs.id=id;
			_rs[id]=rs;
		}
		
		/**
		 * Unset (delete) a remoting service.
		 * 
		 * @param id The remoting service id.
		 */
		public static function unset(id:String):void
		{
			if(!id)return;
			delete _rs[id];
		}
		
		/**
		 * Constructor for RemotingService instances.
		 * 
		 * @param _gateway The remoting gateway.
		 * @param _endpoint The service endpoint.
		 * @param _timeout The time to allow each call.
		 * @param _retries The number of retries to allow.
		 * @param _objectEncoding The amf object encoding.
		 */
		public function RemotingService(_gateway:String,_endpoint:String,_timeout:int=3000,_retries:int=1,_objectEncoding:int=3):void
		{
			gateway=_gateway;
			endpoint=_endpoint;
			timeout=_timeout;
			retries=_retries;
			objectEncoding=_objectEncoding;
		}
		
		/**
		 * Send a method call.
		 * 
		 * <p>The callprops object supports these properties:</p>
		 * 
		 * <ul>
		 * <li>args (Array) - The arguments for the remoting call.</li>
		 * <li>arguments (Array) - The arguments for the remoting call (same as 'args').</li>
		 * <li>timeout (int) - The time to allow each call.</li>
		 * <li>retries (int) - The number of retries to allow.</li>
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
		 * @param method The method to call.
		 * @param args The method arguments.
		 * @param callProps The call properties used for the remoting call.
		 */
		public function send(method:String,callProps:Object):RemotingCall
		{
			var time:int=callProps.timeout||timeout;
			var retry:int=callProps.retries||retries;
			var rc:RemotingCall=new RemotingCall(gateway,endpoint,method,objectEncoding,time,retry,callProps.resultHandler);
			rc.setCredentials(user,pass);
			rc.setCallbacks(callProps);
			if(!callProps.args && !callProps.arguments)callProps.args=[];
			rc.send(callProps.args||callProps.arguments);
			return rc;
		}
		
		/**
		 * Set authentication credentials.
		 * 
		 * @param user The user id.
		 * @param _pass The password.
		 */
		public function setCredentials(_user:String,_pass:String):void
		{
			user=_user;
			pass=_pass;
		}

		/**
		 * Dispose of this remoting service.
		 */
		public function dispose():void
		{
			RemotingService.unset(id);
			id=null;
			pass=null;
			user=null;
			gateway=null;
			endpoint=null;
			timeout=0;
			retries=0;
			objectEncoding=0;
		}
	}
}