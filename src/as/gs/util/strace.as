package gs.util 
{
	
	/**
	 * The strace function traces out the stacktrace from
	 * wherever the strace function was called.
	 * 
	 * @example
	 * <listing>	
	 * import gs.util.strace;
	 * function test()
	 * {
	 *     strace("word",">>trace1","<<trace2");
	 * }
	 * function test2()
	 * {
	 *     test();
	 * }
	 * test2();
	 * 
	 * //output:
	 * &gt;&gt;trace1
	 * strace_fla::MainTimeline/test() : word
	 * strace_fla::MainTimeline/test2()
	 * strace_fla::MainTimeline/frame1()
	 * &lt;&lt;trace1
	 * </listing>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public function strace(msg:String,pre:String=null,post:String=null):void
	{
		var e:Error=new Error();
		var str:String=e.getStackTrace();
		var lines:Array=str.split("\n");
		lines.shift();
		lines.shift();
		var i:int = 0;
		var l:int=lines.length;
		for(;i<l;i++)
		{
			lines[int(i)]=lines[int(i)].replace(/^\s+/,"");
			lines[int(i)]=lines[int(i)].replace(/at /,"");
			if(i==0)lines[int(i)]+=": "+msg;
		}
		if(pre)trace(pre);
		trace(lines.join("\n"));
		if(post)trace(post);
	}
}