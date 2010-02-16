package gs.util 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.setTimeout;

	/**
	 * The CallQueue class is a simple queue data structure,
	 * for method callbacks, but can also wait for events
	 * to fire from any event dispatcher.
	 * 
	 * @example Using the call queue:
	 * <listing>	
	 * import gs.util.CallQueue;
	 * var cs = new CallQueue();
	 * cs.addCall(test,2000);
	 * cs.addCall(test1,3000);
	 * cs.addCall(test2,2000,b1,"click"); //b1 should be a movie clip on the stage.
	 * cs.addCall(test,1000);
	 * cs.start();
	 * function test()
	 * {
	 *     trace("test");
	 * }
	 * function test1()
	 * {
	 *     trace("test1");
	 * }
	 * function test2()
	 * {
	 *     trace("after clicked obj");
	 * }
	 * </listing>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class CallQueue
	{
		
		/**
		 * Stores calls.
		 */
		private var seq:Array;
		
		/**
		 * call cursor.
		 */
		private var cursor:int;
		
		/**
		 * Flag indicating if the sequence is working.
		 */
		private var working:Boolean;
		
		/**
		 * Whether or not to loop the sequence indefinitely,
		 * until stop is called, or it's disposed.
		 */
		public var loop:Boolean;
		
		/**
		 * Whether or not to automatically dispose after
		 * all calls are done.
		 */
		private var autoDispose:Boolean;

		/**
		 * The CallSequence class sequences method calls
		 * after intervals, or events.
		 */
		public function CallQueue()
		{
			seq=[];
		}

		/**
		 * Add a method call to the queue.
		 * 
		 * @param method A function callback.
		 * @param delay The delay in milliseconds to wait before calling.
		 * @param args Arguments to send to the function.
		 * @param ed An event dispatcher implementation.
		 * @param eventTrigger The event that triggers the method call.
		 */
		public function addCall(method:Function,delay:Number,args:Array=null,ed:IEventDispatcher=null,eventTrigger:String=null):CallQueue
		{
			seq.push({func:method,delay:delay,ed:ed,event:eventTrigger,args:args});
			return this;
		}
		
		/**
		 * Add a wait.
		 * 
		 * @param delay The time to wait for (milliseconds).
		 */
		public function waitFor(delay:Number):CallQueue
		{
			seq.push({wait:true,delay:delay});
			return this;
		}
		
		/**
		 * Add multiple calls at once. The parameters
		 * must be aligned correctly in the array, so that
		 * they get passed to the "addCall" method correctly.
		 * 
		 * @param methods An array of method (function) callbacks.
		 * @param delays The delay amount for each callback.
		 * @param args The arguments to give to each callback.
		 * @param edispatchers An array of event dispatchers, for callback waiting.
		 * @param eventTriggers The event triggers, for each event dispatcher.
		 */
		public function addCalls(methods:Array,delays:Array,args:Array=null,edispatchers:Array=null,eventTriggers:Array=null):CallQueue
		{
			if(methods.length!=delays.length&&delays.length!=args.length)throw new Error("The methods, delays, and args parameters must be the same length.");
			if(!edispatchers)edispatchers=[];
			if(!eventTriggers)eventTriggers=[];
			if(!args)args=[];
			var i:int=0;
			var l:int=methods.length;
			for(;i<l;i++)addCall(methods[int(i)],delays[int(i)],args[int(i)],edispatchers[int(i)],eventTriggers[int(i)]);
			return this;
		}

		/**
		 * Start the sequence of calls.
		 */
		public function start():void
		{
			if(working)return;
			cursor=-1;
			working=true;
			doNext();
		}
		
		/**
		 * Execute the call queue, and dispose
		 * of itself when it's done.
		 */
		public function startAndDispose():void
		{
			autoDispose=true;
			start();
		}
		
		/**
		 * Stop calls.
		 */
		public function stop():void
		{
			working=false;
		}
		
		/**
		 * Start the queue from any index.
		 */
		public function startAt(callIndex:int):void
		{
			if(working) return;
			cursor=callIndex-1;
			working=true;
			doNext();
		}
		
		/**
		 * Always does next operation.
		 */
		private function doNext():void
		{
			cursor++;
			if(cursor>=seq.length)
			{
				if(loop)cursor=0;
				else
				{
					if(autoDispose)dispose();
					working=false;
					return;
				}
			}
			var call:Object=getCurrentCall();
			if(call.wait&&call.delay>0) setTimeout(doNext,call.delay);
			else if(call.wait&&call.delay==0)doNext();
			else if(call.ed&&call.event)call.ed.addEventListener(call.event,onCallEvent);
			else callMethodForCurrent();
		}
		
		/**
		 * Get current call.
		 */
		private function getCurrentCall():Object
		{
			return seq[cursor];
		}
		
		/**
		 * On event dispatched.
		 */
		private function onCallEvent(e:Event):void
		{
			var call:Object = getCurrentCall();
			call.ed.removeEventListener(call.event,onCallEvent);
			callMethodForCurrent();
		}
		
		/**
		 * Calls the method for current call.
		 */
		private function callMethodForCurrent():void
		{
			var call:Object=getCurrentCall();
			if(call.delay==0)
			{
				if(call.args)call.func.apply(null,call.args);
				else call.func();
				doNext();
			}
			else setTimeout(closeFunction,call.delay);
		}
		
		/**
		 * Finally calls the current method call.
		 */
		private function closeFunction():void
		{
			if(!working)return;
			var call:Object=getCurrentCall();
			if(call.args)call.func.apply(null,call.args);
			else call.func();
			doNext();
		}
		
		/**
		 * Check whether or not the call queue is running.
		 */
		public function get running():Boolean
		{
			return working;
		}

		/**
		 * Dispose of the call queue.
		 */
		public function dispose():void
		{
			seq=null;
			autoDispose=false;
			cursor = 0;
			loop=false;
			working=false;
		}
	}
}