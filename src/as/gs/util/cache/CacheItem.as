package gs.util.cache
{
	
	import flash.utils.*;
	
	/**
	 * The CacheItem class is used internally to a Cache instance. Each item
	 * in a Cache that is stored, is wrapped by this CacheItem instance to allow
	 * for expirations at an object level.
	 * 
	 * <p>This class does not need to be used in order to store something in a Cache.<p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class CacheItem
	{
		
		/**
		 * The callback to call when this item expires.
		 */
		private var purgeCallback:Function;
		
		/**
		 * The timeout to expire.
		 */
		public var timeout:int;
		
		/**
		 * The stored data.
		 */
		public var object:*;
		
		/**
		 * The key that was used in the actual cache.
		 */
		public var cacheKey:String;
		
		/**
		 * Constructor for CacheItem instances.
		 * 
		 * @param key The key to store the object by.
		 * @param obj The object you want stored by key.
		 * @param purgeCallback The callback function that purges this object.
		 * @param timeout The timeout in which to expie this object.
		 */
		public function CacheItem(key:String,object:*,purgeCallback:Function,timeout:int=-1):void
		{
			this.purgeCallback=purgeCallback;
			cacheKey=key;
			this.timeout=timeout;
			this.object=object;
			if(timeout>-1) flash.utils.setTimeout(purgeItem, timeout);
		}
		
		/**
		 * On timeout, the item is expired.
		 */
		private function purgeItem():void
		{
			this.purgeCallback(cacheKey);
		}
		
		/**
		 * Destroy this cache items internal variables.
		 */
		public function dispose():void
		{
			purgeCallback=null;
			cacheKey=null;
			flash.utils.clearTimeout(timeout);
			timeout=NaN;
			object=null;
		}
	}
}