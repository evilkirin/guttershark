package
{
	import gs.display.accordion.Accordion;
	import gs.display.accordion.BaseAccordionLabelBar;
	import gs.display.accordion.BaseAccordionPane;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class AccordionMain extends Sprite
	{
		
		public var pane1LabelBar:BaseAccordionLabelBar;
		public var pane1Content:MovieClip;
		
		public var pane2LabelBar:BaseAccordionLabelBar;
		public var pane2Content:MovieClip;
		
		public var pane3LabelBar:BaseAccordionLabelBar;
		public var pane3Content:MovieClip;
		
		public var pane4LabelBar:BaseAccordionLabelBar;
		public var pane4Content:MovieClip;
		
		public function AccordionMain()
		{
			super();
			
			var pane:BaseAccordionPane=new BaseAccordionPane(pane1LabelBar,pane1Content);
			var pane2:BaseAccordionPane=new BaseAccordionPane(pane2LabelBar,pane2Content);
			var pane3:BaseAccordionPane=new BaseAccordionPane(pane3LabelBar,pane3Content);
			var pane4:BaseAccordionPane=new BaseAccordionPane(pane4LabelBar,pane4Content);
			
			var accordion:Accordion=new Accordion();
			accordion.addPane(pane);
			accordion.addPane(pane2);
			accordion.addPane(pane3);
			accordion.addPane(pane4);
			
			addChild(accordion);
		}
	}
}