package gs.util 
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	/**
	 * The FlashvarUtils class contains utility methods for working
	 * with flashvars.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class FlashvarUtils 
	{
		
		/**
		 * flashvar lookup.
		 */
		private static var _fvs:Dictionary;
		
		/**
		 * Returns the "flashvars" associated with the object passed, or calls
		 * the "flashvarsForStandalone" method if the swf is running in standalone.
		 * 
		 * @param obj A display object.
		 * @param flashvarsForStandalone A function to retrieve "standalone flashvars" from.
		 * @param zincReturnsStandaloneFlashvars Whether or not the zinc player should return standalone flashvars
		 * - note that you need to use <code>PlayerUtils.gi().isZinc = true</code>.
		 */
		public static function getFlashvars(obj:DisplayObject,flashvarsForStandalone:Function=null,zincReturnsStandaloneFlashvars:Boolean=false):Object
		{
			if(flashvarsForStandalone!= null && (PlayerUtils.isStandAlonePlayer()||PlayerUtils.isIDEPlayer())) return flashvarsForStandalone();
			else if(flashvarsForStandalone!= null && (zincReturnsStandaloneFlashvars && PlayerUtils.isZinc)) return flashvarsForStandalone();
			else if(flashvarsForStandalone!= null && PlayerUtils.isAirApplication()) return flashvarsForStandalone();
			else return obj.root.loaderInfo.parameters;
		}
		
		/**
		 * Gets, and sets the "flashvars" associated with the object passed, or calls
		 * the "flashvarsForStandalone" method if the swf is running in standalone.
		 * 
		 * @param id The id of the flashvar object.
		 * @param obj A display object.
		 * @param flashvarsForStandalone A function to retrieve "standalone flashvars" from.
		 * @param zincReturnsStandaloneFlashvars Whether or not the zinc player should return standalone flashvars
		 * - note that you need to use <code>PlayerUtils.gi().isZinc = true</code>.
		 */
		public static function getAndSetFlashvars(id:String,obj:DisplayObject,flashvarsForStandalone:Function,zincReturnsStandaloneFlashvars:Boolean=false):Object
		{
			var vars:Object;
			if(PlayerUtils.isStandAlonePlayer()||PlayerUtils.isIDEPlayer()) vars=flashvarsForStandalone();
			else if(zincReturnsStandaloneFlashvars && PlayerUtils.isZinc) vars=flashvarsForStandalone();
			else vars=obj.root.loaderInfo.parameters;
			FlashvarUtils.set(id,vars);
			return vars;
		}
		
		/**
		 * Set a flashvars object.
		 * 
		 * @param id The id of the flashvars.
		 * @param flashvars The flashvars object.
		 */
		public static function set(id:String, flashvars:Object):void
		{
			if(!_fvs)_fvs=new Dictionary();
			_fvs[id]=flashvars;
		}
		
		/**
		 * Get a flashvars object.
		 * 
		 * @param id The id of the flashvars.
		 */
		public static function get(id:String):Object
		{
			if(!_fvs)return null;
			return _fvs[id];
		}
		
		/**
		 * Unset a flashvars object.
		 * 
		 * @param id The id of the flashvars.
		 */
		public static function unset(id:String):void
		{
			if(!_fvs) return;
			delete _fvs[id];
		}
	}
}