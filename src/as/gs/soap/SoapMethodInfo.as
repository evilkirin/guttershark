package gs.soap
{
	
	/**
	 * The SoapMethodInfo class is a value object used
	 * in a SoapService. It keeps track of meta data
	 * about each operation parsed out from the original
	 * wsdl.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.soap.SoapService
	 */
	final public class SoapMethodInfo
	{
		
		/**
		 * The operation name.
		 */
		public var name:String;
		
		/**
		 * Parameter names.
		 */
		public var params:Array;
		
		/**
		 * Target namespace.
		 */
		public var targetNS:String;
		
		/**
		 * The service path.
		 */
		public var servicePath:String;
		
		/**
		 * The action.
		 */
		public var action:String;
		
		/**
		 * Constructor for SoapMethod instances.
		 * 
		 * @param name The method name.
		 * @param param The method parameter.
		 * @param targetNS The target namespace.
		 * @param servicePath The service path.
		 * @param action The soap action.
		 */
		public function SoapMethodInfo(name:String,params:Array,targetNS:String,servicePath:String,action:String):void
		{
			this.name=name;
			this.params=params;
			this.targetNS=targetNS;
			this.servicePath=servicePath;
			this.action=action;
		}
		
		/**
		 * 
		 */
		public function toString():String
		{
			return "[Name: "+name+", ServicePath: " +servicePath+", Parameters: " +params+"]";
		}
		
		/**
		 * Dispose of this method info object.
		 */
		public function dispose():void
		{
			name=null;
			params=null;
			targetNS=null;
			servicePath=null;
			action=null;
		}
	}
}