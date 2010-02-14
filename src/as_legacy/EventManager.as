package net.guttershark.managers 
{
	import flash.ui.ContextMenuItem;	
	import flash.events.ContextMenuEvent;	
	import flash.ui.ContextMenu;	
	import flash.display.InteractiveObject;
	import flash.display.LoaderInfo;
	import flash.events.ActivityEvent;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.StatusEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Sound;
	import flash.net.FileReference;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.Socket;
	import flash.net.URLLoader;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import net.guttershark.control.PreloadController;
	import net.guttershark.display.FLV;
	import net.guttershark.support.events.FLVEvent;
	import net.guttershark.support.preloading.events.AssetCompleteEvent;
	import net.guttershark.support.preloading.events.AssetErrorEvent;
	import net.guttershark.support.preloading.events.PreloadProgressEvent;
	import net.guttershark.util.Tracking;
	import net.guttershark.util.XMLLoader;	

	/**
	 * [DEPRECATED] See net.guttershark.util.EventHandler.
	 * 
	 * <p>The EventManager class simplifies events and provides shortcuts for event listeners 
	 * for AS3 top level classes, guttershark classes, and component events on
	 * an opt-in basis. Depending on the callbacks you have defined in your callback delegate,
	 * event listeners will be added to the object. So this means that not all events will
	 * be listened for, only ones with callback functions defined.</p>
	 * 
	 * <p>Events can also be cycled through the javascript tracking framework. You can
	 * send all events that exist for an object through the tracking framework, or - (by
	 * default), only send the events through tracking that you have callbacks defined for.</p>
	 * 
	 * @example Using EventManager with a MovieClip.
	 * <listing>	
	 * import net.guttershark.managers.EventManager;
	 * 
	 * public class Main extends Sprite
	 * {
	 * 
	 *    private var em:EventManager;
	 *    private var mc:MovieClip;
	 *    
	 *    public function Main()
	 *    {
	 *       super();
	 *       em=EventManager.gi();
	 *       mc=new MovieClip();
	 *       mc.graphics.beginFill(0xFF0066);
	 *       mc.graphics.drawCircle(200, 200, 100);
	 *       mc.graphics.endFill();
	 *       em.handleEvents(mc,this,"onCircle");
	 *       addChild(mc);
	 *    }
	 *    
	 *    public function onCircleClick():void
	 *    {
	 *       trace("circle click");
	 *    }
	 *    
	 *    public function onCircleAddedToStage():void
	 *    {
	 *        trace("my circle was added to stage");
	 *    }
	 * }
	 * </listing>
	 * 
	 * <p>Callback methods are defined by the prefix you give to the <em><code>handleEvents</code></em>
	 * method, plus the event name.</p>
	 * 
	 * @example How callbacks must be defined:
	 * <listing>	
	 * import net.guttershark.managers.EventManager;
	 * 
	 * var em:EventManager=EventManager.gi();
	 * var mc:MovieClip=new MovieClip();
	 * 
	 * em.handleEvents(mc,this,"onMyMC",false,true); //onMyMC is the "prefix"
	 * 
	 * function onMyMCClick():void{} //Click is the Event -> so the callback must be defined like prefix+event -> onMyMCClick
	 * 
	 * //to define a handler for MouseMove, the prefix is "onMyMC" the event is "MouseMove".
	 * function onMyMCMouseMove():void{}
	 * </listing>
	 * 
	 * <p>Passing the originating event object back to your callback is optional, but there are a few
	 * events that are not optional, because they contain information you probably need.
	 * The non-negotiable events are listed below.</p>
	 * 
	 * @example Adding support for tracking (only the click event will go through tracking):
	 * <listing>	
	 * import net.guttershark.managers.EventManager;
	 * var em:EventManager=EventManager.gi();
	 * var mc:MovieClip=new MovieClip();
	 * em.handleEvents(mc,this,"onMyMC",false,true);
	 * function onMyMCClick(){}
	 * </listing>
	 * 
	 * @example Adding support for tracking (all events cycle through tracking):
	 * <listing>	
	 * import net.guttershark.managers.EventManager;
	 * var em:EventManager=EventManager.gi();
	 * var mc:MovieClip=new MovieClip();
	 * em.handleEvents(mc,this,"onMyMC",false,false,<strong>true</strong>);
	 * function onMyMCClick(){}
	 * </listing>
	 * 
	 * <p>In the above example, even though a callback is only defined for the click event,
	 * all events from the object will be fire through tracking - with the usual prefix+eventName
	 * as the id for the tracking call.</p>
	 * 
	 * @example Using the EventManager in a loop situation for unique tracking:
	 * <listing>	
	 * import net.guttershark.managers.EventManager;
	 * var em:EventManager=EventManager.gi();
	 * for(var i:int=0; i < myClips.length; i++)
	 * {
	 *     em.handleEvents(myClips[i],this,"onClip",false,true,false,"onClip"+i.toString());
	 * }
	 * function onClipClick()
	 * {
	 * }
	 * </listing>
	 * 
	 * @example Tracking xml file example for the above example.
	 * <listing>	
	 * &lt;tracking&gt;
	 *     &lt;track id="onClipClick0"&gt;
	 *         &lt;atlas&gt;...&lt;/atlas&gt;
	 *         &lt;webtrends&gt;...&lt;/webtrends&gt;
	 *     &lt;/track&gt;
	 *     &lt;track id="onClipClick1"&gt;
	 *         &lt;atlas&gt;...&lt;/atlas&gt;
	 *         &lt;webtrends&gt;...&lt;/webtrends&gt;
	 *     &lt;/track&gt;
	 * &lt;/tracking&gt;
	 * </listing>
	 * 
	 * <p>Supported TopLevel Flashplayer Objects and Events:</p>
	 * <table border='1'>
	 * <tr bgcolor="#999999"><td width="200"><strong>Object</strong></td><td><strong>Events</strong></td></tr>
	 * <tr><td>DisplayObject</td><td>Added,AddedToStage,Activate,Deactivate,Removed,RemovedFromStage</td>
	 * <tr><td>InteractiveObject</td><td>Click,DoubleClick,MouseUp,MouseDown,MouseMove,MouseOver,MouseWheel,MouseOut,FocusIn,<br/>
	 * FocusOut,KeyFocusChange,MouseFocusChange,TabChildrenChange,TabIndexChange,TabEnabledChange</td></tr>
	 * <tr><td>Stage</td><td>Resize,Fullscreen,MouseLeave</td></tr>
	 * <tr><td>TextField</td><td>Change,Link</td></tr>
	 * <tr><td>Timer</td><td>Timer,TimerComplete</td></tr>
	 * <tr><td>Socket</td><td>Connect,Close,SocketData</td></tr>
	 * <tr><td>LoaderInfo</td><td>Complete,Unload,Init,Open,Progress</td></tr>
	 * <tr><td>Camera</td><td>Activity,Status</td></tr>
	 * <tr><td>Microphone</td><td>Activity,Status</td></tr>
	 * <tr><td>NetConnection</td><td>Status</td></tr>
	 * <tr><td>NetStream</td><td>Status</td></tr>
	 * <tr><td>FileReference</td><td>Cancel,Complete,Open,Select,UploadCompleteData</td></tr>
	 * <tr><td>Sound</td><td>Progress,Complete,ID3,Open</td></tr>
	 * </table>
	 * 
	 * <p>Supported Guttershark Classes:</p>
	 * <table border='1'>
	 * <tr bgcolor="#999999"><td width="200"><strong>Object</strong></td><td width="200"><strong>EventListenerDelegate</strong></td><td><strong>Events</strong></td></tr>
	 * <tr><td>PreloadController</td><td>NA</td><td>Complete,Progress,AssetComplete,AssetError</td></tr>
	 * <tr><td>XMLLoader</td><td>NA</td><td>Complete</td></tr>
	 * <tr><td>SoundManager</td><td>NA</td><td>Change</td></tr>
	 * <tr><td>FLV</td><td>NA</td><td>Start,Stop,BufferFull,BufferEmpty,BufferFlush,SeekNotify,SeekInvalidTime,
	 * Meta,CuePoint,Progress,StreamNotFound</td></tr>
	 * </table>
	 * 
	 * <p>Non-negotiable event types that always pass event objects to your callbacks:</p>
	 * <ul>
	 * <li>AssetErrorEvent.ERROR</li>
	 * <li>AssetCompleteEvent.COMPLETE</li>
	 * <li>KeyboardEvent.KEY_UP</li>
	 * <li>KeyboardEvent.KEY_DOWN</li>
	 * <li>MouseEvent.MOUSE_WHEEL</li>
	 * <li>PreloadProgressEvent.PROGRESS</li>
	 * <li>TextEvent.LINK</li>
	 * <li>FLVEvent.PROGRESS</li>
	 * <li>FLVEvent.META_DATA</li>
	 * <li>FLVEvent.CUE_POINT</li>
	 * <li>FLVEvent.STREAM_NOT_FOUND</li>
	 * </ul>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class EventManager
	{
		
		/**
		 * singleton instance
		 */
		private static var instance:EventManager;
		
		/**
		 * Stores info about objects.
		 */
		private var edinfo:Dictionary;
		
		/**
		 * lookup for interactive objects events.
		 */
		private var eventsByObject:Dictionary;
		
		/**
		 * The context menu manager - or context menu objects.
		 */
		private var cmm:ContextMenuManager;

		/**
		 * Singleton access.
		 */
		public static function gi():EventManager
		{
			if(instance == null) instance=new EventManager();
			return instance;
		}
		
		/**
		 * @private
		 * Constructor for EventListenersDelegate instances.
		 */
		public function EventManager()
		{
			if(EventManager.instance) throw new Error("EventManager is a singleton, see EventManager.gi()");
			edinfo=new Dictionary();
			eventsByObject=new Dictionary();
			cmm=ContextMenuManager.gi();
		}
		
		/**
		 * A shortcut for the <em><code>handleEvents</em></code> method.
		 */
		public function he(obj:IEventDispatcher, callbackDelegate:*, callbackPrefix:String, returnEventObjects:Boolean=false, cycleThroughTracking:Boolean=false, cycleAllThroughTracking:Boolean=false, trackingID:String=null):void
		{
			handleEvents(obj,callbackDelegate,callbackPrefix,returnEventObjects,cycleThroughTracking,cycleAllThroughTracking,trackingID);
		}

		/**
		 * Add auto event handling for the target object.
		 * 
		 * @param obj The object to add event listeners to.
		 * @param callbackDelegate The object in which your callback methods are defined.
		 * @param callbackPrefix A prefix for all callback function definitions.
		 * @param returnEventObjects Whether or not to pass the origin event objects back to your callbacks (with exception of non-negotiable event types).
		 * @param cycleThroughTracking For every event that is handled, pass the same event through the tracking framework. Only events that have callbacks will be passed through tracking.
		 * @param cycleAllThroughTracking Automatically adds listeners for every event that the target object dispatches, in order to grab every 
		 * event and pass to tracking, without requiring you to have a callback method defined on your callbackDelegate.
		 * @param trackingID Define a custom trackingID to pass through the tracking framework. For events dispatched from the provided object. The id
		 * is made up your tracking id + the acual event.
		 */
		public function handleEvents(obj:IEventDispatcher, callbackDelegate:*, callbackPrefix:String, returnEventObjects:Boolean=false, cycleThroughTracking:Boolean=false, cycleAllThroughTracking:Boolean=false, trackingID:String=null):void
		{
			if(edinfo[obj]) disposeEventsForObject(obj);
			edinfo[obj]={};
			edinfo[obj].callbackDelegate=callbackDelegate;
			edinfo[obj].callbackPrefix=callbackPrefix;
			edinfo[obj].passEventObjects=returnEventObjects;
			edinfo[obj].passThroughTracking=cycleThroughTracking;
			edinfo[obj].trackingID=trackingID;
			edinfo[obj].cycleAllThroughTracking=cycleAllThroughTracking;
			if(obj is InteractiveObject)
			{
				if((callbackPrefix + "Resize") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.RESIZE, onStageResize,false,0,true);
				if((callbackPrefix + "Fullscreen") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.FULLSCREEN, onStageFullscreen,false,0,true);
				if((callbackPrefix + "Added") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.ADDED,onDOAdded,false,0,true);
				if((callbackPrefix + "AddedToStage") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.ADDED_TO_STAGE,onDOAddedToStage,false,0,true);
				if((callbackPrefix + "Activate") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.ACTIVATE,onDOActivate,false,0,true);
				if((callbackPrefix + "Deactivate") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.DEACTIVATE,onDODeactivate,false,0,true);
				if((callbackPrefix + "Removed") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.REMOVED,onDORemoved,false,0,true);
				if((callbackPrefix + "RemovedFromStage") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.REMOVED_FROM_STAGE,onDORemovedFromStage,false,0,true);
				if((callbackPrefix + "MouseLeave") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave,false,0,true);
				if((callbackPrefix + "Click") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(MouseEvent.CLICK,onIOClick,false,0,true);
				if((callbackPrefix + "DoubleClick") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(MouseEvent.DOUBLE_CLICK,onIODoubleClick,false,0,true);
				if((callbackPrefix + "MouseDown") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(MouseEvent.MOUSE_DOWN,onIOMouseDown,false,0,true);
				if((callbackPrefix + "MouseMove") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(MouseEvent.MOUSE_MOVE,onIOMouseMove,false,0,true);
				if((callbackPrefix + "MouseUp") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(MouseEvent.MOUSE_UP,onIOMouseUp,false,0,true);
				if((callbackPrefix + "MouseOut") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(MouseEvent.MOUSE_OUT,onIOMouseOut,false,0,true);
				if((callbackPrefix + "MouseOver") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(MouseEvent.MOUSE_OVER,onIOMouseOver,false,0,true);
				if((callbackPrefix + "MouseWheel") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(MouseEvent.MOUSE_WHEEL,onIOMouseWheel,false,0,true);
				if((callbackPrefix + "RollOut") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(MouseEvent.ROLL_OUT, onIORollOut,false,0,true);
				if((callbackPrefix + "RollOver") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(MouseEvent.ROLL_OVER,onIORollOver,false,0,true);
				if((callbackPrefix + "FocusIn") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(FocusEvent.FOCUS_IN,onIOFocusIn,false,0,true);
				if((callbackPrefix + "FocusOut") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(FocusEvent.FOCUS_OUT,onIOFocusOut,false,0,true);
				if((callbackPrefix + "KeyFocusChange") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,onIOKeyFocusChange,false,0,true);
				if((callbackPrefix + "MouseFocusChange") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,onIOMouseFocusChange,false,0,true);
				if((callbackPrefix + "TabChildrenChange") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.TAB_CHILDREN_CHANGE, onTabChildrenChange,false,0,true);
				if((callbackPrefix + "TabEnabledChange") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.TAB_ENABLED_CHANGE, onTabEnabledChange,false,0,true);
				if((callbackPrefix + "TabIndexChange") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.TAB_INDEX_CHANGE,onTabIndexChange,false,0,true);
				if((callbackPrefix + "KeyDown") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown,false,0,true);
				if((callbackPrefix + "KeyUp") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(KeyboardEvent.KEY_UP, onKeyUp,false,0,true);
			}
			if(obj is FLV)
			{
				if(((callbackPrefix + "Progress") in callbackDelegate)) obj.addEventListener(FLVEvent.PROGRESS,onFLVProgress,false,0,true);
				if(((callbackPrefix + "Start") in callbackDelegate) || cycleAllThroughTracking) obj.addEventListener(FLVEvent.START,onFLVStart,false,0,true);
				if(((callbackPrefix + "Stop") in callbackDelegate) || cycleAllThroughTracking) obj.addEventListener(FLVEvent.STOP,onFLVStop,false,0,true);
				if(((callbackPrefix + "SeekNotify") in callbackDelegate) || cycleAllThroughTracking) obj.addEventListener(FLVEvent.SEEK_NOTIFY,onFLVSeekNotify,false,0,true);
				if(((callbackPrefix + "SeekInvalidTime") in callbackDelegate) || cycleAllThroughTracking) obj.addEventListener(FLVEvent.SEEK_INVALID_TIME,onFLVSeekInvalidTime,false,0,true);
				if(((callbackPrefix + "StreamNotFound") in callbackDelegate) || cycleAllThroughTracking) obj.addEventListener(FLVEvent.STREAM_NOT_FOUND,onFLVStreamNotFound,false,0,true);
				if(((callbackPrefix + "BufferFlush") in callbackDelegate) || cycleAllThroughTracking) obj.addEventListener(FLVEvent.BUFFER_FLUSH,onFLVBufferFlush,false,0,true);
				if(((callbackPrefix + "BufferEmpty") in callbackDelegate) || cycleAllThroughTracking) obj.addEventListener(FLVEvent.BUFFER_EMPTY,onFLVBufferEmpty,false,0,true);
				if(((callbackPrefix + "BufferFull") in callbackDelegate) || cycleAllThroughTracking) obj.addEventListener(FLVEvent.BUFFER_FULL,onFLVBufferFull,false,0,true);
				if(((callbackPrefix + "CuePoint") in callbackDelegate) || cycleAllThroughTracking) obj.addEventListener(FLVEvent.CUE_POINT,onFLVCuePoint,false,0,true);
				if(((callbackPrefix + "Meta") in callbackDelegate) || cycleAllThroughTracking) obj.addEventListener(FLVEvent.METADATA,onFLVMetaData,false,0,true);
			}
			if(obj is PreloadController)
			{
				if(((callbackPrefix + "Progress") in callbackDelegate)) obj.addEventListener(PreloadProgressEvent.PROGRESS,onProgress,false,0,true);
				if(((callbackPrefix + "Complete") in callbackDelegate) || cycleAllThroughTracking) obj.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
				if(((callbackPrefix + "AssetComplete") in callbackDelegate) || cycleAllThroughTracking) obj.addEventListener(AssetCompleteEvent.COMPLETE, onAssetComplete, false, 0, true);
				if(((callbackPrefix + "AssetError") in callbackDelegate) || cycleAllThroughTracking) obj.addEventListener(AssetErrorEvent.ERROR,onAssetError, false, 0, true);
				return;
			}
			if(obj is TextField)
			{
				if((callbackPrefix + "Change") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.CHANGE, onTextFieldChange,false,0,true);
				if((callbackPrefix + "Link") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(TextEvent.LINK, onTextFieldLink,false,0,true);
				return;
			}
			if(obj is XMLLoader)
			{
				var x:XMLLoader=XMLLoader(obj);
				edinfo[x.contentLoader]=edinfo[obj];
				if((callbackPrefix + "Complete") in callbackDelegate || cycleAllThroughTracking) x.contentLoader.addEventListener(Event.COMPLETE,onXMLLoaderComplete,false,0,true);
				return;
			}
			if(obj is SoundManager)
			{
				if((callbackPrefix + "Change") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.CHANGE,onSoundChange,false,0,true);
				return;
			}
			if(obj is Sound)
			{
				if((callbackPrefix + "Complete") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.COMPLETE,onSoundComplete,false,0,true);
				if((callbackPrefix + "Progress") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(ProgressEvent.PROGRESS,onSoundProgress,false,0,true);
				if((callbackPrefix + "Open") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.OPEN,onSoundOpen,false,0,true);
				if((callbackPrefix + "ID3") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.ID3,onSoundID3,false,0,true);
			}
			if(obj is LoaderInfo || obj is URLLoader)
			{
				if((callbackPrefix + "Complete") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.COMPLETE, onLIComplete,false,0,true);
				if((callbackPrefix + "Open") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.OPEN, onLIOpen,false,0,true);
				if((callbackPrefix + "Unload") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.UNLOAD, onLIUnload,false,0,true);
				if((callbackPrefix + "Init") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.INIT, onLIInit,false,0,true);
				if((callbackPrefix + "Progress") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(ProgressEvent.PROGRESS, onLIProgress,false,0,true);
				return;
			}
			if(obj is Timer)
			{
				if((callbackPrefix + "Timer") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(TimerEvent.TIMER, onTimer,false,0,true);
				if((callbackPrefix + "TimerComplete") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete,false,0,true); 
				return;
			}
			if(obj is Camera || obj is Microphone)
			{
				if((callbackPrefix + "Activity") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(ActivityEvent.ACTIVITY, onCameraActivity,false,0,true);
				if((callbackPrefix + "Status") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(StatusEvent.STATUS, onCameraStatus,false,0,true);
				return;
			}
			if(obj is Socket)
			{
				if((callbackPrefix + "Close") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.CLOSE, onSocketClose,false,0,true);
				if((callbackPrefix + "Connect") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.CONNECT, onSocketConnect,false,0,true);
				if((callbackPrefix + "SocketData") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData,false,0,true);
				return;
			}
			if(obj is NetConnection)
			{
				if((callbackPrefix + "Status") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(StatusEvent.STATUS, onCameraStatus,false,0,true);
				return;
			}
			if(obj is NetStream)
			{
				if((callbackPrefix + "Status") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(StatusEvent.STATUS, onCameraStatus,false,0,true);
				return;
			}
			if(obj is FileReference)
			{
				if((callbackPrefix + "Cancel") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.CANCEL, onFRCancel,false,0,true);
				if((callbackPrefix + "Complete") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.COMPLETE, onFRComplete,false,0,true);
				if((callbackPrefix + "Open") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.OPEN,onFROpen,false,0,true);
				if((callbackPrefix + "Select") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(Event.SELECT, onFRSelect,false,0,true);
				if((callbackPrefix + "UploadCompleteData") in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onFRUploadCompleteData,false,0,true);
				return;
			}
			if(obj is ContextMenu)
			{
				if(!cmm.isMenuRegistered(obj as ContextMenu))
				{
					trace("WARNING: Context menu events will not function from the event manager, unless you've created it through the ContextMenuManager.");
					return;
				}
				var ids:Array=cmm.getIdsForMenu(obj as ContextMenu);
				var j:int=0;
				var l:int=ids.length;
				var id:String;
				for(j;j<l;j++)
				{
					id=ids[j];
					if((callbackPrefix+id) in callbackDelegate)cmm.getItemFromMenuByMenuAndId(ContextMenu(obj),id).addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,onContextMenuSelect,false,0,true);
				}
			}
		}
		
		private function onContextMenuSelect(ce:ContextMenuEvent):void
		{
			var e:* ={};
			e.target=cmm.getMenuFromItem(ContextMenuItem(ce.target));
			handleEvent(e,cmm.getIdFromMenuItem(ContextMenuItem(ce.target)));
		}
		
		private function onFLVSeekNotify(fe:FLVEvent):void
		{
			handleEvent(fe,"Seek");
		}
		
		private function onFLVSeekInvalidTime(fe:FLVEvent):void
		{
			handleEvent(fe,"InvalidTime");
		}
		
		private function onFLVStreamNotFound(fe:FLVEvent):void
		{
			handleEvent(fe,"StreamNotFound",true);
		}
		
		private function onFLVBufferFlush(fe:FLVEvent):void
		{
			handleEvent(fe,"BufferFlush");
		}
		
		private function onFLVBufferFull(fe:FLVEvent):void
		{
			handleEvent(fe,"BufferFull");
		}
		
		private function onFLVBufferEmpty(fe:FLVEvent):void
		{
			handleEvent(fe,"BufferEmpty");
		}
		
		private function onFLVCuePoint(fe:FLVEvent):void
		{
			handleEvent(fe,"CuePoint",true);
		}
		
		private function onFLVMetaData(fe:FLVEvent):void
		{
			handleEvent(fe,"Meta",true);
		}
		
		private function onFLVStop(fe:FLVEvent):void
		{
			handleEvent(fe,"Stop");
		}
		
		private function onFLVStart(fe:FLVEvent):void
		{
			handleEvent(fe,"Start");
		}
		
		private function onFLVProgress(fe:FLVEvent):void
		{
			handleEvent(fe,"Progress",true);
		}
		
		private function onSoundID3(e:Event):void
		{
			handleEvent(e,"ID3");
		}
		
		private function onSoundProgress(pe:ProgressEvent):void
		{
			trace("progress");
			handleEvent(pe,"Progress",true);
		}
		
		private function onSoundComplete(e:Event):void
		{
			handleEvent(e,"Complete");
		}
		
		private function onSoundOpen(e:Event):void
		{
			handleEvent(e,"Open");
		}

		public function handleEventsForObjects(callbackDelegate:*, objects:Array,prefixes:Array,returnEventObjects:Boolean=false,cycleThroughTracking:Boolean=false):void
		{
			var ol:int=objects.length;
			var pl:int=prefixes.length;
			if(ol!=pl)throw new Error("The objects and prefixes must be a 1 to 1 relationship.");
			var i:int=0;
			for(i;i<ol;i++)handleEvents(objects[i],callbackDelegate,prefixes[i],returnEventObjects,cycleThroughTracking);
		}
		
		private function onSoundChange(e:Event):void
		{
			handleEvent(e,"Change");
		}
		
		private function onAssetComplete(ace:AssetCompleteEvent):void
		{
			handleEvent(ace,"AssetComplete",true);
		}
		
		private function onAssetError(aee:AssetErrorEvent):void
		{
			handleEvent(aee,"AssetError",true);
		}

		private function onProgress(pe:PreloadProgressEvent):void
		{
			handleEvent(pe,"Progress",true);
		}
		
		private function onComplete(e:*):void
		{
			handleEvent(e,"Complete");
		}
		
		private function onXMLLoaderComplete(e:Event):void
		{
			handleEvent(e,"Complete");
		}
		
		private function onFRCancel(e:Event):void
		{
			handleEvent(e, "Cancel");
		}
		
		private function onFRComplete(e:Event):void
		{
			handleEvent(e,"Complete");
		}
		
		private function onFROpen(e:Event):void
		{
			handleEvent(e,"Open");
		}
		
		private function onFRSelect(e:Event):void
		{
			handleEvent(e,"Select");
		}
		
		private function onFRUploadCompleteData(de:DataEvent):void
		{
			handleEvent(de,"UploadCompleteData",true);
		}
		
		private function onSocketClose(e:Event):void
		{
			handleEvent(e, "Close");
		}
		
		private function onSocketConnect(e:Event):void
		{
			handleEvent(e, "Connect");
		}
		
		private function onSocketData(pe:ProgressEvent):void
		{
			handleEvent(pe, "SocketData");
		}

		private function onCameraActivity(ae:ActivityEvent):void
		{
			handleEvent(ae, "Activity");
		}
	
		private function onCameraStatus(ae:StatusEvent):void
		{
			handleEvent(ae, "Status", true);
		}

		private function onLIProgress(pe:ProgressEvent):void
		{
			handleEvent(pe, "Progress");
		}

		private function onLIInit(e:Event):void
		{
			handleEvent(e, "Init");
		}
		
		private function onLIUnload(e:Event):void
		{
			handleEvent(e, "Unload");
		}
		
		private function onLIOpen(e:Event):void
		{
			handleEvent(e, "Open");
		}
		 
		private function onLIComplete(e:Event):void
		{
			handleEvent(e, "Complete");
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			handleEvent(e,"KeyDown",true);
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			handleEvent(e,"KeyUp",true);
		}
		
		private function onTabChildrenChange(e:Event):void
		{
			handleEvent(e,"TabChildrenChange");
		}
		
		private function onTabEnabledChange(e:Event):void
		{
			handleEvent(e,"TabEnabledChange");
		}
		
		private function onTabIndexChange(e:Event):void
		{
			handleEvent(e,"TabIndexChange");
		}
		
		private function onTextFieldChange(e:Event):void
		{
			handleEvent(e,"Change");
		}
		
		private function onTextFieldLink(e:TextEvent):void
		{
			handleEvent(e,"Link",true);
		}
		
		private function onStageFullscreen(e:Event):void
		{
			handleEvent(e,"Fullscreen");
		}
		
		private function onStageResize(e:Event):void
		{
			handleEvent(e,"Resize");
		}
		
		private function onStageMouseLeave(e:Event):void
		{
			handleEvent(e,"MouseLeave");
		}
		
		private function onTimer(e:Event):void
		{
			handleEvent(e,"Timer");
		}
		
		private function onTimerComplete(e:Event):void
		{
			handleEvent(e,"TimerComplete");
		}
		
		private function onIORollOver(e:MouseEvent):void
		{
			handleEvent(e,"RollOver");
		}
		
		private function onIORollOut(e:MouseEvent):void
		{
			handleEvent(e,"RollOut");
		}

		private function onIOFocusIn(e:Event):void
		{
			handleEvent(e,"FocusIn");
		}
		
		private function onIOFocusOut(e:Event):void
		{
			handleEvent(e,"FocusOut");
		}
		
		private function onIOKeyFocusChange(e:Event):void
		{
			handleEvent(e,"KeyFocusChange");
		}
		
		private function onIOMouseFocusChange(e:Event):void
		{
			handleEvent(e,"MouseFocusChange");
		}
		
		private function onDOAdded(e:Event):void
		{
			handleEvent(e,"Added");
		}

		private function onDOAddedToStage(e:Event):void
		{
			handleEvent(e,"AddedToStage");
		}
		
		private function onDOActivate(e:Event):void
		{
			handleEvent(e,"Activate");
		}
		
		private function onDODeactivate(e:Event):void
		{
			handleEvent(e,"Deactivate");
		}
		
		private function onDORemoved(e:Event):void
		{
			handleEvent(e,"Removed");
		}
		
		private function onDORemovedFromStage(e:Event):void
		{
			handleEvent(e,"RemovedFromStage");
		}

		private function onIOClick(e:MouseEvent):void
		{
			handleEvent(e,"Click");
		}
		
		private function onIODoubleClick(e:MouseEvent):void
		{
			handleEvent(e,"DoubleClick");
		}
		
		private function onIOMouseDown(e:MouseEvent):void
		{
			handleEvent(e,"MouseDown");
		}
		
		private function onIOMouseMove(e:MouseEvent):void
		{
			handleEvent(e,"MouseMove");
		}
		
		private function onIOMouseOver(e:MouseEvent):void
		{
			handleEvent(e,"MouseOver");
		}
		
		private function onIOMouseOut(e:MouseEvent):void
		{
			handleEvent(e,"MouseOut");
		}
		
		private function onIOMouseUp(e:MouseEvent):void
		{
			handleEvent(e,"MouseUp");
		}
	
		private function onIOMouseWheel(e:MouseEvent):void
		{
			handleEvent(e,"MouseWheel",true);
		}
		
		/**
		 * Generic method used to handle all events, and possibly call
		 * the callback on the defined callback delegate.
		 */
		private function handleEvent(e:*, func:String, forceEventObjectPass:Boolean=false):void
		{
			var obj:IEventDispatcher=IEventDispatcher(e.currentTarget || e.target);
			if(!edinfo[obj])return;
			var info:Object=Object(edinfo[obj]);
			var f:String=info.callbackPrefix+func;
			if(info.passThroughTracking&&!info.trackingID)Tracking.track(f);
			else if(info.passThroughTracking&&info.trackingID)
			{
				f=info.trackingID+func;
				Tracking.track(f);
			}
			if(!(f in info.callbackDelegate))return;
			if(info.passEventObjects||forceEventObjectPass)info.callbackDelegate[f](e);
			else info.callbackDelegate[f]();
		}
		
		/**
		 * A shorcut for the disposeEventsForObject method, this will used
		 * in favor of the latter in 1.0.
		 * 
		 * @param obj The object in which events are being managed.
		 */
		public function disposeEvents(obj:IEventDispatcher):void
		{
			disposeEventsForObject(obj);
		}

		/**
		 * Dispose of events for an object that was being managed by this event manager.
		 * 
		 * @param	obj	The object in which events are being managed.
		 */
		public function disposeEventsForObject(obj:IEventDispatcher):void
		{
			if(!edinfo[obj])return;
			if(edinfo[obj])edinfo[obj]=null;
			if(obj is XMLLoader)
			{
				var x:XMLLoader=XMLLoader(obj);
				edinfo[x.contentLoader]=null;
				x.contentLoader.removeEventListener(Event.COMPLETE,onXMLLoaderComplete);
				return;
			}
			if(obj is Timer)
			{
				obj.removeEventListener(TimerEvent.TIMER, onTimer);
				obj.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete); 
				return;
			}
			if(obj is LoaderInfo||obj is URLLoader)
			{
				obj.removeEventListener(Event.COMPLETE, onLIComplete);
				obj.removeEventListener(Event.OPEN, onLIOpen);
				obj.removeEventListener(Event.UNLOAD, onLIUnload);
				obj.removeEventListener(Event.INIT, onLIInit);
				obj.removeEventListener(ProgressEvent.PROGRESS, onLIProgress);
				return;
			}
			if(obj is Camera||obj is Microphone)
			{
				obj.removeEventListener(ActivityEvent.ACTIVITY, onCameraActivity);
				obj.removeEventListener(StatusEvent.STATUS, onCameraStatus);
				return;
			}
			if(obj is Socket)
			{
				obj.removeEventListener(Event.CLOSE, onSocketClose);
				obj.removeEventListener(Event.CONNECT, onSocketConnect);
				obj.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
				return;
			}
			if(obj is NetConnection)
			{
				obj.removeEventListener(StatusEvent.STATUS, onCameraStatus);
				return;
			}
			if(obj is NetStream)
			{
				obj.removeEventListener(StatusEvent.STATUS, onCameraStatus);
				return;
			}
			if(obj is FileReference)
			{
				obj.removeEventListener(Event.CANCEL, onFRCancel);
				obj.removeEventListener(Event.COMPLETE, onFRComplete);
				obj.removeEventListener(Event.OPEN,onFROpen);
				obj.removeEventListener(Event.SELECT, onFRSelect);
				obj.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onFRUploadCompleteData);
				return;
			}
			if(obj is TextField)
			{
				obj.removeEventListener(Event.CHANGE, onTextFieldChange);
				obj.removeEventListener(TextEvent.LINK, onTextFieldLink);
				return;
			}
			if(obj is PreloadController)
			{
				obj.removeEventListener(PreloadProgressEvent.PROGRESS, onProgress);
				obj.removeEventListener(Event.COMPLETE, onComplete);
				obj.removeEventListener(AssetCompleteEvent.COMPLETE, onAssetComplete);
				obj.removeEventListener(AssetErrorEvent.ERROR,onAssetError);
			}
			if(obj is FLV)
			{
				obj.removeEventListener(FLVEvent.PROGRESS,onFLVProgress);
				obj.removeEventListener(FLVEvent.START,onFLVStart);
				obj.removeEventListener(FLVEvent.STOP,onFLVStop);
				obj.removeEventListener(FLVEvent.SEEK_NOTIFY,onFLVSeekNotify);
				obj.removeEventListener(FLVEvent.SEEK_INVALID_TIME,onFLVSeekInvalidTime);
				obj.removeEventListener(FLVEvent.STREAM_NOT_FOUND,onFLVStreamNotFound);
				obj.removeEventListener(FLVEvent.BUFFER_FLUSH,onFLVBufferFlush);
				obj.removeEventListener(FLVEvent.BUFFER_EMPTY,onFLVBufferEmpty);
				obj.removeEventListener(FLVEvent.BUFFER_FULL,onFLVBufferFull);
				obj.removeEventListener(FLVEvent.CUE_POINT,onFLVCuePoint);
				obj.removeEventListener(FLVEvent.METADATA,onFLVMetaData);
			}
			if(obj is InteractiveObject)
			{
				obj.removeEventListener(Event.RESIZE, onStageResize);
				obj.removeEventListener(Event.FULLSCREEN, onStageFullscreen);
				obj.removeEventListener(Event.ADDED,onDOAdded);
				obj.removeEventListener(Event.ADDED_TO_STAGE,onDOAddedToStage);
				obj.removeEventListener(Event.ACTIVATE,onDOActivate);
				obj.removeEventListener(Event.DEACTIVATE,onDODeactivate);
				obj.removeEventListener(Event.REMOVED,onDORemoved);
				obj.removeEventListener(Event.REMOVED_FROM_STAGE,onDORemovedFromStage);
				obj.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
				obj.removeEventListener(MouseEvent.CLICK,onIOClick);
				obj.removeEventListener(MouseEvent.DOUBLE_CLICK,onIODoubleClick);
				obj.removeEventListener(MouseEvent.MOUSE_DOWN,onIOMouseDown);
				obj.removeEventListener(MouseEvent.MOUSE_MOVE,onIOMouseMove);
				obj.removeEventListener(MouseEvent.MOUSE_UP,onIOMouseUp);
				obj.removeEventListener(MouseEvent.MOUSE_OUT,onIOMouseOut);
				obj.removeEventListener(MouseEvent.MOUSE_OVER,onIOMouseOver);
				obj.removeEventListener(MouseEvent.MOUSE_WHEEL,onIOMouseWheel);
				obj.removeEventListener(MouseEvent.ROLL_OUT, onIORollOut);
				obj.removeEventListener(MouseEvent.ROLL_OVER,onIORollOver);
				obj.removeEventListener(FocusEvent.FOCUS_IN,onIOFocusIn);
				obj.removeEventListener(FocusEvent.FOCUS_OUT,onIOFocusOut);
				obj.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,onIOKeyFocusChange);
				obj.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,onIOMouseFocusChange);
				obj.removeEventListener(Event.TAB_CHILDREN_CHANGE, onTabChildrenChange);
				obj.removeEventListener(Event.TAB_ENABLED_CHANGE, onTabEnabledChange);
				obj.removeEventListener(Event.TAB_INDEX_CHANGE,onTabIndexChange);
				obj.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				obj.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			}
			if(obj is Sound)
			{
				obj.removeEventListener(Event.COMPLETE,onSoundComplete);
				obj.removeEventListener(ProgressEvent.PROGRESS,onSoundProgress);
				obj.removeEventListener(Event.OPEN,onSoundOpen);
				obj.removeEventListener(Event.ID3,onSoundID3);
			}
			if(obj is SoundManager)
			{
				obj.removeEventListener(Event.CHANGE,onSoundChange);
			}
		}
		
		/**
		 * Dispose of events for multiple objects.
		 * @param	objects	An array of objects whose events should be disposed of.
		 */
		public function disposeEventsForObjects(...objects:Array):void
		{
			for each(var obj:* in objects)disposeEventsForObject(obj);
		}	
	}
}