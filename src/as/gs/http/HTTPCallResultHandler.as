package gs.http
{
	import gs.util.XMLUtils;
	import flash.utils.ByteArray;
	
	import gs.util.StringUtils;
	
	import com.adobe.serialization.json.JSON;
	
	import flash.net.URLVariables;
	
	/**
	 * The HTTPCallResultHandler class processes an HTTPCall response.
	 * 
	 * <p>It's used to process the response before a result or fault
	 * is passed back to your onResult or onFault hander function.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.http.HTTPCall
	 */
	public class HTTPCallResultHandler
	{
		
		/**
		 * Process an http call instance.
		 * 
		 * @return Either an HTTPCallResult or HTTPCallFault.
		 */
		public function process(call:HTTPCall):*
		{
			var res:Boolean=true;
			var data:* =call.loader.data;
			var callfault:HTTPCallFault=new HTTPCallFault();
			var callresult:HTTPCallResult=new HTTPCallResult();
			if(!data)return callresult;
			switch(call.responseFormat)
			{
				case "json":
					var json:Object=JSON.decode(data.toString());
					if(json.result!=undefined)res=StringUtils.toBoolean(json.result);
					if(json.success!=undefined)res=StringUtils.toBoolean(json.success);
					if(json.fault!=undefined)
					{
						res=false;
						callfault.fault=json.fault; 
					}
					if(json.faultString!=undefined)
					{
						res=false;
						callfault.fault=json.faultString;
					}
					if(json.faultMessage!=undefined)
					{
						res=false;
						callfault.fault=json.faultMessage;
					}
					if(!res)
					{
						callfault.rawResult=call.loader.data;
						callfault.json=json;
						return callfault;
					}
					else
					{
						callresult.rawResult=call.loader.data;
						callresult.json=json;
						return callresult;
					}
					break;
				case "variables":
					var vars:URLVariables=new URLVariables();
					vars.decode(String(data));
					if(vars.result!=undefined)res=StringUtils.toBoolean(vars.result);
					if(vars.success!=undefined)res=StringUtils.toBoolean(vars.success);
					if(vars.fault!=undefined)
					{
						res=false;
						callfault.fault=vars.fault; 
					}
					if(vars.faultString!=undefined)
					{
						res=false;
						callfault.fault=vars.faultString;
					}
					if(vars.faultMessage!=undefined)
					{
						res=false;
						callfault.fault=vars.faultMessage;
					}
					if(!res)
					{
						callfault.rawResult=call.loader.data;
						callfault.vars=vars;
						return callfault;
					}
					else
					{
						callresult.rawResult=call.loader.data;
						callresult.vars=vars;
						return callresult;
					}
					break;
				case "xml":
					var xml:XML=new XML(String(data));
					if(XMLUtils.hasNode(xml,"result"))res=res=StringUtils.toBoolean(xml.result.toString());
					if(XMLUtils.hasNode(xml,"success"))res=StringUtils.toBoolean(xml.result.toString());
					if(XMLUtils.hasNode(xml,"fault"))
					{
						res=false;
						callfault.fault=xml.fault.toString();
					}
					if(XMLUtils.hasNode(xml,"faultString"))
					{
						res=false;
						callfault.fault=xml.faultString.toString();
					}
					if(XMLUtils.hasNode(xml,"faultMessage"))
					{
						res=false;
						callfault.fault=xml.faultMessage.toString();
					}
					if(!res)
					{
						callfault.rawResult=call.loader.data;
						callfault.xml=xml;
						return callfault;
					}
					else
					{
						callresult.rawResult=call.loader.data;
						callresult.xml=xml;
						return callresult;
					}
					break;
				case "text":
					callresult.rawResult=call.loader.data;
					callresult.text=String(data);
					return callresult;
					break;
				case "binary":
					callresult.rawResult=call.loader.data;
					callresult.binary=call.loader.data as ByteArray;
					return callresult;
					break;
			}
			return callresult;
		}
	}
}