package gs.display.decorators
{
	import gs.model.Model;
	import gs.util.DecoratorUtils;

	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * The NavigateToLink class decorates any sprite,
	 * with "navigateToLink" functionality tied in with the
	 * model.
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final dynamic public class NavigateToLink extends Decorator
	{
		
		/**
		 * A model instance.
		 */
		private var ml:Model;
		
		/**
		 * The link id.
		 */
		private var linkId:String;
		
		/**
		 * The event used to trigger the nav to link.
		 */
		private var event:String;
		
		/**
		 * Constructor for new NavigateToLink instances.
		 * 
		 * @param clip The sprite to decorate.
		 * @param modelLinkId The link id from the model to navigate to.
		 * @param reactToEvent What event to react to.
		 */
		public function NavigateToLink(ml:Model,decorate:*,modelLinkId:String,reactToEvent:String="click")
		{
			if(!decorate)throw new Error("Parameter {sp} cannot be null.");
			methods=DecoratorUtils.buildMethods(["dispose","goToLink"]);
			props=new Dictionary();
			sprite=decorate;
			this.ml=ml;
			if(!ml.doesLinkExist(modelLinkId))throw new Error("The modelLinkId {"+modelLinkId+"} does not exist in the model.");
			sprite.addEventListener(reactToEvent,onClipEvent);
			linkId=modelLinkId;
			event=reactToEvent;
		}
		
		/**
		 * The event 
		 */
		private function onClipEvent(me:Event):void
		{
			ml.navigateToLink(linkId);
		}
		
		/**
		 * Navigates to the link.
		 */
		public function goToLink():void
		{
			ml.navigateToLink(linkId);
		}
		
		/**
		 * Dispose of this decorator.
		 */
		public function dispose():void
		{
			sprite.removeEventListener(event,onClipEvent);
			sprite=null;
			ml=null;
			linkId=null;
			event=null;
			props=null;
			methods=null;
		}
	}
}