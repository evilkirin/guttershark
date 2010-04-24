package gs.tracking 
{
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	/**
	 * The Atlas class fires atlas tracking events.
	 * 
	 * <p>You don't use this manually, create an instance
	 * and set it as the tracking.atlas property.</p>
	 * 
	 * @example Supported xml structure for tracking xml.
	 * <listing>	
	 * &lt;track id="atlas1"&gt;
	 *     &lt;atlas&gt;http://www.google.com/g.jpg&lt;/atlas&gt;
	 * &lt;/track&gt;	
	 * </listing>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * @see gs.tracking.Tracking
	 */
	public class Atlas
	{
		
		/**
		 * Whether or not to trace the calls that get sent.
		 */
		public var traces:Boolean;
		
		/**
		 * The loader used to load atlas gif images.
		 */
		private var loader:Loader;
		
		/**
		 * Constructor for Atlas instances.
		 */
		public function Atlas()
		{
			loader=new Loader();
		}
		
		/**
		 * Sends a tracking call.
		 * 
		 * @param node The xml node for omniture.
		 * @param options Tracking options.
		 */
		public function track(node:XML,options:Object):void
		{
			if(!Tracking.assertions(options))return;
			try {
				if(traces)trace("atlas()",node.toString());
				loader.load(new URLRequest(node.toString()));
			}catch(e:Error){}
		}
	}
}