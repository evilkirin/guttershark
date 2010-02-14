package gs.rtmp.rso
{
	import gs.rtmp.conference.ConferenceEvent;
	import gs.rtmp.core.RTMPClient;
	import gs.rtmp.core.RTMPEvent;
	
	import flash.events.NetStatusEvent;
	import flash.events.SyncEvent;
	import flash.net.SharedObject;
	import flash.utils.setTimeout;
	
	/**
	 * The RemoteSharedObject class represents a
	 * remote shared object, and wraps functionality
	 * to connect to the server, and automatically
	 * setup the SharedObject when connected.
	 * 
	 * <p>It also exposes SharedObject interface through
	 * composition.</p>
	 */
	public class RemoteSharedObject extends RTMPClient
	{
		
		/**
		 * Time to wait before checking that the first sync occured.
		 */
		public static var waitForSyncTimeout:int;
		
		/**
		 * The actual shared object setup after
		 * a net connection is established.
		 */
		public var so:SharedObject;
		
		/**
		 * A client object for shared object callbacks.
		 */
		public var client:RemoteSharedObjectClient;
		
		/**
		 * The name of this remote shared object.
		 */
		public var name:String;
		
		/**
		 * Whether or not this remote shared object is
		 * persistent.
		 */
		public var persistent:Boolean;
		
		/**
		 * Whether or not this remote shared object is
		 * secure.
		 */
		public var secure:Boolean;
		
		/**
		 * The number of times per second that a client's
		 * changes to a shared object are sent to the server.
		 */
		public var syncFrequency:int;
		
		/**
		 * Whether or not the first sync has happened
		 */
		protected var hasSynced:Boolean;
		
		/**
		 * Constructor for RemoteSharedObject instances.
		 * 
		 * @param name The name of the remote shared object.
		 */
		public function RemoteSharedObject(persistent:Boolean=false,secure:Boolean=false)
		{
			this.persistent=persistent;
			this.secure=secure;
			if(!waitForSyncTimeout)waitForSyncTimeout=4000;
		}
		
		/**
		 * Init required parameters.
		 * 
		 * @param endpoint The server connection point.
		 * @param name The remote shared object name.
		 */
		override public function initWith(endpoint:String,name:String):void
		{
			if(!endpoint)
			{
				trace("WARNING: The {endpoint} parameter was null in the call to initWith in RemoteSharedObject");
				return;
			}
			if(!name)
			{
				trace("WARNING: The {name} parameter was null in the call to initWith in RemoteSharedObject");
				return;
			}
			this.endpoint=endpoint;
			this.name=name;
		}
		
		/**
		 * Composition for the internal SharedObject.
		 */
		public function get data():Object
		{
			if(!so) return null;
			return so.data;
		}
		
		/**
		 * Composition for the internal SharedObject.
		 */
		public function clear():void
		{
			if(!nc) return;
			if(!nc.connected) return;
			if(!so) return;
			so.clear();
		}
		
		/**
		 * Composition for the internal SharedObject.
		 */
		public function send(...args):void
		{
			if(!args) return;
			if(!nc.connected) return;
			if(args.length == 0) so.send();
			if(args.length == 1) so.send(args[0]);
			if(args.length == 2) so.send(args[0],args[1]);
			if(args.length == 3) so.send(args[0],args[1],args[2]);
			if(args.length == 4) so.send(args[0],args[1],args[2],args[3]);
			if(args.length == 5) so.send(args[0],args[1],args[2],args[3],args[4]);
			if(args.length == 6) so.send(args[0],args[1],args[2],args[3],args[4],args[5]);
		}
		
		/**
		 * Composition for the internal SharedObject.
		 */
		public function setDirty(propertyName:String):void
		{
			if(!propertyName)
			{
				trace("WARNING: The propertyName was null in the call to setDirty in RemoteSharedObject");
				return;
			}
			if(!so) return;
			so.setDirty(propertyName);
		}
		
		/**
		 * Composition for the internal SharedObject.
		 */
		public function setProperty(name:String,value:*):void
		{
			if(!name)
			{
				trace("WARNING: The property {name} was null in the call to setProperty in RemoteSharedObject");
				return;
			}
			if(!so) return;
			so.setProperty(name,value);
		}
		
		/**
		 * When the shared object sync event occurs.
		 */
		protected function onSync(se:SyncEvent):void
		{
			if(!client)return;
			client.sync(se);
		}
		
		/**
		 * @private
		 */
		public function firstSync():void
		{
			hasSynced=true;
			dispatchEvent(new RTMPEvent(RTMPEvent.CONNECTED,true,false,endpoint));
			dispatchEvent(new ConferenceEvent(ConferenceEvent.FIRST_SYNC,true,false));
		}
		
		/**
		 * Shared object net status.
		 */
		protected function onSharedObjectNetStatus(ns:NetStatusEvent):void
		{
			if(!ns) return;
			trace(">>>>>sharedObjectStatus:",ns.info.code);
		}
		
		/**
		 * Disconnects this client but leaves internal
		 * state ready for another "connect()" call.
		 */
		override public function disconnect():void
		{
			if(so)so.close();
			so=null;
			super.disconnect();
		}
		
		/**
		 * Dispose of this remote shared object.
		 */
		override public function dispose():void
		{
			if(client)client.dispose();
			if(so)so.close();
			name=null;
			so=null;
			persistent=false;
			secure=false;
			syncFrequency=0;
			waitForSyncTimeout=0;
			hasSynced=false;
			super.dispose();
		}
		
		/**
		 * On successfull connect to server.
		 */
		override protected function onSuccess(dispatchConnectedEvent:Boolean=true):void
		{
			if(dispatchConnectedEvent) null;
			setNC();
			so=SharedObject.getRemote(name,nc.uri,persistent,secure);
			if(!client)
			{
				trace("ERROR: RemoteSharedObject instances need a 'client'");
				return;
			}
			so.addEventListener(NetStatusEvent.NET_STATUS,onSharedObjectNetStatus);
			so.addEventListener(SyncEvent.SYNC,onSync);
			so.fps=syncFrequency;
			so.client=client;
			client.rso=this;
			so.connect(nc);
			setTimeout(checkSync,waitForSyncTimeout);
			super.onSuccess(false);
		}
		
		/**
		 * Checks if the first sync ever occured after waitForSyncTimeout
		 */
		protected function checkSync():void
		{
			if(!hasSynced) dispatchEvent(new RSOEvent(RSOEvent.SYNC_TIMEOUT));
		}
	}
}