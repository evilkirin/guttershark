package gs.preloading.workers
{
	import gs.preloading.Asset;
	import gs.util.XMLLoader;

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;

	/**
	 * The XMLWorker class is the worker that loads all
	 * xml files.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.preloading.Preloader
	 * @see gs.managers.AssetManager
	 */
	final public class XMLWorker extends Worker
	{	
		
		/**
		 * Load an asset of type xml.
		 * 
		 * @param asset The Asset instance that needs to be loaded.
		 */
		public override function load(asset:Asset):void
		{
			this.asset = asset;
			this.request = new URLRequest(asset.source);
			this.loader = new XMLLoader();
			loader.contentLoader.addEventListener(Event.OPEN, super.onOpen,false,0,true);
			loader.contentLoader.addEventListener(ProgressEvent.PROGRESS, super.onProgress,false,0,true);
			loader.contentLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHTTPStatus,false,0,true);
			loader.contentLoader.addEventListener(IOErrorEvent.IO_ERROR, super.onIOLoadError,false,0,true);
			loader.contentLoader.addEventListener(IOErrorEvent.DISK_ERROR, super.onIOLoadError,false,0,true);
			loader.contentLoader.addEventListener(IOErrorEvent.NETWORK_ERROR, super.onIOLoadError,false,0,true);
			loader.contentLoader.addEventListener(IOErrorEvent.VERIFY_ERROR, super.onIOLoadError,false,0,true);
			loader.contentLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityError,false,0,true);
			loader.contentLoader.addEventListener(Event.COMPLETE, super.onComplete,false,0,true);
			start();
		}
	}
}