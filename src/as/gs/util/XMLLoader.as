package gs.util
{	

	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	/**
	 * The XMLLoader class loads xml.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class XMLLoader extends EventDispatcher
	{	

		/**
		 * The loader object used for xml loading.
		 */
		public var contentLoader:URLLoader;
		
		/**
		 * The final XML data that has been loaded.
		 */
		private var _data:XML;
		
		/**
		 * Complete handler.
		 */
		private var onComplete:Function;
		
		/**
		 * IOError handler.
		 */
		private var onIOError:Function;
		
		/**
		 * Security error handler.
		 */
		private var onSecurityError:Function;
		
		/**
		 * Constructor for XMLLoader instances.
		 */
		public function XMLLoader()
		{
			contentLoader=new URLLoader();
			contentLoader.addEventListener(Event.COMPLETE,onXMLComplete,false,25);
			contentLoader.addEventListener(IOErrorEvent.DISK_ERROR,_onIOError);
			contentLoader.addEventListener(IOErrorEvent.IO_ERROR,_onIOError);
			contentLoader.addEventListener(IOErrorEvent.NETWORK_ERROR,_onIOError);
			contentLoader.addEventListener(IOErrorEvent.VERIFY_ERROR,_onIOError);
			contentLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,_onSecurityError);
		}
		
		/**
		 * Security error handler.
		 */
		private function _onSecurityError(e:SecurityErrorEvent):void
		{
			if(onSecurityError!=null)onSecurityError();
		}
		
		/**
		 * IOError handler.
		 */
		private function _onIOError(e:IOErrorEvent):void
		{
			if(onIOError!=null)onIOError();
		}
		
		/**
		 * Load an xml file.
		 * 
		 * @example Load an xml file:
		 * <listing>	
		 * import gs.util.XMLLoader;
		 * 
		 * private var xloader:XMLLoader=new XMLLoader();
		 * xloader.contentLoader.addEventListener(Event.COMPLETE,onXMLComplete);
		 * 
		 * public function onXMLComplete(e:Event):void
		 * {
		 *   trace(e.target.data);
		 *   trace(xloader.data);
		 * }
		 * 
		 * xloader.load(new URLRequest(myxmlfile));
		 * </listing>
		 * 
		 * <p>
		 * <b>Example</b><br>
		 * Using callbacks instead of events.
		 * </p>
		 * 
		 * <listing>	
		 * private var xloader:XMLLoader=new XMLLoader();
		 * 
		 * xloader.load(new URLRequest(myxmlfile,onXMLComplete));
		 * 
		 * function onXMLComplete():void
		 * {
		 *     trace(xloader.data);
		 * }
		 * </listing>
		 * 
		 * @param request A URLRequest to the xml file.
		 * @param complete A complete handler function.
		 * @param ioerror An IOError event handler function.
		 * @param securityerror A SecurityErrorEvent handler function.
		 */
		public function load(request:URLRequest,complete:Function=null,ioerror:Function=null,securityerror:Function=null):void
		{
			if(!request)throw new ArgumentError("Parameter {request} cannot be null.");
			onComplete=complete;
			onIOError=ioerror;
			onSecurityError=securityerror;
			contentLoader.dataFormat=URLLoaderDataFormat.TEXT;
			contentLoader.load(request);
		}
		
		/**
		 * Close the internal loader instance.
		 */
		public function close():void
		{
			contentLoader.close();
		}
		
		/**
		 * The final XML data that has been loaded.
		 */
		public function get data():XML
		{
			return _data;
		}
		
		/**
		 * Dispose of this xml loader.
		 */
		public function dispose():void
		{
			contentLoader.removeEventListener(Event.COMPLETE, onXMLComplete);
			contentLoader.removeEventListener(IOErrorEvent.DISK_ERROR,_onIOError);
			contentLoader.removeEventListener(IOErrorEvent.IO_ERROR,_onIOError);
			contentLoader.removeEventListener(IOErrorEvent.NETWORK_ERROR,_onIOError);
			contentLoader.removeEventListener(IOErrorEvent.VERIFY_ERROR,_onIOError);
			contentLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,_onSecurityError);
			contentLoader.close();
			contentLoader=null;
			_data=null;
		}
		
		/**
		 * on xml complete loading.
		 */
		private function onXMLComplete(e:Event):void
		{
			_data=XML(e.target.data);
			if(onComplete!=null)onComplete();
		}
	}
}