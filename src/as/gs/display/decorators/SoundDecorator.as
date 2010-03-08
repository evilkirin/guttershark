package gs.display.decorators 
{
	import gs.managers.AssetManager;
	import gs.managers.SoundManager;
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
		 * Enabled flag.
		 */
		private var en:Boolean;
		
		/**
		 * The clips' stage reference.
		 */
		private var clipStageRef:Stage;
		
		/**
		 * The sound manager.
		 */
		private var snm:SoundManager;
		
		/**
		 * click sound.
		 */
		private var _clicksound:String;
		
		/**
		 * double click sound.
		 */
		private var _dclickSound:String;
		
		/**
		 * over sound.
		 */
		private var _overSound:String;
		
		/**
		 * down sown
		 */
		private var _downSound:String;
		
		/**
		 * up sound.
		 */
		private var _upSound:String;
		
		/**
		 * mouse out sound.
		 */
		private var _outSound:String;
		
		/**
		 * mouse up outside sound.
		 */
		private var _upOutsideSound:String;
		
		/**
		 * flag for using up outside.
		 */
		private var useUpOutside:Boolean;
		
		/**
		 * The audio group in the sound manager.
		 */
		private var groupId:String;
		
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
		 * @param audioGroupname An optional audio group name for the sound manager,
		 * by default it uses "soundDecorators."
		 */
		public function SoundDecorator(decorate:*,sounds:Object,audioGroupName:String="soundDecorators")
		{
			if(!decorate) throw new Error("Parameter {decorate} cannot be null.");
			if(!sounds) return;
			this.sprite=decorate;
			methods=new Dictionary();
			props=DecoratorUtils.buildProps(["clickSound","overSound","downSound","upSound","outSound","upOutsideSound","doubleClickSound"]);
			en=true;
			snm=SoundManager.gi();
			groupId=audioGroupName;
			if(!snm.doesGroupExist(groupId))snm.createGroup(groupId);
			if(sounds.clickSound)clickSound=sounds.clickSound;
			if(sounds.overSound)overSound=sounds.overSound;
			if(sounds.downSound)downSound=sounds.downSound;
			if(sounds.upSound)upSound=sounds.upSound;
			if(sounds.outSound)outSound=sounds.outSound;
			if(sounds.upOutsideSound)upOutsideSound=sounds.upOutsideSound;
			if(sounds.doubleClickSound)doubleClickSound=sounds.doubleClickSound;
		}
		
		/**
		 * Enable or disable sound functionality.
		 */
		public function set enabled(val:Boolean):void
		{
			en=val;
		}
		
		/**
		 * Enable or disable sound functionality.
		 */
		public function get enabled():Boolean
		{
			return en;
		}
		
		/**
		 * Set the click sound.
		 * 
		 * @param val An audibleId that get's used with the sound manager.
		 */
		public function set clickSound(soundLibraryName:String):void
		{
			if(_clicksound)snm.getGroup(groupId).removeObject(_clicksound);
			snm.getGroup(groupId).addObject(soundLibraryName.toLowerCase(),AssetManager.getSound(soundLibraryName));
			_clicksound=soundLibraryName.toLowerCase();
			sprite.removeEventListener(MouseEvent.CLICK,onClick);
			sprite.addEventListener(MouseEvent.CLICK,onClick,false,0,true);
		}
		
		/**
		 * On click
		 */
		private function onClick(e:MouseEvent):void
		{
			if(!en)return;
			snm.getGroup(groupId).playSound(_clicksound);
		}
		
		/**
		 * Set the double click sound.
		 * 
		 * @param val An audibleId that get's used with the sound manager.
		 */
		public function set doubleClickSound(soundLibraryName:String):void
		{
			if(_dclickSound)snm.getGroup(groupId).removeObject(_dclickSound);
			snm.getGroup(groupId).addObject(soundLibraryName.toLowerCase(),AssetManager.getSound(soundLibraryName));
			_dclickSound=soundLibraryName.toLowerCase();
			sprite.removeEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClick);
			sprite.addEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClick,false,0,true);
		}
		
		/**
		 * On double click
		 */
		private function onDoubleClick(e:MouseEvent):void
		{
			if(!en)return;
			snm.getGroup(groupId).playSound(_dclickSound);
		}
		
		/**
		 * Set the over sound.
		 * 
		 * @param val An audibleId that get's used with the sound manager.
		 */
		public function set overSound(soundLibraryName:String):void
		{
			if(_overSound)snm.getGroup(groupId).removeObject(_overSound);
			snm.getGroup(groupId).addObject(soundLibraryName.toLowerCase(),AssetManager.getSound(soundLibraryName));
			_overSound=soundLibraryName.toLowerCase();
			sprite.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			sprite.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver,false,0,true);
		}
		
		/**
		 * On mouse over.
		 */
		private function onMouseOver(e:MouseEvent):void
		{
			if(!en)return;
			snm.getGroup(groupId).playSound(_overSound);
		}
		
		/**
		 * Set the down sound.
		 * 
		 * @param val An audibleId that get's used with the sound manager.
		 */
		public function set downSound(soundLibraryName:String):void
		{
			if(_downSound)snm.getGroup(groupId).removeObject(_downSound);
			snm.getGroup(groupId).addObject(soundLibraryName.toLowerCase(),AssetManager.getSound(soundLibraryName));
			_downSound=soundLibraryName.toLowerCase();
			sprite.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			sprite.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false,0,true);
		}
		
		/**
		 * On mouse down.
		 */
		private function onMouseDown(e:MouseEvent):void
		{
			if(!en)return;
			snm.getGroup(groupId).playSound(_downSound);
		}
		
		/**
		 * Set the up sound.
		 * 
		 * @param val An audibleId that get's used with the sound manager.
		 */
		public function set upSound(soundLibraryName:String):void
		{
			if(_upSound)snm.getGroup(groupId).removeObject(_upSound);
			snm.getGroup(groupId).addObject(soundLibraryName.toLowerCase(),AssetManager.getSound(soundLibraryName));
			_upSound=soundLibraryName.toLowerCase();
			sprite.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			sprite.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,false,0,true);
		}
		
		/**
		 * On mouse up.
		 */
		private function onMouseUp(e:MouseEvent):void
		{
			if(!en)return;
			snm.getGroup(groupId).playSound(_upSound);
		}
		
		/**
		 * Set the out sound.
		 * 
		 * @param val An audibleId that get's used with the sound manager.
		 */
		public function set outSound(soundLibraryName:String):void
		{
			if(_outSound)snm.getGroup(groupId).removeObject(_outSound);
			snm.getGroup(groupId).addObject(soundLibraryName.toLowerCase(),AssetManager.getSound(soundLibraryName));
			_outSound=soundLibraryName.toLowerCase();
			sprite.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			sprite.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut,false,0,true);
		}
		
		/**
		 * On mouse out.
		 */
		private function onMouseOut(e:MouseEvent):void
		{
			if(!en)return;
			snm.getGroup(groupId).playSound(_outSound);
		}
		
		/**
		 * Set the up outside sound.
		 * 
		 * @param val An audibleId that get's used with the sound manager.
		 */
		public function set upOutsideSound(soundLibraryName:String):void
		{
			if(_upOutsideSound)snm.getGroup(groupId).removeObject(_upOutsideSound);
			snm.getGroup(groupId).addObject(soundLibraryName.toLowerCase(),AssetManager.getSound(soundLibraryName));
			_upOutsideSound=soundLibraryName.toLowerCase();
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
			if(!en)return;
			if(!clipStageRef)return;
			if(sprite.hitTestPoint(clipStageRef.mouseX,clipStageRef.mouseY)) return;
			if(!downOverSprite)return;
			downOverSprite=false;
			snm.getGroup(groupId).playSound(_upOutsideSound);
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
			en=false;
			_clicksound=null;
			_downSound=null;
			_outSound=null;
			_overSound=null;
			_upOutsideSound=null;
			_upSound=null;
			sprite=null;
			clipStageRef=null;
			snm=null;
			useUpOutside=false;
			downOverSprite=false;
			groupId=null;
		}
	}
}