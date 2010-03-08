package gs.soap
{

	/**
	 * The SoapCallResultHandler class process soap
	 * responses and figures out if they're good
	 * responses or faults.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.soap.SoapService
	 */
	public class SoapCallResultHandler
	{
		
		/**
		 * Default process method that figures out if the
		 * soap response was successful or faulty.
		 * 
		 * @return Either a SoapCallResult or SoapCallFault.
		 */
		public function process(raw:String):*
		{
			var fal:SoapCallFault;
			var res:SoapCallResult;
			var xml:XML;
			try{xml=new XML(raw);}catch(e:*){}
			if(!xml)return new SoapCallFault(raw,(xml==null));
			var ns:Namespace=xml.namespace();
			var body:XML= new XML(xml.ns::Body);
			var fault:XML;
			if(body.hasOwnProperty("Fault"))fault=new XML(body.Fault);
			if(fault)return new SoapCallFault(raw,(xml==null));
			return new SoapCallResult(raw);
		}
	}
}