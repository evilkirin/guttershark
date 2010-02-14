package gs.util.iters
{
	
	/**
	 * The XMLListIterator iterates an XMLList object.
	 */
	public class XMLListIterator
	{
		
		/**
		 * XML node position.
		 */
		private var cursor:int;
		
		/**
		 * Length of the list.
		 */
		private var len:int;
		
		/**
		 * Data were iterating
		 */
		private var xml:XMLList;
		
		/**
		 * Constructor for XMLListIterator instance.
		 * 
		 * @param xml An XMLList.
		 */
		public function XMLListIterator(xml:XMLList):void
		{
			cursor=-1;
			len=xml.length();
			this.xml=xml;
		}
		
		/**
		 * Whether or not there's a next item.
		 */
		public function hasNext():Boolean
		{
			return cursor<len-1;
		}
		
		/**
		 * Whether or not there's a previous item.
		 */
		public function hasPrev():Boolean
		{
			return cursor>0;
		}
		
		/**
		 * Get the first item and reset the cursor
		 */
		public function first():*
		{
			cursor=0;
			return xml[cursor];
		}
		
		/**
		 * Get the last item and reset the cursor.
		 */
		public function last():*
		{
			cursor=len-1;
			return xml[cursor];
		}
		
		/**
		 * The next xml item.
		 */
		public function next():*
		{
			cursor++;
			return xml[cursor];
		}
		
		/**
		 * The previous xml item.
		 */
		public function prev():*
		{
			cursor--;
			return xml[cursor];
		}
		
		/**
		 * Dispose of this iterator.
		 */
		public function dispose():void
		{
			cursor=0;
			xml=null;
		}
	}
}
