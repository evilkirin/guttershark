package gs.events
{
	import flash.events.Event;
	
	import gs.preloading.Asset;

	/**
	 * The AssetStatusEvent dispatches for an Asset that had an HTTP status other than 0 or 200.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.preloading.Preloader
	 * @see gs.managers.AssetManager
	 */
	final public class AssetStatusEvent extends Event
	{ 
		/**
		 * Defines the value of the type property of the assetStatus event type.
		 */
		public static const STATUS:String = "assetStatus";
		
		/**
		 * The Asset that had the status error.
		 */
		public var asset:Asset;
		
		/**
		 * The status code.
		 */
		public var status:int;
		
		/**
		 * Constructor for AssetStatusEvent instances.
		 * 
		 * @param type The type.
		 * @param asset The Asset that triggered the status event.
		 * @param int The status code of the event.
		 */
		public function AssetStatusEvent(type:String, asset:Asset, status:int)
		{
			super(type,false,false);
			this.asset = asset;
			this.status = status;
		}
		
		/**
		 * Clone this AssetStatusEvent.
		 */
		override public function clone():Event
		{
			return new AssetStatusEvent(type,asset,status);
		}
		
		/**
		 * To string override for descriptions.
		 */
		override public function toString():String
		{
			return "[AssetStatusEvent asset:"+asset.source+"]";
		}
	}
}