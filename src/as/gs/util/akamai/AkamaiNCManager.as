package gs.util.akamai
{
	import flash.events.Event;
	
	import fl.video.*;
	
	import gs.util.akamai.Ident;	
	use namespace flvplayback_internal;
    
    /**
     * The AkamaiNCManager class is a replacement for the
     * default NCManager class from Adobe. This is used with
     * an FLVPlayback component and manages NetConnections
     * specifically to Akamai.
     * 
     * <p>Here's how you set it up:</p>
     * 
     * <listing>	
	 * import fl.video.VideoPlayer;
	 * import gdkit.akamai.AkamaiNCManager;
	 * VideoPlayer.iNCManagerClass="gdkit.akamai.AkamaiNCManager";
	 * </listing>
     * 
     * <p>The AkamaNCManager class is set on the VideoPlayer class, because the VideoPlayer
     * class is used internally to the FLVPlayback Components.</p>
     * 
     * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
     */
    final public class AkamaiNCManager extends NCManager implements INCManager
    {
	    
	    /**
	     * A Flash Media Server IP address on the Akamai Network - set this for connections
	     * instead of a host name address.
	     * 
	     * <p>The FMS_IP can be found from an Akamai Ident service. Which returns the best
	     * IP to use to connect to a Flash Media Server on Akamai's network based off of
	     * geographical information from the client request.</p>
	     * 
	     * <p>The FMS_IP is automatically sniffed after 1 attempt to connect to an Akamai
	     * host name. If the Ident service returns an IP, that IP is used for further
	     * connection attempts.</p> 
	     * 
	     * <p>You can manually find the IP of the best Flash Media Server for the client before making
	     * any attempts to play streams, and set this property. That way no connections to
	     * an Akamai host name are attempted. But this is not required.</p>
	     */ 
		public static var FMS_IP:String;
    	
    	/**
    	 * Allow re-use of already connected net connections.
    	 * It will only re-use when connected to the same domain and
    	 * app name.
    	 * 
    	 * <p>This is recommended you leave false, as even
    	 * if you are connected with a connection, numerous
    	 * drops occur and it's very spotty.</p>
    	 */
    	public static var AllowNCReuse:Boolean=false;
    	
    	/**
    	 * The Akamai host found during processing of the
    	 * requested stream.
    	 */
		private var akamaiHost:String;
    	
    	/**
    	 * The Ident instance that sniffs the IP.
    	 */
    	private var idnt:Ident;
    	
		/**
		 * Member variable to hold "parse results"
		 * which is given to us from the suuper class.
		 */
		private var parseResults:ParseResults;
		
		/**
		 * @private
		 * 
		 * Constructor for AkamaiNCManager instances.
		 */
		public function AkamaiNCManager()
		{
			super();
		}
		
		/**
		 * @private
		 * 
		 * Set the order of connection attempts by protocol and port.
		 * 
		 * <p><strong><em>In order to use this, you must first update the NCManager class's
		 * source file and update the declaration for flvplayback_internal::RTMP_CONN.
		 * It needs to be declared as "public static var."</em></strong></p>
		 * 
		 * <p><strong><em>You must also un-comment a line of code in this source file.</em></strong></p>
		 * 
		 * <p>uncomment this line:</p>
		 * <listing>	
		 * //NCManager.flvplayback_internal::RTMP_CONN=connectAttempts;
		 * </listing>
		 * 
		 * <p>Here's an example:</p>
		 * 
		 * <listing>	
		 * AkamaiNCManager.ConnectOrder=[
		 * 	 {protocol: "rtmp:/", port:"1935"},
		 * 	 {protocol: "rtmpt:/", port:"80" },
		 * 	 {protocol: "rtmp:/", port:"443"}
		 * ];
		 * </listing>
		 * 
		 * <p>Those are the default order. And these are the only supported ports and protocols.
		 * You can just re-order them if needed.</p>
		 * 
		 * @param	connectAttempts		An array of objects with "protocol" and "port" properties on it.
		 */
		public static function set ConnectOrder(connectAttempts:Array):void
		{
			if(!connectAttempts) throw new ArgumentError("Parameter connectAttempts cannot be null or empty.");
			//NCManager.flvplayback_internal::RTMP_CONN=connectAttempts;
		}
		
		/**
		 * @private
		 * 
		 * Overrides the connectToURL method for customization.
		 */
    	override public function connectToURL(url:String):Boolean
    	{	
			initOtherInfo();
			_contentPath=url;
    		var canReuse:Boolean;
    		var returnValue:Boolean;
    		if(_contentPath == null || _contentPath == "") throw new VideoError(VideoError.INVALID_SOURCE);
    		//parse URL to determine what to do with it                                        
    		parseResults=parseURL(_contentPath);
    		if(parseResults.streamName == null || parseResults.streamName == "") throw new VideoError(VideoError.INVALID_SOURCE, url);
    		//connect to either rtmp or http or download and parse smil
    		if(parseResults.isRTMP)
    		{
    			_isRTMP=true;
    			//assumes we are dealing with an Akamai URL
    			//check to see if the serverName and app names match
    			if(AkamaiNCManager.AllowNCReuse)
    			{
    				//trace("AkamaiNCManager.AllowReconnect");
    				if(akamaiHost == parseResults.serverName && getAkamaiAppName(url) == _appName)
	    			{
	    				//trace("Reusing existing Akamai connection");
	    				_streamName=getAkamaiStreamName(url);
	    				if(_streamName.slice(-4).toLowerCase() == ".flv") _streamName=_streamName.slice(0, -4);
	    				//if this host and app is already in use then reuse the existing connection.
	    				returnValue=true;
	    			}
	    			else
	    			{
	    				//canReuse=canReuseOldConnection(parseResults);
	    				if(!AkamaiNCManager.FMS_IP) sniffFMSIP();
	    				if(!parseResults) parseResults=parseURL(_contentPath);
						akamaiHost=parseResults.serverName;
						_protocol=parseResults.protocol;
						_wrappedURL=parseResults.wrappedURL;
						_portNumber=parseResults.portNumber;
						if(AkamaiNCManager.FMS_IP) _serverName=AkamaiNCManager.FMS_IP;
	    				else _serverName=parseResults.serverName;
						_appName=getAkamaiAppName(_contentPath);
						_streamName=getAkamaiStreamName(_contentPath);
	    				if(_appName == null || _appName == "" || _streamName == null || _streamName == "") throw new VideoError(VideoError.INVALID_SOURCE, url);
	    				//trace("2Using the Akamai FMS server at: "+ _serverName);
						//trace("2Akamai app name: " + _appName);
						//trace("2Akamai stream name:" + _streamName);
	    				_autoSenseBW=(_streamName.indexOf(",") >= 0);
	    				returnValue=false;
    				}
    			}
    			else
    			{
    				if(!AkamaiNCManager.FMS_IP)
    				{
    					sniffFMSIP();
    					returnValue=false;
    				}
    				else
    				{
    					if(!parseResults) parseResults=parseURL(_contentPath);
						akamaiHost=parseResults.serverName;
						_protocol=parseResults.protocol;
						_wrappedURL=parseResults.wrappedURL;
						_portNumber=parseResults.portNumber;
						if(AkamaiNCManager.FMS_IP) _serverName=AkamaiNCManager.FMS_IP;
	    				else _serverName=parseResults.serverName;
						_appName=getAkamaiAppName(_contentPath);
						_streamName=getAkamaiStreamName(_contentPath);
						if(_streamName.indexOf(".flv") != -1) _streamName=_streamName.slice(0, _streamName.indexOf(".flv"))+_streamName.slice(_streamName.indexOf(".flv")+4, _streamName.length);
						if(_streamName.slice(-4).toLowerCase() == ".mp3") _streamName=_streamName.slice(0, -4);
						//trace("3Using the Akamai FMS server at: "+ _serverName);
						//trace("3Akamai app name: " + _appName);
						//trace("3Akamai stream name:" + _streamName);
						if(_appName == null || _appName == "" || _streamName == null || _streamName == "") throw new VideoError(VideoError.INVALID_SOURCE, _contentPath);
						returnValue=connectRTMP();
    				}
    			}
    		}
    		else
    		{
    			if(parseResults.streamName.toLowerCase().indexOf(".flv") > -1)
    			{
    				//trace("HTTP");
    				canReuse=canReuseOldConnection(parseResults);
    				_isRTMP=false;
    				_streamName=parseResults.streamName;
    				returnValue= (canReuse || connectHTTP());
    			}
    			else throw new Error("SMIL Not Supported by the AkamaiNCManager class");
    		}
    		return returnValue;
    	}
    	
    	/**
    	 * Initiates an attempt to sniff the FMS 
    	 * IP that the client is currently resolving to.
    	 */
    	private function sniffFMSIP():void
    	{
    		if(!parseResults) parseResults=parseURL(_contentPath);
			idnt=new Ident();
			idnt.contentLoader.addEventListener(Event.COMPLETE,onIPSniff);
			idnt.findBestIPForAkamaiApplication("http://" + parseResults.serverName);
    	}
    	
    	/**
    	 * After succesfully loading the ident XML
    	 */
    	private function onIPSniff(e:Event):void
    	{
    		var xml:XML=e.target.data as XML;
    		if(xml.ip) AkamaiNCManager.FMS_IP=xml.ip.toString();
    		try
    		{
    			if(!parseResults) parseResults=parseURL(_contentPath);
				akamaiHost=parseResults.serverName;
				_isRTMP=true;
				_protocol=parseResults.protocol;
				_wrappedURL=parseResults.wrappedURL;
				_portNumber=parseResults.portNumber;
				_serverName=AkamaiNCManager.FMS_IP;
				_appName=getAkamaiAppName(_contentPath);
				_streamName=getAkamaiStreamName(_contentPath);
				if(_streamName.indexOf(".flv") != -1) _streamName=_streamName.slice(0, _streamName.indexOf(".flv"))+_streamName.slice(_streamName.indexOf(".flv")+4, _streamName.length);
				if(_streamName.slice(-4).toLowerCase() == ".mp3") _streamName=_streamName.slice(0, -4);
				//trace("Using the Akamai FMS server at: "+ _serverName);
				//trace("Akamai app name: " + _appName);
				//trace("Akamai stream name:" + _streamName);
				if(_appName == null || _appName == "" || _streamName == null || _streamName == "") throw new VideoError(VideoError.INVALID_SOURCE, _contentPath);
				connectRTMP();
    		}
    		catch(error:Error)
    		{
    			_nc=null;
    			_owner.ncConnected();
    			throw error;
    		}
    	}
	    
	    /**
	     * Get the Akamai App Name, usually "ondemand"
	     */
    	private function getAkamaiAppName(p:String):String
    	{
    		//first check if a vhost is being passed in
    		var a:String;
    		if(p.indexOf("_fcs_vhost") != -1) a=p.slice(p.indexOf("/", 10)+1, p.indexOf("/", p.indexOf("/", 10)+1))+"?_fcs_vhost="+p.slice(p.indexOf("_fcs_vhost")+11);
    		else a=p.slice(p.indexOf("/", 10)+1, p.indexOf("/", p.indexOf("/", 10)+1))+"?_fcs_vhost="+parseURL(p).serverName;
    		if(p.indexOf("?") != -1) a=a+"&"+p.slice(p.indexOf("?")+1);
    		return a;
    	}
		
		/**
		 * Get the stream name we're trying to play.
		 */
    	private function getAkamaiStreamName(p:String):String
    	{
    		var tempApp:String=p.slice( p.indexOf("/",10) + 1, p.indexOf("/", p.indexOf("/",10) + 1));
    		return p.indexOf("_fcs_vhost") != -1 ? p.slice(p.indexOf(tempApp)+tempApp.length+1, p.indexOf("_fcs_vhost")-1) : p.slice(p.indexOf(tempApp)+tempApp.length+1);
    	}
    }
}