package gs.util 
{
	
	/**
	 * The XMLUtils class contains generic methods
	 * for working with XML.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class XMLUtils
	{
		
		/**
		 * Grab an attribute, or node value from xml. This
		 * will first look for an attribute with "@", then
		 * a node.
		 * 
		 * @example
		 * <listing>	
		 * trace(XMLUtils.getAttrib(myXMLNode,"width")); //don't need to pass "@width".
		 * </listing>
		 */
		public static function getAttrib(xml:*,name:String):*
		{
			if(!xml || !name)return;
			if(xml.hasOwnProperty("@"+name))return xml["@"+name];
			if(xml.hasOwnProperty(name)) return xml[name].toString();
			return null;
		}
		
		/**
		 * Whether or not xml has an attribute on it. You don't
		 * need to pass the "@" - so for @name, pass "name".
		 * 
		 * @example
		 * <listing>	
		 * trace(XMLUtils.hasAttrib(myXMLNode,"width")); //don't pass "@width";
		 * </listing>
		 */
		public static function hasAttrib(xml:*,name:String): Boolean
		{
			if(!xml || !name)return false;
			if(xml.hasOwnProperty("@"+name)) return true;
			return false;
		}
		
		/**
		 * Whether or not xml has a node called name.
		 * 
		 * @example
		 * <listing>	
		 * trace(XMLUtils.hasNode(myXMLNode,"nodeName"));
		 * </listing>
		 */
		public static function hasNode(xml:*,name:String):Boolean
		{
			if(!xml || !name)return false;
			if(xml.hasOwnProperty(name)) return true;
			return false;
		}
		
		/**
		 * Generic way to set an attribute on an
		 * object.
		 * 
		 * @example
		 * <listing>	
		 * XMLUtils.setAttrib(myMovieClip,"alpha",myXMLNode);
		 * </listing>
		 * 
		 * @param target The arget object.
		 * @param name The attribute name
		 * @param attributes An xml object to pull the value from.
		 * @param castType The type cast to perform.
		 */
		public static function setAttrib(target:*,name:String,attributes:*,castType:String="Number"):void
		{
			if(!target)
			{
				trace("WARNING: The {target} parameter was null, nothing done.");
				return;
			}
			if(!name)
			{
				trace("WARNING: The {name} parameter was null, nothing done");
				return;
			}
			var value:* =attributes.attribute(name);
			if(value!=undefined)
			{
				switch(castType)
				{
					case "String":
						target[name]=String(value);
						break;
					case "Number":
						target[name]=Number(value);
						break;
					case "int":
						target[name]=int(value);
						break;	
					case "Boolean":
						target[name]=Boolean(value);
						break;
				}
			}
		}
		
		/**
		 * Walks a node list for a value.
		 * 
		 * <p>This only supports one ".", and "@" attributes.
		 * Doesn't support ".." or any other special accessors.</p>
		 * 
		 * <p>This will return null if the value isn't found.</p>
		 * 
		 * @example	
		 * <listing>	
		 * trace(XMLUtils.walkForValue(myXML,"header.title"));
		 * trace(XMLUtils.walkForValue(myXML,"header.title.@textFormat"));
		 * </listing>
		 */
		public static function walkForValue(xml:*,nodeList:String):String
		{
			if(!xml || !nodeList)
			{
				trace("WARNING: The parameter {xml} or {nodeList} was null, nothing done");
				return null;
			}
			var nodes:Array=nodeList.split(".");
			var i:int=0;
			var l:int=nodes.length;
			var last:* =xml;
			var node:String;
			var value:String=null;
			for(;i<l;i++)
			{
				node=nodes[int(i)];
				if(last.hasOwnProperty(node))
				{
					last=last[node];
					value=last.toString();
					continue;
				}
				else return null;
			}
			return value;
		}
		
		/**
		 * Whether or not a node can be walked down,
		 * reaching the endpoint.
		 * 
		 * <p>This only supports one ".", and "@" attributes.
		 * Doesn't support ".." or any other special accessors.</p>
		 * 
		 * @example
		 * <listing>
		 *     trace(XMLUtils.canWalkTo(myXML,"header.title"));
		 *     trace(XMLUtils.canWalkTo(myXML,"header.title.@textFormat"));
		 * </listing>
		 */
		public static function canWalkTo(xml:*,nodeList:String):Boolean
		{
			if(!xml || !nodeList)
			{
				trace("WARNING: The parameter {xml} or {nodeList} was null, nothing done");
				return false;
			}
			var nodes:Array=nodeList.split(".");
			var i:int=0;
			var l:int=nodes.length;
			var last:* =xml;
			var node:String;
			for(;i<l;i++)
			{
				node=nodes[int(i)];
				if(last.hasOwnProperty(node))
				{
					last=last[node];
					continue;
				}
				else return false;
			}
			return true;
		}
		
		/**
		 * Sets default properties on an object from an xml node.
		 * 
		 * <p>
		 * Default attributes:
		 * <ul>
		 * <li>x</li>
		 * <li>y</li>
		 * <li>width</li>
		 * <li>height</li>
		 * <li>scaleY</li>
		 * <li>scaleX</li>
		 * <li>visible</li>
		 * <li>alpha</li>
		 * <li>name</li>
		 * </ul>
		 * </p>
		 */
		public static function setDefaults(attributes:*,target:*):void
		{
			if(!target)
			{
				trace("WARNING: Parameter {target} was null, nothing done");
				return;
			}
			var setAttrib:Function=setAttrib;
			setAttrib(target,"x",attributes);
			setAttrib(target,"y",attributes);
			setAttrib(target,"width",attributes);
			setAttrib(target,"height",attributes);
			setAttrib(target,"scaleY",attributes);
			setAttrib(target,"scaleX",attributes);
			setAttrib(target,"visible",attributes,"Boolean");
			setAttrib(target,"alpha",attributes);
			setAttrib(target,"name",attributes,"String");
		}
	}
}