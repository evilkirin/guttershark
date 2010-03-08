package gs.util
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * The KeyHandler class is a shortcut to handle keyboard events.
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * <p><strong>Supported Key Shortcuts for Key Sequences</strong></p>
	 * <ul>
	 * <li>BACKSPACE</li>
	 * <li>CONTROL</li>
	 * <li>CAPSLOCK</li>
	 * <li>DELETE</li>
	 * <li>DOWN</li>
	 * <li>END</li>
	 * <li>ENTER</li>
	 * <li>ESC</li>
	 * <li>F1</li>
	 * <li>F2</li>
	 * <li>F3</li>
	 * <li>F4</li>
	 * <li>F5</li>
	 * <li>F6</li>
	 * <li>F7</li>
	 * <li>F8</li>
	 * <li>F9</li>
	 * <li>F10</li>
	 * <li>F11</li>
	 * <li>F12</li>
	 * <li>F13</li>
	 * <li>F14</li>
	 * <li>F15</li>
	 * <li>HOME</li>
	 * <li>INSERT</li>
	 * <li>LEFT</li>
	 * <li>PAGEDOWN</li>
	 * <li>PAGEUP</li>
	 * <li>RIGHT</li>
	 * <li>SHIFT</li>
	 * <li>SPACE</li>
	 * <li>TAB</li>
	 * <li>UP</li>
	 * <li>NUMPAD1</li>
	 * <li>NUMPAD2</li>
	 * <li>NUMPAD3</li>
	 * <li>NUMPAD4</li>
	 * <li>NUMPAD5</li>
	 * <li>NUMPAD6</li>
	 * <li>NUMPAD7</li>
	 * <li>NUMPAD8</li>
	 * <li>NUMPAD9</li>
	 * <li>NUMPAD0</li>
	 * <li>NUMPAD_ADD</li>
	 * <li>NUMPAD_DIVIDE</li>
	 * <li>NUMPAD_MULTIPLY</li>
	 * <li>NUMPAD_SUBTRACT</li>
	 * <li>NUMPAD_DECIMAL</li>
	 * <li>NUMPAD_ENTER</li>
	 * </ul>
	 */
	public class KeyHandler
	{
		
		/**
		 * Key handler lookup.
		 */
		private static var _khs:Dictionary=new Dictionary(true);
		
		/**
		 * Key code strings.
		 */
		private static var keys:String;
		
		/**
		 * Mapped key code to strings. This is a cache
		 * for mapped keycodes to strings.
		 */
		private static var mapped:Dictionary;
		
		/**
		 * Keys that are down for sequence mapping.
		 */
		private var down:Array;
		
		/**
		 * Keys that are down for modified mapping.
		 */
		private var downd:Dictionary;
		
		/**
		 * A lookup for down keys for modified mapping, used
		 * to decide whether or not to fire the callback.
		 */
		private var downdLookup:Dictionary;
		
		/**
		 * Cached split-up version of the shortcut.
		 */
		private var splits:Array;
		
		/**
		 * Shortcut type.
		 */
		private var type:String;
		
		/**
		 * Enum value for type.
		 */
		private static const SEQUENCE:String = "sequence";
		
		/**
		 * Enum value for type.
		 */
		private static var MODIFIED:String = "modified";
		
		/**
		 * Enum value for type.
		 */
		private static var SINGLE:String = "single";
		
		/**
		 * A timeout used to clear pressed keys if the
		 * type is SEQUENCE.
		 */
		private var sequenceTimeout:Number;
		
		/**
		 * @private
		 */
		public var id:String;
		
		/**
		 * Auto target.
		 */
		private var _autoTarget:DisplayObject;
		
		/**
		 * Enabled holder.
		 */
		private var _enabled:Boolean;
		
		/**
		 * The key shortcut.
		 */
		private var shortcut:String;
		
		/**
		 * Stage reference.
		 */
		private var stage:Stage;
		
		/**
		 * Callback for this key handler.
		 */
		private var callback:Function;
		
		/**
		 * Constructor for KeyHandler instances.
		 * 
		 * @param shortcut The key shortcut to install.
		 * @param callback A callback function to execute when the key sequence is pressed.
		 */
		public function KeyHandler(shortcut:String,callback:Function)
		{
			if(!keys)
			{
				keys="BACKSPACE+CONTROL+CAPSLOCK+DELETE+DOWN+";
				keys+="END+ENTER+ESC+F1+F2+F3+F4+F5+F6+F7+F8+F9+F10+F11+F12+";
				keys+="F13+F14+F15+HOME+INSERT+LEFT+PAGEDOWN+PAGEUP+RIGHT+SHIFT+SPACE+TAB+UP";
				keys+="NUMPAD0+NUMPAD1+NUMPAD2+NUMPAD3+NUMPAD4+NUMPAD5+NUMPAD6+NUMPAD7+NUMPAD8+NUMPAD9+";
				keys+="NUMPAD_ADD+NUMPAD_DECIMAL+NUMPAD_DIVIDE+NUMPAD_ENTER+NUMPAD_MULTIPLY+NUMPAD_SUBTRACT";
			}
			if(!mapped)mapped=new Dictionary();
			if(!shortcut)throw new ArgumentError("Parameter {shortcut} cannot be null.");
			if(callback==null)throw new ArgumentError("Parameter {callback} cannot be null.");
			this.shortcut=shortcut;
			this.callback=callback;
			if(shortcut.length==1)type=SINGLE;
			else if( (shortcut.length > 1 && shortcut.indexOf("+") >- 1) || isShortcutForKeycode(shortcut))
			{
				splits=shortcut.split("+");
				type=MODIFIED;
				var i:int=0;
				var l:int=splits.length;
				downdLookup=new Dictionary();
				for(;i<l;i++)downdLookup[splits[i]]=true;
			}
			else
			{
				splits=shortcut.split("");
				type=SEQUENCE;
			}
			if(!StageRef.stage)throw new Error("The KeyHandler class requires that the StageRef.stage property be set. See gs.util.StageRef");
			if(StageRef.stage)stage=StageRef.stage;
			down=[];
			downd=new Dictionary();
			addListeners();
		}
		
		/**
		 * Get a key handler instance.
		 * 
		 * @param id The key handler id.
		 */
		public static function get(id:String):KeyHandler
		{
			if(!id)return null;
			return _khs[id];
		}
		
		/**
		 * Set a key handler instance.
		 * 
		 * @param id An id for the key handler.
		 * @param kh The key handler.
		 */
		public static function set(id:String,kh:KeyHandler):void
		{
			if(!id||!kh)return;
			if(!kh.id)kh.id=id;
			_khs[id]=kh;
		}
		
		/**
		 * Unset (delete) a key handler.
		 * 
		 * @param id The key handler id.
		 */
		public static function unset(id:String):void
		{
			if(!id)return;
			delete _khs[id];
		}
		
		/**
		 * Enable a key handler.
		 * 
		 * @param id The key handler id.
		 */
		public static function enable(id:String):void
		{
			KeyHandler(_khs[id]).enabled=true;
		}
		
		/**
		 * Disable a key handler.
		 * 
		 * @param id The key handler id.
		 */
		public static function disable(id:String):void
		{
			KeyHandler(_khs[id]).enabled=false;
		}
		
		/**
		 * Adds listeners
		 */
		private function addListeners():void
		{
			if(!stage)return;
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
		}
		
		/**
		 * Removes listeners.
		 */
		private function removeListeners():void
		{
			if(!stage)return;
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
		}
		
		/**
		 * On key down handler.
		 */
		private function onKeyDown(e:KeyboardEvent):void
		{
			var char:String=getShortcutForKey(e.keyCode);
			if(!char)char=String.fromCharCode(e.charCode);
			if(type==SINGLE && char==shortcut)
			{
				callback();
				return;
			}
			if(type==SEQUENCE)
			{
				down.push(char);
				var i:int=0;
				var l:int=down.length;
				if(splits.length > down.length)
				{
					clearTimeout(sequenceTimeout);
					sequenceTimeout=setTimeout(clearKeys,600);
					return;
				}
				if(down.length > splits.length)
				{
					clearTimeout(sequenceTimeout);
					clearKeys();
					return;
				}
				var tmp:Array=splits.concat();
				for(;i<l;i++)if(down[int(i)]==splits[int(i)])tmp.shift();
				if(tmp.length < 1)
				{
					callback();
					clearTimeout(sequenceTimeout);
					clearKeys();
					return;
				}
			}
			if(type==MODIFIED)
			{
				downd[char]=true;
				var count:int=0;
				var key:String;
				for(key in downd)
				{
					if(!downdLookup[key])return;
					count++;
				}
				if(count==splits.length)
				{
					callback();
					return;
				}
			}
		}
		
		/**
		 * On key up handler.
		 */
		private function onKeyUp(e:KeyboardEvent):void
		{
			var char:String=getShortcutForKey(e.keyCode);
			if(!char)char=String.fromCharCode(e.charCode);
			if(type==MODIFIED)
			{
				downd[char]=false;
				delete downd[char];
			}
		}
		
		/**
		 * Clears down keys.
		 */
		private function clearKeys():void
		{
			downd=new Dictionary();
			down=[];
		}
		
		/**
		 * Whether or not this key handler should fire.
		 */
		public function set enabled(val:Boolean):void
		{
			if(!_enabled && val)addListeners();
			_enabled=val;
			if(!_enabled)
			{
				removeListeners();
				clearKeys();
			}
		}
		
		/**
		 * Whether or not this key handler should fire.
		 */
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * A display object that toggles enabled / disabled when it's
		 * added / removed from the stage.
		 */
		public function set autoTarget(obj:DisplayObject):void
		{
			removeAutoListeners();
			_autoTarget=obj;
			addAutoListeners();
		}
		
		/**
		 * Adds auto listeners.
		 */
		private function addAutoListeners():void
		{
			if(!_autoTarget)return;
			_autoTarget.addEventListener(Event.ADDED_TO_STAGE,onAutoOnStage);
			_autoTarget.addEventListener(Event.REMOVED_FROM_STAGE,onAutoOffStage);
		}
		
		/**
		 * Removes auto listeners.
		 */
		private function removeAutoListeners():void
		{
			if(!_autoTarget)return;
			_autoTarget.removeEventListener(Event.ADDED_TO_STAGE,onAutoOnStage);
			_autoTarget.removeEventListener(Event.REMOVED_FROM_STAGE,onAutoOnStage);
		}
		
		/**
		 * Stage add handler for the auto target.
		 */
		private function onAutoOnStage(e:Event):void
		{
			enabled=true;
		}
		
		/**
		 * Stage remove handler for the auto target.
		 */
		private function onAutoOffStage(e:Event):void
		{
			enabled=false;
		}
		
		/**
		 * Test whether a string is a shortcut for a keycode.
		 */
		private function isShortcutForKeycode(mapping:String):Boolean
		{
			if(mapped[mapping])return true;
			if(keys.indexOf(mapping)>-1)
			{
				mapped[mapping]=true;
				return true;
			}
			return false;
		}
		
		/**
		 * Returns the shortcut string representation of a keyCode.
		 */
		private function getShortcutForKey(keyCode:uint):String
		{
			var char:String=null;
			switch(keyCode)
			{
				case 0:
					break;
				case Keyboard.BACKSPACE:
					char="BACKSPACE";
					break;
				case Keyboard.CONTROL:
					char="CONTROL";
					break;
				case Keyboard.CAPS_LOCK:
					char="CAPSLOCK";
					break;
				case Keyboard.DELETE:
					char="DELETE";
					break;
				case Keyboard.DOWN:
					char="DOWN";
					break;
				case Keyboard.END:
					char="END";
					break;
				case Keyboard.ENTER:
					char="ENTER";
					break;
				case Keyboard.ESCAPE:
					char="ESC";
					break;
				case Keyboard.F1:
					char="F1";
					break;
				case Keyboard.F2:
					char="F2";
					break;
				case Keyboard.F3:
					char="F3";
					break;
				case Keyboard.F4:
					char="F4";
					break;
				case Keyboard.F5:
					char="F5";
					break;
				case Keyboard.F6:
					char="F6";
					break;
				case Keyboard.F7:
					char="F7";
					break;
				case Keyboard.F8:
					char="F8";
					break;
				case Keyboard.F9:
					char="F9";
					break;
				case Keyboard.F10:
					char="F10";
					break;
				case Keyboard.F11:
					char="F11";
					break;
				case Keyboard.F12:
					char="F12";
					break;
				case Keyboard.F13:
					char="F13";
					break;
				case Keyboard.F14:
					char="F14";
					break;
				case Keyboard.F15:
					char="F15";
					break;
				case Keyboard.HOME:
					char="HOME";
					break;
				case Keyboard.INSERT:
					char="INSERT";
					break;
				case Keyboard.LEFT:
					char="LEFT";
					break;
				case Keyboard.PAGE_DOWN:
					char="PAGEDOWN";
					break;
				case Keyboard.PAGE_UP:
					char="PAGEUP";
					break;
				case Keyboard.RIGHT:
					char="RIGHT";
					break;
				case Keyboard.SHIFT:
					char="SHIFT";
					break;
				case Keyboard.SPACE:
					char="SPACE";
					break;
				case Keyboard.TAB:
					char="TAB";
					break;
				case Keyboard.UP:
					char="UP";
					break;
				case Keyboard.NUMPAD_1:
					char="NUMPAD1";
					break;
				case Keyboard.NUMPAD_2:
					char="NUMPAD2";
					break;
				case Keyboard.NUMPAD_3:
					char="NUMPAD3";
					break;
				case Keyboard.NUMPAD_4:
					char="NUMPAD4";
					break;
				case Keyboard.NUMPAD_5:
					char="NUMPAD5";
					break;
				case Keyboard.NUMPAD_6:
					char="NUMPAD6";
					break;
				case Keyboard.NUMPAD_7:
					char="NUMPAD7";
					break;
				case Keyboard.NUMPAD_8:
					char="NUMPAD8";
					break;
				case Keyboard.NUMPAD_9:
					char="NUMPAD9";
					break;
				case Keyboard.NUMPAD_0:
					char="NUMPAD0";
					break;
				case Keyboard.NUMPAD_ADD:
					char="NUMPADADD";
					break;
				case Keyboard.NUMPAD_DECIMAL:
					char="NUMPAD_DECIMAL";
					break;
				case Keyboard.NUMPAD_DIVIDE:
					char="NUMPAD_DIVIDE";
					break;
				case Keyboard.NUMPAD_ENTER:
					char="NUMPAD_ENTER";
					break;
				case Keyboard.NUMPAD_MULTIPLY:
					char="NUMPAD_MULTIPLY";
					break;
				case Keyboard.NUMPAD_SUBTRACT:
					char="NUMPAD_SUBTRACT";
					break;
			}
			return char;
		}
		
		/**
		 * Dispose of this key handler.
		 */
		public function dispose():void
		{
			KeyHandler.unset(id);
			removeListeners();
			removeAutoListeners();
			clearKeys();
			downd=null;
			down=null;
			splits=null;
			type=null;
			id=null;
			autoTarget=null;
			_enabled=false;
			shortcut=null;
			stage=null;
			callback=null;
		}
	}
}