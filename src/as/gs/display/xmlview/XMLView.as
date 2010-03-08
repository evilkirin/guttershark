package gs.display.xmlview
{
	import gs.display.GSClip;

	/**
	 * The XMLView class is an adapter that implements
	 * the IXMLView interface.
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	dynamic public class XMLView extends GSClip implements IXMLView
	{
		
		/**
		 * A reference to a <code>data</code> node inside of
		 * a view node (<code>view.data</code>)
		 */
		protected var data:XML;
		
		/**
		 * A reference to an <code>attributes</code> node inside of
		 * a view node (<code>view.attributes</code>)
		 */
		protected var attributes:XML;
		
		/**
		 * Initialize this view from xml.
		 * 
		 * @param xml An xml or xml list reference.
		 */
		public function initFromXML(xml:*):void
		{
			if(xml.hasOwnProperty("data"))data=new XML(xml.data);
			if(xml.hasOwnProperty("attributes"))attributes=new XML(xml.attributes);
		}
		
		/**
		 * On creation complete, called when all of a views
		 * children have been created and attached successfully.
		 */
		public function creationComplete():void{}
		
		/**
		 * Tells an XMLViewManager whether or not this view can be hidden.
		 */
		public function canHide():Boolean
		{
			return true;
		}
		
		/**
		 * When a view was not hidden, because the canHide() returned false.
		 */
		public function didNotHide():void{}
		
		/**
		 * Whether or not the XMLViewManager's changeView method
		 * should wait for an event before switching views.
		 */
		public function waitForEvent():String
		{
			return null;
		}
	}
}