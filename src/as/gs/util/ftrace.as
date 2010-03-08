package gs.util 
{
	
	/**
	 * The ftrace function is similar to trace, except
	 * it prefixes the message with the function that the
	 * trace came from.
	 * 
	 * @example
	 * <listing>	
	 * import gs.util.ftrace;
	 * function test()
	 * {
	 *     ftrace("word"); //[MainTimeline/test()] word
	 * }
	 * </listing>
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public function ftrace(msg:String):void
	{
		var e:Error=new Error();
		var str:String=e.getStackTrace();
		if(str==null)trace("(!debug) ",msg);
		else
		{
			var stacks:Array=str.split("\n");
			var caller:String=getCaller(stacks[2]);
			trace(caller+":",msg);
		}
	}
}

function getCaller(line:String):String
{
	var dom_pos:int=line.indexOf("::");
	var caller:String;
	if(dom_pos == -1) caller=line.substr(4);//remove '<tab>at ' beginning part (4 characters)
	else caller=line.substr(dom_pos+2);//remove '<tab>at com.flickaway::' beginning part
	var lb_pos:int=caller.indexOf("[");//get position of the left bracket (lb)
	if(lb_pos==-1)//if the lb doesn't exist (then we don't have "permit debugging" turned on)
	{
		return "[" + caller + "]";
	}
	else
	{
		var line_num:String=caller.substr(caller.lastIndexOf(":"));// find the line number
		caller = caller.substr(0, lb_pos);// cut it out - it'll look like ":51]"
		return "[" + caller + line_num;// line_num already has the trailing right bracket
	}
}