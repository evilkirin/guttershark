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
		 * If the search is case sensitive
		 */
		private var caseSensitive:Boolean;
		
		/**
		 * Constructor for AutoSuggest instances.
		 * 
		 * @param terms An array of strings to search through.
		 * @param caseSensitive If case sensitivity matters.
		 */
		public function AutoSuggest(terms:Array,caseSensitive:Boolean=false):void
		{
			if(!terms)throw new ArgumentError("Parameter {terms} cannot be null");
			_terms=terms;
			this.caseSensitive=caseSensitive;
			terms.sort();
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
		 * @param term The term to search for.
		 * @param returnLowercaseMatches Return all lowercase matches.
		 * @return Array An array of AutoSuggestMatches.
		 */
		public function search(term:String,returnLowercaseMatches:Boolean=true):Array
		{
			if(!caseSensitive) term=term.toLowerCase();
			var resultsTop:Array=[];
			//var resultsContains:Array=[];
			var termsLen:int=_terms.length;
			var regexTop:RegExp;
			//var regexContains:RegExp;
			var regexExact:RegExp;
			var exactMatch:*;
			if(caseSensitive)
			{
				regexExact=new RegExp("^" + term + "$","i");
				regexTop=new RegExp("^" + term,"i");
				//regexContains=new RegExp(term,"i");
			}
			else
			{
				regexExact=new RegExp("^" + term + "$","");
				regexTop=new RegExp("^" + term,"");
				//regexContains=new RegExp(term,"");
			}
			for(var i:int=0; i < termsLen; i++)
			{
				var nterm:String=(caseSensitive) ? _terms[i] : _terms[i].toLowerCase();
				if(returnLowercaseMatches) nterm=nterm.toLowerCase();
				var matchExact:Object=nterm.match(regexExact);
				var matchTop:Object=nterm.match(regexTop);
				//var matchContains:Object=nterm.match(regexContains);
				var highlightedTerm:String;
				var matchf:AutoSuggestMatch;
				if(matchExact)
				{
					highlightedTerm="<span class='suggestedTerm'><span class='matchedLetters'>" + nterm + "</span></span>";
					exactMatch=new AutoSuggestMatch(nterm, highlightedTerm);
				}
				else if(matchTop)
				{
					highlightedTerm="<span class='suggestedTerm'>" + nterm.substr(0,matchTop.index) + "<span class='matchedLetters'>" + nterm.substr(matchTop.index,matchTop[0].length) + "</span>" + nterm.substr((matchTop.index + matchTop[0].length), nterm.length) + "</span>";
					matchf=new AutoSuggestMatch(nterm, highlightedTerm);
					resultsTop.push(matchf);
				}
				/*else if(matchContains)
				{
					highlightedTerm="<span class='suggestedTerm'>";					
					pre=nterm.substr(0,matchContains.index);
					colorized="<span class='matchedLetters'>" + nterm.substr(matchContains.index,matchContains[0].length) + "</span>";
					post=nterm.substr((matchContains.index + matchContains[0].length), nterm.length) + "</span>";
					highlightedTerm += pre + colorized + post;
					matchf=new AutoSuggestMatch(nterm, highlightedTerm);
					resultsContains.push(matchf);	
				}*/
			}
			resultsTop.sortOn("term");
			//resultsContains.sortOn("term");
			var finalResults:Array=resultsTop.concat();
			if(exactMatch) finalResults.unshift(exactMatch);
			return finalResults;
		}
		
		/**
		 * Set the terms to search through.
		 * 
		 * @param terms An array of strings.
		 */
		public function set terms(terms:Array):void
		{
			if(!terms) throw new ArgumentError("Terms cannot be null");
			_terms=terms;
		}
		
		/**
		 * Dispose of internal objects in memory.
		 */
		public function dispose():void
		{
			_terms=null;
			caseSensitive=false;
		}
	}
}