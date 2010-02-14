package gs.rtmp.core
{
	import flash.events.NetStatusEvent;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;
	
	/**
	 * Dispatched when the a stream has started playing
	 * because it was subscribed to.
	 * 
	 * @eventType gs.rtmp.core.RTMPEvent
	 */
	[Event("startedSubscribing", type="gs.rtmp.core.RTMPEvent")]
	
	/**
	 * Dispatched only if the maximum subscribe retries is exceeded,
	 * and attemptForever is false.
	 * 
	 * @eventType gs.rtmp.core.RTMPEvent
	 */
	[Event("streamNotFound", type="gs.rtmp.core.RTMPEvent")]
	
	/**
	 * Dispatched when an attempt is made to subscribe to the stream.
	 * 
	 * @eventType gs.rtmp.core.RTMPEvent
	 */
	[Event("subscribeAttempt", type="gs.rtmp.core.RTMPEvent")]
	
	/**
	 * Dispatched when the insufficient bandwidth event
	 * happens from the server.
	 * 
	 * @eventType gs.rtmp.core.RTMPEvent
	 */
	[Event("insufficientBW", type="gs.rtmp.core.RTMPEvent")]
	
	/**
	 * The RTMPSubscriber class is for subsribing to
	 * live published streams.
	 */
	public class RTMPSubscriber extends RTMPClient
	{
		
		/**
		 * The maximum number of attempts to subscribe
		 * to the stream - default is 3.
		 */
		public static var maxStreamAttempts:int;
		
		/**
		 * The time between stream subscribe attempts - default
		 * is 3000.
		 */
		public static var streamAttemptDelay:int;
		
		/**
		 * Whether or not to keep attempting to play
		 * a stream forever - this overrides
		 * maxStreamAttempts.
		 */
		public var attemptForever:Boolean;
		
		/**
		 * Whether or not an attempt is happening.
		 */
		private var attemptSubscribe:Boolean;
		
		/**
		 * Attempt count.
		 */
		private var streamAttempts:int;
		
		/**
		 * The interval id for trying again.
		 */
		private var tryAgainId:Number;
		
		/**
		 * Constructor for RTMPSubscriber instances.
		 */	
		public function RTMPSubscriber()
		{
			super();
			streamAttempts=0;
			if(!maxStreamAttempts)maxStreamAttempts=3;
			if(!streamAttemptDelay)streamAttemptDelay=3000;
		}
		
		/**
		 * Start subscribing to the stream.
		 */
		public function subscribe():void
		{
			streamAttempts=0;
			initNetStream();
			if(vid)vid.attachNetStream(ns);
			if(vid&&cam)vid.attachCamera(cam);
			attemptToSubscribe();
		}
		
		/**
		 * Stops stubsribing to the stream but
		 * leaves internal state ready for another
		 * subscribe() call.
		 */
		public function unsubscribe():void
		{
			if(vid)vid.attachNetStream(null);
			if(vid&&cam)vid.attachCamera(null);
			attemptSubscribe=false;
			streamAttempts=0;
			if(ns)ns.pause();
		}
		
		/**
		 * Connect, and immediately subscribe when a connection
		 * is available.
		 */
		public function connectAndSubscribe():void
		{
			addEventListener(RTMPEvent.CONNECTED,onClientConnect,false,11,true);
			connect();
		}
		
		/**
		 * After super class connects, start subscribing.
		 */
		protected function onClientConnect(e:RTMPEvent):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			subscribe();
		}
		
		/**
		 * Attempt to subscribe to the stream.
		 */
		protected function attemptToSubscribe():void
		{
			streamAttempts++;
			attemptSubscribe=true;
			if(ns)
			{
				dispatchEvent(new RTMPEvent(RTMPEvent.SUBSCRIBE_ATTEMPT));
				ns.play(stream,-1);
			}
		}
		
		/**
		 * Overrides for specific status codes for subscribing.
		 */
		override protected function onNetStreamStatus(ns:NetStatusEvent):void
		{
			//trace("RTMPSubscriber NetStreamStatus:",ns.info.code);
			switch(ns.info.code)
			{
				case "NetStream.Play.Start":
					if(attemptSubscribe)
					{
						clearInterval(tryAgainId);
						dispatchEvent(new RTMPEvent(RTMPEvent.STARTED_SUBSCRIBING));
						attemptSubscribe=false;
					}
					break;
				case "NetStream.Play.StreamNotFound":
					//tryAgain();
					onStreamFail();
					break;
				case "NetStream.Play.Failed":
					onStreamFail();
					break;
				case "NetStream.Play.InsufficientBW":
					dispatchEvent(new RTMPEvent(RTMPEvent.INSUFFICIENT_BW));
					break;
				case "NetStream.Play.UnpublishNotify":
					break;
				case "NetStream.Play.PublishNotify":
					break;
			}
		}
		
		/**
		 * Internal helper for trying again.
		 */
		private function tryAgain():void
		{
			tryAgainId=setTimeout(attemptToSubscribe,streamAttemptDelay);
		}
		
		/**
		 * Internal use for stream fail / not found.
		 */
		private function onStreamFail():void
		{
			if(attemptForever || (streamAttempts < maxStreamAttempts)) tryAgain();
			else if(streamAttempts == maxStreamAttempts) dispatchEvent(new RTMPEvent(RTMPEvent.STREAM_NOT_FOUND,true,false,null,stream)); 
		}
		
		/**
		 * Dispose of RTMPSubscriber instances.
		 */
		override public function dispose():void
		{
			attemptForever=false;
			attemptSubscribe=false;
			streamAttempts=0;
			clearInterval(tryAgainId);
			super.dispose();
		}	
	}
}