package gs.support.preloading.workers 
{
	import gs.support.preloading.Asset;

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * The JSONWorker class is a worker that's used to load
	 * some URL that's JSON.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.core.Preloader
	 * @see gs.managers.AssetManager
	 */
	final public class JSONWorker extends Worker
	{	
		
		/**
		 * Load an asset of type json.
		 * 
		 * @param asset The Asset instance that needs to be loaded.
		 */
		public override function load(asset:Asset):void
		{
			this.asset = asset;
			this.request = new URLRequest(asset.source);
			this.loader = new URLLoader();
			loader.addEventListener(Event.OPEN, super.onOpen,false,0,true);
			loader.addEventListener(ProgressEvent.PROGRESS, super.onProgress,false,0,true);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHTTPStatus,false,0,true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, super.onIOLoadError,false,0,true);
			loader.addEventListener(IOErrorEvent.DISK_ERROR, super.onIOLoadError,false,0,true);
			loader.addEventListener(IOErrorEvent.NETWORK_ERROR, super.onIOLoadError,false,0,true);
			loader.addEventListener(IOErrorEvent.VERIFY_ERROR, super.onIOLoadError,false,0,true);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityError,false,0,true);
			loader.addEventListener(Event.COMPLETE, super.onComplete,false,0,true);
			start();
		}
	}
}