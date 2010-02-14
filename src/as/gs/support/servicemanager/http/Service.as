package gs.support.servicemanager.http
{
	import flash.utils.Proxy;
	
	import gs.support.servicemanager.shared.Limiter;	

	/**
	 * The Service class is used to send http requests from the service manager.
	 * This class is used internally, and when using the service manager to
	 * make http calls, you are invariably using this class without realizing it.
	 * Don't use this class directly, use the service manager, this class is strictly
	 * for documentation.
	 * 
	 * <p>When you make a service call from the service manager, and pass it
	 * an object of properties, you are passing it a "callProps" object.</p>
	 * 
	 * <p>Supported properties on the callProps object:</p>
	 * <ul>
	 * <li>data (Object) - Data to submit to the service (post or get).</li>
	 * <li>routes (Array) - An array of "route" paths that get concatenated together.</li>
	 * <li>method (String) - post or get.</li>
	 * <li>file (FileReference) - Upload a file. Attempts and timeouts do not apply when uploading a file. See below for more file upload information.</li>
	 * <li>responseFormat (String) - The response format to expect so casting and parsing can occur - see gs.support.servicemanager.http.ResponseFormat.</li>
	 * <li>onCreate (Function) - A function to call, as soon as a http call instance was created (the request hasn't gone out yet though.).</li>
	 * <li>onResult (Function) - A function to call, and pass a CallResult object to.</li>
	 * <li>onFault (Function) - A function to call, and pass a CallFault object to.</li>
	 * <li>onRetry (Function) - A function to call for every retry of a service.</li>
	 * <li>onTimeout (Function) - A function to call after every retry has been attempted, and no result or fault occured.</li>
	 * <li>attempts (int) - The number of retry attempts allowed.</li>
	 * <li>timeout (int - milliseconds) - The amount of time allowed for each call before another attempt is made.</li>
	 * </ul>
	 * 
	 * <p><strong>Extended file upload info.</strong> If you're upload service returns some data, that data
	 * will be passed to your onResult in a CallResult instance. If no data is returned
	 * from the server, a call result object will <strong>not</strong> be passed to your
	 * onResult, or onFault callbacks.<p>
	 * 
	 * <p><strong><h2>File upload responses.</h2></strong> If you do not send back a response,
	 * the flash client does not fire the complete event. This is problamatic, so make
	 * sure to send at least a variable response like: <code>result=true</code>, this
	 * ensures that the on result handlers will correctly fire.</p>
	 * 
	 * <p>HTTP Service calls support a couple extra features, and, if you follow the rules with the
	 * responses from the server, you can trigger the onFault callback. This is useful
	 * for situations where the server may have returned a 200 OK, but you need
	 * to indicate to the client that it was a faulty operation.</p>
	 * 
	 * <p><strong>For "xml" responses</strong></p>
	 * <p>A successful xml response can be any well formed xml, which will trigger the onResult callback.</p>
	 * <p>To indicate a fault, and call the onFault callback, send an XML structure like this as the response:</p> 
	 * <listing>	
	 * &lt;root&gt;
	 *     &lt;fault&gt;my message&lt;/fault&gt;
	 * &lt;/root&gt;
	 * </listing>
	 * 
	 * <p><strong>Note:</strong> the root node name doesn't matter in this case, it's the <code>fault</code> node that matters</p>
	 * 
	 * <p><strong>For "variable" responses</strong></p>
	 * <p>The response should be a url encoded string like so: (name=asdfasd&email=asdfasd&test=sdfsdf)</p>
	 * <p>To indicate a fault through variables define it like so: (fault=my%20fault%20message).</p>
	 * 
	 * <p>For text or binary response formats, no translation of the response occurs, it's handed
	 * back to you as raw data in either the call result, or call fault.</p>
	 * 
	 * @example Submitting data to a POST service.
	 * <listing>	
	 * import gs.managers.ServiceManager;
	 * import gs.support.serviceamanager.shared.CallResult;
	 * import gs.support.serviceamanager.shared.CallFault;
	 * var sm:ServiceManager = ServiceManager.gi();
	 * sm.createHTTPService("sendEmail","http://localhost/sendEmail.php",3,5000,false);
	 * sm.sendEmail({method:"post",responseFormat:"variables",data:{toEmail:"test&#64;example.com",subject:"Example",message:"Hello World"},onResult:onr,onFault:onf});
	 * function onr(cr:CallResult):void{}
	 * function onf(cf:CallFault):void{}
	 * </listing>
	 * 
	 * @example A file upload, with no upload data response:
	 * <listing>	
	 * import gs.managers.ServiceManager;
	 * var sm:ServiceManager = ServiceManager.gi();
	 * sm.createHTTPService("uploadFile","http://localhost/uploadFile.php");
	 * sm.uploadFile({file:myFileReference,onResult:onr,onFault:onf});
	 * function onr():void{} //no parameter here, as no result data is received.
	 * function onf():void{} //no parameter here, as no result data is received.
	 * </listing>
	 * 
	 * @example A file upload, with file upload response data:
	 * <listing>	
	 * import gs.managers.ServiceManager;
	 * import gs.support.serviceamanager.shared.CallResult;
	 * import gs.support.serviceamanager.shared.CallFault;
	 * var sm:ServiceManager = ServiceManager.gi();
	 * sm.createHTTPService("uploadFile","http://localhost/uploadFile.php");
	 * sm.uploadFile({file:myFileReference,onResult:onr,onFault:onf});
	 * function onr(cr:CallResult):void{} //no parameter here, as no result data is received.
	 * function onf(cf:CallFault):void{} //no parameter here, as no result data is received.
	 * </listing>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class Service extends Proxy
	{
		
		/**
		 * A limiter.
		 */
		private var limiter:Limiter;
		
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
		 * default response format.
		 */
		private var drf:String;
		
		/**
		 * Constructor for Service instances.
		 * 
		 * @param id The id of this service.
		 * @param href The endpoing URL.
		 * @param method The HTTP method. GET/POST.
		 * @param defaultResultFormat The default responses data format.
		 */
		public function Service(url:String,attempts:int=3,timeout:int=1000,limiter:Boolean=false,defaultResponseFormat:String="variables")
		{
			this.url = url;
			this.attempts = attempts;
			this.timeout = timeout;
			this.drf = defaultResponseFormat;
			if(limiter) this.limiter = new Limiter();
		}
		
		/**
		 * Sends a service call, from parameters in the callProps object.
		 * 
		 * @param callProps An Object with keys that control the service call, result handling, timeouts, etc.
		 */
		public function send(callProps:Object):void
		{
			if(!callProps.attempts) callProps.attempts = attempts;
			if(!callProps.timeout) callProps.timeout = timeout;
			if(!callProps.responseFormat) callProps.responseFormat = drf;
			if(!callProps.method) callProps.method = "get";
			var sc:ServiceCall = new ServiceCall(url,callProps);
			if(callProps.onCreate) callProps.onCreate();
			if(callProps.file) sc.uploadFile();
			else sc.execute();
		}
		
		/**
		 * Dispose of this service.
		 */
		public function dispose():void
		{
			limiter = null;
			url = null;
			attempts = 0;
			timeout = 0;
			drf = null;
		}

		/**
		 * Friendly description.
		 */
		public function toString():String
		{
			return "[Service "+this.url+"]";
		}
	}
}
