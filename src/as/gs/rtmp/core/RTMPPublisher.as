package gs.rtmp.core
{
	import flash.events.NetStatusEvent;
	import flash.utils.setTimeout;
	
	/**
	 * Dispatched when an attempt to publish the stream
	 * happens.
	 * 
	 * @eventType gs.rtmp.core.RTMPEvent
	 */
	[Event("publishAttempt", type="gs.rtmp.core.RTMPEvent")]
	
	/**
	 * Dispatched when the stream has started publishing.
	 * 
	 * @eventType gs.rtmp.core.RTMPEvent
	 */
	[Event("startedPublishing", type="gs.rtmp.core.RTMPEvent")]
	
	/**
	 * Dispatched when publishing the stream completely fails.
	 * 
	 * @eventType gs.rtmp.core.RTMPEvent
	 */
	[Event("publishFailed", type="gs.rtmp.core.RTMPEvent")]
	
	/**
	 * The RTMPPublisher class is used for publishing
	 * live audio or audio, and video.
	 * 
	 * <p>You can also set the record property which will
	 * cause the server to record the stream</p>
	 */
	public class RTMPPublisher extends RTMPClient
	{
		
		/**
		 * The maximum publishing attempts, default is 3.
		 */
		public static var maxPublishAttempts:int;
		
		/**
		 * The time in between publish attempts, default is 3000.
		 */
		public static var publishDelay:int;
		
		/**
		 * Whether or not to attempt to publish forever.
		 */
		public var attemptForever:Boolean;
		
		/**
		 * Current number of publish attempts.
		 */
		protected var publishAttempts:int;
		
		/**
		 * Whether or not an attept at publishing
		 * is happening.
		 */
		private var attemptPublish:Boolean;
		
		/**
		 * Storage for "record" getter and setter.
		 */
		protected var _record:Boolean;
		
		/**
		 * Storage for "appendToPreviousStream" getter and setter.
		 */
		protected var _append:Boolean;
		
		/**
		 * Constructor for RTMPPublisher instances.
		 */
		public function RTMPPublisher()
		{
			super();
			publishAttempts=0;
			if(!publishDelay)publishDelay=3000;
			if(!maxPublishAttempts)maxPublishAttempts=3;
		}
		
		/**
		 * Whether or not the server should record the stream.
		 */
		public function set record(shouldRecord:Boolean):void
		{
			_record=shouldRecord;
		}
		
		/**
		 * Whether or not the server should record the stream.
		 */
		public function get record():Boolean
		{
			return _record;
		}
		
		/**
		 * Whether or not the stream should be recorded, and appended
		 * to the previous stream that's either on the server, or recorder
		 * previously.
		 */
		public function set appendToPreviousStream(append:Boolean):void
		{
			_append=append;
		}
		
		/**
		 * Whether or not the stream should be recorded and appended
		 * to the previous stream that's either on the server, or recorder
		 * previously.
		 */
		public function get appendToPreviousStream():Boolean
		{
			return _append;
		}
		
		/**
		 * Publish the stream.
		 */
		public function publish(e:* =null):void
		{
			if(e)return;
			initNetStream();
			if(mic)ns.attachAudio(mic);
			if(cam)ns.attachCamera(cam);
			attemptToPublish();
		}
		
		/**
		 * Stop publishing - this leaves internal
		 * state ready to call publish() again.
		 */
		public function unpublish(e:* =null):void
		{
			if(e)return;
			if(mic&&ns)ns.attachAudio(null);
			if(cam&&ns)ns.attachCamera(null);
			try{ns.close();}
			catch(e:*){}
			ns=null;
			publishAttempts=0;
			attemptPublish=false;
		}
		
		/**
		 * Connects to the server and immediately starts publishing.
		 */
		public function connectAndPublish():void
		{
			addEventListener(RTMPEvent.CONNECTED,onClientConnected,false,11,true);
			connect();
		}
		
		/**
		 * On super class connect, start publishing.
		 */
		protected function onClientConnected(e:RTMPEvent):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			publish();
		}
		
		/**
		 * Internal attempt publishing.
		 */
		private function attemptToPublish():void
		{
			publishAttempts++;
			attemptPublish=true;
			if(ns)
			{
				dispatchEvent(new RTMPEvent(RTMPEvent.PUBLISH_ATTEMPT));
				if(_append) ns.publish(stream,"append");
				else if(_record) ns.publish(stream,"record");
				else ns.publish(stream,"live");
			}
		}
		
		/**
		 * Overrides for specific status codes when publishing.
		 */
		override protected function onNetStreamStatus(ns:NetStatusEvent):void
		{
			//trace("RTMPPublisher NetStreamStatus:",ns.info.code);
			switch(ns.info.code)
			{
				case "NetStream.Publish.Start":
					if(attemptPublish)
					{
						dispatchEvent(new RTMPEvent(RTMPEvent.STARTED_PUBLISHING));
						attemptPublish=false;
					}
					break;
				case "NetStream.Publish.BadName":
					onPublishFail();
					break;
			}
		}
		
		/**
		 * When publishing fails.
		 */
		private function onPublishFail():void
		{
			if(attemptForever || (publishAttempts < maxPublishAttempts)) setTimeout(attemptToPublish,publishDelay);
			else if(publishAttempts == maxPublishAttempts) dispatchEvent(new RTMPEvent(RTMPEvent.PUBLISH_FAILED));
		}
		
		/**
		 * Dispose of RTMPPublisher instances.
		 */
		override public function dispose():void
		{
			attemptForever=false;
			publishAttempts=0;
			attemptPublish=false;
			_record=false;
			_append=false;
			super.dispose();
		}
	}
}
