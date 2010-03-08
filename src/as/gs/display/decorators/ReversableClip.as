package gs.display.decorators 
{
	import gs.util.DecoratorUtils;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * The ReversableClip class decorates a
	 * movie clip with play in reverse functionality.
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final dynamic public class ReversableClip extends Decorator
	{
		
		/**
		 * Constructor for ReversableClip instances.
		 * 
		 * @param clip The movie clip to decorate.
		 */
		public function ReversableClip(decorate:MovieClip)
		{
			if(!decorate) throw new Error("Property {decorate} cannot be null.");
			this.sprite=decorate;
			methods=DecoratorUtils.buildMethods(["dispose","playReverse"]);
			props=new Dictionary();
		}

		/**
		 * Play the movie clip in reverse.
		 */
		public function playReverse():void
		{
			sprite.addEventListener(Event.ENTER_FRAME,onEnterFrame,false,0,true);
		}
		
		/**
		 * on enter frame of clip.
		 */
		private function onEnterFrame(e:Event):void
		{
			if(sprite.currentFrame==1)
			{
				sprite.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				return;
			}
			sprite.gotoAndPlay(sprite.currentFrame-1);
		}
		
		/**
		 * Dispose of this decorator.
		 */
		public function dispose():void
		{
			methods=null;
			props=null;
			if(!sprite)return;
			sprite.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			sprite=null;
		}
	}
}