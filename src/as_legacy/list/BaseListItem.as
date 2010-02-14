package net.guttershark.display.list 
{
	import net.guttershark.display.CoreClip;				

	/**
	 * The BaseListItem class is an adapter that
	 * implements the IListItem interface and
	 * contains some basic logic.
	 */
	public class BaseListItem extends CoreClip implements IListItem
	{
		
		/**
		 * A flag indicating whether or not
		 * this item is active.
		 */
		protected var active:Boolean;
		
		/**
		 * The data payload.
		 */
		protected var _data:Object;
		
		/**
		 * Alternative to the data object, which is xml instead.
		 */
		protected var _xml:XML;
		
		/**
		 * Constructor for BaseListItem instances.
		 */
		public function BaseListItem()
		{
			_data={};
		}
		
		/**
		 * Called when an item is clicked.
		 */
		public function activate():void
		{
			active=true;
		}
		
		/**
		 * Called when a different item is clicked,
		 * to deactive the currently active item.
		 */
		public function deactivate():void
		{
			active=false;
		}
		
		/**
		 * The data payload.
		 */
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 * The data payload.
		 */
		public function set data(obj:Object):void
		{
			_data=obj;
		}
	}
}