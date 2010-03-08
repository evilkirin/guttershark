package gs.display.accordion
{
	import flash.display.MovieClip;

	/**
	 * The AccordionPane class wraps a pane section
	 * for the accordion. Yuou pass instances of
	 * this to the accordion.
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class BaseAccordionPane extends MovieClip
	{
		
		/**
		 * Pane content clip.
		 */
		public var content:MovieClip;
		
		/**
		 * Pane label bar.
		 */
		public var labelBar:BaseAccordionLabelBar;
		
		/**
		 * Constructor for AccordionPane instances.
		 * 
		 * @param labelBar The label bar to associate with this pane.
		 * @param content The content clip that belongs to this pane.
		 */
		public function BaseAccordionPane(labelBar:BaseAccordionLabelBar,content:MovieClip):void
		{
			this.content=content;
			this.labelBar=labelBar;
			zero();
			addChild(labelBar);
			addChild(content);
			content.y=labelBar.y+labelBar.height;
		}
		
		/**
		 * Toggles the enabled state on the labelBar.
		 */
		override public function set enabled(b:Boolean):void
		{
			labelBar.enabled=b;
		}
		
		/**
		 * Toggles the enabled state on the labelBar.
		 */
		override public function get enabled():Boolean
		{
			return labelBar.enabled;
		}
		
		/**
		 * Zero's out the label bar and content.
		 */
		private function zero():void
		{
			if(labelBar.x!=0)labelBar.x=0;
			if(labelBar.y!=0)labelBar.y=0;
			if(content.x!=0)content.x=0;
			if(content.y!=0)content.y=0;
		}
		
		/**
		 * Accordion pane width.
		 */
		override public function get width():Number
		{
			return content.width;
		}
		
		/**
		 * Accordion pane height including label bar.
		 */
		override public function get height():Number
		{
			return content.height+labelBar.height;
		}
		
		/**
		 * The label bar height.
		 */
		public function get labelBarHeight():Number
		{
			return this.labelBar.height;
		}
		
		/**
		 * The label bar width.
		 */
		public function get labelBarWidth():Number
		{
			return this.labelBar.width;
		}
	}
}