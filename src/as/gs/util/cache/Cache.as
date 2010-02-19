package gs.util.cache
{
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	/**
	 * The Cache class caches objects in memory.
	 * 
	 * @example Caching an object:
	 * <listing>	
	 * var cache:Cache=new Cache();
	 * var toCache:Object={myKey:"Hello",myOtherKey:"World"};
	 * cache.cacheObject("tocache",toCache);
	 * trace(cache.getCachedObject("tocache").myKey);
	 * </listing>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class Cache
	{

		/**
		 * The memory cache
		 */	
		private var cache:Dictionary;
		
		/**
		 * The interval pointer that is purging
		 * all cache.
		 */
		private var purgeAllInterval:int;
		
		/**
		 * Constructor for Cache instances.
		 * 
		 * @param purgeAllTimeout An interval that purges all items in the cache every time the interval is called.
		 */
		public function Cache(purgeAllInterval:int=-1)
		{
			if(purgeAllInterval > -1) purgeAllInterval=flash.utils.setInterval(purgeAll, purgeAllInterval);
			cache=new Dictionary(true);
		}
		
		/**
		 * Purges all cache.
		 */
		public function purgeAll():void
		{
			var k:*;
			for each(k in cache)
			{
				CacheItem(cache[k]).dispose();
				cache[k]=null;
				delete cache[k];
			}
			cache=new Dictionary(true);
		}
		
		/**
		 * Dispose of this Cache instance. The difference between this
		 * and purgeAll is that dispose will render this cache instance
		 * not usable again. But purgeAll simply resets this cache, and is
		 * still usable afterwords.
		 */
		public function dispose():void
		{
			purgeAll();
			cache=null;
		}
		
		/**
		 * Clear the internal purge all interval.
		 */
		public function clearPurgeAllInterval():void
		{
			clearInterval(purgeAllInterval);
		}
		
		/**
		 * Set and or reset the purge all interval.
		 */
		public function setPurgeAllInterval(interval:Number):void
		{
			clearInterval(purgeAllInterval);
			setInterval(purgeAll,interval);
		}
		
		/**
		 * Purge one item.
		 * 
		 * @param key The key for the object that is stored.
		 */
		public function purgeItem(key:*):void
		{
			if(!cache[key]) return;
			else if(cache[key])
			{
				var ci:CacheItem=CacheItem(cache[key]);
				ci.dispose();
				cache[key]=null;
				delete cache[key];
			}
		}
		
		/**
		 * Cache an object in memory.
		 * 
		 * @param key The key to store the object by.
		 * @param obj The object data.
		 * @param expiresTimeout The timeout to expire this item after.
		 * @param overwrite	Overwrite the previously cached item.
		 */
		public function cacheObject(key:*, obj:*, expiresTimeout:int=-1, overwrite:Boolean=false):void
		{
			if(!key)throw new ArgumentError("Parameter {key} cannot be null.");
			if(!obj)throw new ArgumentError("Parameter {obj} cannot be null.");
			if(!cache[key] || overwrite)
			{
				var cacheItem:CacheItem=new CacheItem(key,obj,purgeItem,expiresTimeout);
				cache[key]=cacheItem;
			}
		}
		
		/**
		 * Test whether or not an object is cached.
		 * 
		 * @param key The key of the object that is cached.
		 */
		public function isCached(key:*):Boolean
		{
			return (!(cache[key]==null));
		}
		
		/**
		 * Get's a cached Object.
		 * 
		 * @param key The key of the object that is cached.
		 */
		public function getCachedObject(key:*):*
		{
			if(!cache[key])throw new Error("No cached item existed for " + key.toString() + " use the isCached() function before calling getCachedItem");
			var item:CacheItem=cache[key] as CacheItem;
			return item.object;
		}
	}
}