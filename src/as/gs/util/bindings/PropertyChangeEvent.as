package gs.util.bindings
{
	import flash.events.Event;			

	/**
	 * The PropertyChangeEvent is used internally to
	 * the BindableObject class, which dispatches
	 * events needed for bindings.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class PropertyChangeEvent extends Event
	{
		
		/**
		 * The PropertyChangeEvent.CHANGE constant defines the
		 * value of the type property of a property change event object.
		 */
		public static const CHANGE:String="propertyChange";
		
		/**
		 * The PropertyChangeEvent.DELETE constant defines the
		 * value of the type property of a property change event object.
		 */
		public static const DELETE:String="delete";
		
		/**
		 * The property who's value was changed or deleted.
		 */
		public var property:String;
		
		/**
		 * Constructor for PropertyChangeEvent instances.
		 * 
		 * @param type The type of property change event.
		 * @param property The property who's value has changed.
		 */
		public function PropertyChangeEvent(type:String,property:String):void
		{
			super(type,false,false);
			this.property=property;
		}
	}
}