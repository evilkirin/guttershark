package gs.audio 
{

	/**
	 * The AudioTimeline class manages updating audio state
	 * at certain time intervals.
	 */
	public class AudioTimeline 
	{
		
		private var instructions:Array;
		private var intimeline:Array;
		
		public function AudioTimeline():void
		{
			intimeline=[];
			instructions=[];
		}
		
		public function addToTimeline(instr:TimelineInstruction):void
		{
			intimeline.push(instr);
			instr.timelineIndex=intimeline.length-1;
		}
		
		public function removeFromTimeline(instr:TimelineInstruction):void
		{
			intimeline.splice(instr.timelineIndex,1);
		}
		
		public function play():void
		{
			var i:int=0;
			var l:int=instructions.length;
			var inst:Object;
			for(;i<l;i++)
			{
				inst=instructions[i];
				TimelineInstruction(inst).schedule();
			}
			i=0;
			for(;i<l;i++)TimelineInstruction(instructions[i]).start();
		}
		
		public function stop():void
		{
			var i:int=0;
			var l:int=intimeline.length;
		}
		
		public function resume():void
		{
			var i:int=0;
			var l:int=intimeline.length;
		}
		
		public function pause():void
		{
			var i:int=0;
			var l:int=intimeline.length;
		}
		
		public function playSoundAt(ao:AudioObject,time:Number):void
		{
			instructions.push(new TimelineInstruction(this,ao,"play",[],time));
		}
		
		public function stopSoundAt(ao:AudioObject,time:Number):void
		{
			instructions.push(new TimelineInstruction(this,ao,"stop",[],time));
		}
		
		public function pauseSoundAt(ao:AudioObject,time:Number):void
		{
			instructions.push(new TimelineInstruction(this,ao,"pause",[],time));
		}
		
		public function resumeSoundAt(ao:AudioObject,time:Number):void
		{
			instructions.push(new TimelineInstruction(this,ao,"resume",[],time));
		}
		
		public function volumeToAt(ao:AudioObject,level:Number,time:Number,changeDuration:Number=.3):void
		{
			instructions.push(new TimelineInstruction(this,ao,"volumeTo",[level,changeDuration],time));
		}
		
		public function setVolumeAt(ao:AudioObject,level:Number,time:Number):void
		{
			instructions.push(new TimelineInstruction(this,ao,"setVolume",[level],time));
		}
	}
}

import flash.events.TimerEvent;
import flash.utils.Timer;
import gs.audio.AudioTimeline;
import gs.audio.AudioObject;

class TimelineInstruction
{
	
	public var timelineIndex:int;
	private var timeline:AudioTimeline;
	private var ao:AudioObject;
	private var method:String;
	private var args:Array;
	private var resumeOffset:Number;
	private var startOffset:Number;
	private var starttime:Number;
	private var endtime:Number;
	private var time:Number;
	private var timer:Timer;
	
	public function TimelineInstruction(_timeline:AudioTimeline,_ao:AudioObject,_method:String,_args:Array,_time:Number,_startOffset:Number=0):void
	{
		timeline=_timeline;
		startOffset=_startOffset;
		ao=_ao;
		method=_method;
		args=_args;
		time=_time;
	}
	
	public function schedule():void
	{
		timer=new Timer(time,1);
		timer.addEventListener(TimerEvent.TIMER,_tick);
	}
	
	public function stop():void
	{
		//timeline.removeFromTimeline(this);
		timer.stop();
	}
	
	public function start():void
	{
		//timeline.addToTimeline(this);
		timer.start();
	}
	
	public function pause():void
	{
		//endtime=getTimer();
		resumeOffset=startOffset+endtime-starttime;
	}
	
	public function resume():void
	{
		//starttime=getTimer();
		//ao.play({startTime:startOffset});
	}
	
	private function _tick(e:TimerEvent):void
	{
		ao[method].apply(ao,args);
	}
}
