package gs.display.decorators 
{
	import gs.audio.AudioObject;
	import gs.util.DecoratorUtils;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	/**
	 * The SoundDecorator class decorates a sprite with
	 * sound functionality for most mouse events.
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final dynamic public class SoundDecorator extends Decorator
	{
		
		/**
		 * Whether or not this sound decorator is enabled.
		 */
		public var enabled:Boolean;
		
		/**
		 * The clips' stage reference.
		 */
		private var clipStageRef:Stage;
		
		/**
		 * click sound.
		 */
		private var _clicksound:AudioObject;
		
		/**
		 * double click sound.
		 */
		private var _dclickSound:AudioObject;
		
		/**
		 * over sound.
		 */
		private var _overSound:AudioObject;
		
		/**
		 * down sown
		 */
		private var _downSound:AudioObject;
		
		/**
		 * up sound.
		 */
		private var _upSound:AudioObject;
		
		/**
		 * mouse out sound.
		 */
		private var _outSound:AudioObject;
		
		/**
		 * mouse up outside sound.
		 */
		private var _upOutsideSound:AudioObject;
		
		/**
		 * flag for using up outside.
		 */
		private var useUpOutside:Boolean;
		
		/**
		 * Flag when mouse down over sprite.
		 */
		private var downOverSprite:Boolean;

		/**
		 * Constructor for SoundDecorator instances.
		 * 
		 * <p>You can pass an object with the same properties
		 * available on this class, that will automatically
		 * get applied.</p>
		 * 
		 * @example Passing a sound object:
		 * <listing>	
		 * var sd:SoundDecorator=new SoundDecorator(mySprite,{clickSound:"blip",overSound:"ringSound"});
		 * </listing>
		 * 
		 * @param clip The sprite to decorate.
		 * @param sounds An object with sound properties to used.
		 */
		public function SoundDecorator(decorate:*,sounds:Object)
		{
			if(!decorate)throw new Error("Parameter {decorate} cannot be null.");
			sprite=decorate;
			methods=new Dictionary();
			props=DecoratorUtils.buildProps(["clickSound","overSound","downSound","upSound","outSound","upOutsideSound","doubleClickSound"]);
			if(sounds.clickSound)clickSound=sounds.clickSound;
			if(sounds.overSound)overSound=sounds.overSound;
			if(sounds.downSound)downSound=sounds.downSound;
			if(sounds.upSound)upSound=sounds.upSound;
			if(sounds.outSound)outSound=sounds.outSound;
			if(sounds.upOutsideSound)upOutsideSound=sounds.upOutsideSound;
			if(sounds.doubleClickSound)doubleClickSound=sounds.doubleClickSound;
		}
		
		/**
		 * Set the click sound.
		 * 
		 * @param ao The audible object for the click sound.
		 */
		public function set clickSound(ao:AudioObject):void
		{
			_clicksound=ao;
			sprite.removeEventListener(MouseEvent.CLICK,onClick);
			sprite.addEventListener(MouseEvent.CLICK,onClick,false,0,true);
		}
		
		/**
		 * On click
		 */
		private function onClick(e:MouseEvent):void
		{
			if(!enabled)return;
			_clicksound.play();
		}
		
		/**
		 * Set the double click sound.
		 * 
		 * @param ao The audible object for the double click sound.
		 */
		public function set doubleClickSound(ao:AudioObject):void
		{
			_dclickSound=ao;
			sprite.removeEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClick);
			sprite.addEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClick,false,0,true);
		}
		
		/**
		 * On double click
		 */
		private function onDoubleClick(e:MouseEvent):void
		{
			if(!enabled)return;
			_dclickSound.play();
		}
		
		/**
		 * Set the over sound.
		 * 
		 * @param ao The audio object for the over sound.
		 */
		public function set overSound(ao:AudioObject):void
		{
			_overSound=ao;
			sprite.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			sprite.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver,false,0,true);
		}
		
		/**
		 * On mouse over.
		 */
		private function onMouseOver(e:MouseEvent):void
		{
			if(!enabled)return;
			_overSound.play();
		}
		
		/**
		 * Set the down sound.
		 * 
		 * @param ao The audio object for the down sound.
		 */
		public function set downSound(ao:AudioObject):void
		{
			_downSound=ao;
			sprite.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			sprite.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false,0,true);
		}
		
		/**
		 * On mouse down.
		 */
		private function onMouseDown(e:MouseEvent):void
		{
			if(!enabled)return;
			_downSound.play();
		}

		/**
		 * Set the up sound.
		 * 
		 * @param ao The audio object for the up sound.
		 */
		public function set upSound(ao:AudioObject):void
		{
			_upSound=ao;
			sprite.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			sprite.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,false,0,true);
		}
		
		/**
		 * On mouse up.
		 */
		private function onMouseUp(e:MouseEvent):void
		{
			if(!enabled)return;
			_upSound.play();
		}

		/**
		 * Set the out sound.
		 * 
		 * @param ao The audio object for the out sound.
		 */
		public function set outSound(ao:AudioObject):void
		{
			_outSound=ao;
			sprite.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			sprite.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut,false,0,true);
		}
		
		/**
		 * On mouse out.
		 */
		private function onMouseOut(e:MouseEvent):void
		{
			if(!enabled)return;
			_outSound.play();
		}
		
		/**
		 * Set the up outside sound.
		 * 
		 * @param val An audibleId that get's used with the sound manager.
		 */
		public function set upOutsideSound(ao:AudioObject):void
		{
			_upOutsideSound=ao;
			useUpOutside=true;
			sprite.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownForOutside);
			if(!sprite.stage)
			{
				sprite.removeEventListener(Event.ADDED_TO_STAGE,onClipAddedToStage);
				sprite.addEventListener(Event.ADDED_TO_STAGE,onClipAddedToStage,false,0,true);
				return;
			}
			clipStageRef=sprite.stage;
			clipStageRef.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpStage);
			clipStageRef.addEventListener(MouseEvent.MOUSE_UP,onMouseUpStage,false,0,true);
			sprite.addEventListener(Event.REMOVED_FROM_STAGE,onClipRemovedFromStage,false,0,true);
		}
		
		/**
		 * On mouse down over sprite, for outside up.
		 */
		private function onMouseDownForOutside(e:MouseEvent):void
		{
			downOverSprite=true;
		}

		/**
		 * On stage mouse up
		 */
		private function onMouseUpStage(e:MouseEvent):void
		{
			if(!enabled||!clipStageRef)return;
			if(sprite.hitTestPoint(clipStageRef.mouseX,clipStageRef.mouseY)) return;
			if(!downOverSprite)return;
			downOverSprite=false;
			_upOutsideSound.play();
		}
		
		/**
		 * On clip added to stage.
		 */
		private function onClipAddedToStage(e:Event):void
		{
			clipStageRef=sprite.stage;
			sprite.removeEventListener(Event.ADDED_TO_STAGE,onClipAddedToStage);
			sprite.addEventListener(Event.REMOVED_FROM_STAGE,onClipRemovedFromStage);
			if(useUpOutside)
			{
				clipStageRef.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpStage);
				clipStageRef.addEventListener(MouseEvent.MOUSE_UP,onMouseUpStage,false,0,true);
			}
		}
		
		/**
		 * On clip removed from stage.
		 */
		private function onClipRemovedFromStage(e:Event):void
		{
			sprite.removeEventListener(Event.REMOVED_FROM_STAGE,onClipRemovedFromStage);
			if(useUpOutside)
			{
				sprite.addEventListener(Event.ADDED_TO_STAGE,onClipAddedToStage,false,0,true);
				clipStageRef.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpStage);
			}
		}
		
		/**
		 * Dispose of this decorator.
		 */
		public function dispose():void
		{
			if(clipStageRef)clipStageRef.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpStage);
			sprite.removeEventListener(MouseEvent.CLICK,onClick);
			sprite.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			sprite.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			sprite.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			sprite.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			enabled=false;
			_clicksound=null;
			_downSound=null;
			_outSound=null;
			_overSound=null;
			_upOutsideSound=null;
			_upSound=null;
			sprite=null;
			clipStageRef=null;
			useUpOutside=false;
			downOverSprite=false;
		}
	}
}