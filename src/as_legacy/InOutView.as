package net.guttershark.display.views 
{
	
	/**
	 * The InOutView class is an AnimatedView with default
	 * functionality setup so that you can use a timeline
	 * to play forwards and backwards as the in transition
	 * and reverse as the out transition.
	 * 
	 * <p>Use the show() and hide() methods as the in and out.</p>
	 */
	public class InOutView extends AnimatedView
	{
		
		/**
		 * Constructor for InOutView instances.
		 */
		public function InOutView()
		{
			super();
			stop();
			watchForLastFrameAndCallComplete = true;
			autoStopOnLastFrame = true;
		}
		
		/**
		 * Show the view - plays clip forward.
		 */
		override public function show():void
		{
			play();
		}
		
		/**
		 * Hide the view - plays clip in reverse.
		 */
		override public function hide():void
		{
			playReverse();
		}
		
		/**
		 * Dispose of this InOutView.
		 */
		override public function dispose():void
		{
			super.dispose();
			watchForLastFrameAndCallComplete = false;
			autoStopOnLastFrame  = false;
		}	}}