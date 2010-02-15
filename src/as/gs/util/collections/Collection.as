package gs.util.collections 
{
	
	/**
	 * A simple collection which acts like a data provider.
	 */
	public class Collection implements ICollection
	{
		
		public var name:String;
		
		/**
		 * Values this collection contains.
		 */
		protected var values:Array;
		
		/**
		 * Constructor for Collection instances.
		 * 
		 * @param name The collection name.
		 */
		public function Collection(name:String)
		{
			this.name=name;
			values=new Array();
		}
		
		/**
		 * Get an item at a specific index.
		 * 
		 * @param i The index of the item.
		 */
		public function getItemAt(i:int):*
		{
			if(!i || i<0 || i>values.length-1) return null;
			return values[i];
		}
		
		/**
		 * Add an item to the collection.
		 * 
		 * @param item An item to add.
		 */
		public function addItem(item:*):void 
		{
			if(!item)return;
			values.push(item);
		}
		
		/**
		 * Add an item at a specific index.
		 * 
		 * @param i The index.
		 * @param item The item to add.
		 */
		public function addItemAt(i:int,item:*):void 
		{
			if(!i || i<0)return;
			values.splice(i,0,item);
		}
		
		/**
		 * Replace an item at a specific index.
		 * 
		 * @param item The item to set.
		 * @param i The index.
		 */
		public function setItemAt(item:*,i:int):Boolean 
		{
			if(i<values.length)
			{
				values[i]=item;
				return true;
			}
			return false;
		}
		
		/**
		 * Remove an item at a specific index.
		 * 
		 * @param i The index of the item to remove.
		 */
		public function removeItemAt(i:int):void 
		{
			values.splice(i,1);
		}
		
		/**
		 * Clear's the collection.
		 */
		public function clear():void 
		{
			values=new Array();
		}
		
		/**
		 * Dispose of this collection
		 */
		public function dispose():void
		{
			values=null;
		}
		
		/**
		 * Collection length.
		 */
		public function get length():int 
		{
			return values.length;
		}
	}
}