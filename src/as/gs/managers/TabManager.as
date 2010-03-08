package gs.managers
{
	
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.utils.Dictionary;

	/**
	 * The TabManager class manages tab indexes.
	 * 
	 * <p>Tab management in flash is flat; which means that no display
	 * object can have the same tab index.</p>
	 * 
	 * <p>This allows you to set a state which consists of any objects
	 * you want. Then you can activate, or deactivate those states.</p>
	 * 
	 * <p><strong>For some reason the Flash components don't adhere
	 * to what the "tabIndex" property means. Even setting tabEnabled=false
	 * on components causes problems with this tab manager.</strong></p>
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class TabManager 
	{
		
		/**
		 * States lookup.
		 */
		private static var states:Dictionary = new Dictionary(true);
		
		/**
		 * The current state.
		 */
		private static var curState:Array;
		
		/**
		 * Create's a new tab state.
		 * 
		 * @param id A unique id to identify this tab state.
		 * @param objs An array of objects, tab order is defined by order of elements in array.
		 */
		public static function set(id:String,...objs:Array):void
		{
			if(!id)throw new ArgumentError("Parameter {id} cannot be null");
			if(!objs)throw new ArgumentError("Parameter {objs} cannot be null or empty.");
			if(!objs && (objs[0] is Array))objs=objs[0];
			states[id]=objs;
		}
		
		/**
		 * Unset (delete) a tab state.
		 * 
		 * @param id The tab state id.
		 */
		public static function unset(id:String):void
		{
			if(!id||!states[id])return;
			states[id]=null;
			delete states[id];
		}
		
		/**
		 * Activate a tab state.
		 * 
		 * @param id The unique tab state id.
		 * @param setFocusToFirst Whether or not to set the stage.focus property to
		 * the first item in the given tab state.
		 */
		public static function activate(id:String,setFocusToFirst:Boolean=true):void
		{
			if(!id)throw new ArgumentError("Parameter {id} cannot be null");
			if(curState)deactivate();
			curState=states[id];
			_activate(setFocusToFirst);
		}
		
		/**
		 * Whether or not a state is defined with
		 * the specified id.
		 * 
		 * @param id The tab state id.
		 */
		public static function contains(id:String):Boolean
		{
			return !(states[id]==null);
		}
		
		/**
		 * Activate the curState tab state.
		 */
		private static function _activate(setFocusToFirst:Boolean):void
		{
			var i:int=0;
			var l:int=curState.length;
			var st:Stage;
			for(;i<l;i++)
			{
				var m:* =curState[int(i)];
				if(!("tabIndex") in m)continue;
				if(!m)continue;
				m.tabIndex=int(i);
				if(!st&&m.stage)st=m.stage;
			}
			if(setFocusToFirst&&(m is InteractiveObject) && st)st.focus=curState[0];
			if(!st && LayoutManager.StageRef)LayoutManager.StageRef.focus=curState[0];
		}
		
		/**
		 * Deactivate the current tab state.
		 */
		public static function deactivate():void
		{
			if(!curState)return;
			var i:int=0;
			var l:int=curState.length;
			for(;i<l;i++)
			{
				if(!curState[int(i)])continue;
				curState[int(i)].tabIndex=-1;
			}
		}
	}
}