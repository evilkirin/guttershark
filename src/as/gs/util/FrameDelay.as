package gs.util
{
	
	import flash.events.Event;
	
	/**
	 * The FrameDelay class allows for a callback to be called after
	 * a certain amount of frames have passed.
	 * 
	 * @example Using a FrameDelay:
	 * <listing>	
	 * var fd:FrameDelay=new FrameDelay(after10, 10);
	 * function after10():void
	 * {
	 *     trace("10 frames have passed");
	 * }
	 * </listing>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class FrameDelay
	{
		
		/**
		 * is done flag.
		 */
		private var isDone:Boolean;
		
		/**
		 * The current frame.
		 */
		private var currentFrame:int;
		
		/**
		 * The callback.
		 */
		private var callback:Function;
		
		/**
		 * Parameters to send to the callback.
		 */
		private var params:Array;
		
		/**
		 * Constructor for FrameDelay instances.
		 * 
		 * @param callback The callback to call.
		 * @param frameCount The number of frames to wait.
		 * @param params An array of parameters to send to your callback.
		 */
		public function FrameDelay(callback:Function,frameCount:int=0,params:Array=null)
		{
			currentFrame=frameCount;
			this.callback=callback;
			this.params=params;
			isDone=(isNaN(frameCount) || (frameCount <= 1));
			FramePulse.AddEnterFrameListener(handleEnterFrame);
		}
		
		/**
		 * Handle an enter frame event.
		 */
		private function handleEnterFrame(e:Event):void
		{
			if(isDone)
			{
				if(params==null)callback();
				else callback.apply(null,params);
				dispose();
			}
			else
			{
				currentFrame--;
				isDone=(currentFrame<=1);
			}
		}
		
		/**
		 * Dispose of this FrameDelay instance.
		 */
		public function dispose():void
		{
			if(isDone)
			{
				FramePulse.RemoveEnterFrameListener(handleEnterFrame);
				params=null;
				callback=null;
				currentFrame=0;
				isDone=false;
			}
		}
	}
}
