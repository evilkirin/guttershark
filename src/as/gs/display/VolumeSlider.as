package gs.display 
{
	import gs.support.bindings.BindableObject;
	import gs.support.bindings.PropertyChangeEvent;
	import gs.util.MathUtils;

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * Dispatched any time the component
	 * is updated to reflect a new level.
	 * 
	 * @eventType flash.events.Event
	 */
	[Event("update", type="flash.events.Event")]

	/**
	 * The VolumeSlider class is a quick way to implement
	 * a volume slider.
	 * 
	 * <p>The example below shows two different styles - these
	 * styles are implemented by you, using whatever movie clip
	 * structures you like, you just provide this class with
	 * a highlight clip that indicates the level and hit object
	 * that triggers updates to the highlight state. See the example
	 * fla listed below to see how these are setup.</p>
	 * 
	 * @example (examples/display/controls/volumeslider/)
	 * <script src="../../../../examples/swfobject.js"></script>
	 * <br/><div id="flashcontent"></div>
	 * <script>
	 * var vars={};
	 * var params={scale:'noScale',salign:'lt',menu:'false'};
	 * var attribs={id:'flaswf',name:'flaswf'}; 
	 * swfobject.embedSWF("../../../../examples/display/volumeslider/deploy/main.swf","flashcontent","86","20","9.0.0",null,vars,params,attribs);
	 * </script>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class VolumeSlider extends BindableObject
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
		 * Constructor for VolumeSlider instances.
		 * 
		 * @param barsMask The mask movie clip that contains vertical bars.
		 * @param hit A hit clip that sits on top of all the display objects.
		 * @param highlight The highlight clip.
		 */
		public function VolumeSlider(hit:MovieClip,highlight:MovieClip)
		{
			if(!hit)throw new ArgumentError("Parameter {hit} cannot be null.");
			if(!highlight)throw new ArgumentError("Parameter {highlight} cannot be null.");
			firstProps={};
			firstProps.sliderWidth=hit.width;
			firstProps.highlightWidth=highlight.width;
			if(highlight.stage)stage=highlight.stage;
			else highlight.addEventListener(Event.ADDED_TO_STAGE,onBarsMaskAddedToStage);
			this.hit=hit;
			this.highlight=highlight;
			init();
		}
		
		/**
		 * When bars mask is added to stage, grab its stage reference.
		 */
		private function onBarsMaskAddedToStage(e:Event):void
		{
			if(highlight.stage)stage=highlight.stage;
			highlight.removeEventListener(Event.ADDED_TO_STAGE,onBarsMaskAddedToStage);
		}

		/**
		 * initialize
		 */
		private function init():void
		{
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
			highlight.width=hit.mouseX;
			volume=volume;
			stage.addEventListener(MouseEvent.MOUSE_UP,onStageUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
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
			if(highlight.width==nw)return;
			var nw:Number=firstProps.sliderWidth*level;
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.CHANGE+"volume","volume"));
			highlight.width=nw;
			update();
		}
		
		/**
		 * On mouse move.
		 */
		private function onMouseMove(e:MouseEvent):void
		{
			highlight.width=hit.mouseX;
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
			stage=null;
			highlight=null;
			firstProps=null;
			hit=null;
		}
	}
}