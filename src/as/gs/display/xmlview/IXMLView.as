package gs.display.xmlview 
{
	
	/**
	 * Interface for views that are XMLViews and work
	 * with an XMLViewManager.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public interface IXMLView
	{
		
		/**
		 * Initialize this view from xml.
		 * 
		 * @param xml An xml or xml list reference.
		 */
		function initFromXML(xml:*):void;
		
		/**
		 * when all of a views children have been created and
		 * attached successfully.
		 */
		function creationComplete():void;
		
		/**
		 * Tells an XMLViewManager whether or not this view can be hidden.
		 */
		function canHide():Boolean;
		
		/**
		 * When a view was not hidden, because the canHide() returned false.
		 */
		function didNotHide():void;
		
		/**
		 * Whether or not the XMLViewManager's changeView method
		 * should wait for an event before switching views.
		 */
		function waitForEvent():String;
	}
}
