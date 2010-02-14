package gs.util
{
	import flash.utils.Dictionary;
	
	/**
	 * The Strings class wraps a locale strings
	 * xml file. This has shortcuts for getting
	 * text from xml by id.
	 * 
	 * <p>The model has a property on it called 'strings',
	 * which can store a reference to one of these
	 * Strings instances.</p>
	 * 
	 * @example Example localized text xml file:
	 * <listing>	
	 * &lt;strings&gt;
	 *   &lt;string id="purchasePower"&gt;&lt;![CDATA[Purchase Power]]&gt;&lt;/string&gt;
	 *   &lt;string id="purchasePowerInputViewTitle"&gt;
	 *     &lt;![CDATA[Drag the sliders to enter amounts. Be sure to enter monthly numbers.]]&gt;
	 *   &lt;/string&gt;
	 *   &lt;string id="purchasePowerDownload"&gt;&lt;![CDATA[download]]&gt;&lt;/string&gt;
	 *   &lt;string id="purchasePowerShare"&gt;&lt;![CDATA[share]]&gt;&lt;/string&gt;
	 *   &lt;string id="purchasePowerCalculate"&gt;&lt;![CDATA[calculate]]&gt;&lt;/string&gt;
	 *   &lt;string id="purchasePowerAdjust"&gt;&lt;![CDATA[adjust]]&gt;&lt;/string&gt;
	 * &lt;/strings&gt;
	 * </listing>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class Strings
	{
		
		/**
		 * The strings xml.
		 */
		private var xml:XML;
		
		/**
		 * Dict lookup.
		 */
		private static var _strs:Dictionary = new Dictionary(true);
		
		/**
		 * @private
		 */
		public var id:String;
		
		/**
		 * Constructor for Strings instances.
		 * 
		 * @param xml The xml of locale strings.
		 */
		public function Strings(xml:XML):void
		{
			this.xml=xml;
		}
		
		/**
		 * Get a Strings instance by id.
		 * 
		 * @param id The string id.
		 */
		public static function get(id:String):Strings
		{
			if(!id)return null;
			return _strs[id];
		}
		
		/**
		 * Set a Strings instance.
		 * 
		 * @param id The strings instance id.
		 * @param str The Strings instance.
		 */
		public static function set(id:String,str:Strings):void
		{
			if(!id)return;
			if(!str.id)str.id=id;
			_strs[id]=str;
		}
		
		/**
		 * Unset (delete) a Strings instance.
		 * 
		 * @param id The strings instance id.
		 */
		public static function unset(id:String):void
		{
			if(!id)return;
			delete _strs[id];
		}
		
		/**
		 * Get string from an id.
		 * 
		 * @param id The id of string to grab.
		 */
		public function getStringFromID(id:String):String
		{
			var nodes:XMLList=(xml..string.(@id==id));
			var l:int=nodes.length();
			if(l>1)
			{
				trace("WARNING: Locale strings files cannot have duplicate id's, using the first one found.");
				return nodes[0].toString();
			}
			if(l==0) trace("WARNING: String with id {"+id+"} wasn't found.");
			return nodes.toString();
		}
		
		/**
		 * Dispose of this strings instance.
		 */
		public function dispose():void
		{
			Strings.unset(id);
		}
	}
}