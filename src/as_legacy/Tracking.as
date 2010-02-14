package net.guttershark.util
{
	import flash.events.StatusEvent;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;		

	/**
	 * [Deprecated] See the net.guttershark.managers.TrackingManager.
	 * 
	 * <p>The Tracking class sends tracking calls through 
	 * ExternalInterface to the guttershark, javascript
	 * tracking framework.</p>
	 * 
	 * <p>You can shut off the default behavior, of using
	 * the guttershark, javascript tracking framework, to
	 * have the tracking calls made from flash.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class Tracking
	{
		
		/**
		 * @private (in development)
		 * A tracking xml file used for sending simulated tracking
		 * messages to the tracking monitor. This is specifically
		 * useful for when you're in the Flash IDE and need to
		 * verify tracking.
		 */
		public static var simulationTrackingXML:XML;
		
		/**
		 * Whether or not to use the guttershark, javascript
		 * tracking framework.
		 */
		public static var useTrackingFramework:Boolean=true;
		
		/**
		 * The tracking xml.
		 */
		public static var trackingXML:XML;
		
		/**
		 * Local connection for the tracking monitor.
		 */
		private static var lc:LocalConnection;

		/**
		 * Make a tracking call.
		 * 
		 * @param xmlid The id in tracking.xml to make tracking calls for.
		 * @param appendData Any dynamic data to be sent to the tracking framework.
		 */
		public static function track(xmlid:String,appendData:Array=null):void
		{
			if(!xmlid) throw new ArgumentError("Parameter xmlid cannot be null.");
			if(simulationTrackingXML)
			{
				simulateCall(xmlid,appendData);
				return;
			}
			if(!useTrackingFramework)
			{
				webtrends(xmlid,appendData);
			}
			else
			{
				if(PlayerUtils.gi().isStandAlonePlayer()||PlayerUtils.gi().isIDEPlayer()) return;
				ExternalInterface.call("flashTrack",xmlid,appendData);
			}
		}
		
		/**
		 * Makes webtrends calls.
		 */
		private static function webtrends(id:String,appendArr:Array):void
		{
			if(!id) return;
			if(appendArr)trace("webtrends: ",id,appendArr);
			else trace("webtrends: ",id);
			var tagStr:String=trackingXML.track.(@id==id).webtrends.toString();
			var parts:Array=tagStr.split(",");
			var dcsuri:String=parts[0];
			var ti:String=parts[1];
			var cg_n:String=parts[2];
			if(!cg_n)cg_n="undefined";
			if(appendArr)
			{
				if(appendArr[0]!=null)dcsuri+=appendArr[0];
				if(appendArr[1]!=null)ti+=appendArr[1];
				if(appendArr[2]!=null)cg_n+=appendArr[2];
			}
			ExternalInterface.call("dcsMultiTrack",'DCS.dcsuri',dcsuri,'WT.ti',ti,'WT_cg_n',cg_n);
		}
		
		/**
		 * Send a simulated message to the tracking monitor.
		 */
		private static function simulateCall(id:String, webAppendData:Array=null):void
		{
			if(!lc) lc=new LocalConnection();
			lc.addEventListener(StatusEvent.STATUS,ons);
			var n:XMLList=simulationTrackingXML.track.(@id == id);
			if(n.webtrends != undefined) simulateWebtrends(n.webtrends.toString());
			if(n.atlas != undefined) simulateAtlas(n.atlas.toString());
			if(n.ganalytics != undefined) simulateGoogle(n.ganalytics.toString());
		}
		
		/**
		 * On status.
		 */
		private static function ons(se:StatusEvent):void{}
		
		/**
		 * Simulate a webtrends call.
		 */
		private static function simulateWebtrends(node:String,appendArr:Array=null):void
		{
			var parts:Array=node.toString().split(",");
			var dscuri:String=parts[0];
			var ti:String=parts[1];
			var cg_n:String=parts[2];
			if(appendArr && appendArr[0]) dscuri += appendArr[0];
			if(appendArr && appendArr[1]) ti += appendArr[1];
			if(appendArr && appendArr[2]) cg_n += appendArr[2];
			var newtag:String="wt::" + dscuri + "," + ti + "," + cg_n;
			lc.send("TrackingMonitor","tracked",newtag);
		}
		
		/**
		 * Simulate an Atlas track.
		 */
		private static function simulateAtlas(str:String):void
		{
			lc.send("TrackingMonitor","tracked","al::"+str);
		}
		
		/**
		 * Simulate a google analytics track.
		 */
		private static function simulateGoogle(str:String):void
		{
			lc.send("TrackingMonitor","tracked","ga::"+str);
		}
	}
}