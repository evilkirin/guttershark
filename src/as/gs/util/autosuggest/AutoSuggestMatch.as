package gs.util.autosuggest
{
	
	/**
	 * The AutoSuggestMatch class represents a matched search term that was found
	 * in an AutoSuggest instance.
	 * 
	 * <p>It provide you with the unchanged original term from the auto suggest, as
	 * well as a highlighted term that is wrapped in HTML to provide you with a way
	 * to do highlighting</p>
	 * 
	 * <p>Consider this example of a "highlightedTerm":</p>
	 * 
	 * <listing>	
	 * &lt;span class='suggestedTerm'&gt;&lt;span class="matchedLetters"&gt;Georg&lt;/span&gt;e Bush&lt;/span&gt;
	 * </listing>
	 * 
	 * <p>In that example, the original term was "George Bush" and the matched part of the
	 * term was "Georg".</p>
	 * 
	 * <p>The highlightedTerm is provided specifically for working with textfields
	 * and styles. You can set the style of both the span class's to provide a highlight
	 * effect.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class AutoSuggestMatch
	{

		/**
		 * The un-changed full term from the auto suggest searchable terms.
		 */
		public var term:String;
		
		/**
		 * An HTML representation of the term that provides a way to use
		 * styles on a textfield for highlights.
		 * 
		 * @example A highlighted term string:
		 * <listing>	
		 * &lt;span class='suggestedTerm'&gt;&lt;span class="matchedLetters"&gt;Georg&lt;/span&gt;e Bush&lt;/span&gt;
		 * </listing>
		 */
		public var highlightedTerm:String;
		
		/**
		 * Constructor for AutoSuggestMatch instances.
		 * 
		 * @param term The un-changed term from the auto suggest search terms.
		 * @param highlightedTerm An HTML wrapped representation of the term.
		 */
		public function AutoSuggestMatch(term:String,highlightedTerm:String):void
		{
			this.term=term;
			this.highlightedTerm=highlightedTerm;
		}
		
		/**
		 * Dispose of internal objects in memory.
		 */
		public function dispose():void
		{
			term=null;
			highlightedTerm=null;
		}
	}
}