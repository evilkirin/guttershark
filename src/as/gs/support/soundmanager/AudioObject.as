package gs.support.soundmanager 
{
	import gs.support.soundmanager.AudioGroup;
	import gs.util.MathUtils;
	
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Timer;

	/**
	 * Dispatched when the sound starts playing.
	 * 
	 * @eventType gs.support.soundmanager.AudioEvent
	 */
	[Event("start", type="gs.support.soundmanager.AudioEvent")]
	
	/**
	 * Dispatched when the sound stops playing.
	 * 
	 * @eventType gs.support.soundmanager.AudioEvent
	 */
	[Event("stop", type="gs.support.soundmanager.AudioEvent")]
	
	/**
	 * Dispatched for progress of the audio.
	 * 
	 * @eventType gs.support.soundmanager.AudioEvent
	 */
	[Event("progress", type="gs.support.soundmanager.AudioEvent")]
	
	/**
	 * Dispatched when the sound is paused.
	 * 
	 * @eventType gs.support.soundmanager.AudioEvent
	 */
	[Event("paused", type="gs.support.soundmanager.AudioEvent")]
	
	/**
	 * Dispatched when the sound is resumed.
	 * 
	 * @eventType gs.support.soundmanager.AudioEvent
	 */
	[Event("resumed", type="gs.support.soundmanager.AudioEvent")]
	
	/**
	 * Dispatched when the sound has looped.
	 * 
	 * @eventType gs.support.soundmanager.AudioEvent
	 */
	[Event("looped", type="gs.support.soundmanager.AudioEvent")]
	
	/**
	 * Dispatched when the sound is muted.
	 * 
	 * @eventType gs.support.soundmanager.AudioEvent
	 */
	[Event("mute", type="gs.support.soundmanager.AudioEvent")]
	
	/**
	 * Dispatched when the sound is un-muted.
	 * 
	 * @eventType gs.support.soundmanager.AudioEvent
	 */
	[Event("unmute", type="gs.support.soundmanager.AudioEvent")]
	
	/**
	 * Dispatched when the sound has completed playing.
	 * 
	 * @eventType gs.support.soundmanager.AudioEvent
	 */
	[Event("complete", type="gs.support.soundmanager.AudioEvent")]

	/**
	 * Dispatched when the volume changes
	 * 
	 * @eventType gs.support.soundmanager.AudioEvent
	 */
	[Event("volumeChange", type="gs.support.soundmanager.AudioEvent")]

	/**
	 * Dispatched when the panning changes.
	 * 
	 * @eventType gs.support.soundmanager.AudioEvent
	 */
	[Event("panChange", type="gs.support.soundmanager.AudioEvent")]

	/**
	 * The AudioObject class controls an object that is
	 * "audible," it can control a sound instance, or any object with
	 * a <em><strong>soundTransform</strong></em> property.
	 * 
	 * <p>The AudioObject can be used directly,
	 * but is not intended that way, you should use
	 * the sound manager instead.</p>
	 * 
	 * <p><strong>There is one, possibly awkward thing about
	 * the AudioObject class.</strong> If you're using the sound
	 * manager or an audio group, an audio object will automatically
	 * dispose of itself if it is controlling a sound instance, and
	 * it has completed playing.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.managers.SoundManager
	 */
	public class AudioObject extends EventDispatcher
	{

		/**
		 * The id of this audible object.
		 */
		public var id:String;
		
		/**
		 * The type of this audible object.
		 */
		private var type:String;
		
		/**
		 * Math utils.
		 */
		private var mu:MathUtils;
		
		/**
		 * The play options.
		 */
		private var ops:Object;
		
		/**
		 * @private
		 * The object being controled.
		 */
		public var obj:*;
		
		/**
		 * The sound channel if this is controlling a Sound.
		 */
		private var channel:SoundChannel;
		
		/**
		 * A transform used to keep reference to the volume.
		 */
		private var transform:SoundTransform;
		
		/**
		 * A volume var holder for mute/unmute.
		 */
		private var vol:Number;
		
		/**
		 * Whether or not this audible object is muted.
		 */
		private var muted:Boolean;
		
		/**
		 * A sound loop watching timer.
		 */
		private var loopWatcher:Timer;
		
		/**
		 * How many loops have occured.
		 */
		private var loops:Number;
		
		/**
		 * @private
		 * The group this audible object belongs to.
		 */
		public var audibleGroup:AudioGroup;

		/**
		 * Whether or not this audible object is playing.
		 */
		private var _isPlaying:Boolean;
		
		/**
		 * Whether ot not the object is paused.
		 */
		private var _isPaused:Boolean;
		
		/**
		 * A holder var for the pause position, which
		 * is used to resume to.
		 */
		private var pausePosition:Number;
		
		/**
		 * The pixels to fill for this audible object.
		 */
		private var _pixelsToFill:int;
		
		/**
		 * The timer used for progress events.
		 */
		private var progressTimer:Timer;

		/**
		 * Constructor for AudioObject instances.
		 * 
		 * @param id The id for this audible object.
		 * @param obj The object to control.
		 * @param group Optionally provide an AudibleGroup this belongs to, for automatic cleanup in the group.
		 */
		public function AudioObject(id:String,obj:*,group:AudioGroup=null):void
		{
			this.id=id;
			this.obj=obj;
			if(group)audibleGroup=group;
			if(obj is Sound)type="s";
			else if("soundTransform" in obj)type="o";
			else throw new Error("The volume for the object added cannot be controled, it must be a Sound or contain a {soundTransform} property.");
			progressTimer=new Timer(300);
			transform=new SoundTransform();
			pausePosition=0;
			muted=false;
			ops={};
		}
		
		/**
		 * Play this audio object.
		 * 
		 * <p>Available options:</p>
		 * <ul>
		 * <li>volume (Number) - The volume to play the audio at.</li>
		 * <li>startTime (Number) - A start offset in milliseconds to start playing the audio from.</li>
		 * <li>loops (Number) - The number of times to loop the sound.</li>
		 * <li>panning (Number) - A panning value for the audio.</li>
		 * <li>restartIfPlaying (Boolean) - If this audible object is playing, and you call play again, it will (by defualt) not do anything,
		 * unless this option is true, which will restart the playing sound.</li>
		 * </ul>
		 * 
		 * @param ops Play options.
		 */
		public function play(ops:Object=null):void
		{
			if(!ops)ops={};
			if(type=="o")
			{
				trace("WARNING: An audible object cannot 'play' a display object it's managing.");
				return;
			}
			if(!ops&&_isPlaying)return;
			if(!ops.restartIfPlaying&&_isPlaying)return;
			if(_isPlaying)
			{
				removeListener();
				channel.stop();
			}
			this.ops=ops;
			var startTime:Number=(ops.starTime)?ops.starTime:0;
			var loops:Number=(ops.loops)?ops.loops:0;
			var panning:Number=(ops.panning)?ops.panning:0;
			var volume:Number=(ops.volume)?ops.volume:1;
			if(transform.volume&&!this.ops.volume)volume=transform.volume;
			transform=new SoundTransform(volume,panning);
			if(loops>0)loopWatcher=new Timer(obj.length);
			channel=obj.play(startTime,loops,transform);
			dispatchEvent(new AudioEvent(AudioEvent.START));
			_isPlaying=true;
			addListener();
			if(loopWatcher)loopWatcher.start();
			if(hasEventListener(AudioEvent.PROGRESS)&&!progressTimer.running)progressTimer.start();
		}
		
		/**
		 * Add listeners for loop and complete.
		 */
		private function addListener():void
		{
			if(loopWatcher)loopWatcher.addEventListener(TimerEvent.TIMER,onLoop,false,0,true);
			channel.addEventListener(Event.SOUND_COMPLETE,onComplete,false,0,true);
		}
		
		/**
		 * Remove listeners for loop and complete.
		 */
		private function removeListener():void
		{
			if(loopWatcher)loopWatcher.removeEventListener(TimerEvent.TIMER,onLoop);
			channel.removeEventListener(Event.SOUND_COMPLETE,onComplete);
		}
		
		/**
		 * Check whether or not the sound is playing.
		 */
		public function get isPlaying():Boolean
		{
			if(type=="o")return false;
			return isPlaying;
		}
		
		/**
		 * Check whether or not the sound is paused.
		 */
		public function get isPaused():Boolean
		{
			if(type=="o")return false;
			return isPaused;
		}
		
		/**
		 * When a loop occurs.
		 */
		private function onLoop(e:TimerEvent):void
		{
			loops++;
			dispatchEvent(new AudioEvent(AudioEvent.LOOPED));
		}
		
		/**
		 * On complete.
		 */
		private function onComplete(e:Event):void
		{
			if(loopWatcher)loopWatcher.stop();
			_isPlaying=false;
			dispatchEvent(new AudioEvent(AudioEvent.COMPLETE));
			if(audibleGroup)
			{
				audibleGroup.cleanupAudibleObject(this);
				dispose();
			}
			progressTimer.stop();
		}
		
		/**
		 * Stop playing.
		 */
		public function stop():void
		{
			if(type=="o")return;
			if(loopWatcher)loopWatcher.stop();
			channel.stop();
			_isPlaying=false;
			dispatchEvent(new AudioEvent(AudioEvent.STOP));
			if(audibleGroup)
			{
				audibleGroup.cleanupAudibleObject(this);
				dispose();
			}
			progressTimer.stop();
		}
		
		/**
		 * Pause playing.
		 */
		public function pause():void
		{
			if(type=="o")return;
			if(_isPaused)return;
			_isPlaying=false;
			if(loopWatcher)loopWatcher.stop();
			dispatchEvent(new AudioEvent(AudioEvent.PAUSED));
			pausePosition=channel.position;
			channel.stop();
			progressTimer.stop();
			_isPaused=true;
		}
		
		/**
		 * Resume playing.
		 */
		public function resume():void
		{
			if(type=="o")return;
			if(_isPlaying)return;
			if(!_isPaused)return;
			_isPlaying=true;
			_isPaused=false;
			removeListener();
			var startTime:Number=pausePosition;
			var loops:Number=(ops.loops)?ops.loops:0;
			channel=obj.play(startTime,loops,transform);
			if(!muted)channel.soundTransform=transform;
			dispatchEvent(new AudioEvent(AudioEvent.RESUMED));
			addListener();
			if(loopWatcher)loopWatcher.start();
			if(!progressTimer.running&&hasEventListener(AudioEvent.PROGRESS))progressTimer.start();
		}
		
		/**
		 * Increase the volume.
		 * 
		 * @param step The amount to increase the volume by.
		 */
		public function increaseVolume(step:Number=.1):void
		{
			transform.volume+=step;
			if(type=="s")channel.soundTransform=transform;
			else if(type=="o")obj.soundTransform=transform;
		}
		
		/**
		 * Decrease the volume.
		 * 
		 * @param step The amount to decrease the volume by.
		 */
		public function decreaseVolume(step:Number=.1):void
		{
			if(transform.volume==0)return;
			transform.volume-=step;
			if(type=="s")channel.soundTransform=transform;
			else if(type=="o")obj.soundTransform=transform;
		}
		
		/**
		 * Mute.
		 */
		public function mute():void
		{
			if(muted)return;
			if(transform.volume==0)return;
			muted=true;
			vol=transform.volume;
			transform.volume=0;
			if(type=="s")channel.soundTransform=transform;
			else if(type=="o")obj.soundTransform=transform;
			dispatchEvent(new AudioEvent(AudioEvent.MUTE));
		}
		
		/**
		 * Un-mute.
		 */
		public function unMute():void
		{
			if(!muted)return;
			muted=false;
			transform.volume=vol;
			if(type=="s")channel.soundTransform=transform;
			else if(type=="o")obj.soundTransform=transform;
			dispatchEvent(new AudioEvent(AudioEvent.UNMUTE));
		}
		
		/**
		 * Toggle mute.
		 */
		public function toggleMute():void
		{
			if(muted)unMute();
			else mute();
		}
		
		/**
		 * Tween the panning.
		 * 
		 * @param pan The new pan level.
		 * @param duration The time it takes to tween the panning.
		 */
		public function panTo(pan:Number,duration:Number=.3):void
		{
			TweenLite.to(this,duration,{pn:pan});
		}
		
		/**
		 * Panning.
		 * 
		 * @param panning The new panning value.
		 */
		public function set panning(panning:Number):void
		{
			if(transform.pan!=panning)dispatchEvent(new AudioEvent(AudioEvent.PAN_CHANGE));
			if(transform.pan==panning)return;
			transform.pan=panning;
			if(type=="s")channel.soundTransform=transform;
			else obj.soundTransform=transform;
		}
		
		/**
		 * Panning.
		 * 
		 * @param panning The new panning value.
		 */
		public function get panning():Number
		{
			return transform.pan;
		}
		
		/**
		 * Set the panning.
		 */
		public function set pn(panning:Number):void
		{
			transform.pan=panning;
			if(type=="s")channel.soundTransform=transform;
			else obj.soundTransform=transform;
		}
		
		/**
		 * A tween property for panning.
		 */
		public function get pn():Number
		{
			return transform.pan;
		}
		
		/**
		 * Set the volume for this audible object.
		 * 
		 * @param level The volume level.
		 */
		public function set volume(level:Number):void
		{
			if(transform.volume!=level)dispatchEvent(new AudioEvent(AudioEvent.VOLUME_CHANGE));
			transform.volume=level;
			if(type=="s")
			{
				if(!channel)return;
				channel.soundTransform=transform;
			}
			else obj.soundTransform=transform;
		}
		
		/**
		 * Volume.
		 */
		public function get volume():Number
		{
			return transform.volume;
		}
		
		/**
		 * Tween the volume.
		 * 
		 * @param level The new volume level.
		 * @param duration The time it takes to tween to the new level.
		 */
		public function volumeTo(level:Number,duration:Number=.3):void
		{
			TweenLite.to(this,duration,{vl:level});
		}
		
		/**
		 * A tween property for volume.
		 */
		public function get vl():Number
		{
			return transform.volume;
		}
		
		/**
		 * Tween volume.
		 */
		public function set vl(level:Number):void
		{
			transform.volume=level;
			if(type=="s")channel.soundTransform=transform;
			else obj.soundTransform=transform;
		}
		
		/**
		 * Seek to a position in the sound.
		 * 
		 * @param position The position of the sound to seek to.
		 */
		public function seek(position:Number):void
		{
			if(type=="o")
			{
				trace("WARNING: Seek is not supported for non Sound instances.");
				return;
			}
			if(!position)return;
			removeListener();
			channel.stop();
			var lps:int=(ops.loops)?ops.loops:0;
			if(lps>0 && loops>1) lps=loops-lps;
			if(lps<0)lps=0;
			channel=Sound(obj).play(position,lps,transform);
		}
		
		/**
		 * Seek to a percent of the sound.
		 * 
		 * @param percent The percent to seek to.
		 */
		public function seekToPercent(percent:Number):void
		{
			if(type=="o")
			{
				trace("WARNING: Seek to percent is not supported when managing display objects.");
				return;
			}
			seek(Sound(obj).length*percent/100);
		}
		
		/**
		 * Seek to a pixel (first set pixels to fill).
		 * 
		 * @param pixel The pixel to seek to.
		 */
		public function seekToPixel(pixel:Number):void
		{
			if(type=="o")
			{
				trace("WARNING: Seek to pixels is not supported when managing display objects.");
				return;
			}
			seek(MathUtils.spread(pixel,pixelsToFill,Sound(obj).length));
		}
		
		/**
		 * Get the percentage of the sound that has played.
		 */
		public function percentPlayed():Number
		{
			if(type=="o")
			{
				trace("WARNING: A display object does not have a percent played value.");
				return -1;
			}
			if(channel.position==0||!channel||!channel.position)return 0;
			return Sound(obj).length/channel.position;
		}
		
		/**
		 * Get the amount of pixels that have played.
		 */
		public function pixelsPlayed():int
		{
			if(type=="o")
			{
				trace("WARNING: A display object does not have a pixels played value.");
				return -1;
			}
			if(!_pixelsToFill)
			{
				trace("WARNING: The pixels to fill is not set. It must be set before using pixelsPlayed()");
				return -1;
			}
			return MathUtils.spread(channel.position,Sound(obj).length,_pixelsToFill);
		}
		
		/**
		 * The amount of pixels to fill for this audio object.
		 * 
		 * @param pixels The amount of pixels to fill.
		 */
		public function set pixelsToFill(pixels:int):void
		{
			_pixelsToFill=pixels;
		}
		
		/**
		 * The amount of pixels to fill for this audio object.
		 */
		public function get pixelsToFill():int
		{
			return _pixelsToFill;
		}
		
		/**
		 * Starts the progress logic.
		 */
		private function startProgressEvents():void
		{
			progressTimer.addEventListener(TimerEvent.TIMER,onTick,false,0,true);
			if(!_isPlaying)return;
			progressTimer.start();
		}
		
		/**
		 * Stops the progress logic.
		 */
		private function stopProgressEvents():void
		{
			progressTimer.stop();
			progressTimer.removeEventListener(TimerEvent.TIMER,onTick);
		}
		
		/**
		 * On tick for progres timer.
		 */
		private function onTick(ev:TimerEvent):void
		{
			if(!_isPlaying)return;
			var e:AudioEvent=new AudioEvent(AudioEvent.PROGRESS,false,true);
			e.pixelsPlayed=pixelsPlayed();
			e.percentPlayed=percentPlayed();
			dispatchEvent(e);
		}
		
		/**
		 * @private
		 */
		override public function addEventListener(type:String,listener:Function,useCapture:Boolean=false,priority:int=0,useWeakReference:Boolean=false):void
		{
			super.addEventListener(type,listener,useCapture,priority,useWeakReference);
			if(type==AudioEvent.PROGRESS&&!hasEventListener(AudioEvent.PROGRESS))startProgressEvents();
		}
		
		/**
		 * @private
		 */
		override public function removeEventListener(type:String,listener:Function,useCapture:Boolean=false):void
		{
			super.removeEventListener(type,listener,useCapture);
			if(type==AudioEvent.PROGRESS&&!hasEventListener(AudioEvent.PROGRESS))stopProgressEvents();
		}
		
		/**
		 * Dispose of this audible object.
		 */
		public function dispose():void
		{
			removeListener();
			progressTimer.stop();
			progressTimer.removeEventListener(TimerEvent.TIMER,onTick);
			id=null;
			obj=null;
			type=null;
			transform=null;
			vol=NaN;
			_isPlaying=false;
			loops=NaN;
			loopWatcher=null;
			ops=null;
			audibleGroup=null;
			channel=null;
			muted=false;
			pausePosition=NaN;
			_pixelsToFill=0;
			mu=null;
		}
	}
}