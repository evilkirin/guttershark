package gs.audio
{
	import gs.events.AudioEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	/**
	 * Dispatched when the group starts playing.
	 * 
	 * @eventType gs.events.AudioEvent
	 */
	[Event("start", type="gs.events.AudioEvent")]
	
	/**
	 * Dispatched when the group stops playing.
	 * 
	 * @eventType gs.events.AudioEvent
	 */
	[Event("stop", type="gs.events.AudioEvent")]
	
	/**
	 * Dispatched when the volume changes
	 * 
	 * @eventType gs.events.AudioEvent
	 */
	[Event("volumeChange", type="gs.events.AudioEvent")]
	
	/**
	 * Dispatched when the group is paused.
	 * 
	 * @eventType gs.events.AudioEvent
	 */
	[Event("paused", type="gs.events.AudioEvent")]
	
	/**
	 * Dispatched when the group is resumed.
	 * 
	 * @eventType gs.events.AudioEvent
	 */
	[Event("resumed", type="gs.events.AudioEvent")]
	
	/**
	 * Dispatched when the group is muted.
	 * 
	 * @eventType gs.events.AudioEvent
	 */
	[Event("mute", type="gs.events.AudioEvent")]
	
	/**
	 * Dispatched when the group is un-muted.
	 * 
	 * @eventType gs.events.AudioEvent
	 */
	[Event("unmute", type="gs.events.AudioEvent")]
	
	/**
	 * The AudioGroup class controls multiple audible objects.
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.audio.AudioObject
	 */
	dynamic public class AudioGroup extends Proxy implements IEventDispatcher
	{
		
		/**
		 * Internal lookup for group.
		 */
		private static var _ag:Dictionary=new Dictionary();
		
		/**
		 * @private
		 * The group id.
		 */
		public var id:String;
		
		/**
		 * Event dispatcher.
		 */
		private var ed:EventDispatcher;
		
		/**
		 * All audibles that have been added.
		 */
		private var audibles:Dictionary;
		
		/**
		 * Stored audible options.
		 */
		private var audibleOptions:Dictionary;
		
		/**
		 * All objects that aren't a sound instance.
		 */
		private var objs:Dictionary;
		
		/**
		 * All playing audible objects.
		 */
		private var playingObjs:Array;
		
		/**
		 * A sound transform that keeps track of volume,
		 * which is applied to sounds that are playing - if no
		 * custom volume is specified in it's play options.
		 */
		private var transform:SoundTransform;
		
		/**
		 * Whether or not all sounds are being stopped.
		 */
		private var stoppingAll:Boolean;
		
		/**
		 * muted flag
		 */
		private var muted:Boolean;
		
		/**
		 * Get an audio group.
		 * 
		 * @param id The audio group id.
		 */
		public static function get(id:String):AudioGroup
		{
			if(!id)return null;
			return _ag[id];
		}
		
		/**
		 * Save an audio group.
		 * 
		 * @param id The id of the audio group.
		 * @param ag The audio group.
		 */
		public static function set(id:String,ag:AudioGroup):void
		{
			if(!id||!ag)return;
			if(!ag.id)ag.id=id;
			_ag[id]=ag;
		}
		
		/**
		 * Unset (delete) an audio group.
		 * 
		 * @param id The audio group id.
		 */
		public static function unset(id:String):void
		{
			if(!id)return;
			delete _ag[id];
		}
		
		/**
		 * Constructor for AudioGroup instances.
		 */
		public function AudioGroup():void
		{
			ed=new EventDispatcher(this);
			objs=new Dictionary();
			audibles=new Dictionary();
			audibleOptions=new Dictionary();
			transform=new SoundTransform();
			playingObjs=[];
		}
		
		/**
		 * Check whether or not a sound instance is playing.
		 * 
		 * @param id The id of the sound instance.
		 */
		public function isPlaying(id:String):Boolean
		{
			if(!hasObject(id))return false;
			var i:int=0;
			var l:int=playingObjs.length;
			for(;i<l;i++)if(AudioObject(playingObjs[int(i)]).id==id)return true;
			return false;
		}
		
		/**
		 * Check if this group contains an audible object.
		 * 
		 * @param id The id to check.
		 */
		public function hasObject(id:String):Boolean
		{
			return !(audibles[id]==null||audibles[id]==undefined);
		}
		
		/**
		 * Add an object to control. You can add a Sound instance,
		 * display object, or any object with a <code>soundTransform</code>
		 * property.
		 * 
		 * @param id The id of the object.
		 * @param obj The object.
		 * @param options Persistent play options for the object.
		 */
		public function addObject(id:String,obj:*,options:Object=null):void
		{
			if(!(obj is Sound)&&!("soundTransform" in obj)) throw new Error("The volume for the object added cannot be controled, it must be a Sound or contain a {soundTransform} property.");
			if(!(obj is Sound))
			{
				var ao:AudioObject=new AudioObject(obj);
				ao.id=id;
				objs[id]=ao;
			}
			audibles[id]=obj;
			if(options)audibleOptions[id]=options;
		}
		
		/**
		 * Remove an object from this group.
		 * 
		 * @param id The id of the object to remove.
		 */
		public function removeObject(id:String):void
		{
			if(objs[id])
			{
				objs[id].dispose();
				delete objs[id];
			}
			if(audibles[id])delete audibles[id];
			if(audibleOptions[id])delete audibleOptions[id];
			var i:int=0;
			var l:int=playingObjs.length;
			for(;i<l;i++)
			{
				if(AudioObject(playingObjs[int(i)]).id==id)
				{
					AudioObject(playingObjs[int(i)]).stop();
					playingObjs.splice(int(i),1);
				}
			}
		}
		
		/**
		 * Play a sound object.
		 * 
		 * @param id The id of the sound to play.
		 * @param options Persistent play options.
		 */
		public function playSound(id:String,options:Object=null):void
		{
			if(!hasObject(id))return;
			var ao:AudioObject=new AudioObject(audibles[id]);
			ao.setIdAndGroup(id,this);
			playingObjs.push(ao);
			if(options&&!options.volume)options.volume=transform.volume;
			if(options)ao.play(options);
			else if(!options&&audibleOptions[id])ao.play(audibleOptions[id]);
			else ao.play({volume:transform.volume});
		}
		
		/**
		 * Play all sound instances contained in this group.
		 */
		public function play():void
		{
			var key:String;
			var ao:AudioObject;
			for(key in audibles)
			{
				ao=new AudioObject(audibles[key]);
				ao.setIdAndGroup(key,this);
				if(audibleOptions[key])ao.play(audibleOptions[key]);
				else ao.play({volume:transform.volume});
				playingObjs.push(ao);
			}
			dispatchEvent(new AudioEvent(AudioEvent.START));
		}
		
		/**
		 * Stop all sound instances contained in this group.
		 */
		public function stop():void
		{
			stoppingAll=true;
			var i:int=0;
			var l:int=playingObjs.length;
			for(;i<l;i++)
			{
				var ao:AudioObject=playingObjs[int(i)];
				if(!ao)continue;
				ao.stop();
			}
			dispatchEvent(new AudioEvent(AudioEvent.STOP));
			stoppingAll=false;
			playingObjs=[];
		}
		
		/**
		 * Stop a playing sound.
		 * 
		 * @param id The id of the sound to stop.
		 */
		public function stopSound(id:String):void
		{
			if(!isPlaying(id))return;
			var i:int=0;
			var l:int=playingObjs.length;
			for(;i<l;i++)
			{
				var o:AudioObject=AudioObject(playingObjs[int(i)]);
				if(o && o.id==id)
				{
					o.stop();
					playingObjs.splice(int(i),1);
				}
			}
		}

		/**
		 * Pause all sound instances contained in this group.
		 */
		public function pause():void
		{
			var i:int=0;
			var l:int=playingObjs.length;
			var ao:AudioObject;
			dispatchEvent(new AudioEvent(AudioEvent.PAUSED));
			for(;i<l;i++)AudioObject(playingObjs[int(i)]).pause();
			for each(ao in objs) ao.pause();
		}
		
		/**
		 * Resume all sound instances contained in this group.
		 */
		public function resume():void
		{
			var i:int=0;
			var l:int=playingObjs.length;
			var ao:AudioObject;
			dispatchEvent(new AudioEvent(AudioEvent.RESUMED));
			for(;i<l;i++)AudioObject(playingObjs[int(i)]).resume();
			for each(ao in objs)ao.resume();
		}

		/**
		 * Increase the group volume.
		 * 
		 * @param step The amount to increase the volume by.
		 */
		public function increaseVolume(step:Number=.1):void
		{
			var i:int=0;
			var l:int=playingObjs.length;
			var ao:AudioObject;
			for(;i<l;i++)AudioObject(playingObjs[int(i)]).increaseVolume(step);
			for each(ao in objs)ao.increaseVolume(step);
			dispatchEvent(new AudioEvent(AudioEvent.VOLUME_CHANGE));
		}
		
		/**
		 * Decrease the group volume.
		 * 
		 * @param step The amount to decrease the volume by.
		 */
		public function decreaseVolume(step:Number=.1):void
		{
			var i:int=0;
			var l:int=playingObjs.length;
			var ao:AudioObject;
			for(;i<l;i++)AudioObject(playingObjs[int(i)]).decreaseVolume(step);
			for each(ao in objs)ao.decreaseVolume(step);
			dispatchEvent(new AudioEvent(AudioEvent.VOLUME_CHANGE));
		}
		
		/**
		 * Set custom levels for any audible objects.
		 * 
		 * @example Setting custom levels:
		 * <listing>	
		 * group.setLevels(["sparkle","blip"],[.3,.5]);
		 * </listing>
		 * 
		 * @param ids The ids of the objects whose levels should be updated.
		 * @param levels An array of levels that correlate to the audible objects' volume.
		 * @param persistent Whether or not the level update will persist when a sound is played more than once.
		 */
		public function setLevels(ids:Array,levels:Array,persistent:Boolean=true):void
		{
			if(!ids||!levels)return;
			if(ids.length!=levels.length) throw new Error("There must be equal parts in the two arrays passed, for the audible ids, and the levels");
			var i:int=0;
			var l:int=ids.length;
			var j:int=0;
			var k:int=playingObjs.length;
			for(;i<l;i++)
			{
				for(j=0;j<k;j++)if(AudioObject(playingObjs[int(j)]).id==ids[int(i)])AudioObject(playingObjs[int(j)]).volume=levels[int(i)];
				if(!persistent)continue;
				if(audibleOptions[ids[int(i)]])audibleOptions[ids[int(i)]].volume=levels[int(i)];
				else
				{
					audibleOptions[ids[int(i)]]={};
					audibleOptions[ids[int(i)]].volume=levels[int(i)];
				}
			}
		}
		
		/**
		 * Applies a volume to all sound and object instances
		 * contained in this group.
		 * 
		 * @param level The new audio level.
		 */
		public function set volume(level:Number):void
		{
			if(transform.volume!=level)dispatchEvent(new AudioEvent(AudioEvent.VOLUME_CHANGE));
			transform.volume=level;
			var i:int=0;
			var l:int=playingObjs.length;
			var ao:AudioObject;
			for(;i<l;i++) AudioObject(playingObjs[int(i)]).volume=transform.volume;
			for each(ao in objs)ao.volume=transform.volume;
		}
		
		/**
		 * The group volume.
		 */
		public function get volume():Number
		{
			return transform.volume;
		}
		
		/**
		 * A tween property for volume.
		 */
		public function get vl():Number
		{
			return transform.volume;
		}
		
		/**
		 * A tween property for volume.
		 */
		public function set vl(val:Number):void
		{
			volume=val;
		}
		
		/**
		 * Tween the volume of this group to a new level.
		 * 
		 * @param level The new volume level.
		 * @param duration The tween duration.
		 */
		public function volumeTo(level:Number,duration:Number=.3):void
		{
			if(level<0 || duration <0)return;
			transform.volume=level;
			var i:int=0;
			var l:int=playingObjs.length;
			var ao:AudioObject;
			for(;i<l;i++) AudioObject(playingObjs[int(i)]).volumeTo(level,duration);
			for each(ao in objs)ao.volumeTo(level,duration);
		}
		
		/**
		 * Set the panning for the entire group.
		 */
		public function set panning(val:Number):void
		{
			if(!val)return;
			transform.pan=val;
			var i:int=0;
			var l:int=playingObjs.length;
			var ao:AudioObject;
			for(;i<l;i++) AudioObject(playingObjs[int(i)]).panning=transform.pan;
			for each(ao in objs)ao.panning=transform.pan;
		}
		
		/**
		 * The group panning.
		 */
		public function get panning():Number
		{
			return transform.pan;
		}
		
		/**
		 * A tween property for panning.
		 */
		public function get pn():Number
		{
			return transform.pan;
		}
		
		/**
		 * A tween property for panning.
		 */
		public function set pn(val:Number):void
		{
			panning=val;
		}
		
		/**
		 * Tween the pan to a new pan.
		 * 
		 * @param pan The new pan level.
		 * @param duration The amount of time the tween takes.
		 */
		public function panTo(pan:Number, duration:Number):void
		{
			if(!pan)return;
			if(!duration)return;
			transform.pan=pan;
			var i:int=0;
			var l:int=playingObjs.length;
			var ao:AudioObject;
			for(;i<l;i++)AudioObject(playingObjs[int(i)]).panTo(pan,duration);
			for each(ao in objs)ao.panTo(pan,duration);
		}
		
		/**
		 * Toggle mute for the entire group.
		 */
		public function toggleMute():void
		{
			if(muted)unmute();
			else mute();
		}
		
		/**
		 * Mute all sounds and objects contained in this group.
		 */
		public function mute():void
		{
			var i:int=0;
			var l:int=playingObjs.length;
			var ao:AudioObject;
			dispatchEvent(new AudioEvent(AudioEvent.MUTE));
			for(;i<l;i++)AudioObject(playingObjs[int(i)]).mute();
			for each(ao in objs)ao.mute();
			muted=true;
		}
		
		/**
		 * Un-mute all sounds and objects contained in this group.
		 */
		public function unmute():void
		{
			var i:int=0;
			var l:int=playingObjs.length;
			var ao:AudioObject;
			dispatchEvent(new AudioEvent(AudioEvent.UNMUTE));
			for(;i<l;i++)AudioObject(playingObjs[int(i)]).unMute();
			for each(ao in objs)ao.unMute();
			muted=false;
		}
		
		/**
		 * @private
		 * Cleans up an audible object after it's not needed. This is
		 * called from a child AudibleObject this group is managing.
		 * 
		 * @param ao The audible object to cleanup.
		 */
		public function cleanupAudibleObject(ao:AudioObject):void
		{
			if(stoppingAll)return;
			var i:int=0;
			var l:int=playingObjs.length;
			for(;i<l;i++)if(playingObjs[int(i)]===ao)playingObjs.splice(int(i),1);
		}
		
		/**
		 * Dispose of this group.
		 */
		public function dispose():void
		{
			AudioGroup.unset(id);
			var i:int=0;
			var l:int=playingObjs.length;
			for(;i<l;i++)AudioObject(playingObjs[int(i)]).dispose();
			var ao:AudioObject;
			for each(ao in objs)ao.dispose();
			id=null;
			audibleOptions=null;
			var key:String;
			for(key in audibles)delete audibles[key];
			for(key in objs)delete objs[key];
			playingObjs=null;
			transform=null;
		}
		
		/**
		 * @private
		 * get a playing obj.
		 */
		private function getPlayingObj(id:String):AudioObject
		{
			var i:int=0;
			var l:int=playingObjs.length;
			for(;i<l;i++)if(AudioObject(playingObjs[int(i)]).id==id)return playingObjs[int(i)];
			return null;
		}
		
		/**
		 * Friendly description.
		 */
		public function toString():String
		{
			return "[AudioGroup "+id+"]";
		}
		
		/**
		 * @private
		 * 
		 * getProperty - override getters to return null always.
		 */
		flash_proxy override function getProperty(name:*):*
		{
			if(isPlaying(name))return AudioObject(getPlayingObj(name));
			if(objs[name])return AudioObject(objs[name]);
			var ao:AudioObject=new AudioObject(audibles[name]);
			ao.setIdAndGroup(name,this);
			return ao;
		}
		
		/**
		 * @private
		 */
		flash_proxy override function callProperty(methodName:*, ...args):*
		{
			throw new Error("Method {"+methodName+"}not found: ");
			return null;
		}
		
		/**
		 * @private
		 */
		public function addEventListener(type:String,listener:Function,useCapture:Boolean=false,priority:int=0,useWeakReference:Boolean=false):void
		{
			ed.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		/**
		 * @private
		 */
		public function removeEventListener(type:String,listener:Function,useCapture:Boolean = false):void
		{
			ed.removeEventListener(type,listener,useCapture);
		}
		
		/**
		 * @private
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return ed.dispatchEvent(event);
		}
		
		/**
		 * @private
		 */
		public function hasEventListener(type:String):Boolean
		{
			return ed.hasEventListener(type);
		}
		
		/**
		 * @private
		 */
		public function willTrigger(type:String):Boolean
		{
			return ed.willTrigger(type);
		}
	}
}