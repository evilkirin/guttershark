package gs.display
{
	import gs.util.StageRef;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	
	/**
	 * The GSSprite class is a base sprite that
	 * fixes null stage references.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class GSSprite extends Sprite
	{
		
		/**
		 * Cached stage instance.
		 */
		private var _stage:Stage;
		
		/**
		 * Dispose of this clip.
		 */
		public function dispose():void
		{
			_stage=null;
		}
		
		/**
		 * StageRef.stage (gs.util.StageRef)
		 */
		override public function get stage():Stage
		{
			if(_stage)return _stage;
			if(super.stage)_stage=super.stage;
			if(StageRef.stage)_stage=StageRef.stage;
			if(!super.stage && !StageRef.stage) return null;
			return _stage;
		}
		
		/**
		 * Sets the visible property to true.
		 */
		public function show():void
		{
			if(visible)return;
			visible=true;
		}
		
		/**
		 * Sets the visible property to false.
		 */
		public function hide():void
		{
			if(!visible)return;
			visible=false;
		}
	}
}