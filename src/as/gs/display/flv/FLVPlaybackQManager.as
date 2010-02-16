package gs.display.flv
{
	import com.greensock.TweenMax;
	
	import fl.video.FLVPlayback;
	import fl.video.VideoEvent;
	import fl.video.VideoPlayer;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;	

	/**
	 * The FLVPlaybackQManager uses an instance of an FLVPlayback
	 * to play videos in a queue. It uses an FLVPlayback for 
	 * the VideoPlayer stack functionality.
	 * 
	 * @example Setup example:
	 * <listing>	
	 * myFLVPlayback.align = VideoAlign.BOTTOM_LEFT;
	 * myFLVPlayback.scaleMode = VideoScaleMode.NO_SCALE;
	 * myFLVPlayback.ncMgr.timeout = 10000;
	 * myFLVPlayback.playheadUpdateInterval = 1300;
	 * queuePlaybackManager = new FLVPlaybackQManager();
	 * queuePlaybackManager.player = myFLVPlayback;
	 * var queue:Array = [
	 *   "assets/flv/6000_EGG.flv",
	 *   "assets/flv/6001_EGG.flv",
	 *   "assets/flv/6002_EGG.flv",
	 *   "rtmp://cp44952.edgefcs.net/ondemand/streamingVideos/high/2035_RES.flv"
	 * ];
	 * queuePlaybackManager.queue = queue;
	 * queuePlaybackManager.streamAttemptTimeBeforeFail = 10;
	 * queuePlaybackManager.start();
	 * </listing>
	 */
	public class FLVPlaybackQManager extends EventDispatcher
	{

		/**
		 * The FLVPlayback instance.
		 */
		private var _player:FLVPlayback;

		/**
		 * The crossfade duration between two clips.
		 */
		public var crossfadeDuration:Number = 1;
		
		/**
		 * The time in seconds remaining in the currently playing clip
		 * before triggering the next clip to play.
		 */
		public var continueWhenTimeLeft:Number = 3;
		
		/**
		 * The queue of videos currently playing over.
		 */
		private var _queue:Array;
		
		/**
		 * The queue index.
		 */
		private var queueIndex:int;
		
		/**
		 * The current player index from the FLVPlayback stack.
		 */
		private var currentPlayerIndex:int = 0;

		/**
		 * Nan count is used for counting how many times 
		 * an update event is triggered with the "playheadTime"
		 * property being NaN. If it reaches this NaN count, 
		 * the next video is played.
		 */
		private var nanCount:int;
		
		/**
		 * Flag indicating that the queue had started.
		 */
		private var started:Boolean;
		
		/**
		 * The time in seconds before a stream fail.
		 */
		private var streamFailTime:int;
		
		/**
		 * The timeout interval.
		 */
		private var streamFailTimeout:Number;
		
		/**
		 * Some state vars.
		 */
		private var httpAttempt:Boolean;
		private var rtmpAttempt:Boolean;
		private var state:int;
		private var playState:Boolean;
		private var goingOut:Boolean;

		/**
		 * Constructor for FLVPlaybackQManager instances.
		 */
		public function FLVPlaybackQManager()
		{
			currentPlayerIndex = -1;
			nanCount = 0;
		}

		/**
		 * Set the queue of file's to play through. You can
		 * use relative, http, and rtmp locations.
		 * 
		 * @param queue An array of files to play.
		 */
		public function set queue(queue:Array):void
		{
			if(!queue || queue.length < 1) throw new ArgumentError("Parameter queue cannot be null or empty.");
			queueIndex = -1;
			_queue = queue;
		}
		
		/**
		 * The FLVPlayback instance used to play through the queue.
		 */
		public function get player():FLVPlayback
		{
			return _player;
		}
		
		/**
		 * Set the instance of an FLVPlayback component you're using
		 * to play the queue in.
		 * 
		 * @param player An FLVPlayback instance.
		 */
		public function set player(player:FLVPlayback):void
		{
			if(!player)throw new ArgumentError("Parameter player cannot be null.");
			_player = player;
			_player.activeVideoPlayerIndex = 1;
			_player.activeVideoPlayerIndex = 2;
			_player.activeVideoPlayerIndex = 3;
			_player.activeVideoPlayerIndex = 0;
			_player.addEventListener(VideoEvent.PLAYING_STATE_ENTERED, onPlay);
			_player.addEventListener(VideoEvent.PLAYHEAD_UPDATE, onUpdate);
		}
		
		/**
		 * Set the time (in seconds) allowed for a stream attempt, before it is considered
		 * a failed attempt. If a stream does not play before the timeout, the stream is closed and
		 * the next video is played.
		 * 
		 * @param seconds The length in seconds.
		 */
		public function set streamAttemptTimeBeforeFail(seconds:Number):void
		{
			if(!seconds)throw new ArgumentError("Parameter seconds must be greater than .1");
			streamFailTime = seconds;
		}
		
		/**
		 * Start playing the queue.
		 */
		public function start():void
		{
			playNext();
		}
		
		/**
		 * Pause the queue.
		 */
		public function pause():void
		{
			_player.pause();
		}
		
		/**
		 * Resets everything internally. Clears the queue.
		 */
		public function reset():void
		{
			playState = false;
			state = 0;
			httpAttempt = false;
			rtmpAttempt = false;
			goingOut = false;
			_queue = [];
			var i:int = 1;
			for(;i<3;i++)_player.getVideoPlayer(int(i)).close();
		}
		
		/**
		 * Stop the queue.
		 */
		public function stop():void
		{
			_player.stop();
		}
		
		/**
		 * The source URI for the currently playing video.
		 */
		public function get source():String
		{
			return _player.source;
		}
		
		/**
		 * Indicates whether or not the currently playing clip is RTMP.
		 */
		public function get isRTMP():Boolean
		{
			return _player.isRTMP;
		}
		
		/**
		 * Interupt the queue and play the specified file immediately.
		 * 
		 * @param source The video source path.
		 */
		public function playNow(source:String):void
		{
			if(!source)throw new ArgumentError("Parameter source cannot be null");
			var vp:VideoPlayer = getPlayer(source);
			httpAttempt = true;
			goingOut = false;
			if(source.indexOf("rtmp://") > -1)
			{
				httpAttempt = false;
				rtmpAttempt = true;
				startStreamFail(currentPlayerIndex);
			}
			vp.play(source);
		}
		
		/**
		 * Gets an available player.
		 */
		private function getPlayer(source:String):VideoPlayer
		{
			if(!source)throw new ArgumentError("Parameter source cannot be null");
			var isr:Boolean = false;
			if(source.indexOf("rtmp://") > -1) isr = true;
			currentPlayerIndex++;
			if(currentPlayerIndex == 4) currentPlayerIndex = 0;
			var vp:VideoPlayer = _player.getVideoPlayer(currentPlayerIndex);
			vp.bufferTime = _player.bufferTime;
			vp.align = _player.align;
			vp.scaleMode = _player.scaleMode;
			return vp;
		}
		
		/**
		 * Gets next clip to play.
		 */
		private function getNextClip():String
		{
			queueIndex++;
			if(queueIndex >= _queue.length) queueIndex = 0;
			if(queueIndex == -1) queueIndex = 0;
			return _queue[queueIndex];
		}
		
		/**
		 * Play the next video in the queue.
		 */
		public function playNext():void
		{
			var nextClip:String = getNextClip();
			var vp:VideoPlayer = getPlayer(nextClip);
			httpAttempt = true;
			if(nextClip.indexOf("rtmp://") > -1)
			{
				httpAttempt = false;
				rtmpAttempt = true;
				startStreamFail(currentPlayerIndex);
			}
			vp.play(nextClip);
		}

		/**
		 * On video update.
		 */
		private function onUpdate(ve:VideoEvent):void
		{
			var target:VideoPlayer = _player.getVideoPlayer(ve.vp);
			var totalTime:Number = target.totalTime;
			if(!totalTime) return;
			var outTweenTime:Number = Number((totalTime - continueWhenTimeLeft).toFixed(2));
			if(isNaN(target.playheadTime))
			{
				nanCount++;
				return;
			}
			if(nanCount == 10)
			{
				nanCount = -1;
				playNext();
			}
			if(target.playheadTime >= outTweenTime && !goingOut)
			{
				goingOut = true;
				playNext();
			}
		}		
		
		/**
		 * On play of the activePlayer
		 */
		private function onPlay(ve:VideoEvent):void
		{
			if(!started) started = true;
			var target:VideoPlayer = _player.getVideoPlayer(ve.vp);
			var activePlayer:VideoPlayer = _player.getVideoPlayer(_player.activeVideoPlayerIndex);
			if(ve.vp == _player.activeVideoPlayerIndex) return;
			var half:Number = crossfadeDuration / 2;
			_player.bringVideoPlayerToFront(currentPlayerIndex);
			_player.activeVideoPlayerIndex = currentPlayerIndex;
			if(started)
			{
				if(activePlayer.isRTMP)
				{
					removeNetConnectionEventListeners(activePlayer);
					activePlayer.stop();
					activePlayer.close();
				}
				
				if(target.isRTMP)
				{
					clearTimeout(streamFailTimeout);
					setTimeout(activePlayer.stop, half);
					rtmpAttempt = false;
					state = 2;
					addNetConnectionEventListeners(target);
				}
				else
				{
					setTimeout(activePlayer.stop, half);
					httpAttempt = false;
					state = 1;
				}
				TweenMax.to(target,half,{autoAlpha:1,volume:_player.volume});
				TweenMax.to(activePlayer,half,{volume:0,autoAlpha:0});
				activePlayer = target;
				activePlayer.bufferTime = 10; //up the buffer time so that it doesn't stop buffering.
			}
			else
			{
				started = true;
				(target.isRTMP) ? rtmpAttempt = false : httpAttempt = false;
				TweenMax.to(target,half,{autoAlpha:1,volume:_player.volume});
				activePlayer = target;
			}
			setTimeout(clearGoingOut, 3000);
			dispatchEvent(new Event("crossfading"));
		}
		
		/**
		 * Clear the goingOut state flag.
		 */
		private function clearGoingOut():void
		{
			goingOut = false;
		}
		
		/**
		 * Start the timeout interval to force a stream fail.
		 */
		private function startStreamFail(playerIndex:int):void
		{
			if(streamFailTime > 0) streamFailTimeout = setTimeout(failStream, (streamFailTime * 1000), playerIndex);
		}
		
		/**
		 * Force the stream to close.
		 */
		private function failStream(playerIndex:int):void
		{
			removeNetConnectionEventListeners(_player.getVideoPlayer(playerIndex));
			_player.getVideoPlayer(playerIndex).stop();
			_player.getVideoPlayer(playerIndex).close();
		}

		/**
		 * Add's event listeners to a target player's NetConnection.
		 */
		private function addNetConnectionEventListeners(target:VideoPlayer):void
		{
			if(target.netConnection) target.netConnection.addEventListener(NetStatusEvent.NET_STATUS, onNS);
			if(target.netStream) target.netStream.addEventListener(NetStatusEvent.NET_STATUS, onNS);
		}
		
		/**
		 * Removes event listeners from a target player's NetConnection.
		 */
		private function removeNetConnectionEventListeners(target:VideoPlayer):void
		{
			if(target.netConnection) target.netConnection.removeEventListener(NetStatusEvent.NET_STATUS, onNS);
			if(target.netStream) target.netStream.removeEventListener(NetStatusEvent.NET_STATUS, onNS);
		}
		
		/**
		 * On NetConnection Net Status
		 */
		private function onNS(ns:NetStatusEvent):void
		{
			switch(ns.info.code)
			{
				case "NetConnection.Connect.Closed":
					if(rtmpAttempt)
					{
						removeNetConnectionEventListeners(_player.getVideoPlayer(_player.activeVideoPlayerIndex));
						playNext();
					}
					break;
			}
		}
	}
}