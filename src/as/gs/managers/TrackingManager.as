package gs.managers 
{
	import gs.util.ObjectUtils;
	import gs.util.PlayerUtils;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
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
	 * var tracking:TrackingManager = new TrackingManager();
	 * tracking.xml = myXMLInstance;
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
	 * <li><b>assertProp</b> (String) - A property on the object firing the event to assert. (true: tracking fires, false:tracking not fired).</li>
	 * <li><b>assertMethod</b> (Function) - A method to call for a boolean result. (true: tracking fires, false:tracking not fired).</li>
	 * <li><b>whenTrue</b> (String) - A tracking ID to fire when assertProp or assertMethod is true.</li>
	 * <li><b>whenFalse</b> (String) - A tracking ID to fire when assertProp or assertMethod is false.</li>
	 * <li><b>dynamicData</b> (Function) - A function to call to get dynamic data to append to a tracking tag. The dynamic
	 * data can be treated differently depending on which tracking implementation your using. Most require an Array returned. Read the source of this
	 * class for more information.</li>
	 * </ul>
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
		 * A local connection for omniture.
		 */
		private var lc:LocalConnection;
		
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
		public function TrackingManager(_xml:XML=null)
		{
			trackWhenStandalone=true;
			objs=new Dictionary(true);
			if(_xml)xml=_xml;
			lc=new LocalConnection();
			lc.addEventListener(StatusEvent.STATUS,onLCStatus);
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
		public function register(obj:*,triggerEvent:String,trackingID:String=null,options:Object=null):void
		{
			if(!enabled)
			{
				trace("WARNING: Tracking not enabled, not registering object.");
				return;
			}
			if(!obj)throw new ArgumentError("Parameter {obj} cannot be null.");
			if(!triggerEvent)throw new ArgumentError("Parameter {trigger} cannot be null");
			if(obj is Array)
			{
				var i:int=0;
				var l:int=obj.length;
				for(i;i<l;i++)register(obj[i],triggerEvent,trackingID,options);
				return;
			}
			if(!(obj is InteractiveObject))
			{
				trace("WARNING: The object attempted to register is not an InteractiveObject, not registering it.");
				return;
			}
			if(!xml)
			{
				trace("WARNING: Tracking xml is not set. Not doing anything.");
				return;
			}
			if(!objs[obj])objs[obj]=new Dictionary(true);
			objs[obj][triggerEvent]={options:options,trackingID:trackingID,triggerEvent:triggerEvent,obj:obj};
			obj.addEventListener(triggerEvent,onEvent,false,0,true);
		}
		
		/**
		 * Unregister an object that triggers a tracking call.
		 * 
		 * @param obj An object (InteractiveObject, or Array) of objects to unregister.
		 * @param triggerEvent The event which triggers the tracking call.
		 */
		public function unregister(obj:*,triggerEvent:String):void
		{
			if(obj is Array)
			{
				var i:int=0;
				var l:int=obj.length;
				for(i;i<l;i++)unregister(obj[i],triggerEvent);
				return;
			}
			if(!(obj is InteractiveObject))return;
			obj.removeEventListener(triggerEvent,onEvent,false);
			delete objs[obj][triggerEvent];
			delete objs[obj];
		}
		
		/**
		 * When an event is fired, which should trigger a tracking
		 * call.
		 */
		private function onEvent(e:Event):void
		{
			if(!enabled) return;
			if(!trackWhenStandalone && (PlayerUtils.isIDEPlayer()||PlayerUtils.isStandAlonePlayer())) return;
			var trackobj:Object=e.currentTarget;
			if(!trackobj)trackobj=e.target;
			var obj:Object=objs[trackobj];
			if(!obj)
			{
				trace("WARNING: An object that was registered for events, which fired the trigger event, couldn't follow through. The tracking event was not fired.");
				return;
			}
			obj=obj[e.type]; //set this to the lookup dict.
			if(!obj)return; //if no event was registered.
			var dd:*;
			var options:Object=obj.options;
			if(options && options.dynamicData)dd=options.dynamicData();
			//checks options like this:
			//{assertProp:"myProp",whenTrue:"trackID",whenFalse:"trackID"};
			var assertRes:*;
			if(options && options.assertProp && options.whenFalse && options.whenTrue)
			{
				obj.trackingID=(Boolean(trackobj[options.assertProp])) ? options.whenTrue : options.whenFalse;
			}
			else if(options && options.assertMethod && options.whenFalse && options.whenTrue)
			{
				assertRes=options.assertMethod();
				obj.trackingID=(Boolean(assertRes)) ? options.whenTrue : options.whenFalse;
			}
			else
			{
				//{assertProp:"myProp",whenTrue:"trackID"}; //if false, trackID is null.
				//{assertProp:"myProp",whenFalse:"trackID"}; //if true, trackID is null.
				if(options && options.assertProp && options.whenFalse && !options.whenTrue)
				{
					assertRes=Boolean(trackobj[options.assertProp]);
					if(!assertRes && options.whenFalse) obj.trackingID = options.whenFalse;
				}
				else if(options && options.assertProp && !options.whenFalse && options.whenTrue)
				{
					assertRes=Boolean(trackobj[options.assertProp]);
					if(assertRes && options.whenTrue) obj.trackingID = options.whenTrue;
				}
			}
			
			if(options && !options.whenFalse && !options.whenTrue)
			{
				//check for these options:
				//{assertProp:"myPropety"};
				//{assertMethod:"myMethod"};
				if(options && options.assertProp && !trackobj[options.assertProp]) return;
				if(options && options.assertMethod && !trackobj[options.assertMethod]()) return;	
			}
			
			var trackingID:String=obj.trackingID;
			if(!trackingID)
			{
				trace("WARNING: The trackingID was null. Not tacking anything.");
				return;
			}
			if(useGuttersharkJSTracking)
			{
				ExternalInterface.call("flashTrack",trackingID,options.dynamicData());
				return;
			}
			var tracknode:* =xml..track.(@id==trackingID);
			if(!tracknode || tracknode.toXMLString()=="")
			{
				trace("ERROR: The tracking id {"+trackingID+"} doesn't exist in the tracking xml. Not firing any tracking.");
				return;
			}
			if(tracknode.hasOwnProperty("webtrends")) //webtrends
			{
				var appendData:Array;
				if(options && options.dynamicData) appendData=options.dynamicData();
				var tagStr:String=tracknode.webtrends.toString();
				var parts:Array=tagStr.split(",");
				var dcsuri:String=parts[0];
				var ti:String=parts[1];
				var cg_n:String=parts[2];
				if(!cg_n)cg_n="undefined";
				if(appendData)
				{
					if(appendData[0]!=null)dcsuri+=appendData[0];
					if(appendData[1]!=null)ti+=appendData[1];
					if(appendData[2]!=null)cg_n+=appendData[2];
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
			if(tracknode.hasOwnProperty("ganalytics")) //ganalytics
			{
				//implement ganalytics.
			}
			if(tracknode.hasOwnProperty("omniture")) //omniture
			{
				var objk:Object={addVars:{}};
				var omniNode:* =tracknode.omniture.children();
				var node:*;
				for each(node in omniNode)
				{
					if(node.name().toString()=="trackId")objk.trackId=node.toString();
					objk.addVars[node.name().toString()]=node.toString();
				}
				if(showTraces)
				{
					trace(">>track omniture");
					ObjectUtils.dump(objk);
				}
				lc.send("TrackingConnection","trackItem",objk);
			}
			if(tracknode.hasOwnProperty("atlas")) //atlas
			{
				//implement atlas
			}
			if(tracknode.hasOwnProperty("hitbox")) //hitbox
			{
				var lid:String;
				var lpos:String;
				if(tracknode.hitbox.hasOwnProperty("lid")) lid=tracknode.hitbox.lid.toString();
				if(tracknode.hitbox.hasOwnProperty("lpos")) lpos=tracknode.hitbox.lpos.toString();
				if(!lid || !lpos)
				{
					trace("WARNING: Hitbox could not fire, missing {lid} or {lpos}");
					return;
				}
				if(!ExternalInterface.available)
				{
					trace("WARNING: ExternalInterface is not available for hitbox.");
					return;
				}
				if(options && options.dynamicData)
				{
					//var dd:* =options.dynamicData();
					if(dd is Array)
					{
						var i:int=0;
						var l:int=dd.length;
						for(i;i<l;i++) lpos+=dd[i].toString();
					}
				}
				if(showTraces)trace("HITBOX: dynamic_fsCommand('" + lpos + "|" + lid + "')");
				ExternalInterface.call("dynamic_fsCommand('" + lpos + "|" + lid + "')");
			}
		}
		
		private function onLCStatus(e:StatusEvent):void
		{
			if(e.code=="error")trace("WARNING: Could not send tracking message to omniture.");
		}
		
		/**
		 * Dispose of this tracking manager.
		 */
		public function dispose():void
		{
			var obj:*;
			var target:*;
			lc.removeEventListener(StatusEvent.STATUS,onLCStatus);
			for(obj in objs)
			{
				target=objs[obj.obj][obj.triggerEvent];
				unregister(target,obj.triggerEvent);
				objs[obj.obj][obj.triggerEvent]=null;
				delete objs[obj.obj][obj.triggerEvent];
			}
			TrackingManager.unset(id);
		}
	}
}