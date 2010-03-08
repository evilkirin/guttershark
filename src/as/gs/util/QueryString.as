package gs.util
{
	import flash.external.*;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	/**
	 * The QueryString class reads query string parameters in the web browsers address bar.
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	dynamic public class QueryString extends Proxy
	{
		
		/**
		 * Cached parameters
		 */
		private var paramsCache:Dictionary;
		
		/**
		 * Constructor for QueryString instances.
		 */
		public function QueryString()
		{
			paramsCache=new Dictionary(true);
			readParams();
		}
		
		/**
		 * Read all parameters. Returns an associative array with each parameters.
		 * Parameters are cached after 1 execution. You can force a re-read.
		 * 
		 * <p><strong>This method will return <code>null</code> if you are running the flash file as a
		 * standalone, or in the Flash IDE.</strong></p>
		 */
		private function readParams():void
		{
			if(!ExternalInterface.available)return;
			var qs:String;
			var splits:Array;
			if(Capabilities.playerType == "Standalone" || Capabilities.playerType == "External") return;
			qs=ExternalInterface.call("window.location.search.substring",1);
			if(qs)
			{
				if(qs.indexOf("&") < 0 && qs.indexOf("=") < 0) return;
				if(qs.indexOf("&") < 0 && qs.indexOf("=") > -1)
				{
					splits=qs.split("=");
					paramsCache[splits[0]]=splits[1];
					return;
				}
				splits=qs.split("&");
				var kvpair:Array;
				var i:int=0;
				var l:int=splits.length;
				for(;i<l;i++)
				{
					kvpair=splits[int(i)].split("=");
					paramsCache[kvpair[0]]=kvpair[1];
				}
			}
		}
		
		/**
		 * Set your own hard coded querystring data.
		 */
		public function set querystringData(data:Dictionary):void
		{
			if(!data)throw new ArgumentError("Parameter data cannot be null");
			paramsCache=data;
		}
		
		/**
		 * Get a querystring parameter.
		 */
		flash_proxy override function getProperty(name:*):*
		{
			if(paramsCache[String(name)])return paramsCache[String(name)];
			return null;
		}
		
		/**
		 * Set a querystring parameter.
		 */
		flash_proxy override function setProperty(name:*,value:*):void
		{
			paramsCache[String(name)]=value;
		}
		
		/**
		 * Dispose of this querystring.
		 */
		public function dispose():void
		{
			paramsCache=null;
		}
	}
}