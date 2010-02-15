package gs.core 
{
	import gs.managers.AssetManager;
	import gs.managers.TrackingManager;
	import gs.util.FlashvarUtils;
	import gs.util.StageRef;
	import gs.util.Strings;

	import flash.events.Event;

	/**
	 * The DocumentController class is a document class
	 * that contains default startup logic.
	 */
	public class DocumentController extends Document
	{
		
		/**
		 * Flashvars.
		 */
		protected var flashvars:Object;
		
		/**
		 * A model instance.
		 */
		protected var model:Model;
		
		/**
		 * A tracking manager instance.
		 */
		protected var tracking:TrackingManager;
		
		/**
		 * A preloader instance.
		 */
		protected var preloader:Preloader;
		
		/**
		 * Constructor for DocumentController instances.
		 * 
		 * @example
		 * <listing>	
		 * public function DocumentController()
		 * {
		 *     initStage();
		 *     initFlashvars();
		 *     initModel();
		 *     initPaths();
		 * } 
		 * </listing>
		 */
		public function DocumentController()
		{
			initStage();
			initFlashvars();
			initModel();
			initPaths();
		}
		
		/**
		 * Returns an object for standalone flashvars.
		 * 
		 * @example
		 * <listing>	
		 * protected function flashvarsForStandalone():Object
		 * {
		 *     return {};
		 * }
		 * </listing>
		 */
		protected function flashvarsForStandalone():Object
		{
			return {};
		}
		
		/**
		 * Initialize the StageRef.stage property.
		 * 
		 * @example
		 * <listing>	
		 * protected function initStage():void
		 * {
		 *     StageRef.stage=stage;
		 * }
		 * </listing>
		 */
		protected function initStage():void
		{
			StageRef.stage=stage;
		}

		/**
		 * Initialize flashvars.
		 * 
		 * @example
		 * <listing>	
		 * protected function initFlashvars():void
		 * {
		 *     flashvars=FlashvarUtils.getFlashvars(this,flashvarsForStandalone);
		 * }
		 * </listing>
		 */
		protected function initFlashvars():void
		{
			flashvars=FlashvarUtils.getFlashvars(this,flashvarsForStandalone);
		}
		
		/**
		 * Initialize paths with the model.
		 * 
		 * @example
		 * <listing>	
		 * protected function initPaths():void
		 * {
		 *     if(model)
		 *     {
		 *         model.addPath("audio","../audio/");
		 *         model.addPath("bmp","../bmp/");
		 *         model.addPath("css","../css/");
		 *         model.addPath("flv","../flv/");
		 *         model.addPath("js","../js/");
		 *         model.addPath("swf","../swf/");
		 *         model.addPath("xml","../xml/");
		 *     }
		 * }
		 * </listing>
		 */
		protected function initPaths():void
		{
			if(model)
			{
				model.addPath("audio",(flashvars.audio)?flashvars.audio:"../audio/");
				model.addPath("bmp",(flashvars.bmp)?flashvars.bmp:"../bmp/");
				model.addPath("css",(flashvars.css)?flashvars.css:"../css/");
				model.addPath("flv",(flashvars.flv)?flashvars.flv:"../flv/");
				model.addPath("js",(flashvars.js)?flashvars.js:"../js/");
				model.addPath("swf",(flashvars.swf)?flashvars.swf:"../swf/");
				model.addPath("xml",(flashvars.xml)?flashvars.xml:"../xml/");
			}
		}
		
		/**
		 * Create and load a model.
		 * 
		 * @example
		 * <listing>	
		 * protected function initModel():void
		 * {
		 *     model=new Model();
		 *     model.loadModel(flashvars.model,onModelReady);
		 * }
		 * </listing>
		 */
		protected function initModel():void
		{
			model=new Model();
			if(flashvars.model)model.loadModel(flashvars.model,onModelReady);
			else onModelReady();
		}
		
		/**
		 * When a model is ready.
		 * 
		 * @example
		 * <listing>
		 * protected function onModelReady():void
		 * {
		 *     setupComplete();
		 *     startPreload();
		 * }	
		 * </listing>
		 */
		protected function onModelReady():void
		{
			setupComplete();
			startPreload();
		}
		
		/**
		 * A hook to start preloading.
		 */
		protected function startPreload():void{}
		
		/**
		 * Override this to write preload complete logic.
		 * 
		 * @example
		 * <listing>	
		 * protected function onPreloadComplete(e:Event):void
		 * {
		 *     model.registerFonts();
		 *     initStrings();
		 *     initTracking();
		 *     registerInstances();
		 * }
	     * </listing>
		 */
		protected function onPreloadComplete(e:Event):void
		{
			model.registerFonts();
			initStrings();
			initTracking();
			registerInstances();
		}
		
		/**
		 * A hook you can override to register instances with their
		 * classes.
		 * 
		 * @example
		 * <listing>	
		 * protected function registerInstances():void
		 * {
		 *      if(model)Model.set("main",model);
		 *      if(tracking)TrackingManager.set("main",tracking);
		 *      if(flashvars)Flashvars.set("main",flashvars);
		 *      Document.set("main",this);
		 * }
		 * </listing>
		 */
		protected function registerInstances():void
		{
			if(model)Model.set("main",model);
			if(tracking)TrackingManager.set("main",tracking);
			if(flashvars)FlashvarUtils.set("main",flashvars);
			Document.set("main",this);
		}
		
		/**
		 * Initialize a Strings instance on the model.
		 * 
		 * <p>If an asset is available in the AssetManager called
		 * "strings" it will initialize the model.strings property for you</p>
		 * 
		 * @example
		 * <listing>	
		 * protected function initStrings():void
		 * {
		 *     if(AssetManager.isAvailable("strings") && model)model.strings=new Strings(AssetManager.getXML("strings"));
		 * }
		 * </listing>
		 */
		protected function initStrings():void
		{
			if(AssetManager.isAvailable("strings") && model)model.strings=new Strings(AssetManager.getXML("strings"));
		}
		
		/**
		 * Initialize a tracking manager.
		 * 
		 * <p>If an asset is available in the AssetManager called
		 * "tracking" it will initialize the tracking property for you</p>
		 * 
		 * @example
		 * <listing>	
		 * protected function initTracking():void
		 * {
		 *     if(AssetManager.isAvailable("tracking"))tracking=new TrackingManager(AssetManager.getXML("tracking"));
		 * }
		 * </listing>
		 */
		protected function initTracking():void
		{
			if(AssetManager.isAvailable("tracking"))tracking=new TrackingManager(AssetManager.getXML("tracking"));
		}
		
		/**
		 * A hook called just before the startPreload method is called.
		 * 
		 * <p>This is called after initStage, initFlashvars, and
		 * after a model has loaded.</p>
		 */
		protected function setupComplete():void{}
		
		/**
		 * Dispose of this document controller.
		 */
		override public function dispose():void
		{
			tracking.dispose();
			model.dispose();
			preloader.dispose();
			preloader=null;
			model=null;
			tracking=null;
			flashvars=null;
		}
	}
}