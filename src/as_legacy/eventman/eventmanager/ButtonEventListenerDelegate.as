package net.guttershark.support.eventmanager
{
	import fl.controls.BaseButton;
	import fl.controls.LabelButton;
	import fl.core.UIComponent;

	/**
	 * The ButtonEventListenerDelegate Class implements event handling
	 * logic for Button components.
	 */
	final public class ButtonEventListenerDelegate extends EventListenerDelegate
	{

		/**
		 * A composite object used for UIComponentEventsDelegation logic.
		 */
		private var uic:UIComponentEventListenerDelegate;

		/**
		 * A composite object used for LabelButton events.
		 */
		private var lbc:LabelButtonEventListenerDelegate;

		/**
		 * A composite object used for BaseButton events.
		 */
		private var bb:BaseButtonEventListenerDelegate;

		/**
		 * @inheritDoc
		 */
		override public function addListeners(obj:*):void
		{
			super.addListeners(obj);
			if(obj is UIComponent)
			{
				uic = new UIComponentEventListenerDelegate();
				uic.eventHandlerFunction = this.handleEvent;
				uic.callbackDelegate = callbackDelegate;
				uic.callbackPrefix = callbackPrefix;
				uic.cycleAllThroughTracking = cycleAllThroughTracking;
				uic.addListeners(obj);
			}
			
			if(obj is BaseButton)
			{
				bb = new BaseButtonEventListenerDelegate();
				bb.eventHandlerFunction = this.handleEvent;
				bb.callbackDelegate = callbackDelegate;
				bb.callbackPrefix = callbackPrefix;
				bb.cycleAllThroughTracking = cycleAllThroughTracking;
				bb.addListeners(obj);
			}
			
			if(obj is LabelButton)
			{
				lbc = new LabelButtonEventListenerDelegate();
				lbc.eventHandlerFunction = this.handleEvent;
				lbc.addListeners(obj);
			}
			
			//no events defined by Button. They're all from ancestors
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			super.dispose();
			if(uic) uic.dispose();
			if(lbc) lbc.dispose();
			if(bb) bb.dispose();
			uic = null;
			lbc = null;
			bb = null;
		}
	}}