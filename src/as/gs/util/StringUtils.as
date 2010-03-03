package gs.util
{
	
	/**
	 * The StringUtils class contains utility methods for strings.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class StringUtils
	{

		private static const LTRIM_EXP:RegExp=/(\s|\n|\r|\t|\v)*$/;
		private static const RTRIM_EXP:RegExp=/^(\s|\n|\r|\t|\v)*/m;
		private static const DEFAULT_ENCODE_DIGITS_SHOWN:int=4;
		private static const DEFAULT_ENCODE_CHARACTER:String='*';
		private static const MINIMUM_CARD_LENGTH:int=13;
		private static const MAXIMUM_CARD_LENGTH:int=16;
		
		/**
		 * Returns a string wrapped in a span with a custom class. This
		 * returns a string like: <code>&lt;span class='myClass'&gt;myText&lt;/span&gt;</code>
		 */
		public static function styleString(txt:String,style:String):String
		{
			return '<span class="'+style+'">'+txt+'</span>';
		}
		
		/**
		 * Wraps the provided string in a span with class body.
		 * 
		 * <p>Like this: <code>&lt;span class='myClass'&gt;myText&lt;/span&gt;</code></p>
		 */
		public static function wrapInBodySpan(str:String):String
		{
			return '<span class="body">'+str+'</span>';
		}
		
		/**
		 * @private
		 */
		public static function speedTest():void
		{
			var a:int = 0;
		}
		
		/**
		 * Returns an array split on commas (,), and any spaces
		 * are removed.
		 * 
		 * @param str A string of comma seperated email addresses.
		 */
		public static function getEmailsFromEmailList(str:String):Array
		{
			var splits:Array = str.split(",");
			var i:int=0;
			var l:int=splits.length;
			var s:String;
			var res:Array = [];
			for(;i<l;i++)
			{
				if(splits[i] == "") continue;
				s=splits[i].replace(/\s+/g,"");
				if(s=="")continue;
				res.push(s);
			}
			return res;
		}
		
		/**
		 * Convert a style sheet formatted color (#ff0099) to
		 * a whole integer.
		 * 
		 * @param num The stylesheet formatted number.
		 */
		public static function styleSheetNumberToInt(num:String):int
		{
			if(!num) return -1;
			return int(num.replace(/\#/,"0x"));
		}
		
		/**
		 * Converts a style sheet formatted color (#ff0099) to
		 * 0xff0099 as a string.
		 * 
		 * @param num The stylesheet formatted number.
		 */
		public static function styleSheetNumberTo0xHexString(num:String):String
		{
			return num.replace(/\#/,"0x");
		}
		
		/**
		 * Check whether a string is a valid email.
		 * 
		 * @param str The email to evaluate.
		 */
		public static function isemail(str:String):Boolean
		{
			var emailExpression:RegExp=/^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
			return emailExpression.test(str);
		}
		
		/**
		 * Check whether a string is a valid po box. (PO ,P O,P.O,P. O,p o,p.o,p. o,Box,Post Office,post office).
		 * 
		 * @param address The string to evaluate.
		 */
		public static function ispobox(address:String):Boolean
		{
			var look:Array=["PO ","P O","P.O","P. O", "p o","p.o","p. o","Box","Post Office","post office"];
			var len:Number=look.length;
			var i:int=0;
			for(;i<len;i++)if(address.indexOf(look[int(i)])!=-1)return true; 
			return false;
		}
		
		/**
		 * Check whether a state abbreviation is a valid state, according to the 
		 * usps list of abbreviations (http://www.usps.com/ncsc/lookups/abbr_state.txt) - including
		 * military state abbreviations.
		 * 
		 * @param state A state abbreviation to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public static function isStateAbbrev(state:String):Boolean
		{
			var states:Array=[
				"AL","AK","AS","AZ",
				"AR","CA","CO","CT","DE","DC",
				"FM","FL","GA","GU","HI","ID",
				"IL","IN","IA","KS","KY","LA",
				"ME","MH","MD","MA","MI","MN",
				"MS","MO","MT","NE","NV","NH",
				"NJ","NM","NY","NC","ND","MP",
				"OH","OK","OR","PW","PA","PR",
				"RI","SC","SD","TN","TX","UT",
				"VT","VI","VA","WA","WV","WI","WY",
				"AE","AA","AP"
			];
			var i:int=0;
			var l:int=62;
			for(;i<l;i++)if(state.toUpperCase()==states[int(i)]) return true;
			return false;
		}
		
		/**
		 * Get an array of 50 state abbreviations.
		 */
		public static function getStateAbbreviationsArray():Array
		{
			return ["AL","AK","AZ","AR","CA","CO","CT","DC",
			"DE","FL","GA","HI","ID","IL","IN","IA","KS",
			"KY","LA","ME","MD","MA","MI","MN","MS","MO",
			"MT","NE","NV","NH","NJ","NM","NY","NC","ND",
			"OH","OK","OR","PA","RI","SC","SD","TN","TX",
			"UT","VT","VA","WA","WV","WI","WY"];
		}
		
		/**
		 * Returns an array of state abbreviations (50 states), plus
		 * some extra according to the usps abbreviations list
		 * (http://www.usps.com/ncsc/lookups/abbr_state.txt).
		 */
		public static function getExtendedStateAbbreviationsArray():Array
		{
			return [
				"AL","AK","AS","AZ",
				"AR","CA","CO","CT","DE","DC",
				"FM","FL","GA","GU","HI","ID",
				"IL","IN","IA","KS","KY","LA",
				"ME","MH","MD","MA","MI","MN",
				"MS","MO","MT","NE","NV","NH",
				"NJ","NM","NY","NC","ND","MP",
				"OH","OK","OR","PW","PA","PR",
				"RI","SC","SD","TN","TX","UT",
				"VT","VI","VA","WA","WV","WI",
				"WY","AE","AA","AP"
			];
		}
		
		/**
		 * Check that a string is a valid http URL.
		 * 
		 * @param str The string to evaluate.
		 */
		public static function isurl(str:String):Boolean
		{
			return (str.substring(0,7) == "http://" || str.substring(0,8) == "https://");
		}
		
		/**
		 * Check whether or not a string is a valid phone number.
		 * 
		 * @param str The string to evaluate.
		 */
		public static function isphone(str:String):Boolean
		{
			var phoneExpression:RegExp=/^((\+\d{1,3}(-| )?\(?\d\)?(-| )?\d{1,3})|(\(?\d{2,3}\)?))(-| )?(\d{3,4})(-| )?(\d{4})(( x| ext)\d{1,5}){0,1}$/i;
			return phoneExpression.test(str);
		}
		
		/**
		 * Check whether or not a string is a valid file URI.
		 * 
		 * @param str The string to evaluate.
		 */
		public static function isfileuri(str:String):Boolean
		{
			return (str.substring(0,8) == "file:///");
		}

		/**
		 * Returns everything after the first occurrence of the provided character in the string.
		 *
		 * @param search The string to search in.
		 * @param returnAfter The string in which everything after the first occurance will be returned.
		 */
		public static function afterFirst(search:String, returnAfter:String):String
		{
			if(search == null) return null;
			var idx:int=search.indexOf(returnAfter);
			if(idx == -1) return null;
			idx += returnAfter.length;
			return search.substr(idx);
		}

		/**
		 * Returns everything after the last occurence of the provided character in the string.
		 *
		 * @param search The string to search in.
		 * @param returnAfter The string in which everything after the last occurance will be returned.
		 */
		public static function afterLast(search:String, returnAfter:String):String 
		{
			if(search == null) return null; 
			var idx:int=search.lastIndexOf(returnAfter);
			if(idx == -1) return null;
			idx += returnAfter.length;
			return search.substr(idx);
		}

		/**
		 * Returns everything before the first occurrence of the provided character in the string.
		 *
		 * @param search The string to search in.
		 * @param returnBefore The string in which everything before the first occurance will be returned.
		 */
		public static function beforeFirst(search:String, returnBefore:String):String 
		{
			if(search == null) return null;
			var idx:int=search.indexOf(returnBefore);
			if(idx == -1) return null;
			return search.substr(0,idx);
		}

		/**
		 * Returns everything before the last occurrence of the provided character in the string.
		 *
		 * @param search The string.
		 * @param returnBefore The string in which everything before the last occurance will be returned.
		 */
		public static function beforeLast(search:String, returnBefore:String):String
		{
			if(search == null) return null;
			var idx:int=search.lastIndexOf(returnBefore);
			if(idx == -1) return null;
			return search.substr(0,idx);
		}

		/**
		 * Returns everything after the first occurance of start and before the first occurrence of end in search.
		 *
		 * @param search The string to search in.
		 * @param start The string to use as the start index.
		 * @param end The string to use as the end index.
		 */
		public static function between(search:String, start:String, end:String):String 
		{
			if(search == null) return null;
			var str:String='';
			var startIdx:int=search.indexOf(start);
			if(startIdx != -1) 
			{
				startIdx += start.length;
				var endIdx:int=search.indexOf(end,startIdx);
				if(endIdx != -1) str=search.substr(startIdx,endIdx - startIdx); 
			}
			return str;
		}

		/**
		 * Capitallizes the first word in a string, and optionally all words.
		 *
		 * @param str The string.
		 * @param allWords Whether or not all words will be capitalized.
		 */
		public static function capitalize(p_string:String, allWords:Boolean=false):String 
		{
			var str:String=trimLeft(p_string);
			if(allWords) return str.replace(/^.|\b./g,_upperCase);
			else return str.replace(/(^\w)/,_upperCase);
		}

		/**
		 * Utility method that intelligently breaks up your string,
		 * allowing you to create blocks of readable text.
		 * This method returns you the closest possible match to the p_delim paramater,
		 * while keeping the text length within the p_len paramter.
		 * If a match can't be found in your specified length an  '...' is added to that block,
		 * and the blocking continues untill all the text is broken apart.
		 *
		 * @param p_string The string to break up.
		 * @param p_len Maximum length of each block of text.
		 * @param p_delim delimter to end text blocks on, default='.'
		 * 
		 * @return Array
		 */
		public static function block(p_string:String, p_len:uint, p_delim:String="."):Array 
		{
			var arr:Array=new Array();
			if(p_string == null || !contains(p_string,p_delim)) return arr;
			var chrIndex:uint=0;
			var strLen:uint=p_string.length;
			var replPatt:RegExp=new RegExp("[^" + escapePattern(p_delim) + "]+$","");
			while(chrIndex < strLen)
			{
				var subString:String=p_string.substr(chrIndex,p_len);
				if(!contains(subString,p_delim))
				{
					arr.push(truncate(subString,subString.length));
					chrIndex += subString.length;
				}
				subString=subString.replace(replPatt,'');
				arr.push(subString);
				chrIndex += subString.length;
			}
			return arr;
		}
		
		/**
		 * Removes whitespace from the front the specified string.
		 *
		 * @param str The String whose beginning whitespace will be removed.
		 */
		public static function trimLeft(str:String):String 
		{
			if(str == null) return '';
			return str.replace(/^\s+/,'');
		}

		/**
		 * Removes whitespace from the end of the specified string.
		 * 
		 * @param str The String whose ending whitespace will be removed.
		 */
		public static function trimRight(str:String):String 
		{
			if(str == null) return '';
			return str.replace(/\s+$/,'');
		}

		/**
		 * Determines the number of times a charactor or sub-string appears within the string.
		 *
		 * @param search The string.
		 * @param pattern The character or sub-string to count.
		 * @param caseSensitive Whether or not the search is case sensitive.
		 */
		public static function countOf(search:String, pattern:String, caseSensitive:Boolean=true):uint 
		{
			if(search == null) return 0;
			var char:String=escapePattern(pattern);
			var flags:String=(!caseSensitive) ? 'ig' : 'g';
			return search.match(new RegExp(char,flags)).length;
		}

		/**
		 * Pads a string with the specified character to a specified length from the left.
		 *
		 * @param str The string to pad.
		 * @param char Character for pad.
		 * @param length Length to pad to.
		 */
		public static function padLeft(str:String, char:String, length:uint):String 
		{
			var s:String=str;
			while(s.length<length) s=char+s;
			return s;
		}

		/**
		 * Pads a string with the specified character to a specified length from the right.
		 *
		 * @param str String to pad
		 * @param char Character for pad.
		 * @param length Length to pad to.
		 */
		public static function padRight(str:String, char:String, length:uint):String 
		{
			var s:String=str;
			while (s.length<length) s += char;
			return s;
		}

		/**
		 * Properly cases the string in "sentence format".
		 *
		 * @param str The string to proper case.
		 */
		public static function properCase(str:String):String 
		{
			if(str == null) return null;
			var st:String=str.toLowerCase().replace(/\b([^.?;!]+)/,capitalize);
			return st.replace(/\b[i]\b/,"I");
		}

		/**
		 * Removes all instances of a pattern in the search string.
		 *
		 * @param search The string that will be checked for instances of remove string
		 * @param pattern The string that will be removed from the input string.
		 * @param caseSensitive Whether or not the replace is case sensitive.
		 */
		public static function remove(search:String, pattern:String, caseSensitive:Boolean=true):String 
		{
			if(search == null) return null;
			var rem:String=escapePattern(pattern);
			var flags:String=(!caseSensitive) ? 'ig' : 'g';
			return search.replace(new RegExp(rem,flags),'');
		}

		/**
		 * Returns the string in reverse order.
		 *
		 * @param str The String that will be reversed.
		 */
		public static function reverse(str:String):String 
		{
			if(str == null) return null;
			return str.split('').reverse().join('');
		}

		/**
		 * Returns the specified string in reverse word order.
		 *
		 * @param str The String that will be reversed.
		 */
		public static function reverseWords(str:String):String 
		{
			if(str == null) return '';
			return str.split(/\s+/).reverse().join('');
		}

		/**
		 * Determines the percentage of similiarity, based on editDistance.
		 *
		 * @param source The source string.
		 * @param target The target string.
		 */
		public static function similarity(source:String, target:String):Number 
		{
			var ed:uint=editDistance(source,target);
			var maxLen:uint=Math.max(source.length,target.length);
			if(maxLen == 0) return 100;
			return (1 - ed / maxLen) * 100;
		}

		/**
		 * Levenshtein distance (editDistance) is a measure of the similarity between two strings,
		 * The distance is the number of deletions, insertions, or substitutions required to
		 * transform a source into a target.
		 *
		 * @param source The source string.
		 * @param target The target string.
		 */
		public static function editDistance(source:String, target:String):uint 
		{
			var i:Number;
			var j:Number;
			if(source==null || target==null) source='';
			if(source==target) return 0;
			var d:Array=new Array();
			var cost:uint;
			var n:uint=source.length;
			var m:uint=target.length;
			if(n==0) return m;
			if(m==0) return n;
			i=0;
			for(;i<=n;i++)d[int(i)]=new Array();
			i=0;
			for(;i<=n;i++)d[int(i)][0]=int(i);
			i=0;
			for(;j<=m;j++)d[0][int(j)]=int(j);
			i=1;
			for(;i<=n;i++)
			{
				var s_i:String=source.charAt(i-1);
				j=1;
				for(;j<=m;j++) 
				{
					var t_j:String=target.charAt(int(j)-1);
					if(s_i==t_j) cost=0; 
					else cost=1;
					d[int(i)][int(j)]=_minimum(d[int(i)-1][int(j)]+1,d[int(i)][int(j)-1]+1,d[int(i)-1][int(j)-1]+cost);
				}
			}
			return d[n][m];
		}

		/**
		 * Swaps the casing of a string.
		 *
		 * @param str The source string.
		 */
		public static function swapCase(str:String):String 
		{
			if(str == null) return null;
			return str.replace(/(\w)/,_swapCase);
		}

		/**
		 * Removes all &lt; and &gt; based tags from a string
		 *
		 * @param str The source string.
		 */
		public static function stripTags(str:String):String 
		{
			if(str == null) return null;
			return str.replace(/<\/?[^>]+>/igm,'');
		}

		/**
		 * Determines the number of words in a string.
		 *
		 * @param str The string.
		 */
		public static function wordCount(str:String):uint
		{
			if(str == null) return 0;
			return str.match(/\b\w+\b/g).length;
		}

		/**
		 * Returns a string truncated to a specified length with optional suffix
		 *
		 * @param str The string.
		 * @param len The length the string should be shortend to.
		 * @param suffix The string to append to the end of the truncated string.
		 */
		public static function truncate(str:String, len:uint, suffix:String="..."):String 
		{
			if(str == null) return '';
			if(!len) len=str.length;
			len -= suffix.length;
			var trunc:String=str;
			if(trunc.length > len) 
			{
				trunc=trunc.substr(0,len);
				if(/[^\s]/.test(str.charAt(len))) trunc=trimRight(trunc.replace(/\w+$|\s+$/,''));
				trunc += suffix;
			}
			return trunc;
		}

		/**
		 * Search for key in string.
		 * 
		 * @param str The target string.
		 * @param key The key to search for.
		 * @param caseSensitive Whether or not the search is case sensitive.
		 */
		public static function search(str:String,key:String,caseSensitive:Boolean=true):Boolean
		{
			if(!caseSensitive)
			{
				str=str.toUpperCase();
				key=key.toUpperCase();
			}
			return (str.indexOf(key) <= -1) ? false : true;
		}

		/**
		 * Does a case insensitive compare with two strings.
		 * 
		 * @param s1 The first string.
		 * @param s2 The second string.
		 * @param caseSensitive Whether or not the comparison is case sensitive.
		 */
		public static function equals(s1:String, s2:String, caseSensitive:Boolean=false):Boolean
		{
			return (caseSensitive) ? (s1 == s2) : (s1.toUpperCase() == s2.toUpperCase());
		}

		/**
		 * Replace every instance of a string with something else
		 * 
		 * @param str The string to search in.
		 * @param oldChar The pattern to be removed.
		 * @param newChar The new string to instert.
		 */
		public static function replace(str:String, oldChar:String, newChar:String):String
		{
			return str.split(oldChar).join(newChar);
		}		

		/**
		 * Remove spaces from a string.
		 * 
		 * @param str The target string.
		 */
		public static function removeSpaces(str:String):String
		{
			return replace(str," ","");
		}

		/**
		 * Remove tabs from a string.
		 * 
		 * @param str The target string.
		 */
		public static function removeTabs(str:String):String
		{
			return replace(str,"	","");	
		}

		/**
		 * Remove leading & trailing white space.
		 * 
		 * @param str The target string.
		 */
		public static function trim(str:String):String
		{
			return ltrim(rtrim(str));
		}

		/**
		 * Removes whitespace from the front of the specified string.
		 * 
		 * @param str The target string.
		 */	
		public static function ltrim(str:String):String
		{
			return str.replace(LTRIM_EXP,"");
		}

		/**
		 * Removes whitespace from the end of a string.
		 * 
		 * @param str The target string.
		 */
		public static function rtrim(str:String):String
		{
			return str.replace(RTRIM_EXP,"");
		}

		/**
		 * Remove whitespace, line feeds, carrige returns from a string.
		 * 
		 * @param str The target string.
		 */
		public static function trimall(str:String):String
		{
			var o:String="";
			var tab:Number=9;
			var linefeed:Number=10;
			var carriage:Number=13;
			var space:Number=32;
			var i:int=0;
			var char:int=str.charCodeAt(i);
			while(i > 0 && char != tab && char != linefeed && char != carriage && char != space)
			{
				o += char;
				i++;
				if(i > str.length) break;
				char=str.charCodeAt(i);
			}
			return o;
		}

		/**
		 * Lower Camel Case a string.
		 * 
		 * @param str The target string.
		 */
		public static function toLowerCamel(str:String):String
		{
			var o:String=new String();
			var i:int=0;
			var l:int=str.length;
			for(;i<l;i++)
			{
				if(str.charAt(i)!=" ")
				{
					if(justPassedSpace)
					{
						o+=str.charAt(int(i)).toUpperCase();
						justPassedSpace=false;
					}
					else o+=str.charAt(int(i)).toLowerCase();
				}
				else var justPassedSpace:Boolean=true;
			}
			return o;
		}

		/**
		 * Determines whether the specified string begins with the specified prefix.
		 * 
		 * @param input The string to search.
		 * @param prefix The prefix that will be tested against the string.
		 */
		public static function beginsWith(input:String, prefix:String):Boolean
		{			
			return (prefix == input.substring(0,prefix.length));
		}

		/**
		 * Determines whether the specified string ends with the specified suffix.
		 * 
		 * @param input The string to search.
		 * @param prefix The suffic that will be tested against the string.
		 */
		public static function endsWith(input:String, suffix:String):Boolean
		{
			return (suffix == input.substring(input.length - suffix.length));
		}			

		/**
		 * Format a number with commas - ie. 10000 -> 10,000
		 * 
		 * @param nm A Number or a String that will cast to a Number.
		 */
		public static function commaFormatNumber(nm:Object):String
		{
			var tmp:String=String(nm);
			var outString:String="";
			var l:int=tmp.length;
			var i:int=0;
			for(;i<l;i++)
			{
				if(int(i)%3==0&&int(i)>0)outString=","+outString;
				outString=tmp.substr(l-(int(i)+1),1)+outString;
			}
			return outString;		
		}

		/**
		 * Capitalize the first character in the string.
		 * 
		 * @param str The string.
		 */
		public static function firstToUpper(str:String):String
		{
			return str.charAt(0).toUpperCase() + str.substr(1);
		}	

		/**
		 * Transforms source String to per word capitalization.
		 * 
		 * @param str The target string.
		 */
		public static function toTitleCase(str:String):String
		{
			var lstr:String=str.toLowerCase();
			return lstr.replace(/\b([a-z])/g,function($0:*):*{return $0.toUpperCase();});
		}

		/**
		 * Encode HTML.
		 * 
		 * @param s The target string that has HTML in it.
		 */
		public static function htmlEncode(s:String):String
		{
			s=replace(s," ","&nbsp;");
			s=replace(s,"&","&amp;");
			s=replace(s,"<","&lt;");
			s=replace(s,">","&gt;");
			s=replace(s,"™",'&trade;');
			s=replace(s,"®",'&reg;');
			s=replace(s,"©",'&copy;');
			s=replace(s,"€","&euro;");
			s=replace(s,"£","&pound;");
			s=replace(s,"—","&mdash;");
			s=replace(s,"–","&ndash;");
			s=replace(s,"…","&hellip;");
			s=replace(s,"†","&dagger;");
			s=replace(s,"·","&middot;");
			s=replace(s,"µ","&micro;");
			s=replace(s,"«","&laquo;");	
			s=replace(s,"»","&raquo;");
			s=replace(s,"•","&bull;");
			s=replace(s,"°","&deg;");
			s=replace(s,'"',"&quot;");
			return s;
		}

		/**
		 * Decode HTML.
		 * 
		 * @param s The target string that has HTML in it.
		 */
		public static function htmlDecode(s:String):String
		{
			s=replace(s,"&nbsp;"," ");
			s=replace(s,"&amp;","&");
			s=replace(s,"&lt;","<");
			s=replace(s,"&gt;",">");
			s=replace(s,"&trade;",'™');
			s=replace(s,"&reg;","®");
			s=replace(s,"&copy;","©");
			s=replace(s,"&euro;","€");
			s=replace(s,"&pound;","£");
			s=replace(s,"&mdash;","—");
			s=replace(s,"&ndash;","–");
			s=replace(s,"&hellip;",'…');
			s=replace(s,"&dagger;","†");
			s=replace(s,"&middot;",'·');
			s=replace(s,"&micro;","µ");
			s=replace(s,"&laquo;","«");	
			s=replace(s,"&raquo;","»");
			s=replace(s,"&bull;","•");
			s=replace(s,"&deg;","°");
			s=replace(s,"&ldquo",'"');
			s=replace(s,"&rsquo;","'");
			s=replace(s,"&rdquo;",'"');
			s=replace(s,"&quot;",'"');
			return s;
		}		

		/**
		 * Sanitize <code>null</code> strings for display purposes.
		 * 
		 * @param str The string.
		 */
		public static function sanitizeNull(str:String):String
		{
			return (str == null || str == "null") ? "" : str;
		}

		/**
		 * Strip the zero off floated numbers.
		 * 
		 * @param n The target number.
		 */	
		public static function stripZeroOnFloat(n:Number):String
		{
			var str:String="";
			var a:Array=String(n).split(".");
			if(a.length > 1) str=(a[0] == "0") ? "." + a[1] : String(n);
			else str=String(n);
			return str;
		}

		/**
		 * Add zero in front of floated number.
		 * 
		 * @param n The target number.
		 */
		public static function padZeroOnFloat(n:Number):String
		{
			return (n > 1 || n < 0) ? String(n) : ("0." + String(n).split(".")[1]);
		}

		/**
		 * Remove scientific notation from very small floats when casting to String.
		 * 
		 * @param n The target number.
		 * 
		 * @example Using the StringUtils.floatToString method:
		 * <listing>	
		 * trace(String(0.0000001)); //returns 1e-7
		 * trace(StringUtils.floatToString(0.0000001)); //returns .00000001
		 * </listing>
		 */
		public static function floatToString(n:Number):String
		{
			var s:String=String(n);
			return (n < 1 && (s.indexOf(".") <= -1 || s.indexOf("e") <= -1)) ? "0." + String(n + 1).split(".")[1] : s;
		}

		/**
		 * Strip the zero off floated numbers and remove Scientific Notation.
		 * 
		 * @param n The target number.
		 */
		public static function stripZeroAndRepairFloat(n:Number):String
		{
			var str:String;
			var tmp:String;
			var isZeroFloat:Boolean;
			// +=1 to prevent scientific notation.
			if(n < 1)
			{
				tmp=String((n + 1));
				isZeroFloat=true;
			}
			else
			{
				tmp=String(n);
				isZeroFloat=false;	
			}
			// if we have a float strip the zero (or +=1) off!
			var a:Array=tmp.split(".");
			if(a.length > 1) str=(a[0] == "1" && isZeroFloat == true) ? "." + a[1] : tmp;				
			else str=tmp;
			return str;
		}

		/**
		 * Generate a set of random characters.
		 * 
		 * @param amount The number of characters to generate.
		 */
		public static function randChar(amount:Number):String
		{
			var str:String="";
			var i:int=0;
			var l:int=int(amount);
			for(;i<l;i++)str+=String.fromCharCode(Math.round(Math.random()*(126-33))+33);
			return str;
		}

		/**
		 * Generate a set of random LowerCase characters.
		 * 
		 * @param amount The number of characters to generate.
		 */	
		public static function randLowerChar(amount:Number):String
		{
			var str:String="";
			var i:int=0;
			var l:int=int(amount);
			for(;i<l;i++)str+=String.fromCharCode(Math.round(Math.random()*(122-97))+97);
			return str;
		}

		/**
		 * Generate a set of random Number characters.
		 * 
		 * @param amount The amount of numbers to generate.
		 */		
		public static function randNum(amount:Number):String
		{
			var str:String="";
			var i:int=0;
			var l:int=int(amount);
			for(;i<l;i++)str+=String.fromCharCode(Math.round(Math.random()*(57-48))+48);
			return str;
		}

		/**
		 * Generate a set of random Special and Number characters.
		 * 
		 * @param amount The number of characters to generate.
		 */		
		public static function randSpecialChar(amount:Number):String
		{
			var str:String="";
			var i:int=0;
			var l:int=int(amount);
			for(;i<l;i++)str+=String.fromCharCode(Math.round(Math.random()*(64-33))+33);
			return str;
		}

		/**
		 * Detect HTML line breaks (&gt;br&lt;).
		 * 
		 * @param str The target string.
		 */
		public static function hasBr(str:String):Boolean
		{
			return (str.split("<br").length>0)?true:false;
		}

		/**
		 * Convert single quotes to double quotes.
		 * 
		 * @param str The target string.
		 */
		public static function toDoubleQuote(str:String):String
		{
			var sq:String="'";
			var dq:String=String.fromCharCode(34);
			return str.split(sq).join(dq);
		}

		/**
		 * Convert double quotes to single quotes.
		 * 
		 * @param str The target string.
		 */
		public static function toSingleQuote(str:String):String
		{
			var sq:String="'";
			var dq:String=String.fromCharCode(34);
			return str.split(dq).join(sq);
		}

		/**
		 * Remove all formatting and return cleaned numbers from string.
		 * 
		 * @param str The target string.
		 * 
		 * @example	Using the StringUtils.toNumeric method:
		 * <listing>	
		 * StringUtils.toNumeric("123-123-1234"); //returns 1221231234 
		 * </listing>
		 */
		public static function toNumeric(str:String):String
		{
			var result:String="";
			var i:int=0;
			var l:int=str.length;
			for(;i<l;i++)
			{
				var code:Number=str.charCodeAt(int(i));
				if(code>=48&&code<=57) result+=str.substr(int(i),1);
			}
			return result;
		}

		/**
		 * Find the file type from a source path.
		 * 
		 * @param source A full file url or path.
		 */
		public static function findFileType(source:String):String
		{
			var fileType:String;
			var filenameRegEx:RegExp=new RegExp("\.([a-zA-Z0-9]{1,4}$)","i");
			var filematch:Array=source.match(filenameRegEx);
			if(filematch) fileType=filematch[1].toLowerCase();
			if(!fileType) return null;
			else return fileType;
		}
		
		/**
		 * Validate a credit card's expiration date.
		 * 
		 * @param month The month.
		 * @param year The year.
		 */
		public function isValidCCExDate(month:int, year:int):Boolean 
		{
			var d:Date=new Date();
			var currentMonth:int=d.getMonth() + 1;
			var currentYear:int=d.getFullYear();
			if((year > currentYear) || (year == currentYear && month >= currentMonth)) return true;
			return false;
		}

		/**
		 * Validate a credit card number.
		 * 
		 * @param strNumber Credit card number as string.
		 */
		public static function isValidCCNumber(strNumber:String):Boolean
		{
			var ccNumber:String=StringUtils.toNumeric(strNumber);
			if(ccNumber.length > 0 && !isNaN(ccNumber as Number) && (ccNumber.length >= MINIMUM_CARD_LENGTH && ccNumber.length <= MAXIMUM_CARD_LENGTH))
			{
				var aNumbers:Array=strNumber.split("");
				var nSum_1:Number=0;
				var nSum_2:Number=0;
				var nSum_Total:Number=0;
				var nParity:Number=aNumbers.length % 2;
				var i:int=0;
				var l:int=aNumbers.length;
				for(;i<l;i++)
				{
					var n:Number=Number(aNumbers[int(i)]);
					if(int(i)%2==nParity) 
					{
						n*=2;
						n=n>9?n-9:n;
						nSum_1+=n;
					}
					else nSum_2+=n;
				}
				nSum_Total=nSum_1+nSum_2;
				return (nSum_Total%10==0);
			} 
			return false;
		}

		/**
		 * Encode a credit card number as a string and encode all digits except the last <em></code>digitsShown</code></em>.
		 * 
		 * @param strNumber	credit card number as string
		 * @param digitsShown display this many digits at the end of the card number for security purposes
		 * @param encodeChar optional encoding character to use instead of default '*'
		 */
		public static function encodeNumber(strNumber:String, digitsShown:uint=DEFAULT_ENCODE_DIGITS_SHOWN, encodeChar:String=DEFAULT_ENCODE_CHARACTER):String 
		{
			var encoded:String="";
			var i:int=0;
			var l:int=strNumber.length;
			for(;i<l-digitsShown;i++) encoded+=encodeChar;
			encoded+=strNumber.slice(-digitsShown);
			return encoded;
		}
		
		/**
		 * Convert string or number to boolean
		 * 
		 * @param s The string ("1", "0", "true", "false", "yes", "no", "on", "off").
		 * 
		 * @example Using toBoolean:
		 * <listing>	
		 * var b:Boolean=StringUtils.toBoolean("true");
		 * </listing>
		 */
		public static function toBoolean(s:String):Boolean
		{
			var b:String=String(s).toLowerCase();
			if(b == "1" || b == "true" || b == "yes" || b == "on") return true;
			else if (b == "0" || b == "false" || b == "no" || b == "off") return false; 
			else throw new Error("StringUtils.toBoolean() could not convert input to a proper Boolean value");
		}		
				
		/**
		 * @private
		 * only used internally, see gs.util.Assertions for a public version.
		 */
		private static function contains(p_string:String, p_char:String):Boolean 
		{
			if(p_string == null) return false;
			return p_string.indexOf(p_char) != -1;
		}
		
		/**
		 * @private
		 */
		private static function escapePattern(p_pattern:String):String 
		{
			// RM: might expose this one, I've used it a few times already.
			return p_pattern.replace(/(\]|\[|\{|\}|\(|\)|\*|\+|\?|\.|\\)/g,'\\$1');
		}
		
		/**
		 * @private
		 */
		private static function _minimum(a:uint, b:uint, c:uint):uint 
		{
			return Math.min(a,Math.min(b,Math.min(c,a)));
		}
		
		/**
		 * @private
		private function _quote(p_string:String, ...args):String
		{
			switch (p_string)
			{
				case "\\":
					return "\\\\";
				case "\r":
					return "\\r";
				case "\n":
					return "\\n";
				case '"':
					return '\\"';
				default:
					return '';
			}
		}*/
		
		/**
		 * @private
		 */
		private static function _upperCase(p_char:String, ...args):String 
		{
			return p_char.toUpperCase();
		}

		/**
		 * @private
		 */
		private static function _swapCase(p_char:String, ...args):String 
		{
			var lowChar:String=p_char.toLowerCase();
			var upChar:String=p_char.toUpperCase();
			switch (p_char) 
			{
				case lowChar:
					return upChar;
				case upChar:
					return lowChar;
				default:
					return p_char;
			}
		}
	}
}