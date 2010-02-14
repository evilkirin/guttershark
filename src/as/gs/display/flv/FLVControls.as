package gs.display.flv
{
	import gs.display.*;
	import gs.support.events.FLVEvent;
	import gs.util.MathUtils;
	import gs.util.SetterUtils;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	/**
	 * The FLVControls class implements logic for
	 * flv controls, which you provide.
	 * 
	 * <p>If a download bar is used, seeking is only
	 * allowed to as much of the video that has downloaded.
	 * Otherwise, seeking is only allowed as far as the play
	 * progress.</p>
	 * 
	 * <p>This class assumes the seek handle is a rectangular
	 * shape, so the math for dragging the handle could be off
	 * if you're trying to use a circular handle. If so,
	 * you can extend this and override a few methods.</p>
	 * 
	 * @example (examples/display/flvcontrols/)
	 * <script src="../../../../examples/swfobject.js"></script>
	 * <br/><div id="flashcontent"></div>
	 * <script>
	 * var vars={};
	 * var params={scale:'noScale',salign:'lt',menu:'false'};
	 * var attribs={id:'flaswf',name:'flaswf'}; 
	 * swfobject.embedSWF("../../../../examples/display/flvcontrols/deploy/main.swf","flashcontent","550","400","9.0.0",null,vars,params,attribs);
	 * </script>
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class FLVControls extends GSSprite
	{

		/**
		 * Stage reference for seeking.
		 */
		private var _stage:Stage;
		
		/**
		 * The play button.
		 */
		protected var playButton:Sprite;

		/**
		 * The pause button.
		 */
		protected var pauseButton:Sprite;
		
		/**
		 * The play progress bar.
		 */
		protected var progressBar:Sprite;
		
		/**
		 * The buffer bar.
		 */
		protected var bufferBar:Sprite;
		
		/**
		 * The buffer indicator.
		 */
		protected var bufferIndicator:Sprite;
		
		/**
		 * The seek handle.
		 */
		protected var seekHandle:Sprite;
		
		/**
		 * The initial play button.
		 */
		protected var initialPlayButton:Sprite;
		
		/**
		 * The mute button.
		 */
		protected var muteButton:Sprite;
		
		/**
		 * The play again button.
		 */
		protected var playAgainButton:Sprite;
		
		/**
		 * The FLV Instance.
		 */
		protected var flv:FLV;
		
		/**
		 * Download progress bar.
		 */
		protected var downloadProgress:Sprite;
		
		/**
		 * Flag indicating if the flv has completely played.
		 */
		protected var complete:Boolean;
		
		/**
		 * Flag indicating handle down state.
		 */
		protected var handleDownForSeek:Boolean;
		
		/**
		 * Progress counter, which only goes to 4. Used to
		 * manage seek bar jumping around during the first few
		 * progress events.
		 */
		private var progressCount:int;
		
		/**
		 * Used to allow a few progress events after the video has completed,
		 * in order to invalidate the state of all display objects.
		 */
		private var completeCount:int;
		
		/**
		 * First properties for difference calculations.
		 */
		private var firstProps:Object;
		
		/**
		 * Whether the seek handle is down or not.
		 */
		private var seekDown:Boolean;
		
		/**
		 * A seperate interval for seeking. Which is a really small
		 * interval, to ensure accuracy of the seek handle position.
		 */
		private var seekHandleInterval:Number;
		
		/**
		 * A max X for the seek handle, when it's pressed down
		 * and dragged, but a download progress bar doesn't exist.
		 */
		private var maxXSeekDown:Number;
		
		/**
		 * Constructor for BaseFLVControls instances.
		 * 
		 * @param flv The flv instance to control.
		 * @param playButton The play button.
		 * @param pauseButton The pause button.
		 * @param downloadProgress A download progress bar.
		 * @param playProgressBar The play progress bar.
		 * @param seekHandle A seek handle.
		 * @param bufferBar A buffer bar.
		 * @param bufferIndicator A buffer indicator. Generally a visual indication of buffering.
		 * @param initialPlayButton An initial play button, that sits over the video.
		 * @param playAgainButton A button shown at the end of the video.
		 * @param muteButton A button that toggles mute.
		 */
		public function FLVControls(flv:FLV,playButton:Sprite=null,pauseButton:Sprite=null,downloadProgress:Sprite=null,playProgressBar:Sprite=null,seekHandle:Sprite=null,bufferBar:Sprite=null,bufferIndicator:Sprite=null,initialPlayButton:Sprite=null,playAgain:Sprite=null,muteButton:Sprite=null)
		{
			super();
			if(!flv) throw new Error("Parameter {flv} cannot be null.");
			if(flv.video.stage)_stage=flv.video.stage;
			else flv.video.addEventListener(Event.ADDED_TO_STAGE,onFLVAddedToStage);
			progressCount=0;
			completeCount=0;
			firstProps={};
			if(playButton)
			{
				this.playButton=playButton;
				playButton.addEventListener(MouseEvent.CLICK,onPlayButtonClick,false,0,true);
			}
			if(pauseButton)
			{
				this.pauseButton=pauseButton;
				pauseButton.addEventListener(MouseEvent.CLICK,onPauseButtonClick,false,0,true);
			}
			if(playProgressBar)this.progressBar=playProgressBar;
			if(seekHandle)
			{
				firstProps.seekHandleX=seekHandle.x;
				this.seekHandle=seekHandle;
				seekHandle.addEventListener(MouseEvent.MOUSE_DOWN,onSeekHandleMouseDown,false,0,true);
			}
			if(bufferBar)this.bufferBar=bufferBar;
			if(bufferIndicator)this.bufferIndicator=bufferIndicator;
			if(playAgain)
			{
				this.playAgainButton=playAgain;
				playAgainButton.addEventListener(MouseEvent.CLICK,onPlayButtonClick,false,0,true);
			}
			if(initialPlayButton)
			{
				this.initialPlayButton=initialPlayButton;
				initialPlayButton.addEventListener(MouseEvent.CLICK,onPlayButtonClick,false,0,true);
			}
			if(muteButton)
			{
				this.muteButton=muteButton;
				muteButton.addEventListener(MouseEvent.CLICK,onMuteClick,false,0,true);
			}
			if(downloadProgress)this.downloadProgress=downloadProgress;
			this.flv=flv;
			flv.addEventListener(FLVEvent.PROGRESS,onFLVProgress,false,0,true);
			flv.addEventListener(FLVEvent.BUFFER_EMPTY,onBufferEmpty,false,0,true);
			flv.addEventListener(FLVEvent.BUFFER_FULL,onBufferFull,false,0,true);
			flv.addEventListener(FLVEvent.START,onFLVStart,false,0,true);
			flv.addEventListener(FLVEvent.STOP,onFLVStop,false,0,true);
			flv.addEventListener(FLVEvent.URL_CHANGE,onFLVURLChange,false,0,true);
		}
		
		/**
		 * Save stage reference.
		 */
		private function onFLVAddedToStage(e:Event):void
		{
			_stage=flv.video.stage;
		}
		
		/**
		 * @private
		 * On url change.
		 */
		protected function onFLVURLChange(fe:FLVEvent):void
		{
			if(seekHandle)seekHandle.x=firstProps.seekHandleX;
			if(downloadProgress)downloadProgress.width=0;
			progressCount=0;
			complete=false;
		}
		
		/**
		 * @private
		 * On flv progress.
		 */
		protected function onFLVProgress(fe:FLVEvent):void
		{
			if(seekDown)return;
			if(fe.percentPlayed>=100)
			{
				if(completeCount>4)return;
				clearInterval(seekHandleInterval);
				seekHandleInterval=NaN;
				complete=true;
				completeCount++;
				progressCount=0;
				if(bufferIndicator)hideBufferIndicator();
				if(bufferBar)
				{
					hideBufferProgressBar();
					defaultBufferProgressBarWidth();
				}
				if(pauseButton)hidePausebutton();
				if(playButton)showPlayButton();
				if(playAgainButton)showPlayAgainButton();
				if(progressBar)progressBarFull();
				if(seekHandle)positionSeekHandleAtStartPosition();
				return;
			}
			completeCount=0;
			if(downloadProgress)
			{
				downloadProgress.width=(fe.bytesLoaded/fe.bytesTotal)*flv.pixelsToFill;
				if(downloadProgress.width==flv.pixelsToFill)flvDownloadComplete();
			}
			if(seekHandle&&progressBar&&!seekDown)
			{
				if(progressCount<4)
				{
					progressCount++;
					positionSeekHandleAtStartPosition();
				}
				else
				{
					if(progressBar.width>seekHandle.width)
					{
						if(isNaN(seekHandleInterval))seekHandleInterval=setInterval(positionSeekHandle,1);
					}
					else positionSeekHandleAtStartPosition();
				}
			}
			if(progressBar)setProgressBarWidth(fe.pixelsPlayed);
			if(bufferBar)setBufferProgressBarWidth(fe.pixelsBuffered);
			if(initialPlayButton)
			{
				if(fe.percentPlayed==0||fe.percentPlayed==1&&flv.isPaused())showInitialPlayButton();
				else hideInitialPlayButton();
			}
			if(playAgainButton&&playAgainButton.visible)hidePlayAgainButton();
		}
		
		/**
		 * @private
		 * on flv start.
		 */
		protected function onFLVStart(fe:FLVEvent):void
		{
			if(playAgainButton)hidePlayAgainButton();
			if(pauseButton)showPauseButton();
			if(playButton)hidePlayButton();
		}

		/**
		 * @private
		 * on flv stop
		 */
		protected function onFLVStop(fe:FLVEvent):void
		{
			if(seekDown)return;
			if(pauseButton)hidePausebutton();
			if(playButton)showPlayButton();
		}
		
		/**
		 * @private
		 * when the buffer is empty.
		 */
		protected function onBufferEmpty(fe:FLVEvent):void
		{
			if(complete)return;
			if(bufferIndicator)showBufferIndicator();
			if(bufferBar)showBufferProgressBar();
		}
		
		/**
		 * @private
		 * when the buffer is full.
		 */
		protected function onBufferFull(fe:FLVEvent):void
		{
			if(bufferIndicator)hideBufferIndicator();
			if(bufferBar)hideBufferProgressBar();
		}
		
		/**
		 * @private
		 * flips volume
		 */
		protected function onMuteClick(me:MouseEvent):void
		{
			SetterUtils.flipProp("volume",0,1,flv);
		}
		
		/**
		 * @private
		 * Play's the video
		 */
		protected function onPlayButtonClick(me:MouseEvent=null):void
		{
			SetterUtils.toggleVisible(playButton,pauseButton);
			if(complete)
			{
				complete=false;
				flv.playFromBeginning();
			}
			else flv.resume();
		}
		
		/**
		 * @private
		 * Pause's video.
		 */
		protected function onPauseButtonClick(me:MouseEvent):void
		{
			SetterUtils.toggleVisible(playButton,pauseButton);
			flv.pause();
		}

		/**
		 * @private
		 */
		protected function onSeekHandleMouseDown(me:MouseEvent):void
		{
			if(complete)return;
			handleDownForSeek=true;
			onSeekHandleDown();
			_stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove,false,0,true);
			_stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp,false,0,true);
		}
		
		/**
		 * On stage mouse up.
		 */
		private function onStageMouseUp(me:MouseEvent):void
		{
			handleDownForSeek=false;
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove);
			_stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			onSeekHandleUp();
		}
		
		/**
		 * On stage mouse move.
		 */
		private function onStageMouseMove(me:MouseEvent):void
		{
			if(handleDownForSeek)mouseMoveWhenSeekHandleDown();
		}
		
		/**
		 * @private
		 * A method called when the mouse is moved, while the
		 * seek handle is down. This method implements
		 * the default seek behavior, and should not be overrided
		 * unless you are trying to completely alter how seeking works.
		 */
		protected function mouseMoveWhenSeekHandleDown():void
		{
			if(downloadProgress)seekHandle.startDrag(true,new Rectangle(progressBar.x,seekHandle.y,(downloadProgress.width - seekHandle.width),0));
			else
			{
				seekHandle.startDrag(true,new Rectangle(progressBar.x,seekHandle.y,maxXSeekDown,0));
			} 
			progressBar.width=(seekHandle.x+seekHandle.width)-firstProps.seekHandleX;
			var time:Number=MathUtils.spread((seekHandle.x-firstProps.seekHandleX),flv.pixelsToFill,flv.totalTime);
			flv.seek(time);
		}

		/**
		 * @private
		 * Called to initiate seeking. This method implements
		 * the default seek behavior, and should not be overrided
		 * unless you are trying to completely alter how seeking works.
		 */
		protected function onSeekHandleDown():void
		{
			seekDown=true;
			if(downloadProgress)seekHandle.startDrag(true,new Rectangle(progressBar.x,seekHandle.y,(downloadProgress.width - seekHandle.width),0));
			else
			{
				maxXSeekDown=progressBar.width-seekHandle.width;
				seekHandle.startDrag(true,new Rectangle(progressBar.x,seekHandle.y,(progressBar.width - seekHandle.width),0));
			}
		}

		/**
		 * @private
		 * Called when the seek handle is released. This is
		 * called for mouse up "outside" as well. This method implements
		 * the default seek behavior, and should not be overrided
		 * unless you are trying to completely alter how seeking works.
		 */
		protected function onSeekHandleUp():void
		{
			seekDown=false;
			seekHandle.stopDrag();
			var time:Number=MathUtils.spread((seekHandle.x-firstProps.seekHandleX),flv.pixelsToFill,flv.totalTime);
			flv.seek(time);
		}
		
		/**
		 * Called when the download of the FLV is 100% complete,
		 * and the download progress bar is as wide as the flv's
		 * pixels to fill.
		 * 
		 * <p>You can override this to do something with the
		 * download progress bar when the flv is completely
		 * loaded.</p>
		 */
		protected function flvDownloadComplete():void{}
		
		/**
		 * A method you can override to hook
		 * into the times that the play button
		 * is shown. The default implementation
		 * sets visible to true.
		 */
		protected function showPlayButton():void
		{
			playButton.visible=true;
		}
		
		/**
		 * A method you can override to hook
		 * into the times that the play button
		 * is hidden. The default implementation
		 * sets visible to false.
		 */
		protected function hidePlayButton():void
		{
			playButton.visible=false;
		}

		/**
		 * A method you can override to hook
		 * into the times that the pause button
		 * is shown. The default implementation
		 * sets visible to true.
		 */
		protected function showPauseButton():void
		{
			pauseButton.visible=true;
		}

		/**
		 * A method you can override to hook
		 * into the times that the pause button
		 * is hidden. The default implementation
		 * sets visible to false.
		 */
		protected function hidePausebutton():void
		{
			pauseButton.visible=false;
		}
		
		/**
		 * A method you can override to hook
		 * into the times that the initial play button
		 * is shown. The default implementation
		 * sets visible to true.
		 */
		protected function showInitialPlayButton():void
		{
			initialPlayButton.visible=true;
		}
		
		/**
		 * A method you can override to hook
		 * into the times that the initial play button
		 * is hidden. The default implementation
		 * sets visible to false.
		 */
		protected function hideInitialPlayButton():void
		{
			initialPlayButton.visible=false;
		}
		
		/**
		 * A method you can override to hook
		 * into the times that the play again button
		 * is shown. The default implementation
		 * sets visible to true.
		 */
		protected function showPlayAgainButton():void
		{
			playAgainButton.visible=true;
		}
		
		/**
		 * A method you can override to hook
		 * into the times that the play again button
		 * is hidden. The default implementation
		 * sets visible to false.
		 */
		protected function hidePlayAgainButton():void
		{
			playAgainButton.visible=false;
		}
		
		/**
		 * Hide the buffer progress bar.
		 */
		protected function hideBufferProgressBar():void
		{
			bufferBar.visible=false;
		}
		
		/**
		 * Show's the buffer progress bar.
		 */
		protected function showBufferProgressBar():void
		{
			bufferBar.visible=true;
		}
		
		/**
		 * Hide the buffer indicator.
		 */
		protected function hideBufferIndicator():void
		{
			bufferIndicator.visible=false;
		}
		
		/**
		 * Show's the buffer indicator.
		 */
		protected function showBufferIndicator():void
		{
			bufferIndicator.visible=true;
		}

		/**
		 * Set's the width of the buffer progress bar.
		 */
		protected function setBufferProgressBarWidth(pixelsBuffered:Number):void
		{
			bufferBar.width=pixelsBuffered;
		}
		
		/**
		 * Set's the width of the play progress bar.
		 */
		protected function setProgressBarWidth(pixelsPlayed:Number):void
		{
			progressBar.width=pixelsPlayed;
		}
		
		/**
		 * Set's the buffer progress bar back to it's default width, (default=1).
		 */
		protected function defaultBufferProgressBarWidth():void
		{
			bufferBar.width=1;
		}
		
		/**
		 * Set's the progress bar to it's complete state.
		 */
		protected function progressBarFull():void
		{
			progressBar.width=flv.pixelsToFill;
		}
		
		/**
		 * Positions the seek handle at the start position.
		 */
		protected function positionSeekHandleAtStartPosition():void
		{
			if(seekHandle.x==firstProps.seekHandleX)return;
			seekHandle.x=firstProps.seekHandleX;
		}
		
		/**
		 * Positions the seek handle on every progress
		 * event from the flv player.
		 */
		protected function positionSeekHandle():void
		{
			var nv:Number = Math.max(firstProps.seekHandleX,Math.ceil((progressBar.x+progressBar.width)-seekHandle.width));
			if(seekHandle.x==nv)return;
			seekHandle.x=nv;
		}

		/**
		 * Dispose of this object.
		 */
		override public function dispose():void
		{
			clearInterval(seekHandleInterval);
			flv.removeEventListener(FLVEvent.PROGRESS,onFLVProgress);
			flv.removeEventListener(FLVEvent.BUFFER_EMPTY,onBufferEmpty);
			flv.removeEventListener(FLVEvent.BUFFER_FULL,onBufferFull);
			flv.removeEventListener(FLVEvent.START,onFLVStart);
			flv.removeEventListener(FLVEvent.STOP,onFLVStop);
			flv.removeEventListener(FLVEvent.URL_CHANGE,onFLVURLChange);
			flv=null;
			bufferBar=null;
			bufferIndicator=null;
			complete=false;
			completeCount = 0;
			downloadProgress=null;
			firstProps=null;
			handleDownForSeek=false;
			initialPlayButton=null;
			maxXSeekDown=NaN;
			muteButton=null;
			pauseButton=null;
			playAgainButton=null;
			playButton=null;
			progressCount = 0;
			seekDown=false;
			seekHandle=null;
			seekHandleInterval=NaN;
			super.dispose();
		}
	}
}