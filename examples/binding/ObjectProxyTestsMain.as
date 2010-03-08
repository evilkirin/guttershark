package
{
	import gs.util.CallQueue;
	import gs.util.bindings.BindableObject;
	import gs.util.bindings.BindingUtils;
	
	import flash.display.Sprite;
	
	public class ObjectProxyTestsMain extends Sprite
	{
		
		private var obj1:BindableObject;
		private var bind:BindingUtils;
		
		public function ObjectProxyTestsMain()
		{
			bind=BindingUtils.gi();
			init();
		}

		public function init():void
		{
			obj1=new BindableObject();
			
			bind.setter(obj1,"test",onTestPropChange);
			bind.property(obj1,"test1",obj1,"test2");
			bind.setter(obj1,"test2",onTest2Set);
			
			var cq:CallQueue=new CallQueue();
			cq.addCall(function():String{return obj1['test']="word";},1000);
			cq.addCall(function():String{return obj1['test']="hello";},1000);
			cq.addCall(function():String{return obj1['test']="again";},1000);
			cq.addCall(function():String{return obj1['test']="yes, again";},1000);
			cq.addCall(function():String{return obj1['test1']="::set test1";},1000);
			cq.addCall(function():String{return obj1['test1']="::set test1, again";},1000);
			cq.startAndDispose();
		}
		
		private function onTestPropChange(value:String):void
		{
			trace("property changed: ",value);
		}
		
		private function onTest2Set(value:String):void
		{
			trace("called test 2 from binding to test1",value);
		}	}}