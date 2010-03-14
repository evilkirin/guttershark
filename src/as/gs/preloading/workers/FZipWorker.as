package gs.preloading.workers 
{
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;

	import gs.events.FZipAssetAvailableEvent;
	import gs.preloading.Asset;
	import gs.util.Disposer;

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	/**
	 * The FZipWorker class does the work of loading
	 * an FZip file.
	 * 
	 * @see http://codeazur.com.br/lab/fzip/
	 */
	public class FZipWorker extends Worker
	{
		
		/**
		 * Disposer for internal objects.
		 */
		private var disposer:Disposer;
		
		/**
		 * A hash lookup for files that were already loaded,
		 * so that duplicate events aren't dispatched.
		 */
		private var loaded:Dictionary;
		
		/**
		 * Timer for tick events to dispatch file available
		 * events.
		 */
		private var tick:Timer;
		
		/**
		 * @inheritDoc
		 */
		override public function load(asset:Asset):void
		{
			disposer=new Disposer();
			this.asset=asset;
			loaded=new Dictionary();
			tick=new Timer(1000);
			tick.addEventListener(TimerEvent.TIMER,_onTimer);
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
			loader.addEventListener(Event.COMPLETE,onComplete,false,0,true);
			tick.start();
			start();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function onComplete(e:Event):void
		{
			dispatchCompletes();
			super.onComplete(e);
		}
		
		/**
		 * Dispatches asset available events for the
		 * fzip.
		 */
		private function dispatchCompletes():void
		{
			var zip:FZip=FZip(loader);
			var i:int=0;
			var l:int=zip.getFileCount();
			for(;i<l;i++)
			{
				var file:FZipFile=zip.getFileAt(i);
				if(loaded[file])continue;
				loaded[file]=true;
				dispatchEvent(new FZipAssetAvailableEvent(FZipAssetAvailableEvent.AVAILABLE,false,false,file));
			}
		}
		
		/**
		 * tick
		 */
		private function _onTimer(e:TimerEvent):void
		{
			dispatchCompletes();
		}
		
		/**
		 * Dispose of this FZipWorker.
		 */
		override public function dispose():void
		{
			tick.stop();
			tick.removeEventListener(TimerEvent.TIMER,_onTimer);
			disposer.clearvars(this,"loaded","disposer","tick");
			disposer.dispose();
			super.dispose();
		}
	}
}