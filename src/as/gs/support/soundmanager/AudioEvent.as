package gs.support.soundmanager 
{
	import flash.events.Event;		

	/**
	 * The AudioEvent class is dispatched for various
	 * audio events from audible objects, audible groups,
	 * and the sound manager.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class AudioEvent extends Event
	{
		
		/**
		 * Audio starts.
		 */
		public static const START:String="start";
		
		/**
		 * Audio stopped.
		 */
		public static const STOP:String="stop";
		
		/**
		 * Audio progress.
		 */
		public static const PROGRESS:String="progress";
		
		/**
		 * Audio resumed.
		 */
		public static const RESUMED:String="resumed";
		
		/**
		 * Audio paused.
		 */
		public static const PAUSED:String="paused";
		
		/**
		 * Audio looped.
		 */
		public static const LOOPED:String="looped";
		
		/**
		 * Audio volume changed.
		 */
		public static const VOLUME_CHANGE:String="volumeChange";
		
		/**
		 * Audio panning changed.
		 */
		public static const PAN_CHANGE:String="panChange";
		
		/**
		 * Audio completed.
		 */
		public static const COMPLETE:String="complete";
		
		/**
		 * Audio muted.
		 */
		public static const MUTE:String="mute";
		
		/**
		 * Audio unmuted.
		 */
		public static const UNMUTE:String="unmute";
		
		/**
		 * The percent of the audio that was played.
		 */
		public var percentPlayed:Number;
		
		/**
		 * The pixels that have been played.
		 */
		public var pixelsPlayed:Number;
		
		/**
		 * Constructor for AudioEvent instances.
		 * 
		 * @param type The event type.
		 * @param bubbles Whether or not the event bubbles.
		 * @param cancelable Whether or not the event is cancelable.
		 */
		public function AudioEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false):void
		{
			super(type,bubbles,cancelable);
		}
	}
}