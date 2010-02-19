package gs.util.autosuggest
{
	
	/**
	 * The AutoSuggest class provides the search logic needed for an auto suggest,
	 * as well as providing you with match data.
	 * 
	 * <p>The AutoSuggest class searches through the provided a list of terms
	 * for a specific search term.</p>
	 * 
	 * <p>As an example. Assume you had this list of words to search through:</p>
	 * 
	 * <ul>
	 * <li>George Bush</li>
	 * <li>Samuel L. Jackson</li>
	 * <li>Flash</li>
	 * <li>Flex</li>
	 * </ul>
	 * 
	 * <p>Now assume you started typing "Fl", the AutoSuggest instance would return an
	 * array of AutoSuggestMatches. The two that matched were Flash and Flex.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class AutoSuggest
	{

		/**
		 * The terms currently being looked through
		 */
		private var _terms:Array;
		
		/**
		 * Constructor for AutoSuggest instances.
		 * 
		 * @param terms An array of strings to search through.
		 * @param caseSensitive If case sensitivity matters.
		 */
		public function AutoSuggest(terms:Array):void
		{
			if(!terms)throw new ArgumentError("Parameter {terms} cannot be null");
			_terms=terms;
			_terms.sort();
		}
		
		/**
		 * Search through the terms in this auto suggest instance for a particular
		 * word or phrase.
		 * 
		 * <p>Example usage:</p>
		 * <listing>	
		 * import gs.util.autosuggest.AutoSuggest;
		 * 
		 * var terms:Array=[
		 *   "George Bush", "Chaotmic Matter", "Particle Effects", "Word up",
		 *   "Gangsta", "The Tony Danza Tap Dance Extravaganza", "Good bye",
		 *   "Goodby","Gaa"
		 * ];
		 * 
		 * var ast:AutoSuggest=new AutoSuggest(terms,false);
		 * var a:*=ast.search("The Tony",true);
		 * 
		 * trace(a[0].term);
		 * trace(a[0].highlightedTerm);
		 * 
		 * var b:*=ast.search("G",true)
		 * trace(b.length);
		 * 
		 * for(var i:int=0; i < b.length; i++)
		 * {
		 *    trace(b[i].term + " :: " + b[i].highlightedTerm);
		 * }
		 * </listing>
		 * 
		 * @param str The string to search for.
		 * @param caseSensitive Whether or not the search is case sensitive.
		 * @param matchAnywhere Whether or not the search string has to be matched form the beginnging (^) of the string, or can the search string
		 * be located anywhere in the string and still be considered a match.
		 * @param returnLowercaseMatches Whether or not to return the matches as all lowercase strings.
		 */
		public function search(str:String,caseSensitive:Boolean=false,matchAnywhere:Boolean=false,returnLowercaseMatches:Boolean=true):Array
		{
			if(!str||str=="")return[];
			if(!caseSensitive)str=str.toLowerCase();
			var finalResults:Array=[];
			var resultsTop:Array=[];
			var resultsContains:Array=[];
			var termsLen:int=_terms.length;
			var regexTop:RegExp;
			var regexContains:RegExp;
			var regexExact:RegExp;
			var exactMatch:*;
			if(caseSensitive)
			{
				regexExact=new RegExp("^"+str+"$","");
				regexTop=new RegExp("^"+str,"");
				regexContains=new RegExp(str,"");
			}
			else
			{
				regexExact=new RegExp("^"+str+"$","i");
				regexTop=new RegExp("^"+str,"i");
				regexContains=new RegExp(str,"i");
			}
			var i:int=0;
			for(;i<termsLen;i++)
			{
				var oterm:String=_terms[i];
				var nterm:String=(caseSensitive)?_terms[i]:_terms[i].toLowerCase();
				if(returnLowercaseMatches)nterm=nterm.toLowerCase();
				var matchExact:Object=nterm.match(regexExact);
				var matchTop:Object=nterm.match(regexTop);
				var matchContains:Object=nterm.match(regexContains);
				var matchf:AutoSuggestMatch;
				var highlightedTerm:String;
				var pre:String;
				var colorized:String;
				var post:String;
				if(matchExact)
				{
					highlightedTerm="<span class='suggestedTerm'><span class='matchedLetters'>"+oterm+"</span></span>";
					exactMatch=new AutoSuggestMatch(oterm,highlightedTerm);
				}
				else if(matchTop)
				{
					highlightedTerm="<span class='suggestedTerm'>"+oterm.substr(0,matchTop.index)+"<span class='matchedLetters'>"+oterm.substr(matchTop.index,matchTop[0].length)+"</span>"+oterm.substr((matchTop.index+matchTop[0].length),oterm.length)+"</span>";
					matchf=new AutoSuggestMatch(oterm,highlightedTerm);
					resultsTop.push(matchf);
				}
				else if(matchContains)
				{
					highlightedTerm="<span class='suggestedTerm'>";
					pre=oterm.substr(0,matchContains.index);
					colorized="<span class='matchedLetters'>"+oterm.substr(matchContains.index,matchContains[0].length)+"</span>";
					post=oterm.substr((matchContains.index+matchContains[0].length),oterm.length)+"</span>";
					highlightedTerm+=pre+colorized+post;
					matchf=new AutoSuggestMatch(oterm,highlightedTerm);
					resultsContains.push(matchf);
				}
			}
			resultsTop.sortOn("term");
			resultsContains.sortOn("term");
			if(resultsTop.length>0)finalResults=resultsTop.concat();
			if(matchAnywhere && resultsContains.length>0)finalResults=finalResults.concat(resultsContains);
			if(exactMatch)finalResults.unshift(exactMatch);
			return finalResults;
		}
		
		/**
		 * The terms to search through.
		 */
		public function set terms(terms:Array):void
		{
			if(!terms)throw new ArgumentError("Terms cannot be null");
			_terms=terms;
			_terms.sort();
		}
		
		/**
		 * The terms to search through.
		 */
		public function get terms():Array
		{
			return _terms;
		}
		
		/**
		 * Dispose of this auto suggest instance.
		 */
		public function dispose():void
		{
			_terms=null;
		}
	}
}