package gs.rtmp.rso
{
	import flash.events.EventDispatcher;
	import flash.events.SyncEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * The RemoteSharedObjectClient client is the "client" for a RemoteSharedObject.
	 * 
	 * <p>It's essentially the SharedObject.client property</p>
	 */
	public class RemoteSharedObjectClient extends EventDispatcher
	{
		
		/**
		 * The host remote shared object for this client.
		 */
		public var rso:RemoteSharedObject;
		
		/**
		 * Should be a pointer to rso.so.data.
		 */
		protected var data:Object;
		
		/**
		 * Whether or not the sync event was the very first
		 * one for this client.
		 */
		protected var firstSync:Boolean;
		
		/**
		 * Used with dirtyTest().
		 */
		private var dirts:String;
		
		/**
		 * Timeout id.
		 */
		private var dirtsId:Number;
		
		/**
		 * Constructor for RemoteSharedObjectClient instances.
		 */
		public function RemoteSharedObjectClient()
		{
			firstSync=true;
		}
		
		/**
		 * When the shared object syncs.
		 */
		public function sync(se:SyncEvent):void
		{
			data=rso.so.data;
			invalidate();
			if(firstSync)
			{
				onFirstSync();
				firstSync=false;
			}
		}
		
		/**
		 * Helper function that dispatchs an RSOEvent.SYNC_COMPLETE
		 * event.
		 */
		protected function syncComplete():void
		{
			if(!firstSync) dispatchEvent(new RSOEvent(RSOEvent.SYNC_COMPLETE,true,false));
		}
		
		/**
		 * This can be used to purposefully dirty
		 * the shared object, so that you start seeing
		 * the sync events.
		 */
		protected function dirtyTest(timeout:int=2000):void
		{
			dirtsId=setTimeout(dirt,timeout);
		}
		
		/**
		 * Dirt tests
		 */
		private function dirt():void
		{
			if(!data) return;
			trace("dirtyTest: ",data.dirtyTest);
			if(dirts == "test 5") dirts = null;
			if(dirts == "test 4") dirts = "test 5";
			if(dirts == "test 3") dirts = "test 4";
			if(dirts == "test 2") dirts = "test 3";
			if(dirts == "test 1") dirts = "test 2";
			if(!dirts) dirts = "test 1";
			if(rso)
			{
				rso.setProperty("dirtyTest",dirts);
				rso.setDirty("dirtyTest");
			}
		}
		
		/**
		 * Invalidate data from shared object - you should
		 * override this.
		 */
		protected function invalidate():void
		{
			trace("invalidation not implemented");
		}
		
		/**
		 * A hook you can override to catch the very
		 * first sync event from the shared object.
		 */
		protected function onFirstSync():void
		{
			rso.firstSync();
		}
		
		/**
		 * Dispose of this client object.
		 */
		public function dispose():void
		{
			clearTimeout(dirtsId);
			rso=null;
			firstSync=false;
			dirts=null;
		}
	}
}
