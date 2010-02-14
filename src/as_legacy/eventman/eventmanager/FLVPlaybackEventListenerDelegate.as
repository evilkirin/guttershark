package net.guttershark.support.eventmanager
{
	import fl.video.FLVPlayback;
	import fl.video.VideoEvent;
	
	/**
	 * The FLVPlaybackEventListenerDelegate class implements
	 * listener logic for FLVPlayback components.
	 * 
	 * @example Setting up the FLVPlaybackEventListenersDelegate on EventManager:
	 * <listing>	
	 * import net.guttershark.support.eventmanager.FLVPlaybackEventListenerDelegate.
	 * EventManager.gi().addEventListenerDelegate(FLVPlayback,FLVPlaybackEventListenerDelegate);
	 * </listing>
	 * 
	 * <p>See the EventManager class for a list of supported events.</p>
	 */
	final public class FLVPlaybackEventListenerDelegate extends EventListenerDelegate
	{

		/**
		 * @inheritDoc
		 */
		override public function addListeners(obj:*):void
		{
			super.addListeners(obj);
			if(obj is FLVPlayback)
			{
				if(callbackPrefix + "Pause" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(VideoEvent.PAUSED_STATE_ENTERED, onFLVPause,false,0,true);
				if(callbackPrefix + "Play" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(VideoEvent.PLAYING_STATE_ENTERED, onFLVPlay,false,0,true);
				if(callbackPrefix + "Stop" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(VideoEvent.STOPPED_STATE_ENTERED, onFLVStopped,false,0,true);
				if(callbackPrefix + "PlayheadUpdate" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(VideoEvent.PLAYHEAD_UPDATE, onFLVPlayheadUpdate,false,0,true);
				if(callbackPrefix + "AutoRewound" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(VideoEvent.AUTO_REWOUND, onFLVAutoRewound,false,0,true);
				if(callbackPrefix + "Buffering" in callbackDelegate || cycleAllThroughTracking)  obj.addEventListener(VideoEvent.BUFFERING_STATE_ENTERED, onFLVBufferState,false,0,true);
				if(callbackPrefix + "Close" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(VideoEvent.CLOSE, onFLVClose,false,0,true);
				if(callbackPrefix + "Complete" in callbackDelegate || cycleAllThroughTracking)  obj.addEventListener(VideoEvent.COMPLETE, onFLVComplete,false,0,true);
				if(callbackPrefix + "FastFoward" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(VideoEvent.FAST_FORWARD, onFLVFastForward,false,0,true);
				if(callbackPrefix + "Ready" in callbackDelegate || cycleAllThroughTracking)  obj.addEventListener(VideoEvent.READY, onFLVReady,false,0,true);
				if(callbackPrefix + "Rewind" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(VideoEvent.REWIND, onFLVRewind,false,0,true);
				if(callbackPrefix + "ScrubFinish" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(VideoEvent.SCRUB_FINISH, onFLVScrubFinish,false,0,true);
				if(callbackPrefix + "ScrubStart" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(VideoEvent.SCRUB_START, onFLVScrubStart,false,0,true);
				if(callbackPrefix + "Seeked" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(VideoEvent.SEEKED, onFLVSeeked,false,0,true);
				if(callbackPrefix + "SkinLoaded" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(VideoEvent.SKIN_LOADED, onFLVSkinLoaded,false,0,true);
				if(callbackPrefix + "StateChange" in callbackDelegate || cycleAllThroughTracking) obj.addEventListener(VideoEvent.STATE_CHANGE, onFLVStateChange,false,0,true);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function removeEventListeners():void
		{
			super.removeEventListeners();
			obj.removeEventListener(VideoEvent.PAUSED_STATE_ENTERED,onFLVPause);
			obj.removeEventListener(VideoEvent.PLAYING_STATE_ENTERED, onFLVPlay);
			obj.removeEventListener(VideoEvent.STOPPED_STATE_ENTERED, onFLVStopped);
			obj.removeEventListener(VideoEvent.PLAYHEAD_UPDATE, onFLVPlayheadUpdate);
			obj.removeEventListener(VideoEvent.AUTO_REWOUND, onFLVAutoRewound);
			obj.removeEventListener(VideoEvent.BUFFERING_STATE_ENTERED, onFLVBufferState);
			obj.removeEventListener(VideoEvent.CLOSE, onFLVClose);
			obj.removeEventListener(VideoEvent.COMPLETE, onFLVComplete);
			obj.removeEventListener(VideoEvent.FAST_FORWARD, onFLVFastForward);
			obj.removeEventListener(VideoEvent.READY, onFLVReady);
			obj.removeEventListener(VideoEvent.REWIND, onFLVRewind);
			obj.removeEventListener(VideoEvent.SCRUB_FINISH, onFLVScrubFinish);
			obj.removeEventListener(VideoEvent.SCRUB_START, onFLVScrubStart);
			obj.removeEventListener(VideoEvent.SEEKED, onFLVSeeked);
			obj.removeEventListener(VideoEvent.SKIN_LOADED, onFLVSkinLoaded);
			obj.removeEventListener(VideoEvent.STATE_CHANGE, onFLVStateChange);
		}
		
		private function onFLVStateChange(ve:VideoEvent):void
		{
			handleEvent(ve,"StateChange");
		}
		
		private function onFLVSkinLoaded(ve:VideoEvent):void
		{
			handleEvent(ve,"SkinLoaded");
		}
		
		private function onFLVSeeked(ve:VideoEvent):void
		{
			handleEvent(ve,"Seeked");
		}
		
		private function onFLVScrubStart(ve:VideoEvent):void
		{
			handleEvent(ve,"ScrubStart");
		}
		
		private function onFLVScrubFinish(ve:VideoEvent):void
		{
			handleEvent(ve,"ScrubFinish");
		}
		
		private function onFLVRewind(ve:VideoEvent):void
		{
			handleEvent(ve,"Rewind");
		}
		
		private function onFLVReady(ve:VideoEvent):void
		{
			handleEvent(ve,"Ready");
		}
		
		private function onFLVFastForward(ve:VideoEvent):void
		{
			handleEvent(ve,"FastForward");
		}
		
		private function onFLVBufferState(ve:VideoEvent):void
		{
			handleEvent(ve,"AutoRewound");
		}

		private function onFLVAutoRewound(ve:VideoEvent):void
		{
			handleEvent(ve,"BufferState");
		}
		
		private function onFLVClose(ve:VideoEvent):void
		{
			handleEvent(ve,"Close");
		}
		
		private function onFLVComplete(ve:VideoEvent):void
		{
			handleEvent(ve,"Complete");
		}
		
		private function onFLVPlayheadUpdate(ve:VideoEvent):void
		{
			handleEvent(ve,"PlayheadUpdate",true);
		}
		
		private function onFLVPlay(ve:VideoEvent):void
		{
			handleEvent(ve,"Play");
		}
		
		private function onFLVPause(ve:VideoEvent):void
		{
			handleEvent(ve,"Pause");
		}
		
		private function onFLVStopped(ve:VideoEvent):void
		{
			handleEvent(ve,"Stop");
		}	}}