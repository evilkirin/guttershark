package gs.rtmp.core
{
	import flash.events.EventDispatcher;
	import flash.net.NetConnection;
	import flash.utils.Dictionary;
	
	/**
	 * The RTMPConnections class is used to cache
	 * connected NetConnections for re-use.
	 */
	public class RTMPConnections extends EventDispatcher
	{
		
		/**
		 * Lookup for connections.
		 */
		private var cons:Dictionary;
		
		/**
		 * A lookup for the number of objects that
		 * are using a connection.
		 */
		private var conCounts:Dictionary;
		
		/**
		 * Singleton instance.
		 */
		private static var inst:RTMPConnections;
		
		/**
		 * Constructor for RTMPConnections.
		 */
		public function RTMPConnections()
		{
			cons=new Dictionary(false);
			conCounts=new Dictionary(false);
		}
		
		/**
		 * Singleton access.
		 */
		public static function gi():RTMPConnections
		{
			if(!inst) inst=new RTMPConnections();
			return inst;
		}
		
		/**
		 * Add a connection.
		 */
		public function addConnection(nc:NetConnection):void
		{
			if(!nc)return;
			if(!nc.connected)return;
			if(cons[nc.uri])cons[nc.uri]++;
			else
			{
				cons[nc.uri]=nc;
				conCounts[nc.uri]=1;
			}
		}
		
		/**
		 * Get a connection.
		 * 
		 * @param uri The endpoint uri.
		 */
		public function getConnection(uri:String):NetConnection
		{
			if(!uri) return null;
			return cons[uri] as NetConnection;
		}
		
		/**
		 * Whether or not a connection is available for endpoint.
		 * 
		 * @param uri The endpoint uri.
		 */
		public function hasConnection(uri:String):Boolean
		{
			if(!uri)return false;
			if(!cons[uri])return false;
			var nc:NetConnection=cons[uri];
			if(nc.connected)return true;
			if(!nc.connected)delete cons[uri];
			return false;
		}
		
		/**
		 * Tell this connection manager that another object is going
		 * to use a connection.
		 */
		public function usingConnection(nc:NetConnection):void
		{
			if(!nc)return;
			if(!nc.connected)return;
			if(!conCounts[nc.uri])conCounts[nc.uri]=1;
			else conCounts[nc.uri]++;
		}
		
		/**
		 * Close a connectionn - only actually closes the NetConnection
		 * if there aren't any more objects using the NC.
		 */
		public function closeConnection(nc:NetConnection):void
		{
			if(!nc)return;
			if(!nc.connected)return;
			var count:int=conCounts[nc.uri];
			if(count<2)
			{
				dispatchEvent(new RTMPEvent(RTMPEvent.CONNECTION_TERMINATED,true,false,nc.uri));
				try{nc.close();}//actually close it.
				catch(e:*){}
				delete cons[nc.uri];
				delete conCounts[nc.uri];
				conCounts[nc.uri]=null;
				cons[nc.uri]=null;
				return;
			}
			conCounts[nc.uri]--;
		}
	}
}