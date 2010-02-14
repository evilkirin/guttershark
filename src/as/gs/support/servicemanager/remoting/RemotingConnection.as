package gs.support.servicemanager.remoting
{
	import flash.events.*;
	import flash.net.NetConnection;	

	/**
	 * The RemotingConnection class simplifies connecting a net connection to 
	 * a Flash Remoting gateway.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class RemotingConnection extends EventDispatcher
	{	

		/**
		 * The gateway URL.
		 */
		public var gateway:String;
		
		/**
		 * The net connection object used to connect.
		 */
		public var connection:NetConnection;
		
		/**
		 * Constructor for RemotingConnection instances.
		 * 
		 * @param gateway The remoting gateway URL.
		 * @param objectEncoding The AMF Object encoding.
		 */
		public function RemotingConnection(gateway:String, objectEncoding:int = 3)
		{
			if(gateway == '' || !gateway) throw new ArgumentError("Gateway cannot be null");
			if(objectEncoding != 0 && objectEncoding != 3) throw new ArgumentError("Object encoding must be 0 or 3");
			this.gateway = gateway;
			connection = new NetConnection();
			connection.objectEncoding = objectEncoding;
			connection.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus,false,0,true);
			connection.addEventListener(IOErrorEvent.IO_ERROR, onConnectionError,false,0,true);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR , onConnectionError,false,0,true);
			connection.connect(gateway);
		}
		
		/**
		 * onConnectionError
		 */
		private function onConnectionError(event:ErrorEvent):void
		{
			connection.close();
			connection = null;
			trace("NetConnection Error"+event.text);
		}
		
		/**
		 * onConnectionStatus
		 */
		private function onConnectionStatus(event:NetStatusEvent):void
		{
			switch(event.info.code)
			{
				case "NetConnection.Connect.Success":
					break;
				case "NetConnection.Connect.Failed":
					trace("Error: NetConnection Failed");
					break;
				case "NetConnection.Call.BadVersion":
					trace("Error: NetConnection BadVersion");
					break;
				case "NetConnection.Call.Prohibited":
					trace("Error: NetConnection Prohibited");
					break;
				case "NetConnection.Connect.Closed":
					trace("Error: NetConnection Closed");
					break;
			}
		}
		
		/**
		 * Dispose of this RemotingConnection.
		 */
		public function dispose():void
		{
			if(connection.connected) connection.close();
			connection = null;
			gateway = null;
		}

		/**
		 * Check whether or not the connection is currently established.
		 */
		public function get connected():Boolean
		{
			return connection.connected;
		}
		
		/**
		 * Re-connect the net connection object.
		 */
		public function reConnect():void
		{
			connection.connect(gateway);
		}
		
		/**
		 * Add a credentials header for any requests going to this connection.
		 * 
		 * @param username The username.
		 * @param password The password.
		 */
		public function setCredentials(username:String,password:String):void
		{
			connection.addHeader("Credentials",false,{userid:username,password:password});
		}
	}
}