package gs.events 
{
	import deng.fzip.FZipFile;
	import flash.events.Event;
	
	/**
	 * The FZipAssetAvailableEvent is dispatched from a preloader
	 * that's loading an FZip asset.
	 */
	public class FZipAssetAvailableEvent extends Event
	{
		
		/**
		 * When a asset in a zip is available.
		 */
		public static const AVAILABLE:String = "available";
		
		/**
		 * The FZipFile that's available.
		 */
		public var file:FZipFile;
		
		/**
		 * Constructor for FZipAssetAvailableEvent
		 * 
		 * @param type The event type.
		 */
		public function FZipAssetAvailableEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false,_file:FZipFile=null)
		{
			super(type,bubbles,cancelable);
			file=_file;
		}
	}
}