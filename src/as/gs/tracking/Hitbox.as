package gs.tracking 
{
	import flash.external.ExternalInterface;

	/**
	 * The Hitbox class fires hitbox tracking events.
	 * 
	 * <p>You don't use this manually, create an instance
	 * and set it as the tracking.hitbox property.</p>
	 * 
	 * @example Supported xml structure for tracking xml.
	 * <listing>	
	 * &lt;tracking&gt;
	 *     &lt;hitbox&gt;
	 *         &lt;lpos&gt;MyLPOS&lt;/lpos&gt;
	 *         &lt;lid&gt;MyLID&lt;/lid&gt;
	 *     &lt;/hitbox&gt;
	 * &lt;/tracking&gt;
	 * </listing>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * @see gs.tracking.Tracking
	 */
	public class Hitbox
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
			var lid:String;
			var lpos:String;
			if(node.hasOwnProperty("lid"))lid=node.lid.toString();
			if(node.hasOwnProperty("lpos"))lpos=node.lpos.toString();
			if(!lid||!lpos)
			{
				trace("WARNING: Hitbox could not fire, missing {lid} or {lpos}");
				return;
			}
			if(!ExternalInterface.available)
			{
				trace("WARNING: ExternalInterface is not available for hitbox.");
				return;
			}
			if(dd && (dd is Array))
			{
				var i:int=0;
				var l:int=dd.length;
				for(;i<l;i++)lpos+=String(dd[int(i)]);
			}
			if(traces)trace("HITBOX: dynamic_fsCommand('"+lpos+"|"+lid+"')");
			ExternalInterface.call("dynamic_fsCommand('"+lpos+"|"+lid+"')");
		}
	}
}