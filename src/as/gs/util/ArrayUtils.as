package gs.util
{
		
	/**
	 * The ArrayUtils class contains utility methods for arrays.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class ArrayUtils 
	{
		
		/**
		 * Clones an array.
		 * 
		 * @param array The array to clone.
		 */
		public static function clone(array:Array):Array
		{
			//fast! - http://agit8.turbulent.ca/bwp/2008/08/04/flash-as3-optimization-fastest-way-to-copy-an-array/
			if(!array) throw new ArgumentError("The array cannot be null");
			return array.concat();
		}
		
		/**
		 * Insert an element into an array at a specific index.
		 * 
		 * @param a The array to insert an element into.
		 * @param element The object to insert.
		 * @param index The index the object will be inserted into.
		 */
		public static function insert(a:Array, element:Object, index:int):Array 
		{
			var aA:Array=a.slice(0,index - 1);
			var aB:Array=a.slice(index,a.length - 1);
			aA.push(element);
			return merge(aA,aB);
		}

		/**
		 * Remove all instances of an element from an array.
		 * 
		 * @param a The array to search and remove from.
		 * @param element The element to remove from the array.
		 */
		public static function remove(a:Array, element:Object):Array 
		{
			var l:int=a.length;
			var k:int=0;
			for(k;k<l;k++)if(a[k]===element) a.splice(k,1);
			return a;
		}

		/**
		 * Determines if a value exists within the array.
		 * 
		 * @param a The array to search.
		 * @param val The element to search for.
		 */			
		public static function contains(a:Array, element:Object):Boolean 
		{
			return(a.indexOf(element) != -1);
		}

		/**
		 * Shuffle array elements.
		 * 
		 * @param a The array to shuffle.
		 */
		public static function shuffle(a:Array):void 
		{
			var l:int=a.length;
			var i:int=0;
			var rand:int;
			for(;i<l;i++)
			{
				var tmp:* =a[int(i)];
				rand=int(Math.random()*l);
				a[int(i)]=a[rand];
				a[int(rand)]=tmp;
			}
		}

		/**
		 * Create a new array that contains unique instances of objects.
		 * This can be used to remove duplication object instances from an array.
		 * 
		 * @param a The array to uniquely copy.
		 */
		public static function uniqueCopy(a:Array):Array 
		{
			var newArray:Array=new Array();
			var len:int=a.length;
			var item:Object;
			var i:int=0;
			for(;i<len;++i) 
			{
				item=a[int(i)];
				if(contains(newArray,item)) continue;
				newArray.push(item);
			}
			return newArray;
		}
		
		/**
		 * Determine if one array is identical to the other array.
		 * 
		 * @param arr1 The first array.
		 * @param arr2 The second array.
		 */
		public static function equals(arr1:Array, arr2:Array):Boolean 
		{
			if(arr1.length!=arr2.length) return false;
			var l:int=arr1.length;
			var i:int=0;
			for(;i<l;i++) if(arr1[int(i)] !== arr2[int(i)]) return false;
			return true;
		}

		/**
		 * Merge two arrays into one.
		 * 
		 * @param a The first array.
		 * @param b The second array.
		 */
		public static function merge(a:Array, b:Array):Array
		{
			var c:Array=b.concat();
			var i:int=a.length-1;
			for(;i>-1;i--)c.unshift(a[int(i)]);
			return c;
		}	

		/**
		 * Swap two element's positions in an array.
		 * 
		 * @param a The target array in which the swap will occur.
		 * @param index1 The first index.
		 * @param index2 The second index.
		 */
		public static function swap(a:Array, index1:int, index2:int):Array
		{
			if(index1>=a.length||index1<0) 
			{
				throw new Error("Index A {"+index1+"} is not a valid index in the array.");
				return a;
			}
			if(index2>=a.length||index2<0) 
			{
				throw new Error("Index B {"+index2+"} is not a valid index in the array.");
				return a;
			}
			var el:Object=a[index1];
			a[index1]=a[index2];
			a[index2]=el;
			return a;
		}	
		
		/**
		 * Remove duplicates from an array and return a new array.
		 * 
		 * @param a The array to remove duplicates from.
		 */
		public static function removeDuplicate(a:Array):Array 
		{
			a.sort();
			var o:Array=new Array();
			var l:int=a.length;
			var i:int=0;
			for(;i<l;i++)if(a[int(i)]!=a[int(i)+1])o.push(a[int(i)]);
			return o;
		}

		/**
		 * Compares two arrays to see if any two indexes have the same
		 * value as the other array.
		 * 
		 * @param a The first array.
		 * @param b The second array.
		 */	
		public static function matchValues(a:Array, b:Array):Boolean 
		{
			var f:int=0;
			var l:int=0;
			var al:int=a.length;
			var bl:int=b.length;
			for(f;f<al;f++)for(l;l<bl;l++)if(b[l].toLowerCase()===a[f].toLowerCase()) return true;
			return false;
		}

		/**
		 * Compare two arrays to see if their values (and optionally order) are identical.
		 * 
		 * @param ordered Whether or not the arrays will be sorted before the compare is performed.
		 * 
		 * @example Using ArrayUtils.compare:
		 * <listing>	
		 * var a:Array=[5,4,3,2,1,'C','B','A'];
		 * var b:Array=['A','B','C',1,2,3,4,5];
		 * trace("arrays (unordered) compare: " + ArrayUtil.compare(a,b)); //true
		 * trace("arrays (ordered) compare: " + ArrayUtil.compare(a,b,true)); //false
		 * </listing>
		 */
		public static function compare(a:Array, b:Array, ordered:Boolean=false):Boolean
		{
			var c:Array=(ordered) ? a : a.concat().sort(Array.DESCENDING);
			var d:Array=(ordered) ? b : b.concat().sort(Array.DESCENDING);
			if(c.length != d.length) return false;
			var l:int=c.length;
			var i:int=0;
			for(;i<l;i++)if(c[int(i)]!==d[int(i)]) return false;
			return true;
		}

		/**
		 * Search for a unique property/value match in an array of complex objects.
		 * 
		 * @param a An array of objects.
		 * @param prop The object property who's value will be tested.
		 * @param val The value to match.
		 * @param caseInsensitive Whether or not <em><code>prop</code></em> and <code>val</code> should be case-insensitive (only if search <em><code>val</code></em> is a <code>String</code>).
		 */
		public static function locatePropVal(a:Array, prop:String, val:Object, caseInsensitive:Boolean=false):Object 
		{
			for(var o:String in a)
			{
				if(!caseInsensitive)if(a[o][prop] == val)return a[o];
				else if(a[o][prop].toUpperCase()==String(val).toUpperCase())return a[o];
			}
			return null;
		}	

		/**
		 * Search for a unique property/value match in an array of
		 * complex objects and return its index in the array.
		 * 
		 * @param a An array of objects.
		 * @param prop The object property who's value will be tested.
		 * @param val The value to match.
		 * @param caseInsensitive Whether or not <em><code>prop</code></em> and <code>val</code> should be case-insensitive (only if search <em><code>val</code></em> is a <code>String</code>).
		 */
		public static function locatePropValIndex(a:Array, prop:String, val:Object, caseInsensitive:Boolean=false):int 
		{
			var l:int=a.length;
			var i:int=0;
			for(;i<l;i++)
			{
				if(!caseInsensitive)if(a[int(i)][prop]==val)return i;
				else if(a[int(i)][prop].toUpperCase()==String(val).toUpperCase())return i;
			}
			return -1;
		}

		/**
		 * Return a new array sliced from the original array of complex objects
		 * based on a <code>prop</code>/<code>val</code> match
		 * 
		 * @param a An array of objects.
		 * @param prop The object property who's value will be tested.
		 * @param val The value to match.
		 * @param caseInsensitive Whether or not <em><code>prop</code></em> and <code>val</code> should be case-insensitive (only if search <em><code>val</code></em> is a <code>String</code>).
		 */
		public static function sliceByPropVal(a:Array, prop:String, val:Object, caseInsensitive:Boolean=false):Array 
		{
			var ma:Array=new Array();
			for(var o :String in a) 
			{
				if(!caseInsensitive) if(a[o][prop]==val) ma.push(a[o]); 
				else if(a[o][prop].toUpperCase()==String(val).toUpperCase()) ma.push(a[o]);
			}
			return ma;
		}	

		/**
		 * Locate and return the (lowest) nearest neighbor or matching value in a <code>NUMERIC</code> sorted array of Numbers.
		 * 
		 * @param val the value to find match or find nearst match of.
		 * @param range of values in array.
		 * @param returnIndex if <code>true</code> return the array index of the neighbor, if <code>false</code> return the value of the neighbor.
		 * 
		 * @example Using ArrayUtils.nearestNeighbor:
		 * <listing>
		 * var a:Array=[1, 3, 5, 7, 9, 11];
		 * var nearestLow:Number=ArrayUtil.nearestNeighbor(4,a); //returns 3 (value)
		 * var nearestHigh:Number=ArrayUtil.nearestNeighbor(4,a,true); //returns 1 (index)
		 * </listing>
		 */
		public static function nearestNeighbor(val:Number,range:Array,returnIndex:Boolean=false):Number
		{
			var nearest:Number=range[0];
			var index:uint=0;
			var l:int=range.length;
			var i:int=1;
			for(;i<l;i++) 
			{
				if(Math.abs(range[int(i)] - val) < Math.abs(nearest-val))
				{
					nearest=range[int(i)];
					index=i;
				}
			}
			return (!returnIndex) ? nearest : index;
		}

		/**
		 * Return the array index of the minimum value in a numeric array.
		 * 
		 * @param a The array to search.
		 */
		public static function minIndex(a:Array):int
		{
			var i:int=a.length;
			var min:Number=a[0];
			var idx:int=0;
			while(i-- > 1)if(a[i] < min) min=a[idx=i];
			return idx;
		}

		/**
		 * Return the array index of the maximum value in a numeric array.
		 * 
		 * @param a The array to search.
		 */	
		public static function maxIndex(a:Array):int 
		{
			var i:int=a.length;
			var max:Number=a[0];
			var idx:int=0;
			while(i-- > 1) if(a[i] > max) max=a[idx=i];
			return idx;	
		}

		/**
		 * Return the minimum value in a numeric array.
		 * 
		 * @param a The array to search.
		 */	
		public static function minValue(a:Array):Number 
		{
			if(a.length==0) return 0;
			return a[minIndex(a)];
		}

		/**
		 * Return the maximum value in a numeric array.
		 * 
		 * @param a The array to search.
		 */	
		public static function maxVal(a:Array):Number
		{
			if(a.length==0) return 0;
			return a[maxIndex(a)];
		}
		
		/**
		 * Advanced array searching with complex matching conditions.
		 * 
		 * <span class="hide">
		 * <ul>
		 * <li>Class</li><li>If the actual value is a Class then they are compared with ===, else the actual value will be checked to see if it <code>is</code> of the Class type.</li> 
		 * <li>Function</li><li>If the actual value is a Function then they are compared with ===, else the expected function is called with the item and the actual value as parameters. This function needs to return a Boolean. eg <code>var condtions:Object={ someProperty: function(item:*, actual:*):Boolean {return actual != null;}}</code></li>
		 * <li>RegExp</li><li>If the actual value is a RegExp then they are compared with ===, else the actual value is tested with the RegExp.</li>
		 * </ul>
		 * </span>
		 * 
		 * @example Example uses.
		 * <listing>		
		 * var movies:Array=[]; //retrieve from some datasource
		 * 
		 * var at:ArrayUtils=ArrayUtils.gi();
		 * 
		 * //find with simple property value condition
		 * var moviesByMichaelBay:Array=at.asearch(movies,{director:'Michael Bay'});
		 * 
		 * //find with property chain condition (assuming the 'released' property returns a Date instance)
		 * var moviesByMichaelByReleasedIn2007:Array=at.asearch(moviesByMichaelBay,{'released.fullYear':2007});
		 * 
		 * //find only the first object.
		 * var moviesByMichaelByReleasedIn2007:Array=at.asearch(moviesByMichaelBay,{'released.fullYear':2007,{find:"first"}});
		 * 
		 * //find only the last object.
		 * var moviesByMichaelByReleasedIn2007:Array=at.asearch(moviesByMichaelBay,{'released.fullYear':2007,{find:"last"}});
		 * 
		 * //find all objects that match (this is the default if no options are provided).
		 * var moviesByMichaelByReleasedIn2007:Array=at.asearch(moviesByMichaelBay,{'released.fullYear':2007,{find:"all"}});
		 * 
		 * //find with class condition - Drama is a class., so any movies[i].genre that is of type Drama, will match and be returned.
		 * var moviesThatAreClass:Array=at.asearch(movies,{genre:Drama});
		 * 
		 * //find with Function condition.
		 * var moviesWithAverageRatings:Array=at.asearch(movies,{rating:function(item:Movie,actual:Number):Boolean{return actual > 2.4 && actual < 3.7;}});
		 * 
		 * //find with RegExp.
		 * var moviesTheBeginWithTr:Array=at.asearch(movies,{name:new RegExp('^Tr.*')});
		 * 
		 * //find with sub-array query (assuming the 'cast' property returns an Array of Actors with the property 'name').
		 * var moviesWithMeganFox:Array=at.asearch(movies,{'cast.name':'Megan Fox'});
		 * </listing>
		 * 
		 * <p>Supported properties in the "options" parameter.</p>
		 * 
		 * <ul>
		 * <li>find</li><li>Specify a find option, can be "all","first", or "last".</li>
		 * </ul>
		 */
		public static function asearch(array:Array,conditions:Object,options:Object=null):*
		{
			if(conditions is Function) return array.filter(conditions as Function);
			if(!options) options={find:"all"};
			var i:int, n:int, item:*;
			if(options.find == "first")
			{
				i=0;
				n=array.length;
				while(i < n) if(asearchMatches(item=array[i++],conditions)) return item;
				return null;
			}
			if(options.find == "last")
			{
				i=array.length - 1;
				n=0;
				while(i >= n) if(asearchMatches(item=array[i--],conditions)) return item;
				return null;
			}
			return array.filter(function(item:Object, index:int, array:Array ):Boolean 
			{
				if(!item) throw new Error("Missing item from array.filter");
				return asearchMatches(array[index],conditions);
			});
		}

		/**
		 * Shortcut for advanced searching for the first matching item.
		 * 
		 * @param array The array to search in.
		 * @param conditions An object defining the conditions to use in the search.
		 */
		public static function asearchFirst(array:Array,conditions:Object):*
		{
			return asearch(array,conditions,{find:"first"});
		}

		/**
		 * Shortcut for advanced searching for the last matching item.
		 * 
		 * @param array The array to search in.
		 * @param conditions An object defining the conditions to use in the search.
		 */
		public static function asearchLast(array:Array,conditions:Object):*
		{
			return asearch(array,conditions,{find:"last"});
		}

		/**
		 * Shortcut for advanced searching by a single property.
		 * 
		 * @param array The array to search in.
		 * @param conditions An object defining the conditions to use in the search.
		 */
		public static function asearchAll(array:Array,conditions:Object):Array
		{
			return asearch(array,conditions,{find:"all"}) as Array;
		}

		/**
		 * Shortcut for advanced searching by a single property.
		 * 
		 * @param array The array to search in.
		 * @param property The property to read.
		 * @param value The value of the target property.
		 * @param options Find An object with find property. {find:"first"|"last"|"all"}.
		 */
		public static function asearchBy(array:Array,property:String,value:*,options:Object=null):*
		{
			var conditions:Object={};
			conditions[ property ]=value;
			return asearch(array,conditions,options);
		}

		/**
		 * Checks it the item matches the conditions.
		 */	
		private static function asearchMatches(item:Object,conditions:Object):Boolean 
		{
			for(var property:String in conditions) 
			{
				var expectedValue:Object=conditions[property];
				var actualValue:Object;
				if(property.indexOf('.') > -1)
				{
					actualValue=item;
					var propertyChain:Array=property.split('.');
					var chainLength:int=propertyChain.length;
					var linkIndex:int=0;
					var propertyLink:String='';
					//todo: revert this to the nicer array.every style
					//var validChain:Boolean=propertyChain.every(function( propertyLink:String, index:int, array:Array ):Boolean
					var validChain:Boolean=false;
					while(linkIndex < chainLength)
					{
						//trace( 'matches.propertyChain:', item, linkIndex, '/', chainLength,
						//actualValue, propertyLink,
						//actualValue.hasOwnProperty( propertyLink ) ? actualValue[ propertyLink ] : 'null' );
						propertyLink=propertyChain[linkIndex];
						if(!actualValue.hasOwnProperty(propertyLink)) break;
						actualValue=actualValue[propertyLink];
						if(linkIndex==(chainLength-1)) //valid if we made it to the last link its valid
						{
							validChain=true;
							break;
						}
						linkIndex++;
					}
					//dont match if the chain isnt valid
					if(!validChain)
					{
						//if links remain in the property chain, check if actualValue is an Array, 
						//then see if there are items in that array that match
						if(actualValue is Array) 
						{
							//true if there are any items that match the remaining pieces
							//its safe to bail out on the first found item
							conditions={};
							conditions[propertyChain.slice(linkIndex).join('.')]=expectedValue;
							var found:Object=asearchFirst(actualValue as Array,conditions);
							return found ? true : false;
						}
						return false;
					}
				}
				else 
				{
					if(!item.hasOwnProperty(property)) return false;		
					actualValue=item[property];
				}
				if(!asearchMatchesValue(item,expectedValue,actualValue)) return false;		
			}
			return true;
		}

		/**
		 * Checks if a value matches the expected value
		 */
		private static function asearchMatchesValue(item:*,expected:*,actual:*):Boolean
		{
			//class matcher.
			if((actual is Class) && (expected is Class)) return ((actual as Class)===(expected as Class));
			if((expected is Class)) return (actual is expected);
			
			//function matcher
			if((actual is Function) && (expected is Function)) return ((actual as Function)===(expected as Function)); 
			if(expected is Function) return (expected as Function)(item,actual);
			
			//regexp matcher
			if((actual is RegExp) && (expected is RegExp)) return ((actual as RegExp)===(expected as RegExp));
			if((actual is String) && (expected is RegExp)) return (expected as RegExp).test(actual as String);
			
			//literal matcher
			return (actual===expected);
		}
	}
}