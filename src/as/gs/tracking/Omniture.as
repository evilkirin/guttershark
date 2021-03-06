package gs.tracking 
{
	import gs.util.ObjectUtils;
	import gs.util.XMLUtils;
	
	/**
	 * The Omniture class fires omniture tracking events.
	 * 
	 * <p>You don't use this manually, create an instance
	 * and set it as the tracking.omniture property.</p>
	 * 
	 * @example Supported xml structure for tracking xml.
	 * <listing>	
	 * &lt;track id="trackTest1"&gt;
	 *     &lt;omniture&gt;
	 *         &lt;track&gt;
	 *             &lt;!--
	 *             By listing properties only it triggers the "track"
	 *             method on actionsource to be called.
	 *             
	 *             You can define any property / value here. The tracking
	 *             class enumerates all nodes and defines them on the
	 *             actionsource component before firing.
	 *             --&gt;
	 *             &lt;pageName&gt;test&lt;/pageName&gt;
	 *             &lt;prop6&gt;test2&lt;/prop6&gt;
	 *             &lt;eVar4&gt;hello&lt;/eVar4&gt;
	 *             &lt;events&gt;event20&lt;/events&gt;
	 *         &lt;/track&gt;
	 *     &lt;/omniture&gt;
	 * &lt;/track&gt;
	 * 
	 * &lt;track id="trackTest2"&gt;
	 *     &lt;omniture&gt;
	 *         &lt;track&gt;
	 *             &lt;pageName&gt;test&lt;/pageName&gt;
	 *             &lt;prop6&gt;test2&lt;/prop6&gt;
	 *             &lt;eVar4&gt;hello&lt;/eVar4&gt;
	 *             &lt;events&gt;event20&lt;/events&gt;
	 *             &lt;!--
	 *             Adding a "trackLink" node triggers the "trackLink" method on
	 *             the actionsource instance to be called.
	 *             --&gt;
	 *             &lt;trackLink&gt;
	 *                &lt;url&gt;http://www.whitehouse.ocom/&lt;/url&gt; &lt;!-- optional, if this isn't set it uses the "name" as the url --&gt; 
	 *                &lt;type&gt;o&lt;/type&gt; &lt;!-- o for custom, d for download, e for exit --&gt;
	 *                &lt;name&gt;adfasdf&lt;/name&gt;
	 *             &lt;/trackLink&gt;
	 *         &lt;/track&gt;
	 *      &lt;/omniture&gt;
	 * &lt;/track&gt;
	 * </listing>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * @see gs.tracking.Tracking
	 */
	public class Omniture
	{
		
		/**
		 * The actionsource component.
		 */
		public var actionsource:*;
		
		/**
		 * Whether or not to trace the calls that get sent.
		 */
		public var traces:Boolean;
		
		/**
		 * Constructor for Omniture instances.
		 * 
		 * @param _actionsource The actionsource component.
		 */
		public function Omniture(_actionsource:*):void
		{
			if(!_actionsource)throw new ArgumentError("ERROR: Parameter {actionsource} cannot be null.");
			actionsource=_actionsource;
		}
		
		/**
		 * @private
		 * 
		 * Clears the actionsource variables.
		 */
		public function clearVars():void
		{
			var i:int=1;
			for(;i<50;i++)
			{
				actionsource["prop" +i]='';
				actionsource["eVar"+i]='';
			}
			i=1;
			for(;i<5;i++)actionsource["hier"+i] = '';
			actionsource.events='';
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
			var dyd:* =Tracking.getDynamicData(options);
			clearVars();
			if(XMLUtils.hasNode(node,"track"))
			{
				var n:XMLList=node.track;
				var prop:String;
				var value:String;
				var traceobj:Object={};
				for each(var x:XML in n.children())
				{
					prop=x.name();
					if(prop=="trackLink")continue;
					value=x.toString();
					traceobj[prop]=value;
					if(dyd[prop])value+=dyd[prop];
					actionsource[prop]=value;
				}
				if(!actionsource.pageName) trace("WARNING: The pageName propery wasn't set on the actionsource. Not firing track().");
				if(!XMLUtils.hasNode(n,"trackLink"))
				{
					if(traces)
					{
						trace("--track()--");
						ObjectUtils.dump(traceobj);
						trace("-----------");
					}
					actionsource.track();
				}
				if(XMLUtils.hasNode(n,"trackLink"))
				{
					var url:String=XMLUtils.walkForValue(n,"trackLink.url");
					var type:String=XMLUtils.walkForValue(n,"trackLink.type");
					var name:String=XMLUtils.walkForValue(n,"trackLink.name");
					if(!url||url=="")url=null;
					if(!type)type="o";
					if(traces) trace("--trackLink(" + ((url)?url:name) + "," + type + "," + name + ")--");
					actionsource.trackLink(url,type,name);
				}
			}
		}
	}
}