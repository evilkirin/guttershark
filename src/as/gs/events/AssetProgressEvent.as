package gs.events
{
	import flash.events.Event;
	
	import gs.preloading.Asset;

	/**
	 * The AssetProgressEvent dispatches for an Asset that is downloading.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.preloading.Preloader
	 * @see gs.managers.AssetManager
	 */
	final public class AssetProgressEvent extends Event
	{ 
		
		/**
		 * Defines the value of the type property of the assetProgress event type.
		 */
		public static const PROGRESS:String = "assetProgress";
		
		/**
		 * The asset that is loading.
		 */
		public var asset:Asset;
		
		/**
		 * Constructor for AssetProgressEvent instances.
		 * 
		 * @param type The type.
		 * @param asset	The Asset that is downloading.
		 */
		public function AssetProgressEvent(type:String, asset:Asset)
		{
			super(type,false,false);
			this.asset = asset;
		}
		
		/**
		 * Clone this AssetProgressEvent.
		 */
		override public function clone():Event
		{
			return new AssetProgressEvent(type,asset);
		}
		
		/**
		 * To string override for descriptions.
		 */
		override public function toString():String
		{
			return "[AssetProgressEvent asset:"+asset.source+"]";
		}
	}
}