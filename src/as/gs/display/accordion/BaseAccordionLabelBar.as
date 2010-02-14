package gs.display.accordion
{
	import gs.display.GSClip;

	import flash.display.Sprite;

	/**
	 * The BaseAccordionLabelBar class is the base class
	 * for all label bars in an accordion pane.
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