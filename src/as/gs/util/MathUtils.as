package gs.util
{
	import gs.util.geom.Point;
	import gs.util.geom.Point3D;

	/**
	 * The MathUtils class contains various math functions.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class MathUtils
	{
		
		/**
		 * Byte value.
		 */
		protected static const BYTE:Number=8;
		
		/**
		 * Kilobit value.
		 */
		protected static const KILOBIT:Number=1024;
		
		/**
		 * Kilobyte value.
		 */
		protected static const KILOBYTE:Number=8192;
		
		/**
		 * Mega bit value.
		 */
		protected static const MEGABIT:Number=1048576;
		
		/**
		 * Megabyte value.
		 */
		protected static const MEGABYTE:Number=8388608;
		
		/**
		 * Gigabit value.
		 */
		protected static const GIGABIT:Number=1073741824;
		
		/**
		 * Gigabyte value.
		 */
		protected static const GIGABYTE:Number=8589934592;
		
		/**
		 * Terabit value.
		 */ 
		protected static const TERABIT:Number=1.099511628e+12;
		
		/**
		 * Terabyte value.
		 */
		protected static const TERABYTE:Number=8.796093022e+12;
		
		/**
		 * Petabit value.
		 */
		protected static const PETABIT:Number=1.125899907e+15;
		
		/**
		 * Petabyte value.
		 */
		protected static const PETABYTE:Number=9.007199255e+15;
		
		/**
		 * Exabit value.
		 */
		protected static const EXABIT:Number=1.152921505e+18;
		
		/**
		 * Exabyte value.
		 */
		protected static const EXABYTE:Number=9.223372037e+18;
		
		/** 
		 * String for quick lookup of a hex character based on index
		 */
		private static const HEX_CHARACTERS:String="0123456789abcdef";
		
		/**
		 * Rotates an integer left by <code>n</code> bits.
		 * 
		 * @param x The integer.
		 * @param n The number of bits to shift left.
		 */
		public static function rotateLeft(x:int,n:int):int
		{
			return (x<<n)|(x>>>(32-n));
		}
		
		/**
		 * Rotates an integer right by <code>n</code> bits.
		 * 
		 * @param x The integer.
		 * @param The number of bits to shift right.
		 */
		public static function rotateRight(x:int,n:int):uint
		{
			var nn:int=32 - n;
			return (x<<nn)|(x>>>(32-nn));
		}

		/**
		 * Outputs the (lowercase) hex value of a int, with optional endianness,
		 *
		 * @param n The integr value to output as hex.
		 * @param bigEndian Whether or not to convert in big endian order.
		 * @return The hex string, not including the 0x.
		 */
		public static function toHex(n:int,bigEndian:Boolean=false):String 
		{
			var s:String="";
			var i:int=0;
			var x:int=0;
			if(bigEndian) for(;i<4;i++)s+=HEX_CHARACTERS.charAt(( n >> ( ( 3 - int(i) ) * 8 + 4 ) ) & 0xF) + HEX_CHARACTERS.charAt(( n >> ( ( 3 - int(i) ) * 8 ) ) & 0xF);
			else for(x;x<4;x++) s+=HEX_CHARACTERS.charAt(( n >> ( int(x) * 8 + 4 ) ) & 0xF) + HEX_CHARACTERS.charAt(( n >> ( int(x) * 8 ) ) & 0xF);
			return s;
		}
		
		/**
		 * Returns the highest value of all passed arguments.
		 * 
		 * @param ...args Any list of numbers.
		 */
		public static function max(...args):Number
		{
			return args.sort()[-1];
		}

		/**
		 * Returns the lowest value of all passed arguments.
		 * 
		 * @param ...args Any list of numbers.
		 */
		public static function min(...args):Number
		{
			return args.sort()[0];
		}
		
		/**
		 * Returns the floor of a number, with optional decimal precision.
		 * 
		 * @param val The number.
		 * @param decimal How many decimals to include.
		 */
		public static function floor(val:Number, decimal:Number):Number
		{
			var n:Number=Math.pow(10,decimal);
			return Math.floor(val * n) / n;
		}	

		/**
		 * Round to a given amount of decimals.
		 * 
		 * @param val The number.
		 * @param decimal The decimal precision.
		 */
		public static function round(val:Number, decimal:Number):Number 
		{
			return Math.round(val*Math.pow(10,decimal))/Math.pow(10,decimal);
		}

		/**
		 * Returns a random number inside a specific range.
		 * 
		 * @param start The first number.
		 * @param end The end number.
		 */	
		public static function random(start:Number, end:Number):Number 
		{
			return Math.round(Math.random()*(end-start))+start;
		}

		/**
		 * Clamp constrains a value to the defined numeric boundaries.
		 * 
		 * @example
		 * <listing>		
		 * utils.math.clamp(20,2,5); //returns 5
		 * utils.math.clamp(3,2,5); //returns 3
		 * utils.math.clamp(3,1,5); //returns 3
		 * utils.math.clamp(1,10,20); //returns 10
		 * </listing>
		 * 
		 * @param val The number.
		 * @param min The minumum range.
		 * @param max The maximum range.
		 */
		public static function clamp(val:Number,min:Number,max:Number):Number
		{
			if(val < min) return min;
			if(val > max) return max;
			return val;
		}

		/**
		 * Similar to clamp & constrain but allows for <i>limit value wrapping</i>.
		 * 
		 * @param val The number.
		 * @param min The miniimum range.
		 * @param max The maximum range.
		 */
		public static function limit(val:Number, min:Number, max:Number, wrap:Boolean=false):Number
		{
			if(!wrap) return clamp(val,min,max);
			while(val > max) val -= (max - min);
			while(val < min) val += (max - min);
			return val;
		}		

		/**
		 * Return the distance between two x,y points.
		 * 
		 * @param x1 The first x position.
		 * @param y1 The first y position.
		 * @param x2 The second x position.
		 * @param y2 The second y position.
		 */
		public static function xyDistance(x1:Number,y1:Number,x2:Number,y2:Number):Number
		{
			var dx:Number=x1 - x2;
			var dy:Number=y1 - y2;
			return Math.sqrt(dx * dx + dy * dy);
		}		

		/**
		 * Return the proportional value of two pairs of numbers.
		 * 
		 * @param x1 The first x position.
		 * @param y1 The first y position.
		 * @param x2 The second x position.
		 * @param y2 The second y position.
		 */
		public static function proportion(x1:Number,y1:Number,x2:Number,y2:Number,x:Number=1):Number
		{
			var n:Number=(!x) ? 1 : x;
			var slope:Number=(y2 - y1) / (x2 - x1);
			return (slope * (n - x1) + y1);
		}

		/**
		 * Return a percentage based on the numerator and denominator.
		 * 
		 * @param amount The amount.
		 * @param total The total
		 * @param percentRange The percentage range that the calculation will scale to.
		 */
		public static function percent(amount:Number,total:Number,percentRange:int=100):Number
		{
			if(total == 0) return 0;
			return (amount / total * percentRange);
		}

		/**
		 * Check if number is positive (zero is positive).
		 * 
		 * @param n The number.
		 */
		public static function isPositive(n:Number):Boolean 
		{
			return (n >= 0);
		}

		/**
		 * Check if number is negative.
		 * 
		 * @param n The number.
		 */
		public static function isNegative(n:Number):Boolean 
		{
			return (n < 0);
		}	

		/**
		 * Check if number is odd (convert to Integer if necessary).
		 * 
		 * @param n The number.
		 */
		public static function isOdd(n:Number):Boolean 
		{
			var i:Number=new Number(n);
			var e:Number=new Number(2);
			return Boolean(i % e);
		}

		/**
		 * Check if number is even (convert to Integer if necessary).
		 * 
		 * @param n The number.
		 */
		public static function isEven(n:Number):Boolean 
		{
			return ((int(n) % 2) == 0);
			//var itn:Number=new Number(n);
			//var e:Number=new Number(2);
			//return (itn % e == 0);
		}

		/**
		 * Check if number is Prime (divisible only by itself and one).
		 * 
		 * @param n The number.
		 */
		public static function isPrime(n:Number):Boolean
		{
			if (n > 2 && n % 2 == 0) return false;
			var l:Number=Math.sqrt(n);
			var i:int=3;
			for(;i<=l;i+=2)if(n % int(i) == 0) return false;
			return true;
		}

		/**
		 * Calculate the factorial of the integer.
		 * 
		 * @param n The number.
		 */
		public static function factorial(n:Number):Number 
		{
			if(n == 0) return 1;
			var d:Number=n.valueOf();
			var i:Number=d - 1;
			while(i) 
			{
				d=d * i;
				i--;
			}
			return d;
		}

		/**
		 * Return an array of divisors of the integer.
		 * 
		 * @param n The number.
		 */
		public static function getDivisors(n:Number):Array 
		{
			var r:Array=new Array();
			for(var i:Number=1, e:Number=n / 2;i <= e; i++) if (n % i == 0) r.push(i);
			if (n != 0) r.push(n.valueOf());
			return r;
		}

		/**
		 * Check if number is an Integer.
		 * 
		 * @param n The number.
		 */
		public static function isInteger(n:Number):Boolean 
		{
			return (n % 1 == 0);
		}

		/**
		 * Check if number is Natural (positive Integer).
		 * 
		 * @param n The number.
		 */
		public static function isNatural(n:Number):Boolean 
		{
			return (n >= 0 && n % 1 == 0);
		}

		/**
		 * Correct "roundoff errors" in floating point math.
		 * 
		 * @param n The number.
		 * @param precision The floating point precision.
		 */
		public static function sanitizeFloat(n:Number, precision:uint=5):Number 
		{
			var c:Number=Math.pow(10,precision);
			return Math.round(c*n)/c;
		}

		/**
		 * Evaluate if two numbers are nearly equal.
		 * 
		 * @param n1 The first number.
		 * @param n2 The second number.
		 */
		public static function fuzzyEval(n1:Number, n2:Number, precision:int=5):Boolean
		{
			var d:Number=n1 - n2;
			var r:Number=Math.pow(10,-precision);
			return d < r && d > -r;
		}

		/**
		 * Returns a random float.
		 * @example
		 * <listing>	
		 * math.utils.randFloat(50); //returns a number between 0-50 exclusive
		 * math.utils.randFloat(20,50); //returns a number between 20-50 exclusive
		 * </listing>
		 */
		public static function randFloat(min:Number,max:Number=NaN):Number 
		{
			if(isNaN(max)) 
			{ 
				max=min; 
				min=0; 
			}
			return Math.random()*(max-min)+min;
		}

		/**
		 * Return a "tilted" random Boolean value.
		 * 
		 * @example	
		 * <listing>	
		 * math.utils.boolean(); //returns 50% chance of true.
		 * math.utils.boolean(.75); //returns 75% chance of true.
		 * </listing>
		 * 
		 * @param chance The percentage chance that the return value will be true.
		 */
		public static function randBool(chance:Number=0.5):Boolean
		{
			return (Math.random()<chance);
		}

		/**
		 * Return a "tilted" value of 1 or -1.
		 * 
		 * @example
		 * <listing>	
		 * math.utils.sign(); //returns 50% chance of 1.
		 * math.utils.sign(.75); //returns 75% chance of 1.
		 * </listing>
		 * 
		 * @param chance The percentage chance that the return value will be true.
		 */		
		public static function sign(chance:Number=0.5):int 
		{
			return (Math.random()<chance)?1:-1;
		}

		/**
		 * Return a "tilted" value of 1 or 0.
		 * 
		 * @example
		 * <listing>	
		 * math.utils.bit(); //returns 50% chance of 1.
		 * math.utils.bit(.75); //returns 75% chance of 1.
		 * </listing>
		 * 
		 * @param chance The percentage chance that the return value will be true.
		 */
		public static function randBit(chance:Number=0.5):int
		{
			return (Math.random()<chance)?1:0;
		}

		/**
		 * Return a random integer.
		 * 
		 * @example
		 * <listing>	
		 * math.utils.integer(25); //returns an integer between 0-24 inclusive.
		 * math.utils.integer(10,25); //returns an integer between 10-24 inclusive.
		 * </listing>
		 * 
		 * @param min The minumum.
		 * @param max The max.
		 */
		public static function randInteger(min:Number,max:Number=NaN):int 
		{
			if(isNaN(max)) 
			{ 
				max=min; 
				min=0; 
			}
			return Math.floor(randFloat(min,max));
		}
		
		
		/**
		 * Check if a number is in range.
		 * 
		 * @param n The number.
		 * @param min The minimum number.
		 * @param max The maximum number.
		 * @param blacklist An array of numbers that cannot be considered in range.
		 */
		public static function isInRange(n:Number,min:Number,max:Number,blacklist:Array=null):Boolean 
		{
			if(!blacklist || blacklist.length < 1) return (n >= min && n <= max);
			if(blacklist.length > 0)
			{
				for(var i:String in blacklist) if(n == blacklist[i]) return false;
			}
			return false;
		}	

		/**
		 * Returns a set of random numbers inside a specific range, optionally unique numbers only.
		 * 
		 * @param min The minimum number.
		 * @param max The maximum number.
		 * @param count How many mubers to generate.
		 * @param unique Whether or not the numbers generated must be unique.
		 */
		public static function randRangeSet(min:Number, max:Number, count:Number, unique:Boolean):Array 
		{
			var rnds:Array=new Array();
			var i:int=0;
			if(unique && count <= (max-min)+1) 
			{
				var nums:Array=new Array();
				i=min;
				for(;i<=max;i++)nums.push(int(i));
				i=1;
				for(;i<=count;i++) 
				{
					var rn:Number=Math.floor(Math.random()*nums.length);
					rnds.push(nums[rn]);
					nums.splice(rn,1);
				}
			}
			else 
			{
				i=1;
				for (i;i<=count;i++) rnds.push(randRangeInt(min,max));
			}
			return rnds;
		}

		/**
		 * Returns a random float number within a given range.
		 * 
		 * @param min The minimum number.
		 * @param max The maxmimum number.
		 */
		public static function randRangeFloat(min:Number, max:Number):Number 
		{
			return Math.random()*(max-min)+min;
		}

		/**
		 * Returns a random integer number within a given range.
		 * 
		 * @param n The minumum number.
		 * @param max The maximum number.
		 */
		public static function randRangeInt(min:Number, max:Number):int 
		{
			return int(Math.floor(Math.random()*(max-min+1)+min));
		}		

		/**
		 * @private
		 * 
		 * Resolve the number inside the range - if outside the range the
		 * nearest boundary value will be returned.
		 * 
		 * @param val The number.
		 * @param min The minimum allowed.
		 * @param max The maximum allowed.
		 */
		public static function resolve(val:Number, min:Number, max:Number):Number
		{
			return Math.max(Math.min(val,max),min);	
		}

		/**
		 * Locate and return the middle value between the three.
		 * 
		 * @param a The first number.
		 * @param b The second number.
		 * @param c The second number.
		 */
		public static function center(a:Number, b:Number, c:Number):Number 
		{
			if((a > b) && (a > c))
			{
				if (b > c) return b; 
				else return c;
			}
			else if ((b > a) && (b > c)) 
			{
				if (a > c) return a;
				else return c;
			}
			else if (a > b) return a;
			else return b;
		}
		
		/**
		 * Convert angle to radian.
		 * 
		 * a The angle.
		 */
		public static function angle2radian(a:Number):Number
		{
			return resolveAngle(a) * Math.PI / 180;
		}

		/**
		 * Convert radian to angle.
		 * 
		 * @param t The radian.
		 */
		public static function radian2angle(r:Number):Number 
		{
			return resolveAngle(r * 180 / Math.PI);
		}

		/**
		 * Will always give back a positive angle between 0 and 360
		 * 
		 * @param a The angle.
		 */
		public static function resolveAngle(a:Number):Number 
		{
			var mod:Number=a % 360;
			return (mod < 0) ? 360 + mod : mod;
		}

		/**
		 * Get the angle from two points.
		 * 
		 * @param p1 The first point.
		 * @param p2 The second point.
		 */
		public static function getAngle(p1:Point,p2:Point):Number 
		{
			var r:Number=Math.atan2(p2.y - p1.y,p2.x - p1.x);
			return radian2angle(r);
		}

		/**
		 * Get the radian from two points.
		 * 
		 * @param p1 The first point.
		 * @param p2 The second point.
		 */
		public static function getRadian(p1:Point, p2:Point):Number 
		{
			return angle2radian(getAngle(p1,p2));
		}

		/**
		 * Get the distance between two points.
		 * 
		 * @param p1 The first point.
		 * @param p2 The secoind point.
		 */
		public static function pointDistance(p1:Point, p2:Point):Number
		{
			var xd:Number=p1.x - p2.x;
			var yd:Number=p1.y - p2.y;
			return Math.sqrt(xd * xd + yd * yd);
		}
		
		/**
		 * Get z distance between two Point3D instances.
		 * 
		 * @param p1 The first point 3d.
		 * @param p2 The second point 3d.
		 */
		public static function getZDistance(p1:Point3D, p2:Point3D):Number 
		{
			return  p1.z - p2.z;
		}

		/**
		 * Get new point based on distance and angle from a given point.
		 * 
		 * @param centerPoint The center point.
		 * @param dist The distance from the center point.
		 * @param angle The angle from the center point.
		 */
		public static function getPointFromDistanceAndAngle(centerPoint:Point, dist:Number, angle:Number):Point 
		{
			var rad:Number=angle2radian(angle);
			return new Point(round(centerPoint.x + Math.cos(rad) * dist,3),round(centerPoint.y + Math.sin(rad) * dist,3));
		}
		
		/**
		 * Convert an integer to binary string representation.
		 * 
		 * @param n The integer to convert.
		 */
		public static function toBinary(n:int):String
		{
			var result:String="";
			for(var i:Number=0;i < 32; i++)
			{
				var lsb:int=n & 1;
				result=(lsb?"1":"0") + result;
				n >>= 1;
			}
			return result;
		}
		
		/**
		 * Convert a binary string (000001010) to an integer.
		 * 
		 * @param binaryString The string to convert.
		 */
		public static function toDecimal(binaryString:String):int 
		{
			var result:Number=0;
			for(var i:int=binaryString.length;i > 0; i--) result += parseInt(binaryString.charAt(binaryString.length - i))*Math.pow(2,i-1);
			return result;
		}
		
		/**
		 * Convert Fahrenheit to Celsius.
		 * 
		 * @param f The fahrenheit value.
		 * @param p The number of decimals.
		 */
		public static function toCelsius(f:Number,p:Number=2):Number 
		{
			var d:String;
			var r:Number=(5 / 9) * (f - 32);
			var s:Array=r.toString().split(".");
			if (s[1] != undefined) d=s[1].substr(0,p);
			else 
			{
				var i:Number=p;
				while (i > 0) 
				{
					d += "0";
					i--;
				}
			}
			var c:String=s[0] + "." + d;
			return Number(c);
		}

		/**
		 * Convert Celsius to Fahrenheit.
		 * 
		 * @param c The celsius value.
		 * @param p The number of decimals.
		 */
		public static function toFahrenheit(c:Number, p:Number=2):Number 
		{
			var d:String;
			var r:Number=(c / (5 / 9)) + 32;
			var s:Array=r.toString().split(".");
			if (s[1] != undefined) d=s[1].substr(0,p);
			else 
			{
				var i:Number=p;
				while (i > 0) 
				{
					d += "0";
					i--;
				}
			}
			var f:String=s[0] + "." + d;
			return Number(f);		
		}
		
		/**
		 * Parse xml string boolean values into native booleans
		 * - supports (true,false,0,1,yes,no,on,off).
		 * 
		 * @param value The string value from XML.
		 */
		public static function parseXMLAsType(value:String):*
		{
			var v:String=value.toLowerCase();
			if(!isNaN(Number(value))) return Number(value);
			if(v == "true" || v == "false" || v == "0" || v == "1" || v == "yes" || v == "no" || v == "on" || v == "off") return StringUtils.toBoolean(value);
			if(v == "null") return null;
			return value;
		}
		
		/**
		 * Spreads a current value and it's total possible value,
		 * over a value that is mapped to another property, like width,
		 * height, etc.
		 * 
		 * <p>This is probably most commonly used
		 * for bytes loaded/total, or video time.</p>
		 * 
		 * @example
		 * <listing>	
		 * var current:Number=14;
		 * var total:Number=60;
		 * var myBar:MovieClip=new MovieClip();
		 * //spreads the value across 300 pixels, and gives you a value you can use for width;
		 * myBar.width=utils.math.spread(current,total,300); //returns 70
		 * </listing>
		 * 
		 * @param current The current value.
		 * @param total The total possible value.
		 * @param spreadInto The total of another property that should be spread over.
		 */
		public static function spread(current:Number,total:Number,spreadInto:int):Number
		{
			return Math.ceil(Math.min((current/total)*spreadInto,spreadInto));
		}
		
		/**
		 * Convert bytes to mega bytes
		 * 
		 * @param n The number.
		 */
		public static function byte2Megabyte(n:Number):Number
		{
			return n / MEGABIT;
		}
		
		/**
		 * Convert bytes to killo bytes.
		 * 
		 * @param n The number.
		 */
		public static function byte2Kilobyte(n:Number):Number
		{
			return n / KILOBIT;
		}

		/**
		 * Convert bytes to bits.
		 * 
		 * @param n The number.
		 */
		public static function byte2bit(n:Number):Number
		{
			return n * BYTE;
		}
		
		/**
		 * Convert kilobits to bits.
		 * 
		 * @param n The number.
		 */
		public static function kilobit2bit(n:Number):Number 
		{
			return n * KILOBIT;
		}

		/**
		 * Convert kilobytes to bits.
		 * 
		 * @param n The number.
		 */
		public static function kilobyte2bit(n:Number):Number 
		{
			return n * KILOBYTE;	
		}
		
		/**
		 * Convert megabits to bits.
		 * 
		 * @param n The number.
		 */
		public static function megabit2bit(n:Number):Number 
		{
			return n * MEGABIT;
		}
		
		/**
		 * Convert megabytes to bits.
		 * 
		 * @param n The number.
		 */
		public static function megabyte2bit(n:Number):Number 
		{
			return n * MEGABYTE;
		}			
		
		/**
		 * Convert gigabit to bits.
		 * 
		 * @param n The number.
		 */
		public static function gigabit2bit(n:Number):Number 
		{
			return n * GIGABIT;
		}
		
		/**
		 * Convert gigabytes to bits.
		 * 
		 * @param n The number.
		 */
		public static function gigabyte2bit(n:Number):Number
		{
			return n * GIGABYTE;
		}
		
		/**
		 * Convert terabits to bits.
		 * 
		 * @param n The number.
		 */
		public static function terabit2bit(n:Number):Number 
		{
			return n * TERABIT;	
		}

		/**
		 * Convert terabytes to bits.
		 * 
		 * @param n The number.
		 */
		public static function terabyte2bit(n:Number):Number 
		{
			return n * TERABYTE;
		}
		
		/**
		 * Convert petabits to bits.
		 * 
		 * @param n The number.
		 */
		public static function petaabit2bit(n:Number):Number 
		{
			return n * PETABIT;	
		}
		
		/**
		 * Convert petabyte to bits.
		 * 
		 * @param n The number.
		 */
		public static function petabyte2bit(n:Number):Number 
		{
			return n * PETABYTE;
		}

		/**
		 * Convert exabits to bits.
		 * 
		 * @param n The number.
		 */
		public static function exabit2bit(n:Number):Number 
		{
			return n * EXABIT;	
		}

		/**
		 * Convert exabytes to bits.
		 * 
		 * @param n The number.
		 */
		public static function exabyte2bit(n:Number):Number 
		{
			return n * EXABYTE;
		}
	}
}