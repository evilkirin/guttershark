package gs.tracking 
{
	import flash.external.ExternalInterface;

	/**
	 * The Webtrends class fires webtrends tracking events.
	 * 
	 * <p>You don't use this manually, create an instance
	 * and set it as the tracking.webtrends property.</p>
	 * 
	 * @example Supported xml structure for tracking xml.
	 * <listing>	
	 * &lt;track id="trackTest1"&gt;
	 *     &lt;webtrends&gt;/ws2008/videos/product/command/play,ddddd,ad92&lt;webtrends&gt;
	 * &lt;/track&gt;
	 * </listing>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * @see gs.tracking.Tracking
	 */
	public class Webtrends
	{
		
		/**
		 * Whether or not to trace out tracking calls.
		 */
		public var traces:Boolean;
		
		/**
		 * Sends a tracking call.
		 * 
		 * @param node The xml node for omniture.
		 * @param options Tracking options.
		 */
		public function track(node:XML,options:Object):void
		{
			if(!Tracking.assertions(options))return;
			var dd:* =Tracking.getDynamicData(options);
			var parts:Array=node.toString().split(",");
			var dcsuri:String=parts[0];
			var ti:String=parts[1];
			var cg_n:String=parts[2];
			if(!cg_n)cg_n="undefined";
			if(dd && (dd is Array))
			{
				if(dd[0])dcsuri+=String(dd[0]);
				if(dd[1])ti+=String(dd[1]);
				if(dd[2])cg_n+=String(dd[2]);
			}
			if(traces) trace("webtrends() dcsMultiTrack","DCS.dcsuri",dcsuri,"WT.ti",ti,"WT_cg_n",cg_n);
			if(!ExternalInterface.available)
			{
				trace("WARNING: ExternalInterface is not available for webtrends.");
				return;
			}
			ExternalInterface.call("dcsMultiTrack","DCS.dcsuri",dcsuri,"WT.ti",ti,"WT_cg_n",cg_n);
		}
	}
}