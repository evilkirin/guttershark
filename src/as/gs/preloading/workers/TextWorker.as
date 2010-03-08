package gs.preloading.workers
{
	import gs.preloading.Asset;

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * The TextWorker class is a worker used to load any source
	 * that is treated as raw text. Anything can be done with
	 * the loaded text.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.preloading.Preloader
	 * @see gs.managers.AssetManager
	 */
	final public class TextWorker extends Worker
	{	
		
		/**
		 * Load an asset that is treated as text.
		 * 
		 * @param asset The Asset instance that needs to be loaded.
		 */
		public override function load(asset:Asset):void
		{
			this.asset=asset;
			this.request=new URLRequest(asset.source);
			this.loader=new URLLoader();
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