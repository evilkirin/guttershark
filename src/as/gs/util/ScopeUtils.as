package gs.util 
{
	
	import flash.display.InteractiveObject;	
	
	/**
	 * The ScopeUtils class provides utilities for working with scope.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class ScopeUtils
	{
		
		/**
		 * Re-target instance variables from a source to a different scope.
		 * 
		 * @example Re-targetting a class' instance variables to inside of a movie clip.
		 * <listing>	
		 * package
		 * {
		 *   class MyView extends CoreClip
		 *   {
		 *       public var formfieldwrapper:MovieClip;
		 *       public var firstname:TextField; //actually exists in formfieldwrapper.firstname.
		 *       public var lastname:TextField;
		 *       public function MyView()
		 *       {
		 *           super();
		 *           //in this call, "formfieldwrapper" represents the source, and "this" represents the new target host.
		 *           utils.scope.retarget(formfieldwrapper,this,"firstname","lastname");
		 *           trace(firstname);
		 *       }
		 *   }
		 * }
		 * </listing>
		 * 
		 * @param source The source instance where the variables are declared.
		 * @param target The new target.
		 * @param objs The instance variables in which the pointer is changing.
		 */
		public static function retarget(source:InteractiveObject,target:InteractiveObject,...objs:Array):void
		{
			if(!source||!target)return;
			var l:int=objs.length;
			var k:int=0;
			for(;k<l;k++)target[objs[int(k)]]=source[objs[int(k)]];
		}
	}
}
