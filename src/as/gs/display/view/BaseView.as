package gs.display.view
{
	import flash.events.Event;
	
	import gs.display.GSClip;	

	/**
	 * The BaseView class is the base for any views, and provides
	 * common hooks and properties.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class BaseView extends GSClip
	{
				
		/**
		 * A controller for this view.
		 */
		public var controller:*;

		/**
		 * Constructor for BaseView instances.
		 */
		public function BaseView()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,ona,false,10,true);
			addEventListener(Event.REMOVED_FROM_STAGE,onre,false,10,true);
			addEventListener(Event.ACTIVATE,onac,false,10,true);
			addEventListener(Event.DEACTIVATE,ond,false,10,true);
			addEventListener(Event.MOUSE_LEAVE,onml,false,10,true);
			init();
		}

		/**
		 * Initialize this view - called from the constructor.
		 */
		protected function init():void{}
		
		/**
		 * on mouse leave.
		 */
		private function onml(e:Event):void
		{
			onMouseLeave();
		}
		
		/**
		 * A method you can override to hook into the mouse
		 * leve event.
		 */
		protected function onMouseLeave():void{}

		/**
		 * on add handler.
		 */
		private function ona(e:Event):void
		{
			stage.addEventListener(Event.RESIZE,onr,false,0,true);
			onAddedToStage();
		}
		
		/**
		 * on removed handler.
		 */
		private function onre(e:Event):void
		{
			stage.removeEventListener(Event.RESIZE, onResize);
			onRemovedFromStage();
		}
		
		/**
		 * When the flash player loses operating system focus.
		 */
		private function ond(e:Event):void
		{
			onDeactive();
		}
		
		/**
		 * When the flash player gains operating system focus.
		 */
		private function onac(e:Event):void
		{
			onActivate();
		}
		
		/**
		 * The resize handler.
		 */
		private function onr(e:Event):void
		{
			onResize();
		}
		
		/**
		 * Override this method to hook into resize events from the stage.
		 */
		protected function onResize():void{}
		
		/**
		 * Override this method to hook into the deactivate event.
		 */
		protected function onDeactive():void{}
		
		/**
		 * Override this method to hook into the activate event.
		 */
		protected function onActivate():void{}
		
		/**
		 * Override this method to hook into the added to stage event.
		 * 
		 * <p>This method calls <a href='#addEventHandlers()'>addEventHandlers()</a> and <a href='#onResize()'>onResize()</a>.</p>
		 */
		protected function onAddedToStage():void
		{
			addEventHandlers();
			onResize();
		}
		
		/**
		 * Override this method to hook into the removed from stage event.
		 * 
		 * <p>This method also calls <a href='#removeEventHandlers()'>removeEventHandlers()</a>.</p>
		 */
		protected function onRemovedFromStage():void
		{
			removeEventHandlers();
		}
		
		/**
		 * Override this method, and use the event manager to add event handlers
		 * on your objects.
		 */
		protected function addEventHandlers():void{}
		
		/**
		 * Override this method, and remove events from objects that were registered
		 * with the event manager.
		 */
		protected function removeEventHandlers():void{}
		
		/**
		 * Override this method and write your own dispose logic.
		 */
		override public function dispose():void{}
	}
}