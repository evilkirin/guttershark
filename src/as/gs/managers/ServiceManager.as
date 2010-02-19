package gs.managers
{
	import gs.core.Model;
	import gs.support.servicemanager.http.Service;
	import gs.support.servicemanager.remoting.RemotingConnection;
	import gs.support.servicemanager.remoting.RemotingService;
	import gs.support.servicemanager.soap.SoapService;

	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	/**
	 * The ServiceManager simplifies remoting, http and soap
	 * requests with support for retries, timeouts, and some features that
	 * are specific to one or the other.
	 * 
	 * @example A basic remoting request example.
	 * <listing>	
	 * import gs.managers.ServiceManager;
	 * import gs.support.servicemanager.shared.CallResult;
	 * import gs.support.servicemanager.shared.CallFault;
	 * 
	 * var sm:ServiceManager=ServiceManager.gi();
	 * 
	 * sm.createRemotingService("users","http://localhost/amfphp/gateway.php",3,1,3000,true);
	 * 
	 * //make a remoting call.
	 * sm.users.getAllUsers({onResult:onr,onFault:onf});
	 * function onr(cr:CallResult):void{}
	 * function onf(cf:CallFault):void{}
	 * </listing>
	 * 
	 * @example A basic http request example:
	 * <listing>	
	 * import gs.managers.ServiceManager;
	 * import gs.support.serviceamanager.shared.CallResult;
	 * import gs.support.serviceamanager.shared.CallFault;
	 * var sm:ServiceManager=ServiceManager.gi();
	 * sm.createHTTPService("codeigniter","http://localhost/codeigniter/index.php/",3,3000,false,"variables");
	 * sm.codeigniter({routes:["user","name"],onResult:onr,onFault:onf}); // -> http://localhost/codeigniter/index.php/user/name
	 * </listing>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.support.servicemanager.http.Service
	 * @see gs.support.servicemanager.remoting.RemotingService
	 * @see gs.support.servicemanager.soap.SoapService
	 */
	final public dynamic class ServiceManager extends Proxy
	{
				
		/**
		 * Stored services.
		 */
		private var services:Dictionary;
		
		/**
		 * Service manager instances.
		 */
		private static var _sms:Dictionary = new Dictionary(true);
		
		/**
		 * RemotingConnections that can be re-used for a service that connects
		 * to the same gateway.
		 */
		private var rcp:Dictionary;
		
		/**
		 * @private
		 */
		public var id:String;
		
		/**
		 * Constructor for ServiceManager instances.
		 */
		public function ServiceManager()
		{
			services=new Dictionary();
			rcp=new Dictionary();
		}
		
		/**
		 * Get a service manager instance.
		 * 
		 * @param id The service manager id.
		 */
		public static function get(id:String):ServiceManager
		{
			if(!id)
			{
				trace("WARNING: Parameter {id} was null, returning null.");
				return null;
			}
			return _sms[id];
		}
		
		/**
		 * Set a service manager instance.
		 * 
		 * @param id The id of the service manager instance.
		 * @param sm A service manager instance.
		 */
		public static function set(id:String,sm:ServiceManager):void
		{
			if(!id || !sm)return;
			_sms[id]=sm;
		}
		
		/**
		 * Unset (delete) a service manager.
		 * 
		 * @param id The id of the service manager.
		 */
		public static function unset(id:String):void
		{
			if(!id)return;
			delete _sms[id];
		}
		
		/**
		 * Initialize this ServiceManager from a model and xml.
		 * 
		 * <p>You should read the Model documentation for an example
		 * of services xml</p>
		 * 
		 * @param ml A model instance.
		 * @param xml The services xml.
		 */
		public function initFromXML(ml:Model,xml:XMLList):void
		{
			var children:XMLList=xml.service;
			var oe:int=3;
			var gateway:String;
			var attempts:int=1;
			var timeout:int=10000;
			var limiter:Boolean=false;
			var url:String;
			var drf:String;
			for each(var s:XML in children)
			{
				if(s.@attempts != undefined)attempts=int(s.@attempts);
				if(s.@timeout != undefined)timeout=int(s.@timeout);
				if(s.@limiter != undefined && s.@limiter=="true")limiter=true;
				if(s.@gateway != undefined)
				{
					var r:XMLList=xml.gateway.(@id == s.@gateway);
					var username:String;
					var password:String;
					if(!r) throw new Error("Gateway {"+s.@gateway+"} not found.");
					if(r.@password !=undefined && (r.@username != undefined || r.@userid !=undefined))
					{
						username=(r.@username!=undefined) ? r.@username : r.@userid;
						password=r.@password;
					}
					if(r.@url!=undefined)gateway=r.@url;
					else if(r.@path!=undefined&&ml.isPathDefined(r.@path.toString()))gateway=ml.getPath(r.@path.toString());
					if(!gateway) throw new Error("Gateway not found, you must have a url or path attribute defined on the gateway node.");
					if(r.@objectEncoding!=undefined) oe=int(r.@objectEncoding);
					if(oe != 3 && oe != 0) throw new Error("ObjectEncoding can only be 0 or 3.");
					createRemotingService(s.@id,gateway,s.@endpoint,oe,attempts,timeout,limiter,true,username,password);
				}
				else if(s.@wsdl!=undefined)
				{
					var wsdlID:String=s.@wsdl;
					var wsdl:* =xml.wsdl.(@id==wsdlID);
					createSOAPService(wsdl.@id,wsdl.@endpoint,int(wsdl.@attempts),int(wsdl.@timeout));
				}
				else
				{
					if(s.@url != undefined)url=s.@url;
					else if(s.@path!=undefined&&ml.isPathDefined(s.@path.toString()))url=ml.getPath(s.@path.toString());
					if(s.@responseFormat != undefined) drf=s.@responseFormat;
					if(drf != null && drf != "variables" && drf != "xml" && drf != "text" && drf != "binary") throw new Error("The defined response format is not supported, only xml|text|binary|variables is supported.");
					createHTTPService(s.@id, url, attempts, timeout, limiter, drf);
				}
			}
		}
		
		/**
		 * Creates a new remoting service internally that you can access as a property on the service manager instance.
		 * 
		 * @param id The id for the service - you can access the service dyanmically as well, like serviceManager.{id}.
		 * @param gateway The gateway url for the remoting server.
		 * @param endpoint The service endpoint, IE: com.test.Users.
		 * @param objectEncoding The object encoding, 0 or 3.
		 * @param attempts The number of attempts that will be allowed for each service call - this sets the default, but can be overwritten by a callProps object.
		 * @param timeout The time allowed for each call, before making another attempt.
		 * @param limiter Use a call limiter.
		 * @param username A username to supply for a credentials header.
		 * @param password A password to supply for a credentals header.
		 */
		public function createRemotingService(id:String,gateway:String,endpoint:String,objectEncoding:int,attempts:int=1,timeout:int=10000,limiter:Boolean=false,overwriteIfExists:Boolean=true,username:String=null,password:String=null):void
		{
			if(services[id]&&!overwriteIfExists)return;
			var rc:RemotingConnection;
			if(rcp[gateway])rc=rcp[gateway];
			else rc=rcp[gateway]=new RemotingConnection(gateway,objectEncoding);
			if(username&&password)rc.setCredentials(username,password);
			if(services[id]&&overwriteIfExists)services[id].dispose();
			services[id]=new RemotingService(rc,endpoint,attempts,timeout,limiter);
		}
		
		/**
		 * Creates a new http service internally that you can access as a property on the service manager instance.
		 * 
		 * @param id The id for the service - you can access the service dyanmically as well, like serviceManager.{id}.
		 * @param url The http url for the service.
		 * @param attempts The number of attempts that will be allowed for each service call - this sets the default, but can be overwritten by a callProps object.
		 * @param timeout The time allowed for each call, before making another attempt.
		 * @param limiter Use a call limiter. (currently not available for HTTP, but plans to add in, in the future.)
		 * @param defaultResponseFormat	The default response format ("variables","xml","text","binary"), see gs.support.servicemanager.http.ResponseFormat.
		 */
		public function createHTTPService(id:String, url:String, attempts:int=1, timeout:int=10000, limiter:Boolean=false, defaultResponseFormat:String="variables"):void
		{
			if(services[id]) return;
			var s:Service=new Service(url,attempts,timeout,limiter,defaultResponseFormat);
			services[id]=s;
		}
		
		/**
		 * Creates a new soap service internally that you can access as a property on the service manager instance.
		 * 
		 * @param id The service id.
		 * @param url The soap wsdl endpoint.
		 * @param attempts The number of attemptes that will be allowed for each service call - this sets the default, but can be overwritten by a callProps object.
		 * @param timeout THe time allowed for each call, before making another attempt.
		 */
		public function createSOAPService(id:String,url:String,attempts:int=1,timeout:int=1000):void
		{
			if(services[id]) return;
			var s:SoapService=new SoapService(url,attempts,timeout);
			services[id]=s;
		}
		
		/**
		 * Get's a service from the internal dictionary of services.
		 * 
		 * <p>This is only intended to be used when you need to get a service
		 * defined by a variable, and not a hard coded property on the service manager.</p>
		 * 
		 * @example Intended use for this method:
		 * <listing>	
		 * var sm:ServiceManager=ServiceManager.gi();
		 * sm.createRemotingService("amfphp","http://localhost/amfphp/gateway.php","HelloWorld");
		 * 
		 * //only intended for use when a variable decides the service it will use.
		 * var a:String="amfphp";
		 * trace(sm.getService(a)); //return amfphp service.
		 * 
		 * //the default, recommended way
		 * trace(sm.amfphp); //returns amfphp service.
		 * </listing>
		 * 
		 * @param id The service id.
		 */
		public function getService(id:String):*
		{
			if(!services[id]) throw new Error("Service {"+id+"} does not exist.");
			return services[id];
		}
		
		/**
		 * Check whether or not a service has been created.
		 * 
		 * @param id The service id to check for.
		 */
		public function serviceExist(id:String):Boolean
		{
			return !(services[id]==null);
		}
		
		/**
		 * Dispose of a service.
		 *
		 * @param id The service id.
		 */
		public function disposeService(id:String):void
		{
			if(!services[id]) return;
			services[id].dispose();
			services[id]=null;
		}
		
		/**
		 * Dispose of this service manager.
		 */
		public function dispose():void
		{
			ServiceManager.unset(id);
			services=null;
		}
			
		/**
		 * @private
		 * 
		 * getProperty - override getters to return null always.
		 */
		flash_proxy override function getProperty(name:*):*
		{
			if(services[name]) return services[name];
			else throw new Error("Service {"+name+"} not available");
		}
		
		/**
		 * @private
		 */
		flash_proxy override function callProperty(methodName:*, ...args):*
		{
			if(!services[methodName]) throw new Error("Service {"+methodName+"} not found.");
			if(services[methodName] is RemotingService) throw new Error("RemotingService cannot be called this way. Please see the documentation in ServiceManager.");
			var callProps:Object=args[0];
			services[methodName].send(callProps);
		}
	}
}