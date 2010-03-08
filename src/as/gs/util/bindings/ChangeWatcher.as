package gs.util.bindings
{
	import flash.events.Event;						

	/**
	 * The ChangeWatcher class is an anonymous event
	 * handling object for each binding created by
	 * the BindingsManager.
	 * 
	 * <p>It takes care of the logic needed, to pass
	 * on values to functions, or set properties, when
	 * a change event occurs.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class ChangeWatcher
	{
		
		/**
		 * The change event source object.
		 */
		private var changeSource:Object;
		
		/**
		 * The property the binding is waiting for.
		 */
		private var property:String;
		
		/**
		 * A setter destination function.
		 */
		private var setterDestination:Function;
		
		/**
		 * The destination source.
		 */
		private var destination:Object;
		
		/**
		 * The destination property for a property binding.
		 */
		private var destProperty:String;
		
		/**
		 * Factory constructor for a setter binding.
		 * 
		 * @param changeSource The source object to listen for changes events from.
		 * @param property The property to be updated when the source dispatches the change event.
		 * @param destination A function callback, which receives a new value from the source.
		 */
		public static function NewSetterChangeWatcher(changeSource:Object,property:String,destination:Function):ChangeWatcher
		{
			var ch:ChangeWatcher = new ChangeWatcher();
			ch.initSetterWatcher(changeSource,property,destination);
			return ch;
		}
		
		/**
		 * @private
		 * Init a setter watcher change watcher object.
		 * 
		 * @param source The source object to listen for changes events from.
		 * @param property The property to be updated when the source dispatches the change event.
		 * @param destination A function callback, which receives a new value from the source.
		 */
		protected function initSetterWatcher(source:Object,property:String,destination:Function):void
		{
			this.changeSource=source;
			this.property=property;
			this.setterDestination=destination;
			changeSource.addEventListener(Event.CHANGE,onSetterPropChange);
			changeSource.addEventListener(PropertyChangeEvent.CHANGE+property,onSetterPropChange);
			changeSource.addEventListener(PropertyChangeEvent.DELETE+property,onDelete);
		}
		
		/**
		 * On property change for a setter change watcher.
		 */
		private function onSetterPropChange(e:Event):void
		{
			if(e is PropertyChangeEvent)
			{
				var pce:PropertyChangeEvent=(e as PropertyChangeEvent);
				if(pce.property!=property) return;
				else sendToSetter();
			}
			else sendToSetter();
		}

		/**
		 * Initiates the setter update to the destination.
		 */
		private function sendToSetter():void
		{
			setterDestination(changeSource[property]);
		}

		/**
		 * Factory constructor for a property binding.
		 * 
		 * @param changeSource The source object to listen for changes events from.
		 * @param property The property to to wait for an update from.
		 * @param destination The destination object.
		 * @param destProperty The property on the destination object to be updated.
		 */
		public static function NewPropertyChangeWatcher(source:Object,property:String,destination:Object,destProperty:String):ChangeWatcher
		{
			var ch:ChangeWatcher = new ChangeWatcher();
			ch.initPropertyWatcher(source,property,destination,destProperty);
			return ch;
		}
		
		/**
		 * @private
		 * Init a property change watcher.
		 * 
		 * @param changeSource The source object to listen for changes events from.
		 * @param property The property to to wait for an update from.
		 * @param destination The destination object.
		 * @param destProperty The property on the destination object to be updated.
		 */
		protected function initPropertyWatcher(source:Object,property:String,destination:Object,destProperty:String):void
		{
			this.changeSource=source;
			this.property=property;
			this.destination=destination;
			this.destProperty=destProperty;
			changeSource.addEventListener(Event.CHANGE,onPropertyChange);
			changeSource.addEventListener(PropertyChangeEvent.CHANGE+property,onPropertyChange);
			changeSource.addEventListener(PropertyChangeEvent.DELETE+property,onDelete);
		}
		
		/**
		 * On change for property binding.
		 */
		private function onPropertyChange(e:Event):void
		{
			if(e is PropertyChangeEvent)
			{
				var pce:PropertyChangeEvent=(e as PropertyChangeEvent);
				if(pce.property!=property) return;
				else updateProperty();
			}
			else updateProperty();
		}
		
		/**
		 * Executes the property update from source to destination.
		 */
		private function updateProperty():void
		{
			destination[destProperty]=changeSource[property];
		}
		
		/**
		 * On key delete from bindable object.
		 */
		private function onDelete(e:Event):void
		{
			dispose();
		}
		
		/**
		 * Dispose of this change watcher.
		 */
		public function dispose():void
		{
			if(changeSource)
			{
				changeSource.removeEventListener(Event.CHANGE,onPropertyChange);
				changeSource.removeEventListener(PropertyChangeEvent.CHANGE+property,onPropertyChange);
				changeSource.removeEventListener(PropertyChangeEvent.DELETE+property,onDelete);
				changeSource=null;	
			}
			destination=null;
			destProperty=null;
			property=null;
			setterDestination=null;
		}
	}
}