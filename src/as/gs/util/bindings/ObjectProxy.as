package gs.util.bindings
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;	

	/**
	 * The ObjectProxy class is the base class that
	 * has the necessary proxy methods, which enable bindings.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	dynamic public class ObjectProxy extends Proxy implements IEventDispatcher
	{
		
		/**
		 * key value lookup.
		 */
		private var _item:Dictionary;
		
		/**
		 * Property list for, for..in loops.
		 */
		private var _propertyList:Array;
		
		/**
		 * An event dispatcher.
		 */
		private var _dispatcher:EventDispatcher;
		
		/**
		 * Constructor for ObjectProxy instances.
		 * 
		 * @param obj Optional object of key's/values that
		 * get set as the properties for this object.
		 */
	    public function ObjectProxy(obj:Dictionary=null)
		{
			_item=obj||new Dictionary(true);
			_dispatcher=new EventDispatcher(this);
	    }
	    
	    /**
	     * @private
	     */
	    override flash_proxy function callProperty(methodName:*, ... args):*
	    {
			return this[methodName].apply(this,args);
	    }
	    
	    /**
	     * @private
	     */
		override flash_proxy function deleteProperty(name:*):Boolean
		{
			if(name in _item)
			{
				var oldValue:* =_item[name];
				delete _item[name];
				dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.DELETE+name,name));
				return true;
			}
			return false;
		}
		
		/**
	     * @private
	     */
	    override flash_proxy function getDescendants(name:*):*
	    {
	    	throw new TypeError('Error #1016: Descendants operator (..) not supported on type ModelData.');
	    }
	    
	    /**
	     * @private
	     */
		override flash_proxy function getProperty(name:*):*
	    {
			return _item[name];
	    }
	    
	    /**
	     * @private
	     */
	    override flash_proxy function hasProperty(name:*):Boolean
	    {
	        return name in _item;
	    }
	    
	    /**
	     * @private
	     */
		override flash_proxy function nextName(index:int):String
		{
			return _propertyList[index-1];
		}
		
		/**
	     * @private
	     */
	    override flash_proxy function nextNameIndex(index:int):int
		{
			if(index==0)this._setupPropertyList();
			return index < _propertyList.length?index+1:0;
		}
		
		/**
	     * @private
	     */
	    override flash_proxy function nextValue(index:int):*
	    {
			if(index==0)this._setupPropertyList();
			return _item[_propertyList[index-1]];
	    }
	    
	    /**
	     * @private
	     */
		override flash_proxy function setProperty(name:*,value:*):void
	    {
	    	var oldValue:* = _item[name];
			if(value!=oldValue)
			{
				_item[name]=value;
				var eventType:String=PropertyChangeEvent.CHANGE+name;
				if(hasEventListener(eventType)) dispatchEvent(new PropertyChangeEvent(eventType,name));
			}
	    }
	    
	    /**
	     * @private
	     * creates property list array for, for..in loops.
	     */
		private function _setupPropertyList():void
		{
			_propertyList=[];
			var x:*;
			for(x in _item) _propertyList.push(x);
		}
		
		/**
		 * @inheritDoc
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * @inheritDoc
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return _dispatcher.dispatchEvent(event);
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasEventListener(type:String):Boolean
		{
			return _dispatcher.hasEventListener(type);
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeEventListener(type:String,listener:Function,useCapture:Boolean=false):void 
		{
			_dispatcher.removeEventListener(type,listener,useCapture);
		}
		
		/**
		 * @inheritDoc
		 */
		public function toString():String 
		{
			return _item.toString.call(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function willTrigger(type:String):Boolean 
		{
			return _dispatcher.willTrigger(type);
		}
	}
}