package gs.managers
{
	
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.utils.Dictionary;

	/**
	 * The TabManager class manages tab indexes in a sophisticated manner.
	 * 
	 * <p>Managing tabs and focus in Flash is not difficult, the
	 * thing that's overlooked is that tab management is "flat",
	 * meaning that no two display objects can have the same tab index
	 *  - through-out the entire movie.</p>
	 * 
	 * <p>This tab manager allows you to create
	 * tab states, that have associated objects
	 * with them. You can "activate" a tab state,
	 * which means unregister previous tabIndex
	 * definitions, and redefine them for the 
	 * objects defined in the new tab state.</p>
	 * 
	 * <p>This allows you to easily toggle different
	 * tab loops throughout the entire movie.</p>
	 * 
	 * <p><strong>Note: for some reason the Flash
	 * components don't adhere to what the "tabIndex"
	 * property means. Even setting tabEnabled=false
	 * on components causes problems with this tab manager.</strong></p>
	 * 
	 * @example (examples/managers/tabmanager/)
	 * 
	 * <script src="../../../../examples/swfobject.js"></script>
	 * <br/><div id="flashcontent"></div>
	 * <script>
	 * var vars={};
	 * var params={scale:'noScale',salign:'lt',menu:'false'};
	 * var attribs={id:'flaswf',name:'flaswf'};
	 * swfobject.embedSWF("../../../../examples/managers/tabmanager/deploy/main.swf","flashcontent","223","180","9.0.0",null,vars,params,attribs);
	 * </script>
	 */
	final public class TabManager 
	{
		
		/**
		 * Singleton instance.
		 */
		private static var inst:TabManager;
		
		/**
		 * States lookup.
		 */
		private var states:Dictionary;
		
		/**
		 * The current state.
		 */
		private var curState:Array;
		
		/**
		 * @private
		 */
		public function TabManager()
		{
			states=new Dictionary();
		}

		/**
		 * Singleton access.
		 */
		public static function gi():TabManager
		{
			if(!inst)inst=new TabManager();
			return inst;
		}
		
		/**
		 * Create's a new tab state.
		 * 
		 * @param id A unique id to identify this tab state.
		 * @param objs An array of objects, tab order is defined by order of elements in array.
		 */
		public function createState(id:String,...objs:Array):void
		{
			if(!id)throw new ArgumentError("Parameter {id} cannot be null");
			if(!objs)throw new ArgumentError("Parameter {objs} cannot be null or empty.");
			states[id]=objs;
		}
		
		/**
		 * Remove a tab state.
		 * 
		 * @param id The tab state id.
		 */
		public function removeState(id:String):void
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
		public function activateState(id:String,setFocusToFirst:Boolean=true):void
		{
			if(!id)throw new ArgumentError("Parameter {id} cannot be null");
			if(curState)deactivateCurrent();
			curState=states[id];
			activateCurrent(setFocusToFirst);
		}
		
		/**
		 * An alternative to the "activateState" method, you
		 * can activate a state - setFocusToFirst setting
		 * stage focus is not attempted.
		 */
		public function set state(id:String):void
		{
			if(!id)throw new ArgumentError("Parameter {id} cannot be null");
			if(curState)deactivateCurrent();
			curState=states[id];
			activateCurrent(false);
		}
		
		/**
		 * Whether or not a state is defined with
		 * the specified id.
		 * 
		 * @param id The tab state id.
		 */
		public function hasState(id:String):Boolean
		{
			return !(states[id]==null);
		}
		
		/**
		 * Activate the curState tab state.
		 */
		private function activateCurrent(setFocusToFirst:Boolean):void
		{
			var i:int=0;
			var l:int=curState.length;
			var st:Stage;
			for(i;i<l;i++)
			{
				var m:* =curState[i];
				if(!("tabIndex") in m)continue;
				if(!m)continue;
				m.tabIndex=i;
				if(!st&&m.stage)st=m.stage;
			}
			if(setFocusToFirst&&(m is InteractiveObject) && st)st.focus=curState[0];
			if(!st && LayoutManager.StageRef)LayoutManager.StageRef.focus=curState[0];
		}
		
		/**
		 * Deactivate the current tab state.
		 */
		public function deactivateCurrent():void
		{
			if(!curState)return;
			var i:int=0;
			var l:int=curState.length;
			for(i;i<l;i++)
			{
				if(!curState[i])continue;
				curState[i].tabIndex=-1;
			}
		}
	}
}