package gs.managers 
{
	import gs.tracking.TrackingHandler;
	import gs.util.PlayerUtils;

	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;

	/**
	 * The TrackingManager class contains shortcuts for handling tracking.
	 * 
	 * @example
	 * <listing>	
	 * //create an object.
	 * var myMovieClip:MovieClip=new MovieClip();
	 * addChild(myMovieClip);
	 * 
	 * //setup tracking manager
	 * var tracking:TrackingManager = new TrackingManager(myXMLInstance);
	 * 
	 * //register an object to fire a tracking event.
	 * tracking.register(myMovieClip,MouseEvent.CLICK,"onMyMovieClipClick"); //onMyMovieClipClick = tracking id. (see below).
	 * </listing>
	 * 
	 * <p>The TrackingManager requires you to set the "xml"
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
	 * node get fired.</p>
	 * 
	 * @example <b>Example</b> all of the supported tags:
	 * <listing>	
	 * &lt;tracking&gt;
	 *     &lt;track id="onMyMovieClipClick"&gt;
	 *         &lt;webtrends&gt;/ws2008/videos/product/command/play,ddddd,ad92&lt;/webtrends&gt;
	 *         &lt;atlas&gt;http://www.google.com/g.jpg&lt;/atlas&gt;
	 *         &lt;ganalytics&gt;/asdf/asdf&lt;/ganalytics&gt;
	 *         &lt;hitbox&gt;
	 *             &lt;lpos&gt;MyLPOS&lt;/lpos&gt;
	 *             &lt;lid&gt;MyLID&lt;/lid&gt;
	 *         &lt;/hitbox&gt;
	 *     &lt;/track&gt;
	 * &lt;/tracking&gt;
	 * </listing>
	 * 
	 * <p><b>Extras</b></p>
	 * 
	 * <p>The TrackingManager also supports an additional "options"
	 * parameter when you register an object:</p>
	 * 
	 * <p>Available options:</p>
	 * <ul>
	 * <li><b>assertTarget</b> (Object) - An object to use for asserting properties and methods.</li>
	 * <li><b>assertProp</b> (String) - A property on the object firing the event to assert. (true: tracking fires, false:tracking not fired).</li>
	 * <li><b>assertMethod</b> (Function) - A function to call for a boolean result. (true: tracking fires, false:tracking not fired).</li>
	 * <li><b>whenTrue</b> (String) - A tracking ID to fire when assertProp or assertMethod is true.</li>
	 * <li><b>whenFalse</b> (String) - A tracking ID to fire when assertProp or assertMethod is false.</li>
	 * <li><b>dynamicData</b> (Function) - A function to call to get dynamic data to append to a tracking tag. The dynamic
	 * data can be treated differently depending on which tracking implementation your using. Most require an Array returned. Read the source of this
	 * class for more information.</li>
	 * </ul>
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class TrackingManager 
	{
		
		/**
		 * Whether or not the tracking manager is enabled.
		 */
		public var enabled:Boolean;
		
		/**
		 * Whether or not to show traces.
		 */
		public var showTraces:Boolean;
		
		/**
		 * Whether or not to send tracking calls when the swf
		 * is running in standalone (IDE, or swf standalone player).
		 */
		public var trackWhenStandalone:Boolean;
		
		/**
		 * Object lookup for registered objects.
		 */
		private var objs:Dictionary;
		
		/**
		 * The tracking XML.
		 */
		private var _xml:XML;
		
		/**
		 * Whether or not to use guttershark external
		 * javascript tracking framework. If you turn this on,
		 * you'll need to make sure the guttershark.js script
		 * is included in the page. All tracking events
		 * are fired externally, and not in flash.
		 */
		public var useGuttersharkJSTracking:Boolean;
		
		/**
		 * Tracking manager instances.
		 */
		private static var _tms:Dictionary=new Dictionary(true);
		
		/**
		 * @private
		 */
		public var id:String;
		
		/**
		 * Constructor for TrackingManager instances.
		 * 
		 * @param _xml An xml object that conforms to the tracking xml format.
		 */
		public function TrackingManager(_xml:XML)
		{
			if(!_xml)throw new ArgumentError("Parameter {_xml} cannot be null.");
			trackWhenStandalone=true;
			enabled=true;
			objs=new Dictionary(true);
			this._xml=_xml;
		}
		
		/**
		 * Get a tracking manager instance.
		 * 
		 * @param id The tracking manager id.
		 */
		public static function get(id:String):TrackingManager
		{
			if(!id)
			{
				trace("WARNING: Parameter {id} is null, returning null.");
				return null;
			}
			return _tms[id];
		}
		
		/**
		 * Set a tracking manager instance.
		 * 
		 * @param id The id of the tracking manager.
		 * @param tm The tracking manager instance.
		 */
		public static function set(id:String, tm:TrackingManager):void
		{
			if(!id||!tm)return;
			if(!tm.id)tm.id=id;
			_tms[id]=tm;
		}
		
		/**
		 * Unset (delete) a tracking manager instance.
		 * 
		 * @param id The id for the tracking manager.
		 */
		public static function unset(id:String):void
		{
			delete _tms[id];
		}
		
		/**
		 * The xml file for tracking.
		 */
		public function set xml(x:XML):void
		{
			_xml=x;
			enabled=true;
		}
		
		/**
		 * The xml file for tracking.
		 */
		public function get xml():XML
		{
			return _xml;
		}
		
		/**
		 * Register an object that triggers a tracking call.
		 * 
		 * @param obj An object (InteractiveObject, or Array) of objects to register.
		 * @param triggerEvent The event which triggers the tracking call.
		 * @param trackingID The tracking id from tracking XML.
		 * @param options Additional options.
		 */
		public function register(obj:*,event:String,id:String=null,options:Object=null):void
		{
			trace("WARNING: The EventManager is deprecated.");
			return;
			/*if(!obj)throw new ArgumentError("Parameter {obj} cannot be null.");
			if(!event)throw new ArgumentError("Parameter {event} cannot be null");
			var th:TrackingHandler=new TrackingHandler(this,id,obj,event,options);
			if(!objs[obj])objs[obj]=new Dictionary(true);
			if(objs[obj][event])trace("WARNING: Overwriting a previous tracking handler.");
			objs[obj][event]=th;*/
		}
		
		/**
		 * Unregister an object that triggers a tracking call.
		 * 
		 * @param obj An object (InteractiveObject, or Array) of objects to unregister.
		 * @param triggerEvent The event which triggers the tracking call.
		 */
		public function unregister(obj:*,event:String):void
		{
			if(!obj||!event)return;
			TrackingHandler(objs[obj][event]).dispose();
			delete objs[obj][event];
			delete objs[obj];
		}
		
		/**
		 * @private
		 * Called from a TrackingHandler instance.
		 * 
		 * @param id The tracking id.
		 * @param obj The object that triggers the tracking event.
		 * @param options The tracking options.
		 */
		public function track(th:TrackingHandler):void
		{
			if(!enabled || (!trackWhenStandalone && (PlayerUtils.isIDEPlayer()||PlayerUtils.isStandAlonePlayer()))) return;
			var options:Object=th.options;
			var obj:* =th.obj;
			var id:String=th.id;
			if(!options)options={};
			var node:XMLList=getNode(id);
			if(node.hasOwnProperty("omniture"))omniture(id,obj,options);
			if(node.hasOwnProperty("atlas"))atlas(id,obj,options);
			if(node.hasOwnProperty("ganalytics"))ganalytics(id,obj,options);
			if(node.hasOwnProperty("hitbox"))hitbox(id,obj,options);
			if(node.hasOwnProperty("webtrends"))webtrends(id,obj,options);
		}
		
		/**
		 * Get dynamic data.
		 */
		private function getDynamicData(options:Object):*
		{
			if(!options)return {};
			if(options.dynamicData!=null && (options.dynamicData is Function))return options.dynamicData();
			return {};
		}
		
		/**
		 * Figures out assertions and tells whether or not to continue.
		 */
		private function assertions(obj:*,options:Object):Boolean
		{
			if(!options)return true;
			var target:Object=obj;
			if(options.assertTarget)target=options.assertTarget;
			if(!options.whenFalse && !options.whenTrue)
			{
				if(options.assertProp && !Boolean(target[options.assertProp]))return false;
				if(options.assertMethod != null && !Boolean(options.assertMethod()))return false;
			}
			return true;
		}
		
		/**
		 * Get's an id when there are assertions that require
		 * getting a different id when true/false.
		 */
		private function getAssertTrackId(obj:*,options:Object):String
		{
			if(!options)return null;
			var res:String=null;
			var target:Object=obj;
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
		
		/**
		 * Get's the xml node for a track id.
		 */
		private function getNode(id:String):XMLList
		{
			return xml.track.(@id==id);
		}
		
		/**
		 * Get's the correct id to fire, figuring out if there are
		 * different id's to use when assertions are present.
		 */
		private function getId(id:String,obj:*,options:Object):String
		{
			if(id)return id;
			else id=getAssertTrackId(obj,options);
			return id;
		}
		
		/**
		 * Fires omniture.
		 */
		private function omniture(id:String,obj:*,options:Object):void
		{
			if(!assertions(obj,options))return;
			var node:*;
			var dd:* =getDynamicData(options);
			var fid:String=getId(id,obj,options);
			if(!fid)return;
			node=getNode(fid).omniture;
		}
		
		/**
		 * Fires atlas.
		 */
		private function atlas(id:String,obj:*,options:Object):void
		{
			if(!assertions(obj,options))return;
			var node:*;
			var dd:* =getDynamicData(options);
			var fid:String=getId(id,obj,options);
			if(!fid)return;
			node=getNode(fid).atlas;
		}
		
		/**
		 * Fires google analytics.
		 */
		private function ganalytics(id:String,obj:*,options:Object):void
		{
			if(!assertions(obj,options))return;
			var node:*;
			var dd:* =getDynamicData(options);
			var fid:String=getId(id,obj,options);
			if(!fid)return;
			node=getNode(fid).ganalytics;
		}
		
		/**
		 * Fires hitbox.
		 */
		private function hitbox(id:String,obj:*,options:Object):void
		{
			if(!assertions(obj,options))return;
			var node:*;
			var dd:* =getDynamicData(options);
			var fid:String=getId(id,obj,options);
			if(!fid)return;
			node=getNode(fid).hitbox;
			var lid:String;
			var lpos:String;
			if(node.hasOwnProperty("lid"))lid=node.lid.toString();
			if(node.hasOwnProperty("lpos"))lpos=node.lpos.toString();
			if(!lid||!lpos)
			{
				trace("WARNING: Hitbox could not fire, missing {lid} or {lpos}");
				return;
			}
			if(!ExternalInterface.available)
			{
				trace("WARNING: ExternalInterface is not available for hitbox.");
				return;
			}
			if(dd && (dd is Array))
			{
				var i:int=0;
				var l:int=dd.length;
				for(;i<l;i++)lpos+=String(dd[int(i)]);
			}
			if(showTraces)trace("HITBOX: dynamic_fsCommand('"+lpos+"|"+lid+"')");
			ExternalInterface.call("dynamic_fsCommand('"+lpos+"|"+lid+"')");
		}
		
		/**
		 * Fires webtrends.
		 */
		private function webtrends(id:String,obj:*,options:Object):void
		{
			if(!assertions(obj,options))return;
			var node:*;
			var dd:* =getDynamicData(options);
			var fid:String=getId(id,obj,options);
			if(!fid)return;
			node=getNode(fid).webtrends;
			var parts:Array=node.toString().split(",");
			var dcsuri:String=parts[0];
			var ti:String=parts[1];
			var cg_n:String=parts[2];
			if(!cg_n)cg_n="undefined";
			if(dd && (dd is Array))
			{
				if(dd[0])dcsuri+=String(dd[0]);
				if(dd[1])ti+=String(dd[1]);
				if(dd[2])cg_n+=String(dd[2]);
			}
			if(showTraces)
			{
				trace(">>track webtrends");
				trace("dcsMultiTrack","DCS.dcsuri",dcsuri,"WT.ti",ti,"WT_cg_n",cg_n);
			}
			if(!ExternalInterface.available)
			{
				trace("WARNING: ExternalInterface is not available for webtrends.");
				return;
			}
			ExternalInterface.call("dcsMultiTrack","DCS.dcsuri",dcsuri,"WT.ti",ti,"WT_cg_n",cg_n);
		}
		
		/**
		 * Dispose of this tracking manager.
		 */
		public function dispose():void
		{
			objs=new Dictionary(true);
			objs=null;
			if(id)TrackingManager.unset(id);
			_xml=null;
			enabled=false;
			showTraces=false;
			useGuttersharkJSTracking=false;
			trackWhenStandalone=false;
		}
	}
}