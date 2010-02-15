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
	 * @example Using the QueryString class when the swf is in a browser:
	 * <listing>	
	 * var qs:QueryString=new QueryString();
	 * trace(qs.myQueryStringVariable);
	 * trace(qs.section);
	 * trace(qs.videoID);
	 * </listing>
	 * 
	 * <p>You can also fake querystring parameters if needed (probably for testing).</p>
	 * 
	 * @example Using the QueryString class outside of a browser:
	 * <listing>	
	 * var qs:QueryString=new QueryString();
	 * var fakeQS:Dictionary=new Dictionary();
	 * fakeQS['videoID']=100;
	 * qs.querystringData=fakeQS;
	 * trace(qs.videoID);
	 * </listing>
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
		 * Whether or not the params were read yet.
		 */
		private var read:Boolean;
		
		/**
		 * Read all parameters. Returns an associative array with each parameters.
		 * Parameters are cached after 1 execution. You can force a re-read.
		 * 
		 * <p><strong>This method will return <code>null</code> if you are running the flash file as a
		 * standalone, or in the Flash IDE.</strong></p>
		 */
		private function readParams():void
		{
			var _params:Dictionary=new Dictionary(true);
			var _queryString:String;
			if(Capabilities.playerType == "Standalone" || Capabilities.playerType == "External") return;
			_queryString=ExternalInterface.call("window.location.search.substring", 1);
			if(_queryString)
			{
				var params:Array=_queryString.split('&');
				var i:int=0;
				var index:int=-1;
				var l:int=params.length;
				for(;i<l;i++)
				{
					var kvPair:String=params[int(i)];
					if((index=kvPair.indexOf("=")) > 0)
					{
						var key:String=kvPair.substring(0,index);
						var value:String=kvPair.substring(index+1);
						_params[key]=value;
					}
				}
			}			
			paramsCache=_params;
		}
		
		/**
		 * Allows you to set the query string data.
		 * 
		 * <p>This is avaiable
		 * for situations when you are testing an application in the Flash IDE,
		 * but still need to rely on query string parameters. You can provide
		 * a hardcoded query string dictionary so that this class won't break
		 * your work, or cause you to have to treat logic differently just to
		 * work in the IDE.</p>
		 */
		public function set querystringData(data:Dictionary):void
		{
			if(!data)throw new ArgumentError("Parameter data cannot be null");
			paramsCache=data;
		}
		
		/**
		 * Read a property from deeplink data.
		 */
		flash_proxy override function getProperty(name:*):*
		{
			if(!read)readParams();
			if(paramsCache[name])return paramsCache[name];
			else return null;
		}
		
		/**
		 * Set a property from deeplink data.
		 */
		flash_proxy override function setProperty(name:*,value:*):void
		{
			paramsCache[name]=value;
		}
		
		/**
		 * Dispose of the internally cached query string parameters.
		 */
		public function dispose():void
		{
			paramsCache=null;
			read=false;
		}
	}
}