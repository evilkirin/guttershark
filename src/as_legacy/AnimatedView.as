package net.guttershark.display.views 
{
	import flash.events.Event;
	
	import net.guttershark.util.FrameDelay;
	import net.guttershark.util.FramePulse;	

	/**
	 * The AnimatedView class provides structure to a class
	 * where views need to have animated timelines, rather
	 * than all code tweens.
	 */
	public class AnimatedView extends BaseView
	{

		/**
		 * Watch for last frame and call complete when done.
		 */
		private var _watchEndAndComplete:Boolean;
		
		/**
		 * Flog var for listeners added.
		 */
		private var listenerAdded:Boolean;
		
		/**
		 * Auto stop on last frame
		 */
		private var _autoStop:Boolean;
		
		/**
		 * Constructor for AnimatedView instances.
		 */
		public function AnimatedView()
		{
			super();
		}
		
		/**
		 * This is a stub method that get's called on the last
		 * frame of a movie clip, you can override this as
		 * a hook.
		 */
		protected function animationComplete():void{}
		
		/**
		 * This is a stub method that get's called when the
		 * timeline starts playing from the first frame, you
		 * can override this as a hook.
		 */
		protected function animationStart():void{}
		
		/**
		 * Set this property to true to automatically call the <code>animationComplete</code>
		 * method when this movie clip hits it's last frame. 
		 */
		public function set watchForLastFrameAndCallComplete(value:Boolean):void
		{
			if(!value && listenerAdded)
			{
				listenerAdded = false;
				FramePulse.RemoveEnterFrameListener(__onEnterFrame);
			}
			else if(value && !listenerAdded)
			{
				listenerAdded = true;
				FramePulse.AddEnterFrameListener(__onEnterFrame);
			}
		}
		
		/**
		 * Get the value of the watch for end frame and call complete flag.
		 */
		public function get watchForLastFrameAndCallComplete():Boolean
		{
			return _watchEndAndComplete;
		}
		
		/**
		 * Auto stop on the last frame of this movie clip.
		 */
		public function set autoStopOnLastFrame(value:Boolean):void
		{
			_autoStop = value;
		}
		
		/**
		 * Overrides the play method to add some logic for reverse playing
		 * and the animationStart method.
		 */
		override public function play():void
		{
			if(!listenerAdded)
			{
				FramePulse.AddEnterFrameListener(__onEnterFrame);
				listenerAdded = true;
			}
			var f:FrameDelay = new FrameDelay(animationStart,1);
			super.play();
			f.dispose();
		}
		
		/**
		 * Play this clip in reverse.
		 */
		public function playReverse():void
		{
			FramePulse.AddEnterFrameListener(eventForReverse);
		}
		
		/**
		 * on enter frame handler
		 */
		private function __onEnterFrame(e:Event):void
		{
			if(currentFrame == totalFrames)
			{
				if(_autoStop) stop();
				listenerAdded = false;
				FramePulse.RemoveEnterFrameListener(__onEnterFrame);
				var f:FrameDelay = new FrameDelay(animationComplete,1);
				f.dispose();
			}
		}
		
		/**
		 * plays reverse.
		 */
		private function eventForReverse(e:Event):void
		{
			this.gotoAndStop(Math.max(1,currentFrame-1));
			if(currentFrame == 1) FramePulse.RemoveEnterFrameListener(eventForReverse);
		}

		/**
		 * Dispose of internal variables and event listeners.
		 */
		override public function dispose():void
		{
			if(listenerAdded) FramePulse.RemoveEnterFrameListener(__onEnterFrame);
			listenerAdded = false;
		}
	}
}
