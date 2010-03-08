package
{
	import gs.control.DocumentController;
	import gs.soap.SoapCallFault;
	import gs.soap.SoapCallResult;
	import gs.soap.SoapService;
	import gs.util.XMLNamespaceProxy;

	public class Main extends DocumentController
	{
		
		private var ss:SoapService;
		
		override protected function flashvarsForStandalone():Object
		{
			return {
				model:"model.xml"
			};
		}
		
		override protected function onModelReady():void
		{
			ss=model.getSoapServiceById("resolveIP");
			ss.setCallbacks({onWSDLReady:ready});
			ss.loadWSDL();
		}
		
		private function ready():void
		{
			ss.listMethods();
			ss.send("ResolveIP",{
				traceSoapRequest:true,
				onFirstCall:firstcall,onResult:res,onFault:fal,
				arguments:{
					ipAddress:"98.207.97.51",
					licenseKey:0
				}
			});
		}
		
		private function firstcall():void
		{
			trace("first call");
		}
		
		private function res(r:SoapCallResult):void
		{
			trace("raw result:");
			trace(r.raw);
			trace("-----------");
			
			//You can either set the nspaceProxy property yourself.
			var cns:Namespace = new Namespace("","http://ws.cdyne.com/");
			r.nspaceProxy = new XMLNamespaceProxy(r.body,cns);
			
			//Or just set the namespaceProxyURI
			r.namespaceProxyURI = "http://ws.cdyne.com/";
			
			//then acess the result.
			trace(r.nspaceProxy.ResolveIPResponse.ResolveIPResult.Organization);
			
			trace("-----------");
			
			//If you don't use namespace proxy. You need to manually setup namespaces.
			default xml namespace = cns;
			trace(r.body.ResolveIPResponse.ResolveIPResult.Organization);
		}
		
		private function fal(f:SoapCallFault):void
		{
			trace(f,"fault");
		}
	}
}