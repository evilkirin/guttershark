package
{
	import gs.control.DocumentController;
	import gs.util.StringUtils;
	import gs.util.autosuggest.AutoSuggest;

	import flash.events.Event;
	import flash.text.TextField;

	public class Main extends DocumentController
	{
		
		public var input:TextField;
		public var result:TextField;
		
		private var terms:Array;
		private var ats:AutoSuggest;
		
		public function Main()
		{
			terms=[
				"George Bush",
				"The Tony Danza Tap Dance Extravaganza",
				"Saosin",
				"Folly",
				"Seinfeld"
			];
			input.addEventListener(Event.CHANGE,onChange);
			ats=new AutoSuggest(terms);
		}
		
		private function onChange(e:Event):void
		{
			var matches:Array=ats.search(input.text,false,true);
			if(matches.length < 1)
			{
				trace("no matches");
				result.htmlText="";
				return;
			}
			var i:int=0;
			var l:int=matches.length;
			for(;i<l;i++)trace(matches[i].term,matches[i].highlightedTerm);
			result.htmlText=StringUtils.wrapInBodySpan(matches[0].highlightedTerm);
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"model.xml"};
		}
		
		override protected function setupComplete():void
		{
			model.getTextAttributeById('result').apply(result);
		}
	}
}