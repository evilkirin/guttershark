package gs.util
{
	import adobe.utils.MMExecute;

	/**
	 * The JSFLProxy class is a proxy class that eleviates the pain
	 * of running jsfl from actionscript.
	 * 
	 * <p>JSFL Proxy does not eleviate having to call such things like:
	 * <code>MMExecute("fl.getDocumentDOM().path")</code>, but it does relieve
	 * calling script files, or functions withing script files, and
	 * handling parameters, and responses from the script. See the
	 * <em>runScript</em> method for more documentation.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class JSFLProxy
	{
		
		/**
		 * Run a jsfl script file, with optional parameters.
		 * 
		 * <p>The callProps object accepts these properties:</p>
		 * 
		 * <ul>
		 * <li>method (String) - A method inside of the jsfl file to execute.</li>
		 * <li>params (Array) - Parameters to send to the jsfl function.</li>
		 * <li>escapeParams (Boolean) - Whether or not to escape all parameters being sent to the function.</li>
		 * <li>responseWasEscaped (Boolean) - Whether the return value from jsfl was escaped. This is useful for returning XML, or string with special characters,
		 * because special characters will throw jsfl errors if they're not escaped.</li>
		 * <li>responseFormat (String) - A response format, so that casting can occur - supports (xml,boolean,int,number,array(csv)).
		 * </ul>
		 * 
		 * <p>Those properties are optional. And depending on what properties are present,
		 * either a jsfl file will execute, or a method inside of it</p>
		 * 
		 * @example Calling a script file (no method):
	 	 * <listing>	
	 	 * var j:JSFLProxy=JSFLProxy.gi();
	 	 * j.runScript("myscript.jsfl",{responseFormat:"xml",responseWasEscape:true});
	 	 * </listing>
	 	 * 
	 	 * @example Calling a method in a script file:
	 	 * <listing>	
	 	 * var j:JSFLProxy=JSFLProxy.gi();
	 	 * j.runScript("myscript.jsfl",{method:"helloWorld",params:["test"],escapeParams:true,responseFormat:"XML",responseWasEscape:true});
	 	 * </listing>
	 	 * 
		 * @param scriptFile The fileURI (file:///) to run.
		 * @param callProps The call properties to use for this call.
		 */
		public static function runScript(scriptFile:String, callProps:Object=null):*
		{
			if(!callProps)callProps={};
			var params:Array=(callProps.params)?callProps.params:[];
			var a:String;
			if(params.length>0)a="";
			var i:int=0;
			var l:int=params.length;
			for(;i<l;i++)
			{
				if(callProps.escapeParams==true)a+="'"+escape(params[int(i)].toString())+"'";
				else a+="'"+params[int(i)].toString()+"'";
				if(i<params.length-1)a+=",";
			}
			var r:String;
			if(!callProps.method)r=MMExecute("fl.runScript('"+scriptFile+"')");
			else
			{
				if(a)r=MMExecute("fl.runScript('"+scriptFile+"','"+callProps.method+"',"+a+")");
				else r=MMExecute("fl.runScript('"+scriptFile+"','"+callProps.method+"')");
			}
			if(callProps.responseWasEscaped)r=unescape(r);
			var ret:* =r;
			if(!callProps.responseFormat&&r=="null"||r=="false")ret=false;
			if(!callProps.responseFormat&&r=="true") ret=true;
			switch(callProps.responseFormat)
			{
				case "boolean":
					ret=StringUtils.toBoolean(r);
					break;
				case "xml":
					ret=new XML(r);
					break;
				case "number":
					ret=Number(r);
					break;
				case "int":
					ret=int(r);
					break;
				case "array":
					ret=r.split(",");
					break;
				default:
					ret=r;
					break;
			}
			return ret;
		}
		
		/**
		 * Alert a message.
		 * 
		 * @param message A message to alert.
		 * @param escap Whether or not to escape the alert message.
		 */
		public static function alert(message:String,escap:Boolean=false):void
		{
			if(escap)MMExecute("alert('"+escape(message.toString())+"')");
			else MMExecute("alert('"+message.toString()+"')");
		}
		
		/**
		 * Trace to output.
		 * 
		 * @param msg An object to trace out.
		 * @param escape Whether or not to escape the trace.
		 */
		public static function trase(msg:*,escap:Boolean=false):void
		{
			trace(msg);
			if(escap)MMExecute("fl.trace('"+escape(msg.toString())+"')");
			else MMExecute("fl.trace('"+msg.toString()+"')");
		}
	}
}
