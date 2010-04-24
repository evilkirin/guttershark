package gs.tracking 
{
	import gs.util.PlayerUtils;
	import gs.util.XMLUtils;

	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * The Tracking class handles firing tracking events.
	 * 
	 * <p>The Tracking class requires you to set the "xml"
	 * property to an XML object formatted like this:</p>
	 * 
	 * <listing>	
	 * &lt;tracking&gt;
	 *     &lt;track id="onMyMovieClipClick"&gt;
	 *     &lt;/track&gt;
	 * &lt;/tracking&gt;
	 * </listing>
	 * 
	 * <p>The tracking manager looks for certain tags
	 * inside of a "track" node - which controls what
	 * to fire. You can mix and match any of the
	 * tags. Whichever tags exist inside of the track
	 * node get fired. You should see the other tracking
	 * classes for the supported xml structure.</p>
	 * 
	 * <p><b>Extras</b></p>
	 * 
	 * <p>The Tracking class also supports an additional
	 * "options" parameter when you register an object or
	 * fire tracking event manually:</p>
	 * 
	 * <p>Available options:</p>
	 * <ul>
	 * <li><b>assertTarget</b> (Object) - An object to use for asserting properties and methods.</li>
	 * <li><b>assertProp</b> (String) - A property on the 'assertTarget' to assert. (true: tracking fires, false:tracking not fired).</li>
	 * <li><b>assertMethod</b> (Function) - A function to call for a boolean result. (true: tracking fires, false:tracking not fired).</li>
	 * <li><b>whenTrue</b> (String) - A tracking ID to fire when assertProp or assertMethod is true.</li>
	 * <li><b>whenFalse</b> (String) - A tracking ID to fire when assertProp or assertMethod is false.</li>
	 * <li><b>dynamicData</b> (Function) - A function to call to get dynamic data to append to a tracking tag. You
	 * should read the source from either of the classes that implement the tracking calls to see how the dynamic
	 * data is handled and expected.</li>
	 * </ul>
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.tracking.Webtrends
	 * @see gs.tracking.Omniture
	 * @see gs.tracking.Atlas
	 * @see gs.tracking.Hitbox
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
		 * An instance of Atlas. You need to set this if
		 * you're expecting to fire atlas tracking events.
		 */
		public var atlas:Atlas;
		
		/**
		 * Whether or not to send tracking events when the flash
		 * player is running as a standalone player.
		 */
		public var trackWhenStandalone:Boolean;
		
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
			trackWhenStandalone=true;
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
			if(!tracking.id)tracking.id=id;
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
			if(options &&!options.assertTarget)options.assertTarget=obj;
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
			if((!trackWhenStandalone && (PlayerUtils.isIDEPlayer()||PlayerUtils.isStandAlonePlayer())))return;
			var nid:String=getId(id,options);
			var found:Boolean=true;
			try { var node:XML=new XML(xml.track.(@id==nid)); }
			catch(e:Error){ found=false; }
			if(node == null || node == "" || !found)
			{
				trace("WARNING: A track node with id {"+id+"} wasn't found. Not doing anything.");
				return;
			}
			if(XMLUtils.hasNode(node,"webtrends") && webtrends) webtrends.track(new XML(node.webtrends),options);
			if(XMLUtils.hasNode(node,"hitbox") && hitbox) hitbox.track(new XML(node.hitbox),options);
			if(XMLUtils.hasNode(node,"omniture") && omniture) omniture.track(new XML(node.omniture),options);
			if(XMLUtils.hasNode(node,"atlas") && atlas) atlas.track(new XML(node.atlas),options);
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