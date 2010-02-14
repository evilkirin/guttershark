package gs.rtmp.core
{
	import flash.events.*;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	/**
	 * Dispatched when the client successfully connects.
	 * 
	 * @eventType gs.rtmp.core.RTMPEvent
	 */
	[Event("connected", type="gs.rtmp.core.RTMPEvent")]
	
	/**
	 * Dispatched when the a connection attempt occurs.
	 * 
	 * @eventType gs.rtmp.core.RTMPEvent
	 */
	[Event("connectionAttempt", type="gs.rtmp.core.RTMPEvent")]
	
	/**
	 * Dispatched when the the connection complete fails.
	 * 
	 * @eventType gs.rtmp.core.RTMPEvent
	 */
	[Event("connectionFailed", type="gs.rtmp.core.RTMPEvent")]
	
	/**
	 * Dispatched when the net connection is closed.
	 * 
	 * @eventType gs.rtmp.core.RTMPEvent
	 */
	[Event("closed", type="gs.rtmp.core.RTMPEvent")]
	
	/**
	 * Dispatched when the connection endpoint is to an
	 * invalid app url.
	 * 
	 * @eventType gs.rtmp.core.RTMPEvent
	 */
	[Event("invalidApp", type="gs.rtmp.core.RTMPEvent")]
	
	/**
	 * Dispatched when the insufficient bandwidth event
	 * happens from the server.
	 * 
	 * @eventType gs.rtmp.core.RTMPEvent
	 */
	[Event("insufficientBW", type="gs.rtmp.core.RTMPEvent")]
	
	/**
	 * The RTMPClient class is a base class for any
	 * client that connects to an rtmp service.
	 */
	public class RTMPClient extends RTMPObject
	{
		
		/**
		 * Maximum number of connection attempts.
		 */
		public static var maxConnectionAttempts:int;
		
		/**
		 * Connection endpoint.
		 */
		public var endpoint:String;
		
		/**
		 * Stream name for live or vod streaming.
		 */
		public var stream:String;
		
		/**
		 * The connection to the server.
		 */
		public var nc:NetConnection;
		
		/**
		 * The net stream.
		 */
		protected var ns:NetStream;
		
		/**
		 * Optional microphone object for audio streaming.
		 */
		public var mic:Microphone;
		
		/**
		 * Optional camera for video streaming.
		 */
		public var cam:Camera;
		
		/**
		 * Vide object for displaying streamed camera, or vod.
		 */
		public var vid:Video;
		
		/**
		 * The number of attempts that have occured.
		 */
		protected var attemptedConnections:int;
		
		/**
		 * An RTMPConnector for more robust connecting.
		 */
		protected var connector:RTMPConnector;
		
		/**
		 * Whether or not a close event has been dispatched.
		 */
		protected var dispatchedClose:Boolean;
		
		/**
		 * Constructor for RTMPClient instances.
		 */
		public function RTMPClient()
		{
			super();
			attemptedConnections=0;
			if(!maxConnectionAttempts)maxConnectionAttempts=3;
		}
		
		/**
		 * @private
		 * Initialize this client from another client
		 */
		public function initFromOtherClient(rc:RTMPClient):void
		{
			if(!rc)
			{
				trace("WARNING: the {rc} parameter was null in the call to initFromOtherClient in RTMPClent");
				return;
			}
			endpoint=rc.endpoint;
			mic=rc.mic;
			cam=rc.cam;
			vid=rc.vid;
			nc=connections.getConnection(rc.nc.uri);
		}
		
		/**
		 * Whether or not this client is connected.
		 */
		public function get connected():Boolean
		{
			return nc.connected;
		}
		
		/**
		 * Helper to finish net connection up.
		 */
		private function finishNC():void
		{
			if(!nc)return;
			nc.client=this;
			nc.addEventListener(NetStatusEvent.NET_STATUS,onNetConnectionStatus,false,0,true);
		}
		
		/**
		 * Initialize this instance with the endpoing, and stream name.
		 * 
		 * @param endpoint The server connection string.
		 * @param stream The stream name.
		 */
		public function initWith(endpoint:String,stream:String):void
		{
			if(!endpoint)
			{
				trace("WARNING: The {endpoint} parameter was null in the call to initWith in RTMPClient");
				return;
			}
			if(!stream)
			{
				trace("WARNING: The {stream} parameter was null in the call to initWith in RTMPClient");
				return;
			}
			this.endpoint=endpoint;
			this.stream=stream;
		}
		
		/**
		 * Set media objects for streaming.
		 * 
		 * @param mic A Microphone.
		 * @param cam A Camera.
		 * @param video A Video display.
		 */
		public function setMedia(mic:Microphone=null,cam:Camera=null,video:Video=null):void
		{
			this.mic=mic;
			this.cam=cam;
			this.vid=video;
		}
		
		/**
		 * Connect to the server.
		 * 
		 * <p>You should always wait for the RTMPEvent.CONNECT event
		 * before doing anything further.</p>
		 */
		public function connect():void
		{
			initializeRTMPConnector();
		}
		
		/**
		 * Attempts to connect the connection to the endpoint.
		 */
		protected function attemptToConnect():void
		{
			if(!nc)
			{
				nc=new NetConnection();
				finishNC();
			}
			attemptedConnections++;
			dispatchEvent(new RTMPEvent(RTMPEvent.CONNECTION_ATTEMPT,true,false,endpoint));
			nc.connect(endpoint);
		}
		
		/**
		 * Initializes an RTMPConnector if opted into.
		 */
		private function initializeRTMPConnector():void
		{
			connector=new RTMPConnector();
			connector.endpoint=endpoint;
			connector.addEventListener(ConnectorEvent.ATTEMPT,onAttempt);
			connector.addEventListener(ConnectorEvent.CONNECTED,onConnectorConnect);
			connector.addEventListener(ConnectorEvent.FAILED,onConnectorFailed);
			connector.connect();
		}
		
		/**
		 * Initialize a net stream.
		 */
		protected function initNetStream():void
		{
			ns=new NetStream(nc);
			ns.client=this;
			ns.addEventListener(NetStatusEvent.NET_STATUS,onNetStreamStatus);
		}
		
		/**
		 * On a connection attempt.
		 */
		private function onAttempt(e:ConnectorEvent):void
		{
			if(nc && nc.connected) return;
			dispatchEvent(new RTMPEvent(RTMPEvent.CONNECTION_ATTEMPT,true,false,e.url));
		}
		
		/**
		 * As soon as the RTMPConnector has a connection.
		 */
		private function onConnectorConnect(ce:ConnectorEvent):void
		{
			onSuccess();
		}
		
		/**
		 * When all of the RTMPConnector attempts have failed.
		 */
		private function onConnectorFailed(ce:ConnectorEvent):void
		{
			onFail();
		}
		
		/**
		 * On success hook.
		 */
		protected function onSuccess(dispatchConnectedEvent:Boolean=true):void
		{
			setNC();
			finishNC();
			if(connector)connector.dispose();
			if(dispatchConnectedEvent)dispatchEvent(new RTMPEvent(RTMPEvent.CONNECTED,true,false,nc.uri));
		}
		
		/**
		 * Hook to set the nc property after a RTMPConnector
		 * is successfully connected. This is only a hook for
		 * subclasses.
		 */
		protected function setNC():void
		{
			nc=connector.connectedNC;
		}
		
		/**
		 * On fail.
		 */
		protected function onFail():void
		{
			dispatchEvent(new RTMPEvent(RTMPEvent.CONNECTION_FAILED,true,false,endpoint));
		}
		
		/**
		 * Disconnects this client but leaves internal
		 * state ready for another "connect()" call.
		 */
		public function disconnect():void
		{
			if(connector)connector.disposeWhenFinished();
			if(ns)ns.close();
			if(nc)nc.removeEventListener(NetStatusEvent.NET_STATUS,onNetConnectionStatus);
			connector=null;
			attemptedConnections=0;
			ns=null;
			nc=null;
		}
		
		/**
		 * Dispose of this client - it's not usable after
		 * dispose.
		 */
		override public function dispose():void
		{
			disconnect();
			if(vid)
			{
				vid.attachCamera(null);
				vid.attachNetStream(null);
				vid=null;
			}
			cam=null;
			mic=null;
			endpoint=null;
			stream=null;
			super.dispose();
		}
		
		/**
		 * On net connection status.
		 */
		protected function onNetConnectionStatus(ns:NetStatusEvent):void
		{
			//trace("netConnectionStatus:",ns.info.code);
			switch(ns.info.code)
			{
				case "NetConnection.Connect.Success":
					onSuccess();
					break;
				case "NetConnection.Connect.Closed":
					dispatchEvent(new RTMPEvent(RTMPEvent.CLOSED,true,false,endpoint));
					break;
				case "NetConnection.Connect.Failed":
					onConnectFail();
					break;
				case "NetConnection.Connect.Rejected":
					onConnectFail();
					break;
				case "NetConnection.Connect.InvalidApp":
					dispatchEvent(new RTMPEvent(RTMPEvent.INVALID_APP,true,false,endpoint));
					break;
			}
		}
		
		/**
		 * Internal use for common code.
		 */
		protected function onConnectFail():void
		{
			if(attemptedConnections == maxConnectionAttempts)
			{
				disconnect();
				dispatchEvent(new RTMPEvent(RTMPEvent.CONNECTION_FAILED,true,false,endpoint));
			}
			else
			{
				attemptToConnect();
			}
		}
		
		/**
		 * On net stream status - subclasses of this client should
		 * implement their own logic for net stream status'.
		 */
		protected function onNetStreamStatus(ns:NetStatusEvent):void
		{
			trace("onNetStreamStatus not implemented");
		}
		
		/**
		 * @private
		 */
		public function onBWDone(...args):void
		{
		}
		
		/**
		 * @private
		 */
		public function onBWCheck(...args):void
		{
		}
	}
}