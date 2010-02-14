package gs.display.tabbar 
{
	import gs.display.GSClip;	
	
	/**
	 * The BaseTabButton class is an adapter that
	 * implements the ITabButton interface, and has
	 * some basic logic.
	 * 
	 * <p>It declares an "active" property, which is
	 * set to true or false when deactivate, or activate
	 * is called.</p>
	 */
	public class BaseTabButton extends GSClip implements ITabButton 
	{
		
		/**
		 * Flag indicating whether or not
		 * this button is active.
		 */
		protected var active:Boolean;
		
		/**
		 * Deactivate this button. It's called on the
		 * current tab button, before activating the next
		 * button or view.
		 */
		public function deactivate():void
		{
			active=false;
		}
		
		/**
		 * Activate this button. It's called when
		 * the tab bar successfully switches to the
		 * requested view.
		 */
		public function activate():void
		{
			active=true;
		}
	}
}