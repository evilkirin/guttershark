package gs.tracking 
{
	import gs.util.XMLUtils;

	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * The Tracking class simplifies tracking.
	 */
	public class Tracking
	{
		
		/**
		 * Instances.
		 */
		private static var insts:Dictionary=new Dictionary();
		
		/**
		 * Tracking instance id.
		 */
		public var id:String;
		
		/**
		 * The tracking xml.
		 */
		public var xml:XML;
		
		/**
		 * An instance of Omniture. You need to set this if
		 * you're expecting to fire omniture tracking events.
		 */
		public var omniture:Omniture;
		
		/**
		 * An instance of Webtrends. You need to set this if
		 * you're expecting to fire webtrends. tracking events.
		 */
		public var webtrends:Webtrends;
		
		/**
		 * An instance of Hitbox. You need to set this if
		 * you're expecting to fire hitbox tracking events.
		 */
		public var hitbox:Hitbox;
		
		/**
		 * Storage for tracking handlers.
		 */
		private var tracks:Array;
		
		/**
		 * Constructor for Tracking instances.
		 * 
		 * @param _xml The tracking xml.
		 */
		public function Tracking(_xml:XML)
		{
			if(!_xml)throw new ArgumentError("ERROR: Argument {_xml} cannot be null.");
			xml=_xml;
			tracks=[];
		}
		
		/**
		 * Get a saved Tracking instance.
		 * 
		 * @param id The tracking instance id.
		 */
		public static function get(id:String):Tracking
		{
			return insts[id];
		}
		
		/**
		 * Save a tracking instance.
		 * 
		 * @param id The tracking instance id.
		 */
		public static function set(id:String,tracking:Tracking):void
		{
			if(!id || !tracking)return;
			tracking.id=id;
			insts[id]=tracking;
		}
		
		/**
		 * Unset (delete) a tracking instance.
		 * 
		 * @param id The tracking instance id.
		 */
		public static function unset(id:String):void
		{
			if(!id)return;
			delete insts[id];
		}
		
		/**
		 * Register an object to fire an event.
		 * 
		 * @param obj The object that fires the event to track.
		 * @param event The event that triggers the tracking to fire.
		 * @param id The tracking id from the tracking xml.
		 * @param options Options associated with the tracking event.
		 */
		public function register(obj:IEventDispatcher,event:String,id:String,options:Object = null):void
		{
			tracks.push(new TrackingHandler(this,id,obj,event,options));
		}
		
		/**
		 * Manually fire a tracking event.
		 * 
		 * <p>Each type of tracking object can accept different
		 * parameters for the "options" object. Read the docs
		 * for the different tracking objects for those details.</p>
		 * 
		 * @param id The id of the "track" node from xml.
		 * @param options The options associated with this tracking call.
		 */
		public function track(id:String,options:Object=null):void
		{
			var nid:String=getId(id,options);
			var found:Boolean=true;
			try { var node:XML=new XML(xml.track.(@id==nid)); }
			catch(e:Error){ found=false; }
			if(node == null || node == "" || !found)
			{
				trace("WARNING: A track node with id {"+id+"} wasn't found. Not doing anything.");
				return;
			}
			if(XMLUtils.hasNode(node,"webtrends") && webtrends) webtrends.track(node.webtrends,options);
			if(XMLUtils.hasNode(node,"hitbox") && hitbox) hitbox.track(node.hitbox,options);
			if(XMLUtils.hasNode(node,"omniture") && omniture) omniture.track(new XML(node.omniture),options);
			//if(XMLUtils.hasAttrib(node,"ganalytics") && hitbox) hitbox.track(node,options);
		}
		
		/**
		 * @private
		 * 
		 * Get's the correct id to fire, figuring out if there are
		 * different id's to use when assertions are present.
		 * 
		 * @param id The id to fire.
		 * @param options Optional options with the tracking event.
		 */
		public static function getId(id:String,options:Object):String
		{
			if(id)return id;
			else id=getAssertTrackId(options);
			return id;
		}
		
		/**
		 * @private
		 * 
		 * Get dynamic data.
		 * 
		 * @param options The options objec that may contain dynamic data.
		 */
		public static function getDynamicData(options:Object):*
		{
			if(!options)return {};
			if(options.dynamicData!=null && (options.dynamicData is Function))return options.dynamicData();
			else if(options.dynamicData) return options.dynamicData;
			return {};
		}
		
		/**
		 * @private
		 * 
		 * Figures out assertions and tells whether or not to continue.
		 */
		public static function assertions(options:Object):Boolean
		{
			if(!options)return true;
			var target:Object;
			if(options.assertTarget)target=options.assertTarget;
			if(!options.whenFalse && !options.whenTrue)
			{
				if(options.assertProp && !Boolean(target[options.assertProp]))return false;
				if(options.assertMethod != null && !Boolean(options.assertMethod()))return false;
			}
			return true;
		}
		
		/**
		 * @private
		 * 
		 * Get's an id when there are assertions that require
		 * getting a different id when true/false.
		 */
		public static function getAssertTrackId(options:Object):String
		{
			if(!options)return null;
			var res:String=null;
			var target:Object;
			if(options.assertTarget)target=options.assertTarget;
			if(options.assertProp && options.whenFalse && options.whenTrue)
			{
				res=(Boolean(target[options.assertProp]) ? options.whenTrue:options.whenFalse);
			}
			if(options.assertMethod != null && options.whenFalse && options.whenTrue)
			{
				res=String(Boolean(options.assertMethod()) ? options.whenTrue:options.whenFalse);
			}
			if(options.assertProp && options.whenFalse && !options.whenTrue)
			{
				if(!Boolean(target[options.assertProp]))res=options.whenFalse;
			}
			if(options.assertProp && !options.whenFalse && options.whenTrue)
			{
				if(Boolean(target[options.assertProp]))res=options.whenTrue;
			}
			return res;
		}
	}
}