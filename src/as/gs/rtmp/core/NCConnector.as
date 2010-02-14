package gs.rtmp.core
{
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * The NCConnector summarizes connecting 
	 * a NetConnection to an endpoint, which calls
	 * back to the RTMPConnector that it has connected.
	 */
	public class NCConnector
	{
		
		/**
		 * The maximum number of connection attempts
		 * - the default is 2.
		 */
		public static var maxConnectAttempts:int;
		
		/**
		 * A timeout for failure detection - the default
		 * is 6000.
		 */
		public static var failFallbackTimeout:int;
		
		/**
		 * Internal NetConnection.
		 */
		public var netConnection:NetConnection;
		
		/**
		 * RTMPConnector.
		 */
		private var connector:RTMPConnector;
		
		/**
		 * The endpoint we're connecting to.
		 */
		public var endpoint:String;
		
		/**
		 * Current connection attempt count.
		 */
		protected var connectionAttempts:int;
		
		/**
		 * Whether or not we already told the RTMPConnector
		 * that we failed.
		 */
		private var alreadyFailed:Boolean;
		
		/**
		 * Interval id.
		 */
		private var failFallbackId:Number;
		
		/**
		 * Constructor for NCConnector instances.
		 * 
		 * @param connector An RTMPConnector.
		 * @param endpoint The endpoint to connect to.
		 */
		public function NCConnector(connector:RTMPConnector,endpoint:String)
		{
			connectionAttempts=0;
			if(!maxConnectAttempts)maxConnectAttempts=2;
			if(!failFallbackTimeout)failFallbackTimeout=6000;
			this.connector=connector;
			this.endpoint=endpoint;
			try{
				netConnection=new NetConnection();
				netConnection.client=this;
				netConnection.addEventListener(NetStatusEvent.NET_STATUS,onNetConnectionStatus,false,0,true);
			}
			catch(ns:NetStatusEvent)
			{
				//trace(ns);
			}
		}
		
		/**
		 * Attempt to connect to the endpoint.
		 */
		public function connect():void
		{
			var errored:Boolean;
			connectionAttempts++;
			try
			{
				netConnection.connect(endpoint);
			}
			catch(s:NetStatusEvent)
			{
				//this only occurs when all internal objects have been
				//cleaned up, but there are still anonymous events being dispatched
				//from the netConnection object.
				errored=true;
				close();
				dispose();
			}
			if(errored)return;
			connector.onAttempt(this);
			failFallbackId=setTimeout(completeFailure,failFallbackTimeout);
		}
		
		/**
		 * After a certain interval, we have to fail this
		 * connection attempt, otherwise this object
		 * could stay in limbo.
		 */
		private function completeFailure():void
		{
			fail();
		}
		
		/**
		 * Close the internal NC.
		 */
		public function close():void
		{
			if(!netConnection) return;
			if(!netConnection.connected) return;
			try{netConnection.close();}
			catch(e:*){}
		}
		
		/**
		 * Dispose of instance, but don't close the NC. If
		 * you want to close the netConnection you need
		 * to call close().
		 */
		public function dispose():void
		{
			if(netConnection)netConnection.removeEventListener(NetStatusEvent.NET_STATUS,onNetConnectionStatus);
			netConnection=null;
			connector=null;
			endpoint=null;
			alreadyFailed=false;
			clearTimeout(failFallbackId);
			connectionAttempts=0;
		}
		
		/**
		 * On NetConnection status.
		 */
		private function onNetConnectionStatus(ns:NetStatusEvent):void
		{
			//trace("NCConnector NetConnectionStatus:",ns.info.code,endpoint);
			switch(ns.info.code)
			{
				case "NetConnection.Connect.Success":
					success();
					break;
				case "NetConnection.Connect.Failed":
					if(connectionAttempts >= maxConnectAttempts) fail();
					else setTimeout(connect,500);
					break;
				case "NetConnection.Connect.Rejected":
					fail();
					break;
				case "NetConnection.Connect.InvalidApp":
					fail();
					break;
			}
		}
		
		/**
		 * fail logic.
		 */
		private function fail():void
		{
			if(!alreadyFailed)
			{
				clearTimeout(failFallbackId);
				alreadyFailed=true;
				if(connector)connector.onFailed();
				close();
				dispose();
			}
		}
		
		/**
		 * On success.
		 */
		private function success():void
		{
			clearTimeout(failFallbackId);
			connector.onSuccess(this);
		}
		
		/**
		 * @private
		 */
		public function onBWDone(...args):void{}
		
		/**
		 * @private
		 */
		public function onBWCheck(...args):void{}
	}
}