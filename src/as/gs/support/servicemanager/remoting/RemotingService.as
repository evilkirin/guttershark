package gs.support.servicemanager.remoting
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import gs.support.servicemanager.remoting.RemotingCall;
	import gs.support.servicemanager.remoting.RemotingConnection;
	import gs.support.servicemanager.shared.Limiter;	
	
	/**
	 * The RemotingService class creates and sends remoting requests.
	 * This class is used internally, and when using the service manager to
	 * make remoting calls, you are invariably using this class without realizing it.
	 * Don't use this class directly, use the service manager, this class is strictly
	 * for documentation.
	 * 
	 * <p>When you make a service call from the service manager, and pass it
	 * an object of properties, you are passing it a "callProps" object.</p>
	 * 
	 * <p>Supported properties on the callProps object:</p>
	 * <ul>
	 * <li>params (Array) - The parameters to send to the remoting service.</li>
	 * <li>onCreate (Function) - A function to call, as soon as a remoting call instance was created (the request hasn't gone out yet though.).</li>
	 * <li>onResult (Function) - A function to call, and pass a CallResult object to.</li>
	 * <li>onFault (Function) - A function to call, and pass a CallFault object to.</li>
	 * <li>onRetry (Function) - A function to call for every retry of a service call.</li>
	 * <li>onTimeout (Function) - A function to call after every retry has been attempted, and no result or fault was returned.</li>
	 * <li>attempts (int) - The number of retry attempts allowed.</li>
	 * <li>timeout (int - milliseconds) - The amount of time allowed for each call before another attempt is made.</li>
	 * <li>returnArgs (Boolean) - Return the original <em><code>callprops.params</code></em> sent through the
	 * request as the second parameter to your onResult, or onFault callback</li>
	 * </ul>
	 * 
	 * @example An extended remoting call example, with all callProp object properties filled in:
	 * <listing>	
	 * import gs.managers.ServiceManager;
	 * import gs.support.serviceamanager.shared.CallResult;
	 * import gs.support.serviceamanager.shared.CallFault;
	 * 
	 * var sm:ServiceManager = ServiceManager.gi();
	 * 
	 * //this sets up a remoting service.
	 * sm.createRemotingService("users","http://localhost/amfphp/gateway.php",3,1,3000,true);
	 * 
	 * //make a remoting call.
	 * sm.users.getUserByName({params:["sam"],onResult:onr,onFault:onf,onCreate:onc,onRetry:onrt,onTimeout:ont,attempts:2,timeout:3000,returnArgs:true});
	 * function onr(cr:CallResult,params:Array):void{} //onResult
	 * function onf(cf:CallFault,params:Array):void{} //onFault
	 * function onc():void{} //onCreate
	 * function onrt():void{} //onRetry
	 * function ont:void(){} //onTimeout
	 * </listing>
	 * 
	 * <p>A remoting service supports something called a "limiter" which means
	 * that if a request is being made to a service with X parameters, another
	 * request to that service CANNOT be made until a result,timeout,or fault
	 * occurs on the first call.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	dynamic public class RemotingService extends Proxy
	{
		
		/**
		 * @private
		 * The RemotingConnection.
		 */
		public var rc:RemotingConnection;
		
		/**
		 * @private
		 * A limiter, which get's passed to call instances.
		 */
		public var limiter:Limiter;
		
		/**
		 * The endpoint.
		 */
		private var endpoint:String;
		
		/**
		 * how many attempts.
		 */
		private var attempts:int;
		
		/**
		 * timeout.
		 */
		private var timeout:int;
		
		/**
		 * Constructor for RemotingService instances.
		 * 
		 * @param rc A RemotingConnection that this service will use.
		 * @param endpoint The service endpoint.
		 * @param attempts How many attempts can be made before a timeout occures.
		 * @param timeout The time to allow each request, before retrying.
		 */
		public function RemotingService(rc:RemotingConnection,endpoint:String,attempts:int,timeout:int,limiter:Boolean)
		{
			this.rc=rc;
			this.endpoint=endpoint;
			this.attempts=attempts;
			this.timeout=timeout;
			if(limiter) this.limiter = new Limiter();
		}
		
		/**
		 * This is not the recommended way of using the remoting service, but is available
		 * so you can call service methods where the methd name comes from a string variable.
		 * 
		 * @example Calling a service with the call method:
		 * <listing>	
		 * var sm:ServiceManager = ServiceManager.gi();
		 * 
		 * var tf:TextField = new TextField();
		 * tf.text = "helloWorld";
		 * 
		 * sm.helloWorldService.call(tf.text,{...});
		 * 
		 * //the normal way:
		 * sm.helloWorldService.helloWorld({...});
		 * </listing>
		 */
		public function call(methodName:String, ...args):*
		{
			var callProps:Object = args[0];
			if(!callProps.timeout) callProps.timeout=timeout;
			if(!callProps.attempts) callProps.attempts=attempts;
			if(!callProps.params) callProps.params=[];
			callProps.endpoint=endpoint;
			callProps.method=methodName;
			var rcall:RemotingCall = new RemotingCall(this,callProps);
			if(callProps.onCreate) callProps.onCreate();
			var unique:String=(rc.gateway+endpoint+methodName+callProps.params.toString());
			rcall.id = unique;
			if(limiter)
			{
				if(!limiter.canExecute(unique))
				{
					if(callProps.onLimited) callProps.onLimited();
					return;
				}
				rcall.limiter = limiter;
			}
			rcall.execute();
			return null;
		}
		
		/**
		 * @private
		 * 
		 * sm.user // returns user RemotingService
		 * //sm.user.deleteUser({})
		 * 
		 * callProperty - proxy override (__resolve)
		 */
		flash_proxy override function callProperty(methodName:*, ...args):*
		{
			var callProps:Object = args[0];
			if(!callProps.timeout) callProps.timeout=timeout;
			if(!callProps.attempts) callProps.attempts=attempts;
			if(!callProps.params) callProps.params=[];
			callProps.endpoint=endpoint;
			callProps.method=methodName;
			var rcall:RemotingCall = new RemotingCall(this,callProps);
			if(callProps.onCreate) callProps.onCreate();
			var unique:String=(rc.gateway+endpoint+methodName+callProps.params.toString());
			rcall.id = unique;
			if(limiter)
			{
				if(!limiter.canExecute(unique))
				{
					if(callProps.onLimited) callProps.onLimited();
					return;
				}
				rcall.limiter = limiter;
			}
			rcall.execute();
			return null;
		}
		
		/**
		 * Dispose of this RemotingService.
		 */
		public function dispose():void
		{
			if(limiter) limiter.dispose();
			limiter = null;
			timeout = 0;
			attempts = 0;
			endpoint = null;
		} 
		
		/**
		 * Friendly description.
		 */
		public function toString():String
		{
			return "[RemotingService " + endpoint + "]";
		}
	}
}