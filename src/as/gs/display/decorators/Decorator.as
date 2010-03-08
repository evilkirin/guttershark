package gs.display.decorators 
{

	import flash.utils.flash_proxy;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	
	/**
	 * The Decorator Class is a base decorator that helps
	 * implement chainable decorators.
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	dynamic public class Decorator extends Proxy
	{
		
		/**
		 * Method lookup.
		 */
		protected var methods:Dictionary;
		
		/**
		 * The decorated object.
		 */
		protected var sprite:*;
		
		/**
		 * Props lookup.
		 */
		protected var props:Dictionary;
		
		/**
		 * An optional proxy object that unknown
		 * methods or properties get sent to.
		 */
		protected var proxyThrough:*;
		
		/**
		 * @private
		 */
		flash_proxy override function getProperty(name:*):*
		{
			if(!props[name]&&proxyThrough) return proxyThrough[name];
			else if(!props[name]) return sprite[name];
		}
		
		/**
		 * @private
		 */
		flash_proxy override function setProperty(name:*, value:*):void
		{
			if(!props[name]&&proxyThrough)proxyThrough[name]=value;
			else if(!props[name])sprite[name]=value;
		}
		
		/**
		 * @private
		 */
		flash_proxy override function callProperty(methodName:*, ...args):*
		{
			if(!methods[methodName]&&proxyThrough)return proxyThrough[methodName].apply(null,args);
			else if(!methods[methodName])return sprite[methodName].apply(null,args);
		}
	}
}
