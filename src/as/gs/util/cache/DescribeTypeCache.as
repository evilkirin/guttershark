package gs.util.cache 
{
	
	/**
	 * The DescribeType classs wraps the flash.util.describeType
	 * function and caches all object descriptions so that
	 * describeType will only be called once for any object.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class DescribeTypeCache 
	{
		
		/**
		 * Singleton instance.
		 */
		private static var inst:DescribeTypeCache;
		
		/**
		 * The type cache.
		 */
		private var dcache:Cache;
		
		/**
		 * Singleton access.
		 */
		public static function gi():DescribeTypeCache
		{
			if(!inst)inst=new DescribeTypeCache();
			return inst;
		}
		
		/**
		 * @private
		 */
		public function DescribeTypeCache()
		{
			dcache=new Cache();
		}
		
		/**
		 * Returns the type description for an object.
		 * 
		 * @param obj The object to describe.
		 */
		public function describeType(obj:*):XML
		{
			var x:XML;
			if(dcache.isCached(obj)) x=dcache.getCachedObject(obj);
			else
			{
				x=describeType(obj);
				dcache.cacheObject(obj,x);
			}
			return x;
		}
	}
}