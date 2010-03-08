package gs.util 
{
	
	/**
	 * The URLUtils class contains utility methods for
	 * working with urls.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class URLUtils 
	{
		
		private static var defaultPorts:Object = {
			http:80,rtmp:1935,rtmpt:80,rtmps:443
		};
		
		/**
		 * Default lookup method for a default port by protocol
		 */
		private static function getDefaultPort(protocol:String):int
		{
			return defaultPorts[protocol.toLowerCase()]||0;
		}
		
		/**
		 * Get the port number.
		 * 
		 * @param url The url.
		 */
		public static function getPort(url:String):int
		{
			var tmp:int=url.indexOf('://');
			if(tmp ==-1)return 0;
			var startIndex:int = url.indexOf(':', tmp + 3) + 1;
			return parseInt(url.substr(startIndex))||getDefaultPort(getProtocol(url));
		}
		
		/**
		 * Converts a potentially relative URL to a full qualified URL.
		 * 
		 * <p>If the URL is not relative, it is just returned as is. If the URL starts
		 * with a slash, the host and port from the root URL are prepended.
		 * Otherwise, the host, port, and path are prepended.</p>
		 */
		public static function getFullURL(rootURL:String,url:String):String
		{
			if(!rootURL)return url;
			else if(url.indexOf('://') != -1)return url;
			else
			{
				rootURL=rootURL.lastIndexOf('/')==rootURL.length-1?rootURL:rootURL+'/';
				if(url.charAt(0)=='/')
				{
					var tmp:int=rootURL.indexOf('://');
					if(tmp==-1) return url;
					var slashIndex:int=rootURL.indexOf('/',tmp+3);
					slashIndex=slashIndex==-1?rootURL.length:slashIndex;
					return rootURL.substr(0,slashIndex)+'/'+url.substr(1);
				}
				else return rootURL+url;
			}
			throw new ArgumentError('Unable to resolve URL');
		}
		
		/**
		 * Get the protocol from a url.
		 * 
		 * @param url The url.
		 */
		public static function getProtocol(url:String):String
		{
			var endIndex:uint=url.indexOf(':/');
			if(endIndex==-1)return '';
			return url.substr(0,endIndex);
		}
		
		/**
		 * Get the server name out of a url.
		 * 
		 * @param url The url.
		 */
		public static function getServerName(url:String):String
		{
			var tmp:int=url.indexOf('://');
			if(tmp==-1)return '';
			var colonIndex:int=url.indexOf(':',tmp+3);
			var slashIndex:int=url.indexOf('/',tmp+3);
			var endIndex:int=Math.min(colonIndex==-1?url.length:colonIndex,slashIndex==-1?url.length:slashIndex);
			return url.substring(tmp+3,endIndex);
		}
		
		/**
		 * Get the server name and port from a url.
		 * 
		 * @param url The url.
		 */
		public static function getServerNameWithPort(url:String):String
		{
			var tmp:int=url.indexOf('://');
			if (tmp==-1) return '';
			var slashIndex:int=url.indexOf('/', tmp + 3);
			return url.substring(tmp+3,slashIndex==-1?url.length:slashIndex);
		}
		
		/**
		 * Whether or not the url is https.
		 * 
		 * @param url The url.
		 */
		public static function isHTTPS(url:String):Boolean
		{
			return url.indexOf('https://')==0;
		}
		
		/**
		 * Whether or not a url is http.
		 * 
		 * @param url The url.
		 */
		public static function isHTTP(url:String):Boolean
		{
			switch(url.substr(url.indexOf('://')))
			{
				case 'http':
				case 'https':
				case 'rtmp':
					return true;
			}
			return false;
		}
	}
}