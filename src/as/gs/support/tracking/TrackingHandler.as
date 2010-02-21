package gs.support.tracking 
{
	import gs.managers.TrackingManager;

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 * The TrackingHandler class is used internally
	 * in a tracking manager.
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
		 * Manager reference for the manager that actually
		 * fires the tracking call.
		 */
		protected var manager:TrackingManager;
		
		/**
		 * Constructor for TrackingHandler instances.
		 * 
		 * @param _manager A tracking manager reference.
		 * @param _id The tracking id.
		 * @param _obj The object that triggers the tracking call.
		 * @param _event The event that triggers the tracking call.
		 * @param _options Options for the tracking call.
		 */
		public function TrackingHandler(_manager:TrackingManager,_id:String,_obj:IEventDispatcher,_event:String,_options:Object)
		{
			if(!_manager)throw new ArgumentError("Parameter {_manager} cannot be null.");
			if(!_event)throw new ArgumentError("Parameter {_event} cannot be null.");
			if(!_obj)throw new ArgumentError("Parameter {_obj} cannot be null.");
			manager=_manager;
			id=_id;
			obj=_obj;
			obj.addEventListener(_event,handler);
			event=_event;
			options=_options;
		}
		
		/**
		 * When the event fires, tell the manager to fire a tracking call.
		 */
		private function handler(e:Event):void
		{
			manager.track(this);
		}
		
		/**
		 * Dispose of this tracking handler.
		 */
		public function dispose():void
		{
			obj.removeEventListener(event,handler);
			manager=null;
			obj=null;
			id=null;
			event=null;
			options=null;
		}
	}
}