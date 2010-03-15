package gs.preloading
{
	import gs.events.AssetCompleteEvent;
	import gs.events.AssetErrorEvent;
	import gs.events.AssetOpenEvent;
	import gs.events.AssetProgressEvent;
	import gs.events.AssetStatusEvent;
	import gs.preloading.Preloader;
	import gs.preloading.workers.Worker;
	import gs.util.StringUtils;

	import flash.events.SecurityErrorEvent;
	import flash.system.LoaderContext;
	import flash.utils.getTimer;

	/**
	 * The Asset class is an asset a Preloader uses.
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.core.Preloader
	 * @see gs.managers.AssetManager
	 */
	final public class Asset
	{

		/**
		 * The controller that receives updates from this item.
		 */
		private var controller:Preloader;

		/**
		 * The worker that is doing the loading work.
		 */
		private var worker:*;
		
		/**
		 * The file type of this asset. This will be a file extension less the period (jpg).
		 */
		public var fileType:String;
		
		/**
		 * The URI to the file to load.
		 */
		public var source:String;
		
		/**
		 * The identifier of this item in the AssetManager
		 */
		public var libraryName:String;
		
		/**
		 * The data for this asset after the asset has been loaded. 
		 * 
		 * <p>This will be a reference to the loader that was used
		 * in loading the data.</p>
		 */
		public var data:*;
		
		/**
		 * Download start time.
		 */
		private var startTime:Number;
		
		/**
		 * Constructor for Asset instances.
		 * 
		 * @param source The source URL to the asset.
		 * @param libraryName The name to be used in the AssetManager.
		 * @param forceType Force the asset's type (jpg,jpeg,bmp,png,gif,mp3,xml,swf,flv,m4v,mp4,json,zip,txt,text).
		 */
		public function Asset(source:String, libraryName:String = null, forceType:String = null)
		{
			if(!forceType)
			{
				var fileType:String=StringUtils.findFileType(source);
				if(!fileType)throw new Error("The filetype could not be found for this item: " + source);
				this.fileType=fileType;
			}
			else this.fileType=forceType;
			this.source = source;
			if(!libraryName)
			{
				trace("WARNING: No library name was supplied for asset with source {"+source+"} using the source as the libraryName");
				this.libraryName=source;
			}
			else this.libraryName=libraryName;
		}
		
		/**
		 * @private
		 * 
		 * Starts the load process for this item.
		 * 
		 * @param controller A Preloader that is controlling this asset.
		 * @param loaderContext A loader context object.
		 */
		public function load(controller:Preloader,loaderContext:LoaderContext=null):void
		{
			this.controller=controller;
			worker=Worker.GetWorkerInstance(fileType);
			addListenersToWorker();
			worker.loaderContext=loaderContext;
			worker.load(this);
			startTime=getTimer();
		}
		
		/**
		 * removes listeners
		 */
		private function removeListenersFromWorker():void
		{
			if(!worker) return;
			worker.removeEventListener(AssetCompleteEvent.COMPLETE,onComplete);
			worker.removeEventListener(AssetProgressEvent.PROGRESS,controller.progress);
			worker.removeEventListener(AssetErrorEvent.ERROR,onError);
			worker.removeEventListener(AssetOpenEvent.OPEN,controller.open);
			worker.removeEventListener(AssetStatusEvent.STATUS,onHTTPStatus);
			worker.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
		}
		
		/**
		 * adds listeners
		 */
		private function addListenersToWorker():void
		{
			if(!worker) return;
			worker.addEventListener(AssetCompleteEvent.COMPLETE,onComplete);
			worker.addEventListener(AssetProgressEvent.PROGRESS,controller.progress);
			worker.addEventListener(AssetErrorEvent.ERROR,onError);
			worker.addEventListener(AssetOpenEvent.OPEN,controller.open);
			worker.addEventListener(AssetStatusEvent.STATUS,onHTTPStatus);
			worker.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
		}
		
		/**
		 * On complete
		 */
		private function onComplete(e:AssetCompleteEvent):void
		{
			controller.complete(e);
			dispose();
		}
		
		/**
		 * On error.
		 */
		private function onError(e:AssetErrorEvent):void
		{
			if(!controller)
			{
				dispose();
				return;
			}
			controller.error(e);
			dispose();
		}
		
		/**
		 * On http status.
		 */
		private function onHTTPStatus(h:AssetStatusEvent):void
		{
			if(!controller)
			{
				dispose();
				return;
			}
			controller.httpStatus(h);
			dispose();
		}
		
		/**
		 * Handles security error, the controller doesn't specifically handle it.
		 */
		private function onSecurityError(se:SecurityError):void
		{
			dispose();
			throw se;
		}
		
		/**
		 * @private
		 * kilobytes per second.
		 */
		public function get kbps():Number
		{
			return worker.bytesLoaded/(getTimer()-startTime);
		}
		
		/**
		 * @private
		 * 
		 * Returns the bytes loaded for this item.
		 */
		public function get bytesLoaded():Number
		{
			return worker.bytesLoaded;
		}
		
		/**
		 * @private
		 * 
		 * Returns the bytes total for this item.
		 */
		public function get bytesTotal():Number
		{
			return worker.bytesTotal;
		}
		
		/**
		 * Dispose of this asset.
		 */
		public function dispose():void
		{
			removeListenersFromWorker();
			if(worker) worker.dispose();
			worker = null;
			controller = null;
			libraryName = null;
			fileType = null;
		}
	}
}