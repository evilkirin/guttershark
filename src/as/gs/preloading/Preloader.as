package gs.preloading
{
	import gs.events.AssetCompleteEvent;
	import gs.events.AssetErrorEvent;
	import gs.events.AssetOpenEvent;
	import gs.events.AssetProgressEvent;
	import gs.events.AssetStatusEvent;
	import gs.events.PreloadProgressEvent;
	import gs.managers.AssetManager;
	import gs.preloading.workers.Worker;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.setTimeout;

	/**
	 * Dispatched for each asset that has completed downloading.
	 * 
	 * @eventType gs.events.AssetCompleteEvent
	 */
	[Event("assetComplete", type="gs.events.AssetCompleteEvent")]
	
	/**
	 * Dispatched for each asset that has started downloading.
	 * 
	 * @eventType gs.events.AssetOpenEvent
	 */
	[Event("assetOpen", type="gs.events.AssetOpenEvent")]
	
	/**
	 * Dispatched for each asset that has has stopped downloading because of an error.
	 * 
	 * @eventType gs.events.AssetErrorEvent
	 */
	[Event("assetError", type="gs.events.AssetErrorEvent")]
	
	/**
	 * Dispatched for each asset that is downloading.
	 * 
	 * @eventType gs.support.preloading.events.AssetProgressEvent
	 */
	[Event("assetProgress", type="gs.support.preloading.events.AssetProgressEvent")]
	
	/**
	 * Dispatched for each asset that generated an http status code other than 0 or 200.
	 * 
	 * @eventType gs.events.AssetStatusEvent
	 */
	[Event("assetStatus", type="gs.events.AssetStatusEvent")]
	
	/**
	 * Dispatched on progress of the entire Preloader progress.
	 * 
	 * @eventType gs.events.PreloadProgressEvent
	 */
	[Event("preloadProgress", type="gs.events.PreloadProgressEvent")]
	
	/**
	 * Dispatched when the Preloader completes downloading all assets in the queue.
	 * 
	 * @eventType flash.events.Event
	 */
	[Event("complete", type="flash.events.Event")]

	/**
	 * The Preloader class is a controller you use for loading assets.
	 * 
	 * <p>It provides you with methods for starting, stopping, pausing, resuming
	 * and prioritizing of assets, and registers all loaded assets with the asset manager.</p>
	 * 
	 * <p>By default, the Preloader loads all swf's and bitmap's into the same
	 * application domain. Unless specified otherwise in the constructor.</p>
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.managers.AssetManager
	 */
	final public class Preloader extends EventDispatcher
	{
		
		/**
		 * The number of loaded items in this instance of the Preloader.
		 */
		private var loaded:int;
		
		/**
		 * Number of errors in this instance.
		 */
		private var loadErrors:int;

		/**
		 * An array of items to be loaded.
		 */
		private var loadItems:Array;
		
		/**
		 * A duplicate of the original load items. Used internally.
		 */
		private var loadItemsDuplicate:Array;
		
		/**
		 * The currently loading item.
		 */
		private var currentItem:Asset;
		
		/**
		 * A pool of total bytes from each item that is loading
		 * in this instance.
		 */
		private var bytesTotalPool:Array;
		
		/**
		 * A loading pool, each item that is loading has an 
		 * entry in this pool, the entry is it's bytesLoaded.
		 */
		private var bytesLoadedPool:Array;
		
		/**
		 * Stores loading item info (bl / bt)
		 */
		private var loadingItemsPool:Array;
		
		/**
		 * The total pixels to fill for this preloader.
		 */
		private var totalPixelsToFill:int;
		
		/**
		 * Flag used for pausing and resuming
		 */
		private var _working:Boolean;
		
		/**
		 * The last percent update that was dispatched.
		 */
		private var lastPercentUpdate:Number;
		
		/**
		 * The last pixel update that was dispatched.
		 */
		private var lastPixelUpdate:Number;
		
		/**
		 * The last asset that loaded.
		 */
		private var lastCompleteAsset:Asset;
		
		/**
		 * The loader context for all loading.
		 */
		private var loaderContext:LoaderContext;
		
		/**
		 * How many pixels are full.
		 */
		private var _pixelsFull:Number;
		
		/**
		 * Last calculated kbps.
		 */
		private var lastkbps:Number;
		
		/**
		 * Constructor for Preloader instances.
		 * 
		 * @param pixelsToFill The total number of pixels this preloader needs to fill - this is used in calculating both pixels and percent. 
		 * @param loaderContext The loader context for all assets being loaded with this Preloader.
		 */
		public function Preloader(pixelsToFill:int=100,loaderContext:LoaderContext=null)
		{
			if(pixelsToFill<=0)throw new ArgumentError("Pixels to fill must be greater than zero.");
			Worker.RegisterDefaultWorkers();
			if(!loaderContext)this.loaderContext=new LoaderContext(false,ApplicationDomain.currentDomain);
			else this.loaderContext=loaderContext;
			this.loaderContext.checkPolicyFile=true;
			totalPixelsToFill=pixelsToFill;
			bytesTotalPool=[];
			bytesLoadedPool=[];
			loadingItemsPool=[];
			loadItems=[];
			loaded=0;
			loadErrors=0;
			_working=false;
		}
		
		/**
		 * Kilobytes per second of the currently loading asset.
		 */
		public function get kbps():Number
		{
			if(!currentItem&&lastkbps)return lastkbps;
			if(!currentItem&&isNaN(lastkbps))return -1;
			lastkbps=currentItem.kbps;
			return lastkbps;
		}

		/**
		 * Add items to the controller to load - if the preloader is currently working,
		 * these items will be appended to the items to load.
		 * 
		 * @param items An array of Asset instances.
		 */
		public function addItems(items:Array):void
		{
			if(!items)return;
			if(!items[0])return;
			if(!this.loadItems[0])this.loadItems=items.concat();
			else this.loadItems = this.loadItems.concat(items.concat());
			loadItemsDuplicate=loadItems.concat();
		}
		
		/**
		 * Add items to the controller to load, with top priority.
		 * 
		 * @param items An array of Asset instances.
		 */
		public function addPrioritizedItems(items:Array):void
		{
			if(!items)return;
			if(!items[0])return;
			if(!this.loadItems[0])this.loadItems=items.concat();
			else
			{
				var l:int=items.length;
				var i:int=0;
				for(;i<l;i++)this.loadItems.unshift(items[int(i)]);
			}
			loadItemsDuplicate=loadItems.concat();
		}

		/**
		 * Starts loading the assets, and resumes loading from a stopped state.
		 */
		public function start():void
		{
			if(!loadItems[0])
			{
				trace("WARNING: No assets are in the preloader, no preloading will start.");
				return;
			}
			_working=true;
			load();
		}
		
		/**
		 * Stops the preloader and closes the current loading assets.
		 */
		public function stop():void
		{
			currentItem.dispose();
			currentItem=null;
			_working=false;
		}
		
		/**
		 * Pause the preloader.
		 * 
		 * <p>The current item will finish loading but not continue until you start it again.</p>
		 */
		public function pause():void
		{
			_working=false;
		}
		
		/**
		 * Indicates whether or not this controller is doing any preloading.
		 */
		public function get working():Boolean
		{
			return _working;
		}
		
		/**
		 * The number of items left in the preload queue.
		 */
		public function get numLeft():int
		{
			return loadItems.length;
		}
		
		/**
		 * @private
		 */
		public function set pixelsFull(pixels:Number):void
		{
			if(_pixelsFull==pixels)return;
			_pixelsFull=pixels;
		}
		
		/**
		 * Returns the pixels full, based off of how much
		 * has downloaded, and how many pixelsToFill. For
		 * example - if the pixels to fill is 100, and 10%
		 * of the download is complete, this will return 10.
		 */
		public function get pixelsFull():Number
		{
			return _pixelsFull;
		}
		
		/**
		 * Set the number of pixels to fill, useful if
		 * the pixel calculations need to change.
		 */
		public function set pixelsToFill(px:int):void
		{
			totalPixelsToFill=px;
		}
		
		/**
		 * The number of pixels that should be filled.
		 */
		public function get pixelsToFill():int
		{
			return totalPixelsToFill;
		}

		/**
		 * The last completed asset.
		 */
		public function get lastCompletedAsset():Asset
		{
			return lastCompleteAsset;
		}

		/**
		 * Prioritize an asset.
		 * 
		 * @param asset An asset instance that's in the queue to be loaded.
		 */
		public function prioritize(asset:Asset):void
		{
			if(!asset)return;
			if(!asset.source||!asset.libraryName)throw new Error("Both a source and an id must be provided on the Asset to prioritize.");
			var l:int=loadItems.length;
			var i:int=0;
			for(;i<l;i++)
			{
				var item:Asset=Asset(loadItems[int(i)]);
				if(item.source==asset.source)
				{
					var litem:Asset=loadItems.splice(int(i),1)[0] as Asset;
					loadItems.unshift(litem);
					return;
				}
			}
		}
		
		/**
		 * Recursively called to load each item in the queue.
		 */
		private function load():void
		{
			if(!_working)return;
			var item:Asset=Asset(this.loadItems.shift());
			currentItem=item;
			loadingItemsPool[item.source]=item;
			item.load(this,loaderContext);
		}
		
		/**
		 * Internal method used to send out updates.
		 */
		private function updateStatus():void
		{
			var pixelPool:Number=0;
			var pixelContributionPerItem:Number=Math.ceil(totalPixelsToFill/(loadItemsDuplicate.length-loadErrors));
			var pixelUpdate:Number;
			var percentUpdate:Number;
			var key:String;
			for(key in loadingItemsPool)
			{
				var bl:* =bytesLoadedPool[key];
				var bt:* =bytesTotalPool[key];
				if(bl==undefined||bt==undefined)continue;
				var pixelsForItem:Number=Math.ceil((bl/bt)*pixelContributionPerItem);
				//trace("update: key: " + key + " bl: " + bl.toString() + " bt: " + bt.toString() + " pixelsForItem: " + pixelsForItem);
				pixelPool+=pixelsForItem;
			}
			pixelUpdate=pixelPool;
			percentUpdate=Math.ceil((pixelPool/totalPixelsToFill)*100);
			if(lastPixelUpdate>0&&lastPercentUpdate>0&&lastPixelUpdate==pixelUpdate&&lastPercentUpdate==percentUpdate)return;
			if(pixelUpdate>=pixelsToFill)return;
			lastPixelUpdate=pixelUpdate;
			lastPercentUpdate=percentUpdate;
			this.pixelsFull=pixelUpdate;
			dispatchEvent(new PreloadProgressEvent(PreloadProgressEvent.PROGRESS,pixelUpdate,percentUpdate));
		}
		
		/**
		 * This is used to check the status of this preloader.
		 */
		private function updateLoading():void
		{
			if(loadItems.length>0)load();
			else if((loaded+loadErrors)>=(loadItems.length))
			{	
				_working=false;
				pixelsFull=totalPixelsToFill;
				dispatchEvent(new PreloadProgressEvent(PreloadProgressEvent.PROGRESS,totalPixelsToFill,100));
				dispatchEvent(new Event(Event.COMPLETE));
				setTimeout(reset,150);
				//new FrameDelay(reset,2);
			}
		}
		
		/**
		 * Resets internal state so the Preloader
		 * can be re-used if needed.
		 */
		public function reset():void
		{
			loadErrors=0;
			loaded=0;
			loadItems=[];
			loadItemsDuplicate=[];
			bytesTotalPool=[];
			bytesLoadedPool=[];
			if(currentItem)currentItem.dispose();
			currentItem=null;
			if(lastCompletedAsset)lastCompleteAsset.dispose();
			lastCompleteAsset=null;
		}
		
		/**
		 * Dispose of this preloader.
		 */
		public function dispose():void
		{
			loadErrors=0;
			loaded=0;
			loadItems=null;
			loadItemsDuplicate=null;
			bytesTotalPool=null;
			bytesLoadedPool=null;
			if(currentItem)currentItem.dispose();
			currentItem=null;
			if(lastCompletedAsset)lastCompleteAsset.dispose();
			lastCompleteAsset=null;
			loaderContext=null;
		}

		/**
		 * @private
		 * 
		 * Every Asset in the queue calls this method on it's progress event.
		 * 
		 * @param pe AssetProgressEvent
		 */
		public function progress(pe:AssetProgressEvent):void
		{
			var item:Asset=Asset(pe.asset);
			var source:String=pe.asset.source;
			if(item.bytesTotal<0||isNaN(item.bytesTotal))return;
			else if(item.bytesLoaded<0||isNaN(item.bytesLoaded))return;
			if(!bytesTotalPool[source])bytesTotalPool[source]=item.bytesTotal;
			bytesLoadedPool[source]=item.bytesLoaded;
			dispatchEvent(new AssetProgressEvent(AssetProgressEvent.PROGRESS,pe.asset));
			updateStatus();
		}
		
		/**
		 * @private
		 * 
		 * Each item calls this method on it's complete.
		 * 
		 * @param e AssetCompleteEvent
		 */
		public function complete(e:AssetCompleteEvent):void
		{
			loaded++;
			lastCompleteAsset=e.asset;
			AssetManager.addAsset(e.asset.libraryName,e.asset.data,e.asset.source);
			dispatchEvent(new AssetCompleteEvent(AssetCompleteEvent.COMPLETE,e.asset));
			updateStatus();
			updateLoading();
		}
		
		/**
		 * @private
		 * 
		 * Each item calls this method on any load errors.
		 * 
		 * @param e AssetErrorEvent
		 */
		public function error(e:AssetErrorEvent):void
		{
			trace("Error loading: "+e.asset.source);
			loadErrors++;
			updateStatus();
			updateLoading();
			dispatchEvent(new AssetErrorEvent(AssetErrorEvent.ERROR,e.asset));
		}
		
		/**
		 * @private
		 * 
		 * Each item calls this method on an http status that is
		 * not 0 or 200.
		 * 
		 * @param e AssetStatusEvent
		 */
		public function httpStatus(e:AssetStatusEvent):void
		{
			trace("Error loading: "+e.asset.source);
			loadErrors++;
			updateStatus();
			updateLoading();
			dispatchEvent(new AssetStatusEvent(AssetStatusEvent.STATUS,e.asset,e.status));
		}

		/**
		 * @private
		 * 
		 * Each item calls this method when it starts downloading.
		 * 
		 * @param e AssetOpenEvent
		 */
		public function open(e:AssetOpenEvent):void
		{
			dispatchEvent(new AssetOpenEvent(AssetOpenEvent.OPEN,e.asset));
		}
	}
}