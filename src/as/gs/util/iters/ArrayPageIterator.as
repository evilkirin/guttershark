package gs.util.iters
{
	
	/**
	 * The ArrayPageIterator class provides a non-destructive way
	 * to iterate over an array in page sizes.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class ArrayPageIterator 
	{
		
		/**
		 * The array of data it's paging through.
		 */
		protected var array:Array;
		
		/**
		 * The page size.
		 */
		protected var pageSize:int;
		
		/**
		 * The current page.
		 */
		protected var _page:int;
		
		/**
		 * The total number of pages available.
		 */
		protected var totalPages:int;
		
		/**
		 * Constructor for ArrayPageIterator instances.
		 */
		public function ArrayPageIterator(array:Array,pageSize:int):void
		{
			this.array=array;
			this.pageSize=pageSize;
			totalPages=Math.ceil(array.length/pageSize);
			_page=-1;
		}
		
		/**
		 * Set the current page index.
		 * 
		 * @param page The page (0 based).
		 */
		public function set page(page:int):void
		{
			if(page>totalPages||page<0) throw new Error("Page out of bounds.");
			_page=page;
		}
		
		/**
		 * Move cursor to the last page.
		 */
		public function moveLast():void
		{
			_page = totalPages+1;
		}
		
		/**
		 * Move cursor to the first page.
		 */
		public function moveFirst():void
		{
			_page = -1;
		}
		
		/**
		 * Get the first page.
		 */
		public function firstPage():Array
		{
			return array.slice(0,pageSize);
		}
		
		/**
		 * Get the last page.
		 */
		public function lastPage():Array
		{
			return array.slice(array.length-(pageSize-1),array.length);
		}
		
		/**
		 * Get the next page out of the array.
		 */
		public function nextPage():Array
		{
			_page++;
			if(_page>=totalPages)
			{
				_page=totalPages;
				return null;
			}
			var start:int=(_page*pageSize);
			var end:int=start+pageSize;
			return array.slice(start,end);
		}
		
		/**
		 * Get the previous page out of the array.
		 */
		public function previousPage():Array
		{
			_page--;
			if(_page<0)
			{
				_page=-1;
				return null;
			}
			var start:int=(_page*pageSize);
			var end:int=start+pageSize;
			return array.slice(start,end);
		}
	}
}