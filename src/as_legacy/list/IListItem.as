package net.guttershark.display.list 
{
	
	/**
	 * The IListItem interface defines a contract for
	 * items that can be displayed in a list.
	 */
	public interface IListItem
	{
		
		/**
		 * Called when an item is clicked.
		 */
		function activate():void;
		
		/**
		 * Called when a different item is clicked,
		 * to deactive the currently active item.
		 */
		function deactivate():void;
		
		/**
		 * The data payload.
		 */
		function get data():Object;
		
		/**
		 * The data payload.
		 */
		function set data(data:Object):void;
		
		function get height():Number;
		
		function get width():Number;	}}