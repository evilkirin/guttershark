package gs.display 
{
	import gs.support.bindings.PropertyChangeEvent;
	import gs.util.MathUtils;

	import com.greensock.TweenLite;

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	/**
	 * Dispatched any time the component
	 * is updated to reflect a new level.
	 * 
	 * @eventType flash.events.Event
	 */
	[Event("update", type="flash.events.Event")]

	/**
	 * The VimeoVolume class re-creates the vimeo.com
	 * volume control slider.
	 * 
	 * @example (examples/display/controls/vimeovolume/)
	 * <script src="../../../../examples/swfobject.js"></script>
	 * <br/><div id="flashcontent"></div>
	 * <script>
	 * var vars={};
	 * var params={scale:'noScale',salign:'lt',menu:'false'};
	 * var attribs={id:'flaswf',name:'flaswf'};
	 * swfobject.embedSWF("../../../../examples/display/vimeovolume/main.swf","flashcontent","33","20","9.0.0",null,vars,params,attribs);
	 * </script>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class VimeoVolume extends EventDispatcher
	{
		
		/**
		 * An update event when the level changes.
		 */
		public static const UPDATE:String="update";
		
		/**
		 * Stage ref.
		 */
		private var stage:Stage;
		
		/**
		 * Bars mask.
		 */
		private var barsMask:MovieClip;
		
		/**
		 * references to bar clips in the mask.
		 */
		private var barsInMask:Array;
		
		/**
		 * Hit clip.
		 */
		private var hit:MovieClip;
		
		/**
		 * The highlight clip.
		 */
		private var highlight:MovieClip;
		
		/**
		 * Initial property values.
		 */
		private var firstProps:Object;

		/**
		 * Constructor for VimeoVolume instances.
		 * 
		 * @param barsMask The mask movie clip that contains vertical bars.
		 * @param hit A hit clip that sits on top of all the display objects.
		 * @param highlight The highlight clip.
		 */
		public function VimeoVolume(barsMask:MovieClip,hit:MovieClip,highlight:MovieClip)
		{
			if(!barsMask)throw new ArgumentError("Parameter {barsMask} cannot be null.");
			if(!hit)throw new ArgumentError("Parameter {hit} cannot be null.");
			if(!highlight)throw new ArgumentError("Parameter {highlight} cannot be null.");
			firstProps={};
			firstProps.barsMaskHeight=barsMask.height;
			firstProps.sliderWidth=hit.width;
			firstProps.highlightWidth=highlight.width;
			if(barsMask.stage)stage=barsMask.stage;
			else barsMask.addEventListener(Event.ADDED_TO_STAGE,onBarsMaskAddedToStage);
			this.barsMask=barsMask;
			this.barsInMask=barsInMask;
			this.hit=hit;
			this.highlight=highlight;
			init();
		}
		
		/**
		 * When bars mask is added to stage, grab its stage reference.
		 */
		private function onBarsMaskAddedToStage(e:Event):void
		{
			if(barsMask.stage)stage=barsMask.stage;
			barsMask.removeEventListener(Event.ADDED_TO_STAGE,onBarsMaskAddedToStage);
		}

		/**
		 * initialize
		 */
		private function init():void
		{
			var i:int=0;
			barsInMask=[];
			var l:int=barsMask.numChildren;
			for(;i<l;i++) barsInMask.push(barsMask.getChildAt(int(i)));
			i=0;
			var bar:MovieClip;
			for(;i<l;i++)
			{
				bar=barsInMask[int(i)];
				bar.buttonMode = true;
				bar.addEventListener(MouseEvent.MOUSE_OVER,onBarOver);
				bar.addEventListener(MouseEvent.MOUSE_OUT,onBarOut);
				bar.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			}
			hit.buttonMode=true;
			hit.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
		}
		
		/**
		 * Dispatches update events.
		 */
		private function update():void
		{
			dispatchEvent(new Event(VimeoVolume.UPDATE));
		}
		
		/**
		 * On down for bar / hit.
		 */
		private function onDown(me:MouseEvent):void
		{
			if(!stage)
			{
				trace("WARNING: VimeoVolume instance doesn't have a stage reference, not doing anything.");
				return;
			}
			
			highlight.width=barsMask.mouseX;
			volume=volume;
			stage.addEventListener(MouseEvent.MOUSE_UP,onStageUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		}
		
		/**
		 * on bar out.
		 */
		private function onBarOut(me:MouseEvent):void
		{
			TweenLite.to(me.target,.25,{height:firstProps.barsMaskHeight});
		}
		
		/**
		 * on bar over.
		 */
		private function onBarOver(me:MouseEvent):void
		{
			TweenLite.to(me.target,.15,{height:hit.height});
		}
		
		/**
		 * [Bindable] The volume level based off of the highlight indicator, this
		 * property is bindable.
		 */
		public function get volume():Number
		{
			return (MathUtils.spread(highlight.width,firstProps.sliderWidth,100)*.01);
		}
		
		/**
		 * The volume level based off of the highlight indicator, this
		 * property is bindable.
		 */
		public function set volume(level:Number):void
		{
			var nw:Number=firstProps.sliderWidth*level;
			if(highlight.width==nw)return;
			highlight.width=nw;
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.CHANGE+"volume","volume"));
			update();
		}
		
		/**
		 * On mouse move.
		 */
		private function onMouseMove(e:MouseEvent):void
		{
			highlight.width=barsMask.mouseX;
			volume=volume;
		}
		
		/**
		 * On stage up.
		 */
		private function onStageUp(e:MouseEvent):void
		{
			if(!stage)return;
			stage.removeEventListener(MouseEvent.MOUSE_UP,onStageUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		}
		
		/**
		 * Dispose of this VimeoVolume control.
		 */
		public function dispose():void
		{
			if(stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP,onStageUp);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			}
			var bar:MovieClip;
			var i:int=0;
			var l:int=barsInMask.length;
			for(;i<l;i++)
			{
				bar=barsInMask[int(i)];
				bar.removeEventListener(MouseEvent.MOUSE_OVER,onBarOver);
				bar.removeEventListener(MouseEvent.MOUSE_OUT,onBarOut);
				bar.removeEventListener(MouseEvent.MOUSE_DOWN,onDown);
			}
			stage=null;
			highlight=null;
			barsInMask=null;
			barsMask=null;
			firstProps=null;
			hit=null;
		}
	}
}