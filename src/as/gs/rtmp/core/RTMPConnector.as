package gs.rtmp.core
{
	import flash.net.NetConnection;
	
	/**
	 * The RTMPConnector class makes a connection to
	 * a server with NetConnection, but tries simultaneous
	 * connection attempts in order to find the fastest
	 * connection.
	 */
	public class RTMPConnector extends RTMPObject
	{
		
		/**
		 * Whether or not to include the RTMPT protocol
		 * in connection attempts.
		 */
		public static var tunnel:Boolean;
		
		/**
		 * The endpoint to connect to, 
		 */
		public var endpoint:String;
		
		/**
		 * The first connected NetConnection.
		 */
		private var _connectedNC:NetConnection;
		
		/**
		 * The number of connections that haven't reported
		 * status yet.
		 */
		private var idleConnections:int;
		
		/**
		 * Whether or not an event was dispatched for fail.
		 */
		private var dispatchedFail:Boolean;
		
		/**
		 * Whether or not I dispose of myself when all is complete.
		 */
		private var _disposeWhenFinished:Boolean;
		
		/**
		 * Whether or not the _connectedNC was already
		 * closed with the connections manager.
		 */
		private var terminated:Boolean;
		
		/**
		 * Holder for ports and protocols to try.
		 */
		private var conAttempts:Array;
		
		/**
		 * Constructor for RTMPConnector instances.
		 */
		public function RTMPConnector()
		{
			super();
			idleConnections=0;
		}
		
		/**
		 * Updates protocols and ports.
		 */
		private function updateProtocolsAndPorts():void
		{
			conAttempts = [
				{port:"1935",protocol:"rtmp"},
				{port:"443",protocol:"rtmp"},
				{port:"80",protocol:"rtmp"},
			];
			if(tunnel)
			{
				conAttempts.push({port:"80",protocol:"rtmpt"});
			}
		}
		
		/**
		 * Initiate connection attempts.
		 */
		public function connect():void
		{
			if(!endpoint)
			{
				trace("Error: The endpoint wasn't set for this RTMPConnector");
				return;
			}
			updateProtocolsAndPorts();
			var e:String;
			if(endpoint.indexOf("rtmp://") > -1)e=endpoint.substring(7);
			else if(endpoint.indexOf("rtmpt://") > -1)e=endpoint.substring(8);
			var a:Array = e.split("/");
			var domain:String = a.shift();
			var path:String = "/" + a.join("/");
			var i:int=0;
			var l:int=conAttempts.length;
			var ncc:NCConnector;
			var conn:String;
			for(;i<l;i++)
			{
				conn=conAttempts[int(i)].protocol + "://" + domain + ":"+ conAttempts[int(i)].port+path;
				if(connections.hasConnection(conn))
				{
					var n:NetConnection=connections.getConnection(conn);
					connections.usingConnection(n);
					onConnectionAvailable(n);
					return;
				}
				ncc=new NCConnector(this,conn);
				ncc.connect();
				idleConnections++;
			}
		}
		
		/**
		 * When a connection is available in the RTMPConnections
		 * cache.
		 */
		private function onConnectionAvailable(nc:NetConnection):void
		{
			if(!nc)return;
			_connectedNC=nc;
			dispatchEvent(new ConnectorEvent(ConnectorEvent.CONNECTED));
			idleConnections=0;
			autoDispose();
		}
		
		/**
		 * @private
		 * Callback that NCConnector uses to pass the successfully
		 * connected NC back.
		 */
		public function onSuccess(ncc:NCConnector):void
		{
			if(!ncc)return;
			if(_connectedNC)
			{
				ncc.close();
				ncc.dispose();
				return;
			}
			idleConnections=Math.max(0,--idleConnections);
			if(ncc)
			{
				_connectedNC=ncc.netConnection;
				ncc.dispose();
			}
			if(connections)connections.addConnection(_connectedNC);
			dispatchEvent(new ConnectorEvent(ConnectorEvent.CONNECTED));
			autoDispose();
		}
		
		/**
		 * @private
		 * When a NCConnector completely fails at connecting.
		 */
		public function onFailed():void
		{
			idleConnections=Math.max(0,--idleConnections);
			invalidateIdleConnections();
			autoDispose();
		}
		
		/**
		 * On an attempt.
		 */
		public function onAttempt(ncc:NCConnector):void
		{
			if(_connectedNC) return;
			dispatchEvent(new ConnectorEvent(ConnectorEvent.ATTEMPT,ncc.endpoint,false,true));
		}
		
		/**
		 * Helper function for closing and disposing.
		 */
		private function autoDispose():void
		{
			if(idleConnections < 1 && _disposeWhenFinished)
			{
				if(connectedNC && connectedNC.connected)
				{
					if(!terminated)
					{
						if(connections)connections.closeConnection(_connectedNC);
						connections=null;
						terminated=true;
					}
				}
				dispose();
			}
		}
		
		/**
		 * Dispose of this.
		 */
		override public function dispose():void
		{
			endpoint=null;
			idleConnections=0;
			conAttempts=null;
			dispatchedFail=false;
			super.dispose();
		}
		
		/**
		 * Dispose of myself when all outstanding connection attempts
		 * have failed or completed.
		 */
		public function disposeWhenFinished():void
		{
			_disposeWhenFinished=true;
			autoDispose();
		}
		
		/**
		 * Invalidates the status of all idle connections.
		 */
		private function invalidateIdleConnections():void
		{
			if(idleConnections <= 0 && !_connectedNC)
			{
				if(_disposeWhenFinished)
				{
					dispose();
					_disposeWhenFinished=false;
				}
				else if(!dispatchedFail)
				{
					dispatchEvent(new ConnectorEvent(ConnectorEvent.FAILED));
					dispatchedFail=true;
				}
			}
		}
		
		/**
		 * The connected NetConnection object after everything
		 * is complete.
		 */
		public function get connectedNC():NetConnection
		{
			return _connectedNC;
		}
	}
}