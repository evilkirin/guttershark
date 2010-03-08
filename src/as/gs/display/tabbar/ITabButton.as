package gs.display.tabbar 
{
	import flash.events.IEventDispatcher;			

	/**
	 * The ITabButton interface defines a contract
	 * for buttons that work with the TabBar class.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public interface ITabButton extends IEventDispatcher
	{

		/**
		 * Activate this button. It's called when
		 * the tab bar successfully switches to the
		 * requested view.
		 */
		function activate():void;
		
		/**
		 * Deactivate this button. It's called on the
		 * current tab button, before activating the next
		 * button or view.
		 */
		function deactivate():void;
	}
}