package gs.tracking 
{
	import gs.util.ObjectUtils;
	import gs.util.XMLUtils;
	
	/**
	 * The Omniture fires omniture tracking events.
	 * Don't use this manually, create an
	 * instance and pass it to a Tracking instance.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
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
			actionsource.clearVars();
		}
		
		/**
		 * Sends a tracking call.
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
					value=x.toString();
					traceobj[prop]=value;
					if(dyd[prop])value+=dyd[prop];
					actionsource[prop]=value;
				}
				if(!actionsource.pageName) trace("WARNING: The pageName propery wasn't set on the actionsource. Not firing track().");
				else
				{
					if(traces)
					{
						trace("--track()--");
						ObjectUtils.dump(traceobj);
						trace("-----------");
					}
					actionsource.track();
				}
			}
			clearVars();
			if(XMLUtils.hasNode(node,"trackLink"))
			{
				var url:String=XMLUtils.walkForValue(node,"trackLink.url");
				var type:String=XMLUtils.walkForValue(node,"trackLink.type");
				var name:String=XMLUtils.walkForValue(node,"trackLink.name");
				if(!url||url=="")url=null;
				if(!type)type="o";
				if(traces) trace("--trackLink(" + ((url)?url:name) + "," + type + "," + name + ")--");
				actionsource.trackLink(url,type,name);
			}
		}
	}
}