package gs.events
{
	import flash.events.Event;
	
	import gs.preloading.Asset;

	/**
	 * The AssetErrorEvent dispatches when an asset has stopped loading due to an error.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.preloading.Preloader
	 * @see gs.managers.AssetManager
	 */
	final public class AssetErrorEvent extends Event
	{ 
		
		/**
		 * Defines the value of the type propert yof the assetError event type.
		 */
		public static const ERROR:String = "assetError";
		
		/**
		 * The Asset that errored out.
		 */
		public var asset:Asset;
		
		/**
		 * Constructor for AssetErrorEvent instances.
		 * 
		 * @param type The event type.
		 * @param asset	The Asset that errored out.
		 */
		public function AssetErrorEvent(type:String, asset:Asset)
		{
			super(type,false,false);
			this.asset = asset;
		}
		
		/**
		 * Clone this AssetErrorEvent.
		 */
		override public function clone():Event
		{
			return new AssetErrorEvent(type,asset);
		}
		
		/**
		 * To string override for descriptions.
		 */
		override public function toString():String
		{
			return "[AssetErrorEvent asset:"+asset.source+"]";
		}
	}
}