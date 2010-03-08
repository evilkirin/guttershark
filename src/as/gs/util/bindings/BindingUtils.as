package gs.util.bindings
{
	import flash.utils.Dictionary;

	/**
	 * The BindingUtils class creates bindings
	 * for you.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class BindingUtils 
	{
		
		/**
		 * Singleton instance.
		 */
		private static var inst:BindingUtils;
		
		/**
		 * Change watcher lookup.
		 */
		private var bindings:Dictionary;
		
		/**
		 * @private
		 * Constructor for BindingsManager instance.
		 */
		public function BindingUtils()
		{
			bindings=new Dictionary(true);
		}
		
		/**
		 * Singleton access.
		 */
		public static function gi():BindingUtils
		{
			if(!inst)inst=new BindingUtils();
			return inst;
		}
		
		/**
		 * Bind a property change to a setter function.
		 * 
		 * <p>Note that you can't technically pass a "setter"
		 * function, you have to use a normal function, which
		 * accept's the new value.</p>
		 * 
		 * @example Using bindSetter:
		 * <listing>	
		 * obj1=new BindableObject();
		 * BindingUtils.gi().setter(obj1,"test",onTestPropChange);
		 * var cq:CallQueue=new CallQueue();
		 * cq.addCall(function():String{return obj1['test']="word";},1000);
		 * cq.addCall(function():String{return obj1['test']="hello";},1000);
		 * cq.addCall(function():String{return obj1['test']="again";},1000);
		 * cq.addCall(function():String{return obj1['test']="yes, again";},1000);
		 * cq.startAndDispose();
		 * private function onTestPropChange(value:String):void
		 * {
		 *     trace("property changed: ",value);
		 * }
		 * </listing>
		 */
		public function setter(source:Object,property:String,destination:Function):void
		{
			if(!bindings[source])bindings[source]=new Dictionary(true);
			bindings[source][property]=ChangeWatcher.NewSetterChangeWatcher(source,property,destination);
		}
		
		/**
		 * Bind a property change, to another property.
		 * 
		 * @example Using bindProperty:
		 * <listing>	
		 * obj1=new BindableObject();
		 * BindingUtils.gi().property(obj1,"test1",obj1,"test2");
		 * BindingUtils.gi().setter(obj1,"test2",onTest2Set);
		 * var cq:CallQueue=new CallQueue();
		 * cq.addCall(function():String{return obj1['test']="word";},1000);
		 * cq.addCall(function():String{return obj1['test']="hello";},1000);
		 * cq.addCall(function():String{return obj1['test']="again";},1000);
		 * cq.addCall(function():String{return obj1['test']="yes, again";},1000);
		 * cq.addCall(function():String{return obj1['test1']="::set test1";},1000);
		 * cq.addCall(function():String{return obj1['test1']="::set test1, again";},1000);
		 * cq.startAndDispose();
		 * private function onTest2Set(value:String):void
		 * {
		 *     trace("called test 2 from binding to test1",value);
		 * }
		 * </listing>
		 */
		public function property(source:Object,property:String,destination:Object,destProperty:String):void
		{
			if(!bindings[source])bindings[source]=new Dictionary();
			bindings[source][property]=ChangeWatcher.NewPropertyChangeWatcher(source,property,destination,destProperty);
		}
		
		/**
		 * Dispose of a binding.
		 * 
		 * @param source The source object.
		 * @param property The property that was bound.
		 */
		public function unbind(source:Object,property:String):void
		{
			if(!bindings[source])return;
			if(!bindings[source][property])return;
			bindings[source][property].dispose();
			delete bindings[source][property];
		}
	}
}