package gs.util 
{
	import flash.display.Sprite;
	
	/**
	 * The SpriteUtils class contains utility methods for sprites.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class SpriteUtils 
	{
		
		/**
		 * Creates a hit state sprite for a sprite.
		 * 
		 * @param hitFor The sprite to create a hitstate for.
		 * @param buttonMode Whether or not to use button mode.
		 * @param handCursor Whether or not to use the hand cursor.
		 * 
		 * @example How it creates a hit state.
		 * <listing>	
		 * var s:Sprite = new Sprite();
		 * s.graphics.beginFill(0xffffff,0);
		 * s.graphics.drawRect(0,0,hitFor.width,hitFor.height);
		 * s.buttonMode=buttonMode;
		 * s.useHandCursor=handCursor;
		 * return s;
		 * </listing>
		 */
		public static function createHitSprite(hitFor:Sprite,buttonMode:Boolean=true,handCursor:Boolean=true):Sprite
		{
			var s:Sprite=new Sprite();
			s.graphics.beginFill(0xffffff,0);
			s.graphics.drawRect(0,0,hitFor.width,hitFor.height);
			s.buttonMode=buttonMode;
			s.useHandCursor=handCursor;
			return s;
		}
	}
}