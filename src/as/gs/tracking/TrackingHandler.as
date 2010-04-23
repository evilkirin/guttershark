package gs.tracking 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 * The TrackingHandler class is used inside of the Tracking class.
	 * 
	 * <p>It's used when you call the register method of the
	 * Tracking class. You don't need to use this manually.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class TrackingHandler 
	{
		
		/**
		 * The tracking id to fire.
		 */
		public var id:String;
		
		/**
		 * The object that triggers the tracking event.
		 */
		public var obj:IEventDispatcher;
		
		/**
		 * The event that will trigger that tracking call.
		 */
		public var event:String;
		
		/**
		 * Options for the tracking call.
		 */
		public var options:Object;
		
		/**
		 * Tracking reference for the tracking that actually
		 * fires the tracking call.
		 */
		protected var tracking:Tracking;
		
		/**
		 * Constructor for TrackingHandler instances.
		 * 
		 * @param _tracking A tracking reference.
		 * @param _id The tracking id.
		 * @param _obj The object that triggers the tracking call.
		 * @param _event The event that triggers the tracking call.
		 * @param _options Options for the tracking call.
		 */
		public function TrackingHandler(_tracking:Tracking,_id:String,_obj:IEventDispatcher,_event:String,_options:Object)
		{
			if(!_tracking)throw new ArgumentError("Parameter {_tracking} cannot be null.");
			if(!_event)throw new ArgumentError("Parameter {_event} cannot be null.");
			if(!_obj)throw new ArgumentError("Parameter {_obj} cannot be null.");
			tracking=_tracking;
			id=_id;
			obj=_obj;
			obj.addEventListener(_event,handler);
			event=_event;
			options=_options;
		}
		
		/**
		 * When the event fires, tell the tracking to fire a tracking call.
		 */
		private function handler(e:Event):void
		{
			tracking.track(id,options);
		}
		
		/**
		 * Dispose of this tracking handler.
		 */
		public function dispose():void
		{
			obj.removeEventListener(event,handler);
			tracking=null;
			obj=null;
			id=null;
			event=null;
			options=null;
		}
	}
}