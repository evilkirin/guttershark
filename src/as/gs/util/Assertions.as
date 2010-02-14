package gs.util 
{

	/**
	 * The Assertions class is a singleton that provides assertions for conditionals,
	 * and relieve's defensive programming for methods that require arguments.
	 * 
	 * <p>All of the methods can be used for conditional assertions.</p>
	 * @example Using assertions for conditionals:
	 * 
	 * <listing>	
	 * var t:String=" ";
	 * if(Assertions.emptyString(t)) trace("it's empty");
	 * t="word";
	 * if(Assertions.emptyString(t)) trace("doh"); //this wont trace, because the assertion evaluates to false.
	 * </listing>
	 * 
	 * <p>You can also use the assertion class as defense when checking for valid
	 * method arguments and throw errors.</p>
	 * 
	 * @example Using the assertions class for method argument defense:
	 * <listing>	
	 * function setSomething(val:Number):void
	 * {
	 *     Assertions.notNull(val,"Parameter val cannot be null"); //throws argument error if val is null
	 *     somthing=val;
	 * }
	 * </listing>
	 * 
	 * <p>You can also change the exception type that get's thrown if an assertion fails.</p>
	 * @example Changing the exception type:
	 * <listing>	
	 * function setSomething(mc:MovieClip):void
	 * {
	 *    Assertions.compatible(mc,MovieClip,"Parameter val must be a MovieClip",TypeError);
	 * }
	 * </listing>
	 * 
	 * @example	Extended example:
	 * <listing>	
	 * public class MyMC extends CoreClip
	 * {
	 *     
	 *     public function setSomeValue(value:Object):void
	 *     {
	 *         Assertions.notNil(value,"Parameter value cannot be null"); //argument error if value is null
	 *     }
	 *     
	 *     public function setSomeArray(array:Array):void
	 *     {
	 *         Assertions.notNilOrEmpty(array,"Parameter array cannot be null"); //argument error if array is null or length==0
	 *     }
	 * }
	 * </listing>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class Assertions
	{
		
		/**
		 * A function delegate you can define, which will
		 * be called when an assertion fails - this is intended
		 * to be used if you wanted to post the assertion
		 * to an http service for logging errors.
		 * 
		 * @example Using the onAssertionFail delegate:
		 * <listing>	
		 * Assertions.onAssertionFail=onAssertionFail;
		 * private function onAssertionFail(msg:String):void
		 * {
		 *     trace(msg);
		 * }
		 * </listing>
		 */
		public static var onAssertionFail:Function;
		
		/**
		 * Throws the error, depending on the exceptionType.
		 */
		private static function throwError(message:String, exceptionType:Class):void
		{
			try{if(onAssertionFail!==null) onAssertionFail(message);}
			catch(e:ArgumentError){trace("WARNING: Your onAssertionFail function must accept one parameter - a message string.");}
			switch(exceptionType)
			{
				case null:
					throw new ArgumentError(message);
					break;
				default:
					throw new exceptionType(message);
					break;
			}
		}
		
		/**
		 * Assert that a value is greater than a minimum number.
		 * 
		 * @param value The value to test.
		 * @param minimum The minimum number that the value must be greater than.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public static function greater(value:Number, minimum:Number=-1,message:String=null,exceptionType:Class=null):Boolean
		{
			if(message) if(value < minimum) throwError(message,exceptionType);
			return (value > minimum);
		}
		
		/**
		 * Assert that a value is smaller than a maximum number.
		 * 
		 * @param value The value to test.
		 * @param maximum The maximum number that the value must be smaller than.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public static function smaller(value:Number,maxmimum:Number=0,message:String=null,exceptionType:Class=null):Boolean
		{
			if(message) if(value > maxmimum) throwError(message,exceptionType);
			return (value < maxmimum);
		}
		
		/**
		 * Assert that a value is equal to another value.
		 * 
		 * @param value The value to test.
		 * @param otherValue The other value to compare with value (this is actually typed as &#42;, but asdocs changes it to String for some reason).
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public static function equal(value:*,otherValue:*,message:String=null,exceptionType:Class=null):Boolean
		{
			if(message) if(value!==otherValue) throwError(message,exceptionType);
			return (value===otherValue);
		}
		
		/**
		 * Assert that a value is defferent from another value.
		 * 
		 * @param value The value to test.
		 * @param otherValue The other value to compare with value (this is actually typed as &#42, but asdocs changes it to String for some reason).
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public static function different(value:*,otherValue:*,message:String=null,exceptionType:Class=null):Boolean
		{
			if(message) if(value===otherValue) throwError(message,exceptionType);
			return (value!==otherValue);
		}
		
		/**
		 * Assert if an Array is nil or empty.
		 * 
		 * @param array The array to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public static function nilOrEmpty(array:Array,message:String=null,exceptionType:Class=null):Boolean
		{
			if(message) if(!nil(array) && array.length>0) throwError(message,exceptionType);
			return (nil(array) || array.length==0);
		}
		
		/**
		 * Assert if an Array is not nil or empty.
		 * 
		 * @param array The array to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public static function notNilOrEmpty(array:Array, message:String=null,exceptionType:Class=null):Boolean
		{
			if(message) if(nil(array) || array.length==0) throwError(message,exceptionType);
			return !(nil(array) || array.length==0);
		}
		
		/**
		 * Assert if an object is nil.
		 * 
		 * @param obj The object to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public static function nil(obj:*,message:String=null,exceptionType:Class=null):Boolean
		{
			if(message) if(!(obj === null || obj === undefined || !obj)) throwError(message, exceptionType);
			if(obj === null || obj === undefined || !obj) return true;
			return false;
		}
		
		/**
		 * Assert if an object is not nil.
		 * 
		 * @param object The object to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public static function notNil(object:*,message:String=null,exceptionType:Class=null):Boolean
		{
			if(message) if(nil(object)) throwError(message,exceptionType);
			return !(nil(object));
		}
		
		/**
		 * Assert if an object is compatible with another type.
		 * 
		 * @param obj The object to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public static function compatible(obj:*,type:Class,message:String=null,exceptionType:Class=null):Boolean
		{
			if(message) if(!(obj is type)) throwError(message,exceptionType);
			return (obj is type);
		}
		
		/**
		 * Assert if an object is not compatible with another type.
		 * 
		 * @param obj The object to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public static function notCompatible(obj:*, type:Class, message:String=null,exceptionType:Class=null):Boolean
		{
			if(message) if((compatible(obj,type))) throwError(message,exceptionType);
			return (!(compatible(obj,type)));
		}
		
		/**
		 * Assert that a string contains another string.
		 * 
		 * @param str The string to search in.
		 * @param pat The pattern that will be searched for in str.
		 */
		public static function contains(str:String,pat:String,message:String=null,exceptionType:Class=null):Boolean
		{
			if(message) if(nil(str) || smaller(str.indexOf(pat),0)) throwError(message,exceptionType);
			if(nil(str)) return false;
			return !smaller(str.indexOf(pat),0);
		}
		
		/**
		 * Assert a string as being empty (zero characters or all spaces).
		 * 
		 * @param str The string to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public static function emptyString(str:String,message:String=null,exceptionType:Class=null):Boolean
		{
			var r:RegExp=/^ {0,}$/i;
			if(message) if(!r.test(str)) throwError(message,exceptionType);
			return r.test(str);
		}
		
		/**
		 * Assert a string as being not empty (zero characters or all spaces).
		 * 
		 * @param str The string to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public static function notEmptyString(str:String,message:String=null,exceptionType:Class=null):Boolean
		{
			var r:RegExp=/^ {0,}$/i;
			if(message) if(r.test(str)) throwError(message,exceptionType);
			return !r.test(str);
		}
		
		/**
		 * Assert that a string has all number characters.
		 * 
		 * @param str The string to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public static function numberString(str:String,message:String=null,exceptionType:Class=null):Boolean
		{
			var regx:RegExp=/^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
			if(message) if(nil(str) || (!regx.test(str))) throwError(message,exceptionType);
			if(nil(str)) return false;
			return regx.test(str);
		}
		
		/**
		 * Assert that a string does not have all number characters.
		 * 
		 * @param str The string to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public static function notNumberString(str:String,message:String=null,exceptionType:Class=null):Boolean
		{
			var regx:RegExp=/^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
			if(message) if(notNil(str) && (regx.test(str))) throwError(message,exceptionType);
			if(nil(str)) return true;
			return !regx.test(str);
		}
	}
}