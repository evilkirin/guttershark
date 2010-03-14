package gs.audio 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * The AudioTimelineAction class is used with an
	 * AudioTimeline.
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.audio.AudioTimeline
	 */
	public class AudioTimelineAction 
	{
		
		/**
		 * @private
		 */
		public var timelineIndex:int;
		
		/**
		 * @private
		 */
		public var timeline:AudioTimeline;
		
		/**
		 * The audio object the actions are called on.
		 */
		private var ao:AudioObject;
		
		/**
		 * The method name to call on the audio object.
		 */
		private var method:String;
		
		/**
		 * The arguments to pass to the argument object.
		 */
		private var args:Array;
		
		/**
		 * A resume offset.
		 */
		private var resumeOffset:Number;
		
		/**
		 * A start offset.
		 */
		private var startOffset:Number;
		
		/**
		 * The time when start was called.
		 */
		private var starttime:Number;
		
		/**
		 * The time when stop was called.
		 */
		private var endtime:Number;
		
		/**
		 * The time to wait before triggering the call.
		 */
		private var time:Number;
		
		/**
		 * Timer used to trigger the action.
		 */
		private var timer:Timer;
		
		private var props:Object;
		
		/**
		 * Constructor for AudioTimelineAction instances.
		 * 
		 * @param _ao An AudioObject to control.
		 * @param _method The method this action calls.
		 * @param _triggerTime The time in milliseconds that this action is triggered at.
		 * @param _args Arguments to pass to the method on the audio object.
		 * @param _props Optional properties.
		 */
		public function AudioTimelineAction(_ao:AudioObject,_method:String,_triggerTime:Number,_args:Array=null,_props:Object=null)
		{
			if(!_ao)throw new ArgumentError("ERROR: Parameter {_ao} cannot be null.");
			if(!_method)throw new ArgumentError("ERROR: Parameter {_method} cannot be null.");
			if(!_triggerTime)throw new ArgumentError("ERROR: Parameter {_triggerTime} cannot be null.");
			ao=_ao;
			method=_method;
			args=_args;
			if(!args)args=[];
			props=_props;
			time=_triggerTime;
			timer=new Timer(time,1);
			timer.addEventListener(TimerEvent.TIMER,_tick);
		}
		
		/**
		 * @private
		 */
		public function stop():void
		{
			timer.stop();
		}
		
		/**
		 * @private
		 */
		public function start():void
		{
			timer.start();
		}
		
		/**
		 * @private
		 */
		public function pause():void
		{
			//endtime=getTimer();
			resumeOffset=startOffset+endtime-starttime;
		}
		
		/**
		 * @private
		 */
		public function resume():void
		{
			//starttime=getTimer();
			//ao.play({startTime:startOffset});
		}
		
		/**
		 * On timer expired.
		 */
		private function _tick(e:TimerEvent):void
		{
			if(!(method in ao))
			{
				trace("WARNING: Method {"+method+"} is not available on the audio object. Not doing anything.");
				return;
			}
			ao[method].apply(ao,args);
		}
	}
}