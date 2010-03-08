package gs.util
{
	import gs.display.flv.FLV;
	import gs.events.AssetCompleteEvent;
	import gs.events.AssetErrorEvent;
	import gs.events.FLVEvent;
	import gs.events.PreloadProgressEvent;
	import gs.preloading.Preloader;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	/**
	 * The EventHandler class is a utility to simplify
	 * adding events to display objects. It allows you
	 * to specify callback objects which predefined
	 * functions are defined.
	 * 
	 * @example Using EventHandler:
	 * <listing>	
	 * public class Main extends Sprite
	 * {
	 *     public var mc:MovieClip;
	 *     private var eh:EventHandler;
	 *     private var eh2:EventHandler;
	 *     
	 *     public function Main()
	 *     {
	 *         eh = new EventHandler(mc,this,"onMC");
	 *         eh2 = new EventHandler(mc,this,"onMC2");
	 *     }
	 * 
	 *     public function onMCClick():void
	 *     {
	 *         trace("CLICK");
	 *     }
	 *    
	 *     public function onMC2Click():void
	 *     {
	 *         trace("clicked from 2");
	 *         eh2.dispose();
	 *         eh2 = null;
	 *     }
	 * }
	 * </listing>
	 * 
	 * <p>EventHandler supports handling events for these objects:</p>
	 * 
	 * <ul>
	 * <li>InteractiveObject</li>
	 * <li>Preloader</li>
	 * <li>FLV</li>
	 * <li>XMLLoader</li>
	 * </ul>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class EventHandler 
	{
		
		/**
		 * The object dispatching events.
		 */
		private var obj:*;
		
		/**
		 * The callback object.
		 */
		private var callbackScope:*;
		
		/**
		 * The callback method prefix.
		 */
		private var callbackPrefix:String;
		
		/**
		 * Whether or not to return event objects.
		 */
		private var returnEventObjs:Boolean;
		
		/**
		 * Contstructor for EventHandler instances.
		 * 
		 * @param obj The object to listen to.
		 * @param callbackDelegate The object that contains callback methods.
		 * @param prefix The callback method prefix.
		 * @param returnEventObjets Whether or not to return event objects.
		 */
		public function EventHandler(obj:*, callbackDelegate:*, prefix:String, returnEventObjects:Boolean=false):void
		{
			this.obj=obj;
			callbackPrefix=prefix;
			callbackScope=callbackDelegate;
			returnEventObjs=returnEventObjects;
			if(obj is InteractiveObject)
			{
				if((callbackPrefix + "Resize") in callbackDelegate) obj.addEventListener(Event.RESIZE, onStageResize,false,0,true);
				if((callbackPrefix + "Fullscreen") in callbackDelegate) obj.addEventListener(Event.FULLSCREEN, onStageFullscreen,false,0,true);
				if((callbackPrefix + "Added") in callbackDelegate) obj.addEventListener(Event.ADDED,onDOAdded,false,0,true);
				if((callbackPrefix + "AddedToStage") in callbackDelegate) obj.addEventListener(Event.ADDED_TO_STAGE,onDOAddedToStage,false,0,true);
				if((callbackPrefix + "Activate") in callbackDelegate) obj.addEventListener(Event.ACTIVATE,onDOActivate,false,0,true);
				if((callbackPrefix + "Deactivate") in callbackDelegate) obj.addEventListener(Event.DEACTIVATE,onDODeactivate,false,0,true);
				if((callbackPrefix + "Removed") in callbackDelegate) obj.addEventListener(Event.REMOVED,onDORemoved,false,0,true);
				if((callbackPrefix + "RemovedFromStage") in callbackDelegate) obj.addEventListener(Event.REMOVED_FROM_STAGE,onDORemovedFromStage,false,0,true);
				if((callbackPrefix + "MouseLeave") in callbackDelegate) obj.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave,false,0,true);
				if((callbackPrefix + "Click") in callbackDelegate) obj.addEventListener(MouseEvent.CLICK,onIOClick,false,0,true);
				if((callbackPrefix + "DoubleClick") in callbackDelegate) obj.addEventListener(MouseEvent.DOUBLE_CLICK,onIODoubleClick,false,0,true);
				if((callbackPrefix + "MouseDown") in callbackDelegate) obj.addEventListener(MouseEvent.MOUSE_DOWN,onIOMouseDown,false,0,true);
				if((callbackPrefix + "MouseMove") in callbackDelegate) obj.addEventListener(MouseEvent.MOUSE_MOVE,onIOMouseMove,false,0,true);
				if((callbackPrefix + "MouseUp") in callbackDelegate) obj.addEventListener(MouseEvent.MOUSE_UP,onIOMouseUp,false,0,true);
				if((callbackPrefix + "MouseOut") in callbackDelegate) obj.addEventListener(MouseEvent.MOUSE_OUT,onIOMouseOut,false,0,true);
				if((callbackPrefix + "MouseOver") in callbackDelegate) obj.addEventListener(MouseEvent.MOUSE_OVER,onIOMouseOver,false,0,true);
				if((callbackPrefix + "MouseWheel") in callbackDelegate) obj.addEventListener(MouseEvent.MOUSE_WHEEL,onIOMouseWheel,false,0,true);
				if((callbackPrefix + "RollOut") in callbackDelegate) obj.addEventListener(MouseEvent.ROLL_OUT, onIORollOut,false,0,true);
				if((callbackPrefix + "RollOver") in callbackDelegate) obj.addEventListener(MouseEvent.ROLL_OVER,onIORollOver,false,0,true);
				if((callbackPrefix + "FocusIn") in callbackDelegate) obj.addEventListener(FocusEvent.FOCUS_IN,onIOFocusIn,false,0,true);
				if((callbackPrefix + "FocusOut") in callbackDelegate) obj.addEventListener(FocusEvent.FOCUS_OUT,onIOFocusOut,false,0,true);
				if((callbackPrefix + "KeyFocusChange") in callbackDelegate) obj.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,onIOKeyFocusChange,false,0,true);
				if((callbackPrefix + "MouseFocusChange") in callbackDelegate) obj.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,onIOMouseFocusChange,false,0,true);
				if((callbackPrefix + "TabChildrenChange") in callbackDelegate) obj.addEventListener(Event.TAB_CHILDREN_CHANGE, onTabChildrenChange,false,0,true);
				if((callbackPrefix + "TabEnabledChange") in callbackDelegate) obj.addEventListener(Event.TAB_ENABLED_CHANGE, onTabEnabledChange,false,0,true);
				if((callbackPrefix + "TabIndexChange") in callbackDelegate) obj.addEventListener(Event.TAB_INDEX_CHANGE,onTabIndexChange,false,0,true);
				if((callbackPrefix + "KeyDown") in callbackDelegate) obj.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown,false,0,true);
				if((callbackPrefix + "KeyUp") in callbackDelegate) obj.addEventListener(KeyboardEvent.KEY_UP, onKeyUp,false,0,true);
			}
			if(obj is FLV)
			{
				if(((callbackPrefix + "Progress") in callbackDelegate)) obj.addEventListener(FLVEvent.PROGRESS,onFLVProgress,false,0,true);
				if(((callbackPrefix + "Start") in callbackDelegate)) obj.addEventListener(FLVEvent.START,onFLVStart,false,0,true);
				if(((callbackPrefix + "Stop") in callbackDelegate)) obj.addEventListener(FLVEvent.STOP,onFLVStop,false,0,true);
				if(((callbackPrefix + "SeekNotify") in callbackDelegate)) obj.addEventListener(FLVEvent.SEEK_NOTIFY,onFLVSeekNotify,false,0,true);
				if(((callbackPrefix + "SeekInvalidTime") in callbackDelegate)) obj.addEventListener(FLVEvent.SEEK_INVALID_TIME,onFLVSeekInvalidTime,false,0,true);
				if(((callbackPrefix + "StreamNotFound") in callbackDelegate)) obj.addEventListener(FLVEvent.STREAM_NOT_FOUND,onFLVStreamNotFound,false,0,true);
				if(((callbackPrefix + "BufferFlush") in callbackDelegate)) obj.addEventListener(FLVEvent.BUFFER_FLUSH,onFLVBufferFlush,false,0,true);
				if(((callbackPrefix + "BufferEmpty") in callbackDelegate)) obj.addEventListener(FLVEvent.BUFFER_EMPTY,onFLVBufferEmpty,false,0,true);
				if(((callbackPrefix + "BufferFull") in callbackDelegate)) obj.addEventListener(FLVEvent.BUFFER_FULL,onFLVBufferFull,false,0,true);
				if(((callbackPrefix + "CuePoint") in callbackDelegate)) obj.addEventListener(FLVEvent.CUE_POINT,onFLVCuePoint,false,0,true);
				if(((callbackPrefix + "Meta") in callbackDelegate)) obj.addEventListener(FLVEvent.METADATA,onFLVMetaData,false,0,true);
				if(((callbackPrefix + "XMP") in callbackDelegate)) obj.addEventListener(FLVEvent.XMP_DATA,onFLVXMPData,false,0,true);
			}
			if(obj is Preloader)
			{
				if(((callbackPrefix + "Progress") in callbackDelegate)) obj.addEventListener(PreloadProgressEvent.PROGRESS,onProgress,false,0,true);
				if(((callbackPrefix + "Complete") in callbackDelegate)) obj.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
				if(((callbackPrefix + "AssetComplete") in callbackDelegate)) obj.addEventListener(AssetCompleteEvent.COMPLETE, onAssetComplete, false, 0, true);
				if(((callbackPrefix + "AssetError") in callbackDelegate)) obj.addEventListener(AssetErrorEvent.ERROR,onAssetError, false, 0, true);
			}
			if(obj is XMLLoader)
			{
				if((callbackPrefix + "XMLComplete") in callbackDelegate) obj.contentLoader.addEventListener(Event.COMPLETE,onXMLLoaderComplete,false,0,true);
			}
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
		
		private function onFLVXMPData(fe:FLVEvent):void
		{
			handleEvent(fe,"XMP",true);
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
			handleEvent(e,"XMLComplete");
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
		private function handleEvent(e:*,func:String,forceEventObjectPass:Boolean=false):void
		{
			var f:String=callbackPrefix+func;
			if(!(f in callbackScope))return;
			if(returnEventObjs || forceEventObjectPass)callbackScope[f](e);
			else callbackScope[f]();
		}

		/**
		 * Dispose of this event handler.
		 */
		public function dispose():void
		{
			if(obj is XMLLoader)
			{
				obj.contentLoader.removeEventListener(Event.COMPLETE,onXMLLoaderComplete);
			}
			if(obj is Preloader)
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
				obj.removeEventListener(FLVEvent.XMP_DATA,onFLVXMPData);
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
		}
	}
}
