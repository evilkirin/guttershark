package gs.display.accordion
{
	import gs.display.GSClip;

	import flash.display.Sprite;

	/**
	 * The BaseAccordionLabelBar class is the base class
	 * for all label bars in an accordion pane.
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class BaseAccordionLabelBar extends GSClip
	{
		
		/**
		 * The hit clip for this bar.
		 */
		public var hitclip:Sprite;
		
		/**
		 * @inheritDoc
		 */
		override public function get hitArea():Sprite
		{
			return hitclip;
		}
	}
}