package gs.util 
{
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	/**
	 * The NavigateToURL class is a utility to alter
	 * how all url navigation is done.
	 * 
	 * <p>You can also set this class to send an ExternalInterface
	 * call to a function in javascript to open the page instead.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class NavigateToURL 
	{
		
		/**
		 * Controls how to send the request for
		 * a page navigation.
		 */
		public static var mode:String;
		
		/**
		 * The window parameter for navigateToURL calls.
		 */
		public static var window:String = "_blank";
		
		/**
		 * Whether or not to fallback to using navigateToURL 
		 * in the event that ExternalInterface isn't available.
		 */
		public static var fallbackToNavToURL:Boolean;
		
		/**
		 * If this is set, and the mode is external interface,
		 * the call will be made to this method, with the url parameter
		 * and window.
		 */
		public static var externalInterfaceOpenMethod:String;
		
		/**
		 * Mode for using navigateToURL for page navigations.
		 */
		public static const flashNavigateToURL:String = "navigateToURL";
		
		/**
		 * Mode for using external interface for page navigations.
		 */
		public static const externalInterface:String = "externalInterface";
		
		/**
		 * Navigate to a url.
		 * 
		 * @param url The url request.
		 * @param windw The window mode.
		 */
		public static function navToURL(url:URLRequest,windw:String="_blank"):void
		{
			if(!url)return;
			switch(mode)
			{
				case flashNavigateToURL:
					navigateToURL(url,windw);
					break;
				case externalInterface:
					if(!ExternalInterface.available)
					{
						if(!fallbackToNavToURL)
						{
							trace("ExternalInterface is not available. Not doing anything.");
							return;
						}
						navigateToURL(url,windw);
						return;
					}
					if(externalInterfaceOpenMethod) ExternalInterface.call(externalInterfaceOpenMethod,url.url,windw);
					else ExternalInterface.call("window.open","windowName",url.url);
					break;
				default:
					navigateToURL(url,windw);
					break;
			}
		}
	}
}