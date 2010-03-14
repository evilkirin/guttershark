package gs.audio 
{

	/**
	 * The AudioTimeline class performs audio actions
	 * at scheduled times.
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class AudioTimeline 
	{
		
		/**
		 * Actions
		 */
		private var actions:Array;
		
		/**
		 * Constructor for AudioTimeline isntances.
		 */
		public function AudioTimeline():void
		{
			actions=[];
		}
		
		/**
		 * Add an action to the timeline.
		 * 
		 * @param action The action to add.
		 */
		public function add(action:AudioTimelineAction):void
		{
			if(!action.timeline)action.timeline=this;
			actions.push(action);
			action.timelineIndex=actions.length-1;
		}
		
		/**
		 * Remove an action from the timeline.
		 * 
		 * @param action The action to remove.
		 */
		public function remove(action:AudioTimelineAction):void
		{
			if(!actions||actions.length<1)return;
			actions.splice(action.timelineIndex,1);
		}

		/**
		 * Start playback.
		 */
		public function start():void
		{
			var i:int=0;
			var l:int=actions.length;
			for(;i<l;i++)AudioTimelineAction(actions[i]).start();
		}
		
		/**
		 * Stop playback.
		 */
		public function stop():void
		{
			var i:int=0;
			var l:int=actions.length;
			for(;i<l;i++)AudioTimelineAction(actions[i]).stop();
		}
		
		/**
		 * Resume playback.
		 */
		public function resume():void
		{
			var i:int=0;
			var l:int=actions.length;
			for(;i<l;i++)AudioTimelineAction(actions[i]).resume();
		}
		
		/**
		 * Pause the timeline. You cannot pause any type
		 * of tweening that is happening to the sound.
		 */
		public function pause():void
		{
			var i:int=0;
			var l:int=actions.length;
			for(;i<l;i++)AudioTimelineAction(actions[i]).pause();
		}
	}
}