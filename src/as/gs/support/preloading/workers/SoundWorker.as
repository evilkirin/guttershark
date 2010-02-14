package gs.support.preloading.workers
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	import gs.support.preloading.Asset;
		
	/**
	 * The SoundWorker class is the worker loads all
	 * sound files.
	 * 
	 * <p>This class is not used directly. It is used internally to an
	 * Asset instance.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.core.Preloader
	 * @see gs.managers.AssetManager
	 */
	final public class SoundWorker extends Worker
	{
		
		/**
		 * Load an asset of type mp3 or aif.
		 * 
		 * @param asset The Asset instance that needs to be loaded.
		 */
		public override function load(asset:Asset):void
		{
			this.loader = new Sound();
			this.asset = asset;
			this.request = new URLRequest(asset.source);
			loader.addEventListener(Event.COMPLETE, onComplete,false,0,true);
			loader.addEventListener(ProgressEvent.PROGRESS, onProgress,false,0,true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOLoadError,false,0,true);
			loader.addEventListener(IOErrorEvent.DISK_ERROR, onIOLoadError,false,0,true);
			loader.addEventListener(IOErrorEvent.NETWORK_ERROR, onIOLoadError,false,0,true);
			loader.addEventListener(IOErrorEvent.VERIFY_ERROR, onIOLoadError,false,0,true);
			loader.addEventListener(Event.OPEN, onOpen,false,0,true);
			start();
		}
	}
}