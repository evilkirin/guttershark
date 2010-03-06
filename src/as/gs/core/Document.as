package gs.core 
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	/**
	 * The Document class is a stub for a flash
	 * document class.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class Document extends Sprite
	{
		
		/**
		 * Document lookup.
		 */
		private static var _docs:Dictionary=new Dictionary(true);
		
		/**
		 * @private
		 * The id of this document.
		 */
		public var id:String;
		
		/**
		 * Constructor for Document instances.
		 */
		public function Document()
		{
			super();
		}
		
		/**
		 * Set a document instance.
		 * 
		 * @param id An id for the document.
		 * @param doc A document instance.
		 */
		public static function set(id:String,doc:Document):void
		{
			if(!id||!doc)return;
			if(!doc.id)doc.id=id;
			_docs[id]=doc;
		}
		
		/**
		 * Get a document instance.
		 * 
		 * @param id The id of the document.
		 */
		public static function get(id:String):Document
		{
			if(!id)
			{
				trace("WARNING: Parameter {id} was null, returning null.");
				return null;
			}
			return _docs[id];
		}
		
		/**
		 * Unset a document instance.
		 * 
		 * @param id Unset (delete) a document instance.
		 */
		public static function unset(id:String):void
		{
			if(!id)return;
			delete _docs[id];
		}
		
		/**
		 * Dispose of this document.
		 */
		public function dispose():void
		{
			if(id)Document.unset(id);
			id=null;
		}
	}
}