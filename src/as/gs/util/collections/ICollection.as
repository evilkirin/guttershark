package gs.util.collections 
{
	/**
	 * Interface for collection objects.
	 */
	public interface ICollection
	{
		
		/**
		 * Add an item to the collection.
		 * 
		 * @param item An item to add.
		 */
		function addItem(item:*):void;
		
		/**
		 * Add an item at a specific index.
		 * 
		 * @param i The index.
		 * @param item The item to add.
		 */
		function addItemAt(i:int,item:*):void;
		
		/**
		 * Get an item at a specific index.
		 * 
		 * @param i The index of the item.
		 */
		function getItemAt(i:int):*;
		
		/**
		 * Remove an item at a specific index.
		 * 
		 * @param i The index of the item to remove.
		 */
		function removeItemAt(i:int):void;
		
		/**
		 * Replace an item at a specific index.
		 * 
		 * @param item The item to set.
		 * @param i The index.
		 */
		function setItemAt(item:*,index:int):Boolean;
		
		/**
		 * Clear's the collection.
		 */
		function clear():void;
		
		/**
		 * Dispose of this collection.
		 */
		function dispose():void;
	}
}