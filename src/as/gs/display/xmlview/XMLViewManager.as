package gs.display.xmlview
{
	import gs.managers.AssetManager;

	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * The XMLViewManager manages creating views from
	 * xml.
	 * 
	 * <p>The XViewManager can recursivly create view
	 * structures that are defined by XML. Each view
	 * it creates should either be a subclass of XMLView
	 * or implement the IXMLView interface class which has hooks
	 * and initialization methods that accept the neccessary XML data.</p>
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class XMLViewManager
	{
		
		/**
		 * xview xml reference.
		 */
		private var xml:XMLList;
		
		/**
		 * xdata xml reference
		 */
		private var xdata:XMLList;
		
		/**
		 * Asset manager singleton instance.
		 */
		private var am:AssetManager;
		
		/**
		 * A tmp holder variable for view switching.
		 */
		private var fromView:XMLView;
		
		/**
		 * A temp holder variable for view switching.
		 */
		private var toView:XMLView;
		
		/**
		 * An event string waited for from a BaseXView.
		 */
		private var waitedOnEvent:String;
		
		/**
		 * Lookup for xml view managers.
		 */
		private static var _xvms:Dictionary;
		
		/**
		 * Constructor for XViewManager instances.
		 * 
		 * @param xviews An xmllist of views, structured for xview creation.
		 * @param xdata An option xmllist of data nodes, that the xviews node uses
		 * for a "data" source.
		 */
		public function XMLViewManager(xviews:XMLList,xdata:XMLList=null):void
		{
			xml=xviews;
			this.xdata=xdata;
		}
		
		/**
		 * Set an xmlview manager instance.
		 * 
		 * @param id The xml view manager id.
		 * @param xvm The xml view manager.
		 */
		public static function set(id:String,xvm:XMLViewManager):void
		{
			if(!_xvms)_xvms=new Dictionary();
			_xvms[id]=xvm;
		}
		
		/**
		 * Get an xml view manager.
		 * 
		 * @param id The xml view manager id.
		 */
		public static function get(id:String):XMLViewManager
		{
			if(!_xvms)return null;
			return _xvms[id];
		}
		
		/**
		 * Unset (delete) an xml view manager.
		 * 
		 * @param id The xml view manager id.
		 */
		public static function unset(id:String):void
		{
			if(!_xvms)return;
			delete _xvms[id];
		}
		
		/**
		 * Creates and returns a view with the id
		 * specified.
		 * 
		 * @param id The view id.
		 */
		public function get(id:String):IXMLView
		{
			return buildView(xml..view.(@id==id));
		}
		
		/**
		 * @private
		 * 
		 * Recursive view builder - it builds
		 * from the bottom most leaf, up to the trunk/base
		 * of the node given.
		 * 
		 * @param view The view xml node.
		 */
		protected function buildView(view:*):IXMLView
		{
			var vln:String=(view.@libraryName==undefined)?null:view.@libraryName;
			var inswf:String=(view.@inSWF==undefined)?null:view.@inSWF;
			var frid:String=((view.@fromID==undefined)?((view.fromID==undefined)?null:view.@fromId):view.@fromID);
			var xv:*;
			var xvb:IXMLView;
			var subs:Array=[];
			var names:Dictionary=new Dictionary(true);
			var ch:IXMLView;
			var subview:XML;
			var subviews:XMLList=view.view;
			for each(subview in subviews)
			{
				xvb=buildView(subview);
				subs.unshift(xvb);
				if(subview.@name!=undefined)names[xvb]=subview.@name;
			}
			if(vln)
			{
				var klass:Class;
				if(inswf) AssetManager.getClassFromSWFLibrary(inswf,vln);
				else klass=AssetManager.getClass(vln);
				xv=new klass();
				if(!(xv is IXMLView)) throw new Error("The class instantiated from XML does not implement IXView.");
			}
			else if(frid)
			{
				xv=buildView(xml..view.(@id==frid));
				if(view.@name!=undefined) xv.name=view.@name;
				return xv;
			}
			else xv=new XMLView();
			if(view.@name!=undefined)xv.name=view.@name;
			xv.initFromXML(view);
			var l:int=subs.length;
			if(l==0)
			{
				xv.creationComplete();
				return xv;
			}
			if(l==1)
			{
				ch=subs[0];
				xv.addChild(ch);
				xv[names[ch]]=ch;
				delete names[ch];
				xv.creationComplete();
			}
			else
			{
				var i:int=0;
				for(;i<l;i++)
				{
					ch=subs[int(i)];
					xv.addChild(ch);
					xv[names[ch]]=ch;
					delete names[ch];
					xv.addChild(ch);
				}
				xv.creationComplete();
			}
			return xv;
		}
		
		/**
		 * Change from one view to the next.
		 * 
		 * <p>Both views should already be built, this just calls
		 * a sequence of methods on each view.</p>
		 */
		public function switchViews(from:XMLView,to:XMLView):void
		{
			if(!from.canHide())
			{
				from.didNotHide();
				return;
			}
			var event:String=from.waitForEvent();
			if(event)
			{
				from.addEventListener(event,onEvent);
				toView=to;
				fromView=from;
				return;
			}
			from.hide();
			to.show();
		}
		
		/**
		 * On wait event.
		 */
		private function onEvent(e:Event):void
		{
			fromView.hide();
			fromView.removeEventListener(waitedOnEvent,onEvent);
			toView.show();
		}
		
		/**
		 * Dispose of this XMLViewManager.
		 */
		public function dispose():void
		{
			xml=null;
			xdata=null;
			am=null;
			fromView=null;
			toView=null;
			waitedOnEvent=null;
		}
	}
}