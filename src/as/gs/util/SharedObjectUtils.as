package gs.util 
{

	import flash.utils.Dictionary;
	import flash.net.SharedObject;
	
	/**
	 * The SharedObjectUtils class contains utility methods for working with
	 * shared objects.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class SharedObjectUtils 
	{
		
		/**
		 * Shared object lookup.
		 */
		private static var _sos:Dictionary;
		
		/**
		 * Restores a shared object then set it with the lookup.
		 * 
		 * @param id The id to save the shared object as.
		 * @param sokey The shared object key.
		 */
		public static function restoreAndSet(id:String,sokey:String):SharedObject
		{
			var so:SharedObject=SharedObject.getLocal(sokey);
			set(id,so);
			return so;
		}
		
		/**
		 * Set a shared object.
		 * 
		 * @param id The id of the shared object.
		 * @param so The shared object.
		 */
		public static function set(id:String,so:SharedObject):void
		{
			if(!_sos)_sos=new Dictionary();
			_sos[id]=so;
		}
		
		/**
		 * Get a saved shared object.
		 * 
		 * @param id The id of the shared object.
		 */
		public static function get(id:String):SharedObject
		{
			if(!_sos)return null;
			return _sos[id];
		}
		
		/**
		 * Unset a shared object.
		 * 
		 * @param id The id of the shared object.
		 */
		public function unset(id:String):void
		{
			if(!_sos)return;
			delete _sos[id];
		}
	}
}