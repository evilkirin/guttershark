package gs.util 
{
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	/**
	 * The Disposer class is a helper that can simplify
	 * disposing objects.
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class Disposer 
	{
		
		/**
		 * Registered objects.
		 */
		private var objects:Dictionary;
		
		/**
		 * Constructor for Disposer instances.
		 */
		public function Disposer():void
		{
			objects=new Dictionary();
		}
		
		/**
		 * A helper method to simplify your disposal
		 * logic.
		 */
		public function clearvars(target:*,...varNames):void
		{
			if(!target||varNames.length<1)return;
			var i:int=0;
			var l:int=varNames.length;
			var name:String;
			for(;i<l;i++)
			{
				name=varNames[i];
				if(!(name in target))continue;
				else if(target[name] is Boolean)target[name]=false;
				else if(target[name] is Number)target[name]=NaN;
				else if(target[name] is int)target[name]=0;
				else target[name]=null;
			}
		}
		
		/**
		 * Add an object to this disposer.
		 * 
		 * @param o The object.
		 */
		public function addObject(o:*):void
		{
			if(!o)return;
			objects[o]=true;
		}
		
		/**
		 * Remove an object from disposal.
		 * 
		 * @param o The object.
		 */
		public function removeObject(o:*):void
		{
			if(!o)return;
			delete objects[o];
		}
		
		/**
		 * Dispose of a certain type of registered objects.
		 * 
		 * @param type The type to dispose of.
		 */
		public function disposeType(type:Class):void
		{
			if(type==null)return;
			var obj:*;
			for(obj in objects)
			{
				if(!(obj is type))continue;
				if("dispose" in obj)obj.dispose();
				if(obj is Timer)Timer(obj).stop();
			}
		}
		
		/**
		 * Dispose of everything this disposer is keeping
		 * track of.
		 */
		public function disposeAll():void
		{
			var obj:*;
			for(obj in objects)
			{
				if("dispose" in obj) obj.dispose();
				if(obj is Timer)Timer(obj).stop();
			}
		}
		
		/**
		 * Dispose of this disposer instance.
		 */
		public function dispose():void
		{
			objects=null;
		}
	}
}