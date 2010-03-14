package gs.managers
{
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;
	
	import gs.display.flv.FLV;
	import gs.util.BitmapUtils;
	import gs.util.XMLLoader;
	
	import com.adobe.serialization.json.JSON;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.net.NetStream;
	import flash.system.ApplicationDomain;
	import flash.text.Font;
	import flash.text.StyleSheet;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	/**
	 * The AssetManager class is a helper that stores all assets
	 * loaded by any Preloader and can get assets from any
	 * swf library.
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.preloading.Preloader
	 */
	final public class AssetManager
	{	
		
		/**
		 * Store for assets.
		 */
		private static var assets:Dictionary = new Dictionary();
		
		/**
		 * The last asset that was registered with this manager.
		 */
		private static var _lastLibraryName:String;
		
		/**
		 * A lookup to objects by source utl path.
		 */
		private static var sourceLookup:Dictionary = new Dictionary(true);
		
		/**
		 * The current application domain.
		 */
		private static var cd:ApplicationDomain = ApplicationDomain.currentDomain;
		
		/**
		 * Register an asset in the library.
		 * 
		 * @param libraryName The item id.
		 * @param obj The loaded asset object.
		 */
		public static function addAsset(libraryName:String,obj:*,source:String=null):void
		{
			if(!libraryName)throw new ArgumentError("Parameter {libraryName} cannot be null");
			if(!obj)throw new ArgumentError("Parameter {obj} cannot be null");
			assets[libraryName]=obj;
			sourceLookup[libraryName]=source;
			_lastLibraryName=libraryName;
		}
		
		/**
		 * Remove an asset from the library.
		 * 
		 * @param libraryName The asset's libraryName to remove.
		 */
		public static function removeAsset(libraryName:String):void
		{
			if(!libraryName)throw new ArgumentError("Parameter {libraryName} cannot be null");
			assets[libraryName]=null;
			sourceLookup[libraryName]=null;
		}
		
		/**
		 * The last libraryName that was used to register an object.
		 * 
		 * <p>This is useful for when you don't neccessarily have a
		 * libraryName available, but you know that the librayName
		 * you need was the last asset registered in the AssetManager.</p>
		 * 
		 * @example Using the lastLibraryName property.
		 * <listing>	
		 * var am:AssetManager=AssetManager.gi();
		 * addChild(am.getBitmap(am.lastLibraryName)); //assuming you know the last asset was a bitmap
		 * </listing>
		 */
		public static function get lastLibraryName():String
		{
			return _lastLibraryName;
		}
		
		/**
		 * Check to see if an asset is available in the library.
		 * 
		 * @param libraryName The libraryName used to register the asset.
		 */
		public static function isAvailable(libraryName:String):Boolean
		{
			if(!libraryName)throw new ArgumentError("Parameter {libraryName} cannot be null");
			if(assets[libraryName]) return true;
			return false;
		}
		
		/**
		 * Get any stored asset.
		 * 
		 * @param libraryName The library name used when the asset was registered.
		 */
		public static function getAsset(libraryName:String):*
		{
			if(!libraryName)throw new ArgumentError("Parameter {libraryName} cannot be null");
			if(!assets[libraryName]) throw new Error("Item not registered in library with the id: " + libraryName);
			return assets[libraryName];
		}
		
		/**
		 * Returns a JSON object that was loaded with a preloader.
		 * 
		 * @param libraryName The library name used when the asset was registered.
		 */
		public static function getJSON(libraryName:String):Object
		{
			if(!libraryName)throw new ArgumentError("Parameter {libraryName} cannot be null");
			if(assets[libraryName]!=null)
			{
				var s:String=assets[libraryName].data.toString();
				if(s=="")return {};
				return JSON.decode(s);
			}
			throw(new Error("No JSON Object available for libraryName {" + libraryName + "}"));
		}
		
		/**
		 * Get an asset that was loaded as text.
		 * 
		 * @param libraryName The library name used when the asset was registered.
		 */
		public static function getText(libraryName:String):String
		{
			if(!libraryName)throw new ArgumentError("Parameter {libraryName} cannot be null");
			if(assets[libraryName]!=null)return assets[libraryName].data.toString();
			throw(new Error("No JSON Object available for libraryName {" + libraryName + "}"));
		}
		
		/**
		 * Get a loaded asset as a SWF.
		 * 
		 * <p>The asset is cast as a Loader class</p>
		 * 
		 * @param libraryName The library name used when the asset was registered.
		 */
		public static function getSWF(libraryName:String):Loader
		{
			if(!libraryName)throw new ArgumentError("Parameter {libraryName} cannot be null");
			if(assets[libraryName] != null) return getAsset(libraryName) as Loader;
			throw new Error("SWF {" + libraryName + "} was not found");
		}
		
		/**
		 * Get a class from a swf library.
		 * 
		 * @param swfLibraryName The library name used when the swf asset was registered.
		 * @param classNameInLibrary The export class name in the loaded swf's library.
		 */
		public static function getClassFromSWFLibrary(swfLibraryName:String, classNameInLibrary:String):Class
		{
			if(!swfLibraryName)throw new ArgumentError("Parameter {swfLibraryName} cannot be null");
			if(!classNameInLibrary)throw new ArgumentError("Parameter {classNameInLibrary} cannot be null");
			if(assets[swfLibraryName] != null)
			{
				var swf:Loader=getAsset(swfLibraryName) as Loader;
				var SymbolClass:Class=swf.contentLoaderInfo.applicationDomain.getDefinition(classNameInLibrary) as Class;
				return SymbolClass;
			}
			throw new Error("No class reference: {" + classNameInLibrary + "} in swf {" + swfLibraryName + "} was found");
		}
		
		/**
		 * Get a movie clip from a swf library.
		 * 
		 * @param swfLibraryName The library name used when the swf asset was registered.
		 * @param classNameInLibrary The export class name in the loaded swf's library.
		 */
		public static function getMovieClipFromSWFLibrary(swfLibraryName:String, classNameInLibrary:String):MovieClip
		{
			if(!swfLibraryName)throw new ArgumentError("Parameter {swfLibraryName} cannot be null");
			if(!classNameInLibrary)throw new ArgumentError("Parameter {classNameInLibrary} cannot be null");
			if(assets[swfLibraryName] != null)
			{
				var swf:Loader=getAsset(swfLibraryName) as Loader;
				var SymbolClassMC:Class=swf.contentLoaderInfo.applicationDomain.getDefinition(classNameInLibrary) as Class;
				var symbolInstance:MovieClip=new SymbolClassMC() as MovieClip;
				return symbolInstance;
			}
			throw(new Error("No movie clip: {" + classNameInLibrary + "} in swf {" + swfLibraryName + "} was found"));
		}
		
		/**
		 * Get a sprite from a swf library.
		 * 
		 * @param swfLibraryName The library name used when the swf asset was registered.
		 * @param classNameInLibrary The export class name in the loaded swf's library.
		 */
		public static function getSpriteFromSWFLibrary(swfLibraryName:String, classNameInLibrary:String):Sprite
		{
			if(!swfLibraryName)throw new ArgumentError("Parameter {swfLibraryName} cannot be null");
			if(!classNameInLibrary)throw new ArgumentError("Parameter {classNameInLibrary} cannot be null");
			if(assets[swfLibraryName] != null)
			{
				var swf:Loader=getAsset(swfLibraryName) as Loader;
				var SymbolClassMC:Class=swf.contentLoaderInfo.applicationDomain.getDefinition(classNameInLibrary) as Class;
				var symbolInstance:Sprite=new SymbolClassMC() as Sprite;
				return symbolInstance;
			}
			throw(new Error("No sprite: {" + classNameInLibrary + "} in swf {" + swfLibraryName + "} was found"));
		}
		
		/**
		 * Get a font from a swf library.
		 * 
		 * <p>The Font is also registered through Font.registerFont before it's returned.</p>
		 * 
		 * @param swfLibraryName The library name used when the swf asset was registered.
		 * @param fontLinkageId	The font linkage id.
		 */
		public static function getFontFromSWFLibrary(swfLibraryName:String, fontLinkageId:String):Font
		{
			if(!swfLibraryName)throw new ArgumentError("Parameter {swfLibraryName} cannot be null");
			if(!fontLinkageId)throw new ArgumentError("Parameter {fontLinkageId} cannot be null");
			if(assets[swfLibraryName] != null)
			{
				var swf:Loader=getAsset(swfLibraryName) as Loader;
				var FontClass:Class=swf.contentLoaderInfo.applicationDomain.getDefinition(fontLinkageId) as Class;
				Font.registerFont(FontClass);
				var fontInstance:Font=new FontClass();
				return fontInstance;
			}
			throw(new Error("No font: {" + fontLinkageId + "} in swf {" + swfLibraryName + "} was found"));
		}
		
		/**
		 * Get a sound from a swf library
		 * 
		 * @param swfLibraryName The library name used when the swf asset was registered.
		 * @param soundLinkageId The sounds' linkage id from the swf library.
		 */
		public static function getSoundFromSWFLibrary(swfLibraryName:String, soundLinkageId:String):Sound
		{
			if(!swfLibraryName)throw new ArgumentError("Parameter {swfLibraryName} cannot be null");
			if(!soundLinkageId)throw new ArgumentError("Parameter {soundLinkageId} cannot be null");
			if(assets[swfLibraryName] != null)
			{
				var swf:Loader=getAsset(swfLibraryName) as Loader;
				var SoundClass:Class=swf.contentLoaderInfo.applicationDomain.getDefinition(soundLinkageId) as Class;
				var soundInstance:Sound=new SoundClass();
				return soundInstance;
			}
			throw(new Error("No sound: {" + soundLinkageId + "} in swf {" + swfLibraryName + "} was found"));
		}
		
		/**
		 * Get a style sheet that was preloaded from a css file.
		 * 
		 * @param libraryName The library name used when the asset was registered.
		 */
		public static function getStyleSheet(libraryName:String):StyleSheet
		{
			if(!libraryName)throw new ArgumentError("Parameter {libraryName} cannot be null");
			if(assets[libraryName] != null)
			{
				var sheet:StyleSheet=StyleSheet(assets[libraryName]);
				return sheet;
			}
			throw(new Error("Stylesheet {"+libraryName+"} not found."));
		}
		
		/**
		 * Get a bitmap from a swf library.
		 * 
		 * @param swfLibraryName The library name used when the swf asset was registered.
		 * @param bitmapLinkageId The bitmaps' linkage id.
		 */
		public static function getBitmapFromSWFLibrary(swfLibraryName:String,bitmapLinkageId:String,smooth:Boolean=true):Bitmap
		{
			if(!swfLibraryName)throw new ArgumentError("Parameter {swfLibraryName} cannot be null");
			if(!bitmapLinkageId)throw new ArgumentError("Parameter {bitmapLinkageId} cannot be null");
			var bitmap:Bitmap;
			if(assets[swfLibraryName] != null)
			{
				var swf:Loader=getAsset(swfLibraryName) as Loader;
				var BitmapClass:Class=swf.contentLoaderInfo.applicationDomain.getDefinition(bitmapLinkageId) as Class;
				bitmap=BitmapUtils.copyBitmap(new BitmapClass());
				bitmap.smoothing=smooth;
				return bitmap;
			}
			throw(new Error("No bitmap: {" + bitmapLinkageId + "} in swf {" + swfLibraryName + "} was found"));
		}
		
		/**
		 * Get a Bitmap.
		 * 
		 * <p>This returns a bitmap in the current appliction domain.
		 * If preloading is loaded into the same application domain, it
		 * will get a bitmap from any swf.</p>
		 * 
		 * @param libraryName The library name used when the asset was registered.
		 */
		public static function getBitmap(libraryName:String,smooth:Boolean=true):Bitmap
		{
			if(!libraryName)throw new ArgumentError("Parameter {libraryName} cannot be null");
			var bitmap:Bitmap;
			if(assets[libraryName] != null)
			{
				bitmap=BitmapUtils.copyBitmap(Bitmap(getAsset(libraryName).content));
				bitmap.smoothing=smooth;
				return bitmap;
			}
			else if(cd.hasDefinition(libraryName))
			{
				var clss:Class=cd.getDefinition(libraryName) as Class;
				var b:BitmapData=new clss(1,1) as BitmapData;
				bitmap=new Bitmap(b,"auto",smooth);
				return bitmap;
			}
			throw new Error("Bitmap {" + libraryName + "} was not found.");
		}
		
		/**
		 * Get a sound.
		 * 
		 * <p>This returns a sound in the current appliction domain.
		 * If preloading is loaded into the same application domain, it
		 * will get a sound from any swf.</p>
		 * 
		 * @param libraryName The library name used when the asset was registered.
		 */
		public static function getSound(libraryName:String):Sound
		{
			if(!libraryName)throw new ArgumentError("Parameter {libraryName} cannot be null");
			if(cd.hasDefinition(libraryName))
			{
				var instance:Class=cd.getDefinition(libraryName) as Class;
				var s:Sound=new instance() as Sound;
				return s;
			}
			if(assets[libraryName] != null) return getAsset(libraryName) as Sound;
			throw new Error("Sound {" + libraryName + "} was not found.");
		}
		
		/**
		 * Get a loaded asset as XML.
		 * 
		 * @param libraryName The library name used when the asset was registered.
		 */
		public static function getXML(libraryName:String):XML
		{
			if(!libraryName)throw new ArgumentError("Parameter {libraryName} cannot be null");
			if(assets[libraryName] != null) return XMLLoader(getAsset(libraryName)).data as XML;
			throw new Error("XML {" + libraryName + "} was not found.");
		}
		
		/**
		 * Get a loaded asset as a NetStream.
		 * 
		 * @param libraryName The library name used when the asset was registered.
		 */
		public static function getNetStream(libraryName:String):NetStream
		{
			if(!libraryName)throw new ArgumentError("Parameter {libraryName} cannot be null");
			if(assets[libraryName] != null) return NetStream(getAsset(libraryName));
			throw new Error("NetStream {" + libraryName + "} was not found.");
		}
		
		/**
		 * Check whether or not a net stream is 100% loaded.
		 * 
		 * @param libraryName The library name used when the asset was registered.
		 */
		public static function isNetStreamLoaded(libraryName:String):Boolean
		{
			if(!libraryName)throw new ArgumentError("Parameter {libraryName} cannot be null");
			if(assets[libraryName]!=null) var ns:NetStream=NetStream(getAsset(libraryName));
			else throw new Error("NetStream {"+libraryName+"} not available.");
			return (ns.bytesLoaded>=ns.bytesTotal);
		}
		
		/**
		 * Get an flv instance.
		 * 
		 * @param libraryName The library name used when the asset was registered.
		 */
		public static function getFLV(libraryName:String):FLV
		{
			if(!libraryName)throw new ArgumentError("Parameter {libraryName} cannot be null");
			var f:FLV=new FLV();
			f.load(sourceLookup[libraryName],320,240,4,false,false);
			return f;
		}
		
		/**
		 * Get a movie clip.
		 * 
		 * <p>This returns a movie clip in the current appliction domain.
		 * If preloading is loaded into the same application domain, it
		 * will get a movie clip from any swf.</p>
		 * 
		 * @param exportName The export class name from the library.
		 */
		public static function getMovieClip(exportName:String):MovieClip
		{
			if(!exportName)throw new ArgumentError("Parameter {exportName} cannot be null");
			if(cd.hasDefinition(exportName))
			{
				var instance:Class=cd.getDefinition(exportName) as Class;
				var s:MovieClip=new instance() as MovieClip;
				return s;
			}
			throw new Error("MovieClip {" + exportName + "} was not found.");
		}

		/**
		 * Get a font.
		 * 
		 * <p>This returns a font in the current appliction domain.
		 * If preloading is loaded into the same application domain, it
		 * will get a font from any swf.</p>
		 * 
		 * @param exportName The export class name from the library.
		 */
		public static function getFont(exportName:String):Font
		{
			if(!exportName)throw new ArgumentError("Parameter {exportName} cannot be null");
			if(cd.hasDefinition(exportName))
			{
				var instance:Class=cd.getDefinition(exportName) as Class;
				var f:Font=new instance() as Font;
				Font.registerFont(instance);
				return f;
			}
			throw new Error("Font {" + exportName + "} was not found.");
		}
		
		/**
		 * Get a sprite.
		 * 
		 * <p>This returns a sprite in the current appliction domain.
		 * If preloading is loaded into the same application domain, it
		 * will get a sprite from any swf.</p>
		 * 
		 * @param exportName The export class name from the library.
		 */
		public static function getSprite(exportName:String):Sprite
		{
			if(!exportName)throw new ArgumentError("Parameter {exportName} cannot be null");
			if(cd.hasDefinition(exportName))
			{
				var instance:Class=cd.getDefinition(exportName) as Class;
				var s:Sprite=new instance() as Sprite;
				return s;
			}
			throw new Error("Sprite {" + exportName + "} was not found.");
		}
		
		/**
		 * Get a Class.
		 * 
		 * <p>This returns a class in the current appliction domain.
		 * If preloading is loaded into the same application domain, it
		 * will get a class from any swf.</p>
		 * 
		 * @param libraryName The item name in the library.
		 */
		public static function getClass(exportName:String):Class
		{
			if(!exportName)throw new ArgumentError("Parameter {exportName} cannot be null");
			if(cd.hasDefinition(exportName)) return cd.getDefinition(exportName) as Class;
			throw new Error("Class {" + exportName + "} was not found.");
		}
		
		/**
		 * Get an FZip.
		 * 
		 * @param libraryName The library name used when the asset was registered.
		 */
		public static function getFZip(libraryName:String):FZip
		{
			return FZip(assets[libraryName]);
		}
		
		/**
		 * Send a bitmap from an fzip file to a receiver function.
		 * 
		 * <p>This method needs a reciever callback because the bitmap
		 * is loaded by calling "loader.loadBytes" which takes a few milliseconds.
		 * The bitmap will not be ready for you if this function returned
		 * immediately.</p>
		 * 
		 * @example An example reciever function
		 * <listing>	
		 * function receiveBitmap(filename:String,bitmap:Bitmap):void{}
		 * </listing>
		 * 
		 * @param fzip The FZip object.
		 * @param filename The filename inside the fzip.
		 * @param receiver The receiver function: <code>function(filename:String,bitmap:Bitmap).</code>
		 * @param timeout (Optional) The time to wait before triggering the callback in milliseconds.
		 */
		public static function getBitmapFromFZip(fzip:FZip,filename:String,receiver:Function,timeout:Number=100):void
		{
			var loader:Loader=new Loader();
			var fzipfile:FZipFile=fzip.getFileByName(filename);
			loader.loadBytes(fzipfile.content);
			setTimeout(_sendBitmap,timeout,filename,loader,receiver);
		}
		
		/**
		 * Sends bitmaps to a receiver function.
		 */
		private static function _sendBitmap(filename:String,loader:Loader,receiver:Function):void
		{
			var bitmap:Bitmap=BitmapUtils.copyBitmap(Bitmap(loader.content));
			bitmap.smoothing=true;
			receiver.apply(null,[filename,bitmap]);
		}
		
		/**
		 * Purge all assets from the library. The AssetManager is still
		 * usable after a dispose - just the assets are disposed of.
		 */
		public static function dispose():void
		{
			assets=new Dictionary(false);
			sourceLookup=new Dictionary(true);
			_lastLibraryName=null;
		}
	}
}