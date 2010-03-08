package gs.preloading.workers
{
	import gs.preloading.Asset;

	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;

	/**
	 * The BitmapWorker class is the worker that loads all
	 * assets that are considered bitmap files.
	 *	
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 *	
	 * @see gs.preloading.Preloader
	 * @see gs.managers.AssetManager
	 */
	public class BitmapWorker extends Worker
	{	
		
		/**
		 * Load an asset of type bitmap.
		 * 
		 * @param asset The Asset instance that needs to be loaded.
		 */
		override public function load(asset:Asset):void
		{
			this.asset = asset;
			request = new URLRequest(asset.source);
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.OPEN, super.onOpen,false,0,true);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, super.onProgress,false,0,true);
			loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHTTPStatus,false,0,true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, super.onIOLoadError,false,0,true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.DISK_ERROR, super.onIOLoadError,false,0,true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, super.onIOLoadError,false,0,true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.VERIFY_ERROR, super.onIOLoadError,false,0,true);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityError,false,0,true);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, super.onComplete,false,0,true);
			start();
		}
	}
}