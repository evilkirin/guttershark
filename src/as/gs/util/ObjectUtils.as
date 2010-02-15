package gs.util
{
	import flash.utils.ByteArray;
	import flash.utils.describeType;

	/**
	 * The ObjectUtils class has utility methods for working with objects.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class ObjectUtils
	{
		
		/**
		 * Dump tracing recursion counter.
		 */
		private static var n:int;
		
		/**
		 * Dump tracing string builder.
		 */
		private static var str:String;
		
		/**
		 * Spaces to use in the dump() method.
		 */
		private static var spaces:Array;
		
		/**
		 * Clone an object instance.
		 * 
		 * @example Cloning a generic object:
		 * <listing>	
		 * var myObj:Object=new Object();
		 * myObj.message="hello world";
		 * var myCopy:Object=ObjectUtils.clone(myObj);
		 * trace(myCopy.message);
		 * </listing>
		 * 
		 * @param object The object to clone.
		 */
		public static function clone(object:*):*
		{
			if(!object) throw new ArgumentError("Parameter object cannot be null");
			var byteArray:ByteArray=new ByteArray();
			byteArray.writeObject(object);
			byteArray.position=0;
			return byteArray.readObject();
		}
		
		/**
		 * Walk down a property chain.
		 * 
		 * @example Using walkChain:
		 * <listing>	
		 * var obju:ObjectUtils = ObjectUtils.gi();
		 * var o:Object = {};
		 * o.test = {};
		 * o.test.name = "Aaron";
		 * trace(obju.walkChain(o,"test.name")); // -> "Aaron"
		 * </listing>
		 * 
		 * @example Using walkChain with leaveBehind:
		 * <listing>	
		 * var obju:ObjectUtils = ObjectUtils.gi();
		 * var o:Object = {};
		 * o.test = {};
		 * o.test.person = {};
		 * o.test.person.name = "Aaron";
		 * trace(obju.walkChain(o,"test.person.name",1)); // -> "[Object Object]" -> refers to "o.test.person".
		 * trace(obju.walkChain(o,"test.person.name")); // -> "Aaron"
		 * </listing>
		 * 
		 * @param obj The object to walk.
		 * @param chain The property chain.
		 * @param leaveBehind You can have the walk stop with x amounts left.
		 */
		public static function walkChain(obj:*,chain:String,leaveBehind:int=0):*
		{
			var props:Array=chain.split(".");
			if(leaveBehind>0) props.splice(props.length-leaveBehind,leaveBehind);
			if(props.length==1)return obj[props[0]];
			else
			{
				var i:int=1;
				var l:int=props.length;
				var finalObj:* =obj[props[0]];
				for(;i<l;i++)finalObj=finalObj[props[int(i)]];
			}
			return finalObj;
		}
		
		/**
		 * Dump trace an object.
		 * 
		 * @param o The object to trace.
		 */
		public static function dump(o:Object):void
		{
			str="";
			n=-1;
			if(!spaces)spaces=[""," ","  ","   ","    ","     "];
			dumpObj(o);
			str=str.slice(0,str.length-1);//remove the lastest \n
			trace(str);
			str=null;
		}
		
		/**
		 * Dump trace an object, returning a string.
		 */
		public static function rdump(o:Object):String
		{
			str="";
			n=-1;
			if(!spaces)spaces=[""," ","  ","   ","    ","     "];
			dumpObj(o);
			str=str.slice(0,str.length-1);//remove the lastest \n
			return str;
		}
		
		/**
		 * recursive helper for dump().
		 */
		private static function dumpObj(o:Object):void
		{
			if(n>4)
			{
				str += "...recusion_limit..." + "\n"; 
				return;
			}
			n++;
			var type:String=describeType(o).@name;
			var t:String;
			var i:String;
			if(type=='Array')
			{
				for(i in o)
				{
					t=describeType(o[i]).@name;
					if(t=='Array'||t=='Object')
					{
						str+=(spaces[n]+"["+i+"]:"+"\n");
						dumpObj(o[i]);
					}
					else str+=(spaces[n]+"["+i+"]:"+String(o[i])+"\n");
				}
			}
			else if(type=='Object')
			{
				for(i in o)
				{
					t=describeType(o[i]).@name;
					if(t=='Array'||t=='Object')
					{
						str+=(spaces[n]+i+":"+"\n");
						dumpObj(o[i]);
					}
					else str+=(spaces[n]+i+":"+String(o[i])+"\n");
				}
			}
			else str+=(String(o)+"\n");
			n--;
		}
	}
}