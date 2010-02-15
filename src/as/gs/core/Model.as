package gs.core
{
	import gs.managers.*;
	import gs.support.preloading.*;
	import gs.util.NavigateToURL;
	import gs.util.StringUtils;
	import gs.util.Strings;
	import gs.util.StyleSheetUtils;
	import gs.util.TextAttributes;
	import gs.util.XMLLoader;
	import gs.util.cache.*;

	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;

	/**
	 * The Model class contains shortcuts for parsing a model xml file.
	 * 
	 * @example Example model XML file:
	 * <listing>	
	 * &lt;?xml version="1.0" encoding="utf-8"?&gt;
	 * &lt;model&gt;
	 *    &lt;fonts&gt;
	 *        &lt;font libraryName="Arial_Test" inSWF="fonts" /&gt;
	 *        &lt;group id="myGroup"&gt;
	 *            &lt;font libraryName="Helvetica Neueu Bold Condensed" /&gt;
	 *        &lt;/group&gt;
	 *    &lt;/fonts&gt;
	 *    
	 *    &lt;assets&gt;
	 *        &lt;asset libraryName="clayBanner1" source="clay_banners_1.jpg" preload="true" /&gt;
	 *        &lt;asset libraryName="clayBanner2" source="clay_banners_2.jpg" /&gt;
	 *        &lt;asset libraryName="clayWebpage" source="clay_webpage.jpg" /&gt;
	 *        &lt;asset libraryName="rssFeed" source="http://codeendeavor.com/feed" forceType="xml" /&gt;
	 *        &lt;asset libraryName="fonts" source="fonts.swf" preload="true" /&gt;
	 *        &lt;group id="sounds"&gt;
	 *            &lt;asset libraryName="thesound" source="sound.mp3" path="sounds" /&gt;
	 *        &lt;/group&gt;
	 *    &lt;/assets&gt;
	 *    
	 *    &lt;links&gt;
	 *        &lt;link id="google" url="http://www.google.com" /&gt;
	 *        &lt;link id="rubyamf" url="http://www.rubyamf.org" /&gt;
	 *        &lt;link id="guttershark" url="http://www.guttershark.net" window="_blank" /&gt;
	 *        &lt;link id="googleFromStringId" stringId="googleInStrings" /&gt;
	 *    &lt/links&gt;
	 *    
	 *    &lt;attributes&gt;
	 *        &lt;attribute id="someAttribute" value="the value" /&gt;
	 *        &lt;attribute id="someAttributeFromStrings" stringId="someAttributeValueStringId" /&gt;
	 *    &lt;/attributes&gt;
	 *    
	 *    &lt;textAttributes&gt;
	 *        &lt;attribute id="myTextAttribute1" autoSize="left" antiAliasType="advanced" styleSheetId='someStyleSheetId' textFormatId='someTextFormatId' stringId='someStringId' wrapInBodySpan='true' /&gt;
	 *        &lt;attribute id="myTextAttribute2" styleSheetId='someStyleSheetId' /&gt; &lt;!-- you don't have to use every attribute, it will only apply what's here. --&gt;
	 *    &lt/textAttributes&gt;
	 *    
	 *    &lt;services&gt;
	 *        &lt;!-- remoting --&gt;
	 *        &lt;gateway id="amfphp" path="amfphp" url="http://localhost/amfphp/gateway.php" objectEncoding="3" /&gt;
	 *        &lt;service id="test" gateway="amfphp" endpoint="Test" limiter="true" attempts="4" timeout="1000" /&gt;
	 *        
	 *        &lt;!-- http --&gt;
	 *        &lt;service id="foo" url="http://localhost/" attempts="4" timeout="1000" /&gt;
	 *        &lt;service id="sessionDestroy" path="sessiondestroy" url="http://tagsf/services/codeigniter/session/destroy" attempts="4" timeout="1000" responseFormat="variables" /&gt;
	 *        &lt;service id="ci" url="http://tagsf/services/codeigniter/" attempts="4" timeout="1000" responseFormat="variables" /&gt;
	 *        
	 *        &lt;!-- soap --&gt;
	 *        &lt;wsdl id="myWSDL" endpoint="http://example.com/?wsdl" attempts="3" timeout="3000" /&gt;
	 *        &lt;service id="myWSDL" wsdl="myWSDL" /&gt;
	 *    &lt;/services&gt;
	 *    
	 *    &lt;security&gt;
	 *        &lt;policyfiles&gt;
	 *            &lt;crossdomain url="http://www.codeendeavor.com/crossdomain.xml" /&gt;
	 *        &lt;/policyfiles&gt;
	 *        &lt;xscript&gt;
	 *            &lt;domain name="macromedia.com" /&gt;
	 *            &lt;domain name="\*" /&gt;
	 *            &lt;domain name="192.168.1.1" /&gt;
	 *        &lt;/xscript&gt;
	 *    &lt;/security&gt;
	 *    
	 *    &lt;stylesheets&gt;
	 *        &lt;stylesheet id="colors"&gt;
	 *            &lt;![CDATA[
	 *                .pink {
	 *            	      color:#FF0066
	 *                }
	 *            ]]&gt;
	 *        &lt;/stylesheet&gt;
	 *        &lt;stylesheet id="colors2"&gt;
	 *            &lt;![CDATA[
	 *                .some {
	 *            	      color:#FF8548
	 *                }
	 *            ]]&gt;
	 *        &lt;/stylesheet&gt;
	 *        &lt;stylesheet id="colors3" mergeStyleSheets="colors,colors2" /&gt;
	 *    &lt;/stylesheets&gt;
	 *    
	 *    &lt;textformats&gt;
	 *        &lt;textformat id="theTF" font="Arial" color="0xFF0066" bold="true" /&gt;
	 *    &lt;/textformats&gt;
	 *    
	 *    &lt;properties&gt;
	 *        &lt;propset id="test"&gt;
	 *            &lt;textFormat id="theTextFormat" /&gt;
	 *            &lt;alpha&gt;0.5&lt;/alpha&gt;
	 *            &lt;xywh x="20" y="+30" width="+100" height="100" /&gt; &lt;!-- optional node for x/y/w/h --&gt;
	 *            &lt;y&gt;+30&lt;/y&gt;
	 *            &lt;width&gt;400&lt;/width&gt;
	 *            &lt;alpha&gt;+.4&lt;/alpha&gt;
	 *        &lt;/propset&gt;
	 *        &lt;propset id="tfieldTest"&gt;
	 *            &lt;styleSheet id="colors3" /&gt;
	 *            &lt;htmlText&gt;&lt;![CDATA[&lt;p&gt;&lt;span class="pink"&gt;hello&lt;/span&gt; &lt;span class="some"&gt;w&lt;/span&gt;orld&lt;/p&gt;]]&gt;&lt;/htmlText&gt;
	 *            &lt;htmlText id="sparsley"/&gt; &lt;!-- optionally you can target a content/text node from the model, but not both. --&gt;
	 *        &lt;/propset&gt;
	 *    &lt;/properties&gt;
	 * &lt;/model&gt;
	 * </listing>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * <p>
	 * <b>Examples</b><br/>
	 * The examples are in the guttershark repository.
	 * </p>
	 * 
	 * <p>
	 * <ul>
	 * <li>examples/allowdomain/Main.as</li>
	 * <li>examples/assets/Main.as</li>
	 * <li>examples/assets2/Main.as</li>
	 * <li>examples/attributes/Main.as</li>
	 * <li>examples/colors/Main.as</li>
	 * <li>examples/fontlibs/Main.as</li>
	 * <li>examples/fontlibs2/Main.as</li>
	 * <li>examples/links/Main.as</li>
	 * <li>examples/localization/Main.as</li>
	 * <li>examples/model/Main.as</li>
	 * <li>examples/paths/Main.as</li>
	 * <li>examples/policyfiles/Main.as</li>
	 * <li>examples/preload/Main.as</li>
	 * <li>examples/preload1/Main.as</li>
	 * <li>examples/properties/Main.as</li>
	 * <li>examples/services/Main.as</li>
	 * <li>examples/stylesheets/Main.as</li>
	 * <li>examples/textformats/Main.as</li>
	 * <li>examples/textattributes/Main.as</li>
	 * <li>examples/xmlview/classes/Main.as</li>
	 * </ul>
	 * </p>
	 */
	final public dynamic class Model
	{
		
		/**
		 * Reference to the entire model XML.
		 */
		private var _model:XML;
		
		/**
		 * The id of this model.
		 */
		public var id:String;
		
		/**
		 * A placeholder for an instance of a Strings
		 * object. This is never set automatically, it's
		 * a placeholder to you to set it yourself.
		 */
		public var strings:Strings;
		
		/**
		 * Stores a reference to the <code>&lt;assets&gt;&lt;/assets&gt;</code>
		 * node in the model xml.
		 */
		public var assets:XMLList;
		
		/**
		 * Stores a reference to the <code>&lt;links&gt;&lt;/links&gt;</code>
		 * node in the model xml.
		 */
		public var links:XMLList;
		
		/**
		 * Stores a reference to the <code>&lt;attributes&gt;&lt;/attributes&gt;</code>
		 * node in the model xml.
		 */
		public var attributes:XMLList;
		
		/**
		 * Stores a reference to the <code>&lt;services&gt;&lt;/services&gt;</code>
		 * node in the model xml.
		 */
		public var services:XMLList;
		
		/**
		 * Stores a reference to the <code>&lt;stylesheets&gt;&lt;/stylesheets&gt;</code>
		 * node in the model xml.
		 */
		public var stylesheets:XMLList;
		
		/**
		 * Stores a reference to the <code>&lt;textformats&gt;&lt;/textformats&gt;</code>
		 */
		public var textformats:XMLList;
		
		/**
		 * Stores a reference to the <code>&lt;properties&gt;&lt;/properties&gt;</code>
		 * node in the model xml.
		 */
		public var properties:XMLList;
		
		/**
		 * Stores a reference to the <code>&lt;fonts&gt;&lt/fonts&gt;</code>
		 * node in the model xml.
		 */
		public var fonts:XMLList;
		
		/**
		 * Stores a reference to the <code>&lt;security&gt;&lt;/security&gt;</code>
		 * node in the model xml.
		 */
		public var security:XMLList;
		
		/**
		 * Stores a reference to the <code>&lt;textAttributes&gt;&lt;/textAttributes&gt;</code>
		 * node in the model xml.
		 */
		public var textAttributes:XMLList;

		/**
		 * If external interface is not available, all paths are stored here.
		 */
		private var paths:Dictionary;
		
		/**
		 * A cache for text formats and stylesheets.
		 */
		private var modelcache:Cache;
		
		/**
		 * Custom merged stylesheets.
		 */
		private var customStyles:Dictionary;

		/**
		 * xml loader used for loadModelXML;
		 */
		private var xmlLoader:XMLLoader;
		
		/**
		 * A callback for xml loader complete function.
		 */
		private var xmlLoaderOnComplete:Function;
		
		/**
		 * Model lookup.
		 */
		private static var _models:Dictionary = new Dictionary(true);
		
		/**
		 * @private
		 * Constructor for Model instances.
		 */
		public function Model()
		{
			paths=new Dictionary();
			customStyles=new Dictionary();
			modelcache=new Cache();
		}
		
		/**
		 * Get a model instance.
		 * 
		 * @param id The id of the model.
		 */
		public static function get(id:String):Model
		{
			if(!id)
			{
				trace("WARNING: Parameter {id} was null, returning null");
				return null;
			}
			return _models[id];
		}
		
		/**
		 * Set a model instance.
		 * 
		 * @param id The model id.
		 * @param ml The model instance.
		 */
		public static function set(id:String,ml:Model):void
		{
			if(!ml.id)ml.id=id;
			_models[id]=ml;
		}
		
		/**
		 * Unsets (deletes) a model instance.
		 */
		public static function unset(id:String):void
		{
			if(!_models)return;
			delete _models[id];
		}
		
		/**
		 * Sets the model xml.
		 * 
		 * @param xml The xml content that is the model.
		 */
		public function set xml(xml:XML):void
		{
			if(!xml)throw new ArgumentError("Parameter xml cannot be null");
			_model=xml;
			if(_model.assets)assets=_model.assets;
			if(_model.links)links=_model.links;
			if(_model["attributes"])attributes=_model["attributes"];
			if(_model.stylesheets)stylesheets=_model.stylesheets;
			if(_model.service)services=_model.services;
			if(_model.textformats)textformats=_model.textformats;
			if(_model.properties)properties=_model.properties;
			if(_model.fonts)fonts=_model.fonts;
			if(_model.security)security=_model.security;
			if(_model.textAttributes)textAttributes=_model.textAttributes;
		}
		
		/**
		 * The XML used as the model.
		 */
		public function get xml():XML
		{
			return _model;
		}
		
		/**
		 * Load's an xml file to use as the model xml.
		 * 
		 * @param model The model xml file name.
		 * @param onCompleteCallback A callback function for on complete of the xml load.
		 */
		public function loadModel(model:String,onCompleteCallback:Function=null):void
		{
			xmlLoaderOnComplete=onCompleteCallback;
			xmlLoader=new XMLLoader();
			xmlLoader.contentLoader.addEventListener(Event.COMPLETE,onXMLComplete,false,0,true);
			var req:URLRequest=new URLRequest(model);
			xmlLoader.load(req);
		}
		
		/**
		 * On model xml complete.
		 */
		private function onXMLComplete(e:Event):void
		{
			xml=xmlLoader.data;
			xmlLoader.removeEventListener(Event.COMPLETE,onXMLComplete);
			if(xmlLoaderOnComplete!=null)xmlLoaderOnComplete();
		}

		/**
		 * Get an Asset instance by the library name.
		 * 
		 * @param libraryName The libraryName of the asset to create.
		 * @param prependSourcePath	The path to prepend to the source property of the asset.
		 */
		public function getAssetByLibraryName(libraryName:String, prependSourcePath:String=null):Asset
		{
			checkForXML();
			var cacheKey:String="asset_"+libraryName;
			if(modelcache.isCached(cacheKey))return modelcache.getCachedObject(cacheKey) as Asset;
			if(!libraryName)throw new ArgumentError("Parameter libraryName cannot be null");
			var node:XMLList=assets..asset.(@libraryName==libraryName);
			var ft:String=(node.@forceType!=undefined&&node.@forceType!="")?node.@forceType:null;
			var src:String=node.@source || node.@src;
			if(prependSourcePath)src=prependSourcePath+src;
			if(node.@path!=undefined)src=getPath(node.@path.toString())+src;
			var a:Asset=new Asset(src,libraryName,ft);
			modelcache.cacheObject(cacheKey,a);
			return a;
		}
		
		/**
		 * Get an array of asset objects, from the provided library names.
		 * 
		 * @param ...libraryNames An array of library names.
		 */
		public function getAssetsByLibraryNames(...libraryNames:Array):Array
		{
			checkForXML();
			var cacheKey:String="assets_"+libraryNames.join("");
			if(modelcache.isCached(cacheKey))return modelcache.getCachedObject(cacheKey) as Array;
			var p:Array=[];
			var i:int=0;
			var l:int=libraryNames.length;
			for(i;i<l;i++) p[i]=getAssetByLibraryName(libraryNames[i]);
			modelcache.cacheObject(cacheKey,p);
			return p;
		}
		
		/**
		 * Get an array of asset objects, defined by a group node.
		 * 
		 * @param groupId The id of the group node.
		 */
		public function getAssetGroup(groupId:String):Array
		{
			checkForXML();
			var cacheKey:String="assetGroup_"+groupId; 
			if(modelcache.isCached(cacheKey))return modelcache.getCachedObject(cacheKey) as Array;
			var x:XMLList=assets..group.(@id==groupId);
			var n:XML;
			var payload:Array=[];
			for each(n in x..asset)payload.push(getAssetByLibraryName(n.@libraryName));
			modelcache.cacheObject(cacheKey,payload);
			return payload;
		}
		
		/**
		 * Returns an array of Asset instances from the assets node,
		 * that has a "preload" attribute set to true (preload='true').
		 */
		public function getAssetsForPreload():Array
		{
			checkForXML();
			var a:XMLList=assets..asset;
			if(!a)
			{
				trace("WARNING: No assets were defined, not doing anything.");
				return null;
			}
			var payload:Array=[];
			for each(var n:XML in a)
			{
				if(n.@preload==undefined||n.@preload=="false")continue;
				var ft:String=(n.@forceType!=undefined&&n.@forceType!="")?n.@forceType:null;
				var src:String=n.@source||n.@src;
				if(n.attribute("path")!=undefined)src=getPath(n.@path.toString())+src;
				var ast:Asset=new Asset(src,n.@libraryName,ft);
				payload.push(ast);
			}
			return payload;
		}
		
		/**
		 * Creates and returns a URLRequest from a link node.
		 * 
		 * @param id The id of the link node.
		 */
		public function getLink(id:String):URLRequest
		{
			checkForXML();
			var key:String="link_"+id;
			if(modelcache.isCached(key))return URLRequest(modelcache.getCachedObject(key));
			var link:XMLList=links..link.(@id==id);
			if(!link) return null;
			var u:URLRequest;
			if(link.hasOwnProperty("@stringId"))u=new URLRequest(strings.getStringFromID(link.@stringId));
			else if(link.@url!=undefined)u=new URLRequest(link.@url);
			else if(link.@href!=undefined)u=new URLRequest(link.@href);
			modelcache.cacheObject(key,u);
			return u;
		}
		
		/**
		 * Check whether or not a link is defined in the model.
		 * 
		 * @param id The link id.
		 */
		public function doesLinkExist(id:String):Boolean
		{
			checkForXML();
			var link:XMLList=links..link.(@id==id);
			if(!link||link==null)return false;
			return true;
		}
		
		/**
		 * Get the window attribute value on a link node.
		 * 
		 * @param id The id of the link node.
		 */
		public function getLinkWindow(id:String):String
		{
			checkForXML();
			var key:String="window_"+id;
			if(modelcache.isCached(key))return String(modelcache.getCachedObject(key));
			var link:XMLList=links..link.(@id == id);
			if(!link)return null;
			var window:String=link.@window;
			if(window)modelcache.cacheObject(key,window);
			return window;
		}
		
		/**
		 * Navigates to a link.
		 * 
		 * @param id The link id.
		 */
		public function navigateToLink(id:String):void
		{
			var req:URLRequest=getLink(id);
			var w:String=getLinkWindow(id);
			NavigateToURL.navToURL(req,w);
			//navigateToURL(req,w);
		}
		
		/**
		 * Get the value from an attribute node.
		 * 
		 * @param attributeID The id of an attribute node.
		 */
		public function getAttribute(attributeID:String):String
		{
			checkForXML();
			var attr:XMLList=attributes..attribute.(@id==attributeID);
			if(!attr)return null;
			if(attr.hasOwnProperty("@stringId")) return strings.getStringFromID(attr.@stringId);
			return attr.@value;
		}
		
		/**
		 * Get a text attributes.
		 * 
		 * @param attributeID The id of a text attribute node.
		 */
		public function getTextAttributeById(id:String):TextAttributes
		{
			checkForXML();
			var cachekey:String = "textAttributes_"+id;
			if(modelcache.isCached(cachekey)) return modelcache.getCachedObject(cachekey);
			var ss:StyleSheet=null;
			var tf:TextFormat=null;
			var string:String=null;
			var anti:String=null;
			var auto:String=null;
			var attr:XMLList=textAttributes..attribute.(@id==id);
			if(!attr)return null;
			if(attr.hasOwnProperty("@styleSheetId"))ss=getStyleSheetById(attr.@styleSheetId);
			if(attr.hasOwnProperty("@textFormatId"))tf=getTextFormatById(attr.@textFormatId);
			if(attr.hasOwnProperty("@stringId"))
			{
				if(!strings)
				{
					trace("WARNING: The {strings} property on the model is not setup. Not doing anything.");
					return null;
				}
				else string=strings.getStringFromID(attr.@stringId);
			}
			if(attr.hasOwnProperty("@antiAliasType"))anti=attr.@antiAliasType;
			if(attr.hasOwnProperty("@autoSize"))auto=attr.@autoSize;
			var ta:TextAttributes=new TextAttributes(ss,tf,anti,auto,string);
			if(attr.hasOwnProperty("@wrapInBodySpan"))ta.wrapInBodySpan=(attr.@wrapInBodySpan=="true")?true:false;
			if(attr.hasOwnProperty("@clearsTextAfterApply"))ta.clearsTextAfterApply=(attr.@clearsTextAfterApply=="true")?true:false;
			modelcache.cacheObject(cachekey,ta);
			return ta;
		}
		
		/**
		 * A shortcut method to get an attribute as a number.
		 * 
		 * @param attributeID The id of an attribute node.
		 */
		public function attrAsNumber(attributeID:String):Number
		{
			return Number(getAttribute(attributeID));
		}
		
		/**
		 * A shortcut method to get an attribute as an integer.
		 * 
		 * @param attributeID The id of an attribute node.
		 */
		public function attrAsInt(attributeID:String):int
		{
			return int(getAttribute(attributeID));
		}
		
		/**
		 * A shortcut method to get an attribute as a boolean.
		 * 
		 * @param attributeID The id of an attribute node.
		 */
		public function attrAsBool(attributeID:String):Boolean
		{
			return (getAttribute(attributeID)=="true"?true:false);
		}
		
		/**
		 * Check that the model xml was set on the singleton instance before any attempts
		 * to read the xml happens.
		 */
		protected function checkForXML():void
		{
			if(!_model) throw new Error("The model xml must be set on the model before attempting to read a property from it.");
		}

		/**
		 * Check whether or not a path has been defined.
		 */
		public function isPathDefined(path:String):Boolean
		{
			return !(paths[path]==false);
		}
		
		/**
		 * Add a path to the model.
		 * 
		 * @example Using path logic with the model.
		 * <listing>	
		 * public class Main extends DocumentController
		 * {
		 *     override protected function initPaths():void
		 *     {
		 *         ml.addPath("root","./");
		 *         ml.addPath("assets",ml.getPath("root")+"assets/");
		 *         ml.addPath("bitmaps",ml.getPath("root","assets")+"bitmaps/");
		 *         testPaths();
		 *     }
		 *     
		 *     //illustrates how the "getPath" function works.
		 *     private function testPaths():void
		 *     {
		 *         trace(ml.getPath("root")); // -> ./
		 *         trace(ml.getPath("assets")); // -> ./assets/
		 *         trace(ml.getPath("bitmaps")); // -> ./assets/bitmaps/
		 *     }
		 * }
		 * </listing>
		 * 
		 * @param pathId The path identifier.
		 * @param path The path.
		 */	
		public function addPath(pathId:String, path:String):void
		{
			paths[pathId]=path;
			return;
		}
		
		/**
		 * Get a path concatenated from the given pathIds.
		 * 
		 * @param ...pathIds An array of pathIds whose values will be concatenated together.
		 */
		public function getPath(...pathIds:Array):String
		{
			var fp:String="";
			var i:int=0;
			var l:int=pathIds.length;
			for(i;i<l;i++)
			{
				if(!paths[pathIds[i]]) throw new Error("Path {"+pathIds[i]+"} not defined.");
				fp += paths[pathIds[i]];
			}
			return fp;
		}
		
		/**
		 * Loads all the security policy files
		 * specified in the model.
		 */
		public function loadPolicyFiles():void
		{
			if(!security) return;
			var pf:XMLList=security.policyfiles.crossdomain;
			var s:XML;
			var sp:String;
			for each(s in pf)
			{
				if(s.hasOwnProperty("@url")) sp = s.@url;
				if(s.hasOwnProperty("src")) sp = s.@src;
				Security.loadPolicyFile(sp);
			}
		}
		
		/**
		 * Allows a domain for cross scripting this swf.
		 * 
		 * <p>This is specifically for cases where a swf needs to
		 * allow an outer swf access (Security.allowDomain()).
		 */
		public function allowCrossScriptingDomains():void
		{
			if(!security) return;
			var pf:XMLList=security.xscripting.children();
			var s:*;
			var sp:String;
			for each(s in pf)
			{
				if(s.hasOwnProperty("@name"))sp=s.@name;
				if(s.hasOwnProperty("@value"))sp=s.@value;
				if(s.hasOwnProperty("@domain"))sp=s.@domain;
				Security.allowDomain(sp);
				Security.allowInsecureDomain(sp);
			}
		}
		
		/**
		 * Get's a color defined in the "colors" stylesheet. There
		 * must be a stylesheet defined with the id of "colors".
		 * 
		 * @example A colors stylesheet definition:
		 * <listing>	
		 * &lt;stylsheets&gt;
		 *     &lt;stylesheet id="colors"&gt;
		 *     &lt;![CDATA[
		 *         .pink{color:#ff0066}
		 *     ]]&gt;
		 *     &lt;/stylesheet&gt;
		 * &lt;/stylesheets&gt;
		 * </listing>
		 * 
		 * @example Using this method:
		 * <listing>	
		 * var color:int=Model.gi().getColorAsInt(".pink");
		 * </listing>
		 * 
		 * @param selector The selector from "colors" the stylesheet.
		 */
		public function getColorAsInt(selector:String):int
		{
			if(!selector)return -1;
			var s:StyleSheet=getStyleSheetById("colors");
			if(!s)throw new Error("A stylesheet in the model name 'colors' must be defined.");
			var c:String=s.getStyle(selector).color;
			if(!c)trace("WARNING: The selector {"+selector+"} in the colors stylesheet wasn't found.");
			return StringUtils.styleSheetNumberToInt(c);
		}
		
		/**
		 * Get a color in hex with 0x, (0xff0066).
		 * 
		 * @param selector The select from the "colors" stylesheet.
		 * 
		 * @see #getColorAsInt The getColorAsInt function for more documentation.
		 */
		public function getColorAs0xHexString(selector:String):String
		{
			if(!selector)return "0x";
			var s:StyleSheet=getStyleSheetById("colors");
			if(!s)throw new Error("A stylesheet in the model name 'colors' must be defined.");
			var c:String=s.getStyle(selector).color;
			if(!c)trace("WARNING: The selector {"+selector+"} in the colors stylesheet wasn't found.");
			return StringUtils.styleSheetNumberTo0xHexString(c);
		}
		
		/**
		 * Get a color in hex with #, (#ff0066).
		 * 
		 * @param selector The select from the "colors" stylesheet.
		 * 
		 * @see #getColorAsInt The getColorAsInt function for more documentation.
		 */
		public function getColorAsPoundHexString(selector:String):String
		{
			var s:StyleSheet=getStyleSheetById("colors");
			if(!s)throw new Error("A stylesheet in the model name 'colors' must be defined.");
			var c:String=s.getStyle(selector).color;
			if(!c)
			{
				trace("WARNING: The selector {"+selector+"} in the colors stylesheet wasn't found.");
				return "#FFFFFF";
			}
			return c;
		}
		
		/**
		 * Get a StyleSheet object by the node id.
		 * 
		 * <p>There is one extra "feature" that this can do -
		 * setting the proper font names for you, based off of
		 * the "font" or "fontFamily".</p>
		 * 
		 * <p>If you specify a "font" style, this will look for
		 * a font defined in the model, grab it out of the library,
		 * and use font.fontName as the "fontFamily" style.</p>
		 * 
		 * <p>If you specify the "fontFamily" style, this will
		 * use the asset manager to try and grab your font out,
		 * and replace what you have defined for the "fontFamily"
		 * style with the proper name.</p>
		 * 
		 * @param id The id of the stylesheet node to grab from the model.
		 */
		public function getStyleSheetById(id:String):StyleSheet
		{
			checkForXML();
			var cacheId:String="css_"+id;
			if(modelcache.isCached(cacheId))return StyleSheet(modelcache.getCachedObject(cacheId));
			if(customStyles[id])return StyleSheet(customStyles[id]);
			var n:XMLList=stylesheets.stylesheet.(@id==id);
			if(!n)return null;
			var s:StyleSheet;
			if(n.@mergeStyleSheets!=undefined)s=mergeStyleSheetsAs(n.@id,n.@mergeStyleSheets.toString().split(","));
			else
			{
				s=new StyleSheet();
				s.parseCSS(n.toString());
			}
			var names:Array=s.styleNames;
			var i:int=0;
			var l:int=names.length;
			var so:Object;
			var fc:Class;
			var f:Font;
			var finalFontFamily:String;
			for(i;i<l;i++)
			{
				so=s.getStyle(names[i]);
				for(var key:String in so)
				{
					if(key=="font")
					{
						var fontNode:XMLList=fonts..font.(@libraryName==so[key]);
						if(fontNode.hasOwnProperty("@inSWF")) fc=AssetManager.getClassFromSWFLibrary(fontNode.@inSWF,so[key]);
						else fc=AssetManager.getClass(so[key]);
						Font.registerFont(fc);
						f=new fc();
						delete so[key];
						finalFontFamily=f.fontName;
					}
					else if(key=="fontFamily")
					{
						fc=AssetManager.getClass(so[key]);
						Font.registerFont(fc);
						f=new fc();
						finalFontFamily=f.fontName;
					}
				}
				if(finalFontFamily)so['fontFamily']=finalFontFamily;
				s.setStyle(names[i],so);
			}
			modelcache.cacheObject(cacheId,s);
			return s;
		}
		
		/**
		 * Merge any number of style sheets declared in the model as a new
		 * stylesheet with a unique id. The new stylesheet is returned to you,
		 * and can be accessed again through the <em>getStyleSheetById</em>
		 * method. You can also declare merged style sheets in the model
		 * through xml.
		 * 
		 * @param newStyleId The id to name the new merged stylesheet.
		 * @param styleId An array of style ids that are defined in the model.
		 */
		public function mergeStyleSheetsAs(newStyleId:String, ...styleIds:Array):StyleSheet
		{
			checkForXML();
			if(!newStyleId)throw new ArgumentError("Parameter {newStyleId} cannot be null.");
			if(!styleIds)throw new ArgumentError("Parameter {styleIds} cannot be null or empty");
			if(styleIds[0] is Array)styleIds=styleIds[0];
			var sheets:Array=[];
			var i:int=0;
			var l:int=styleIds.length;
			for(i;i<l;i++)sheets.push(getStyleSheetById(styleIds[i]));
			var newstyle:StyleSheet=StyleSheetUtils.mergeStyleSheets(sheets);
			customStyles[newStyleId]=newstyle;
			var cacheKey:String="css_"+newStyleId;
			modelcache.cacheObject(cacheKey,newstyle,-1,true);
			return newstyle;
		}
		
		/**
		 * Get a TextFormat object by the node id.
		 * 
		 * <p>Supports these attributes:</p>
		 * <ul>
		 * <li>align</li>
		 * <li>blockIndent</li>
		 * <li>bold</li>
		 * <li>bullet</li>
		 * <li>color</li>
		 * <li>font</li>
		 * <li>indent</li>
		 * <li>italic</li>
		 * <li>kerning</li>
		 * <li>leading</li>
		 * <li>leftMargin</li>
		 * <li>letterSpacing</li>
		 * <li>rightMargin</li>
		 * <li>size</li>
		 * <li>underline</li>
		 * </ul>
		 */
		public function getTextFormatById(id:String):TextFormat
		{
			checkForXML();
			var cacheId:String="tf_"+id;
			if(modelcache.isCached(cacheId)) return modelcache.getCachedObject(cacheId) as TextFormat;
			var n:XMLList=textformats.textformat.(@id==id);
			var tf:TextFormat=new TextFormat();
			if(n.attribute("align")!=undefined) tf.align=n.@align;
			if(n.attribute("blockIndent")!=undefined) tf.blockIndent=int(n.@blockIndent);
			if(n.attribute("bold")!=undefined) tf.bold=n.@bold;
			if(n.attribute("bullet")!=undefined) tf.bullet=StringUtils.toBoolean(n.@bullet);
			if(n.attribute("color")!=undefined) tf.color=Number(n.@color);
			if(n.attribute("font")!=undefined)
			{
				var fontNode:*;
				if(fonts)fontNode=fonts..font.(@libraryName==n.@font);
				if(fontNode==undefined) tf.font=AssetManager.getFont(n.@font).fontName;
				else
				{
					var klass:Class;
					var font:Font;
					if(fontNode.attribute("inSWF")!=undefined)
					{
						klass=AssetManager.getClassFromSWFLibrary(fontNode.@inSWF,fontNode.@libraryName);
						font=new klass();
					}
					else font=AssetManager.getFont(fontNode.@libraryName);
					tf.font=font.fontName;
				}
			}
			if(n.attribute("indent")!=undefined) tf.indent=Number(n.@indent);
			if(n.attribute("italic")!=undefined) tf.italic=StringUtils.toBoolean(n.@italic);
			if(n.attribute("kerning")!=undefined) tf.kerning=StringUtils.toBoolean(n.@kerning);
			if(n.attribute("leading")!=undefined) tf.leading=Number(n.@leading);
			if(n.attribute("leftMargin")!=undefined) tf.leftMargin=Number(n.@leftMargin);
			if(n.attribute("letterSpacing")!=undefined) tf.letterSpacing=Number(n.@letterSpacing);
			if(n.attribute("rightMargin")!=undefined) tf.rightMargin=Number(n.@rightMargin);
			if(n.attribute("size")!=undefined) tf.size=Number(n.@size);
			if(n.attribute("underline")!=undefined) tf.underline=StringUtils.toBoolean(n.@underline);
			modelcache.cacheObject(cacheId,tf);
			return tf;
		}
		
		/**
		 * Register declared fonts from the model. If no group id is specified,
		 * all fonts declared are registered.
		 * 
		 * @param groupId Optionally register fonts that were declared as part of a specific group.
		 */
		public function registerFonts(groupId:String=null):void
		{
			var child:XML;
			if(groupId)
			{
				var group:XML=fonts.group.(@id==groupId);
				for each(child in group.font)
				{
					if(child.attribute("inSWF")!=undefined) Font.registerFont(AssetManager.getClassFromSWFLibrary(child.@inSWF,child.@libraryName));
					else Font.registerFont(AssetManager.getClass(child.@libraryName));
				}
			}
			else
			{
				for each(child in fonts.font)
				{
					if(child.attribute("inSWF")!=undefined) Font.registerFont(AssetManager.getClassFromSWFLibrary(child.@inSWF,child.@libraryName));
					else Font.registerFont(AssetManager.getClass(child.@libraryName));
				}
			}
		}

		/**
		 * Clears the internal cache.
		 * 
		 * <p>The internal cache caches textformats and stylesheets.</p>
		 */
		public function clearCache():void
		{
			modelcache.purgeAll();
		}
		
		/**
		 * Dispose of this model.
		 */
		public function dispose():void
		{
			Model.unset(id);
			clearCache();
			modelcache.dispose();
			modelcache=null;
			xml=null;
		}
	}
}