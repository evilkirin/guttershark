package gs.util.akamai
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import gs.util.XMLLoader;

	/**
	 * The Ident class is used for pinging an Akamai Ident service to determine
	 * the best IP to use for a Flash Media Server on the Akamai network. The Ident
	 * service returns an XML file with an IP address in it.
	 * 
	 * <p>Ident services take geographical positions into account and returns 
	 * the best IP address to use for a Flash Media Server on Akamai's network.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class Ident
	{

		/**
		 * The IP address that was found from the Akamai Ident Service.
		 */
		public var ip:String;
		
		/**
		 * XML Loader.
		 */
		private var _contentLoader:XMLLoader;
		
		/**
		 * Constructor for Ident instances.
		 */
		public function Ident()
		{
			_contentLoader=new XMLLoader();
			_contentLoader.contentLoader.addEventListener(Event.COMPLETE,onxml,false,11,false);
		}
		
		/**
		 * Find the best IP for an Akamai Application.
		 * 
		 * @param akamaiURI Your akamai application URI. 
		 * 
		 * @example Using Ident:
		 * <listing>	
		 * import gdkit.akamai.AkamaiNCManager;
		 * import gdkit.akamai.Ident;
		 * import flash.events.Event;
		 * var i:Ident=new Ident();
		 * i.contentLoader.addEventListener(Event.COMPLETE, onc);
		 * function onc(e:Event):void
		 * {
		 *    trace(e.target.data.ip);
		 *    trace(i.ip);
		 *    AkamaiNCManager.FMS_IP=i.ip;
		 * }
		 * i.findBestIPForAkamaiApplication("http://cp44952.edgefcs.net/");
		 * </listing>
		 */
		public function findBestIPForAkamaiApplication(akamaiAppURL:String):void
		{
			//matches one of these:
			//http://cp44952.edgefcs.net/
			//http://cp44952.edgefcs.net
			//https://cp44952.edgefcs.net/
			//https://cp44952.edgefcs.net
			var reg:RegExp=new RegExp("^https?\://cp[0-9]{1,9}\.edgefcs\.net/?$","i");
			if(!akamaiAppURL) throw new Error("The Akamai host cannot be null");
			if(!akamaiAppURL.match(reg)) throw new Error("The supplied Akamai Application URL is not correctly formatted. Here is a RegExp that demonstrates how to format it: ^https?\://cp[0-9]{1,9}\.edgefcs\.net/?$");
			_contentLoader.load(new URLRequest(akamaiAppURL + "/fcs/ident/"));
		}
		
		/**
		 * on xml load.
		 */
		private function onxml(e:Event):void
		{
			_contentLoader.contentLoader.removeEventListener(Event.COMPLETE, onxml);
			this.ip=XML(e.target.data).ip.toString();
		}
		
		/**
		 * Dispose of this Ident instance.
		 */
		public function dispose():void
		{
			if(!ip) _contentLoader.contentLoader.removeEventListener(Event.COMPLETE, onxml);
			_contentLoader=null;
			ip=null;
		}
		
		/**
		 * The loader used to load XML from the Akamai ident service.
		 */
		public function get contentLoader():URLLoader
		{
			return _contentLoader.contentLoader;
		}
	}
}
