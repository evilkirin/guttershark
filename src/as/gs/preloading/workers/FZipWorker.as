package gs.preloading.workers 
{
	import deng.fzip.FZip;

	import gs.preloading.Asset;

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;

	/**
	 * The FZipWorker class does the work of loading
	 * an FZip file.
	 * 
	 * @see http://codeazur.com.br/lab/fzip/
	 */
	public class FZipWorker extends Worker
	{
		
		/**
		 * @inheritDoc
		 */
		override public function load(asset:Asset):void
		{
			this.asset=asset;
			request=new URLRequest(asset.source);
			loader=new FZip();
			loader.addEventListener(Event.OPEN,super.onOpen,false,0,true);
			loader.addEventListener(ProgressEvent.PROGRESS,super.onProgress,false,0,true);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,super.onHTTPStatus,false,0,true);
			loader.addEventListener(IOErrorEvent.IO_ERROR,super.onIOLoadError,false,0,true);
			loader.addEventListener(IOErrorEvent.DISK_ERROR,super.onIOLoadError,false,0,true);
			loader.addEventListener(IOErrorEvent.NETWORK_ERROR,super.onIOLoadError,false,0,true);
			loader.addEventListener(IOErrorEvent.VERIFY_ERROR,super.onIOLoadError,false,0,true);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,super.onSecurityError,false,0,true);
			loader.addEventListener(Event.COMPLETE,super.onComplete,false,0,true);
			start();
		}
	}
}