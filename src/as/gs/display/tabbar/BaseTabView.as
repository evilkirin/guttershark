package gs.display.tabbar 
{
	import gs.display.view.BaseView;	

	/**
	 * The BaseTabView class is an adapter that implements
	 * the ITabView interface. It implements the required
	 * functions, from ITabView, which you can override or leave
	 * as is.
	 */
	public class BaseTabView extends BaseView implements ITabView
	{
		
		/**
		 * A query method that the TabBar uses to
		 * decide if switching to another view, other
		 * than the current view is allowed.
		 * 
		 * <p>You need to return true, to allow a switch
		 * to another view, or false to deny the switch.</p>
		 * 
		 * <p>This can be useful in situation where forms
		 * are being used, and you need to make sure a
		 * form is filled out before switching to the next
		 * view.</p>
		 */
		public function shouldActivateOther():Boolean
		{
			return true;
		}
		
		/**
		 * Called if the "shouldActivateOther" method
		 * returns false, indicating that a view switch
		 * was not allowed.
		 */
		public function couldNotActivateOther():void
		{
		}
		
		/**
		 * Tells the tab bar to wait for an event
		 * to fire, before switching to the next view.
		 * 
		 * <p>Return null to not wait, or any string,
		 * as the event to wait for.</p>
		 */
		public function waitForEvent():String
		{
			return null;
		}
		
		/**
		 * Tell's the view that the tab manager is waiting
		 * for the event specified from waitForEvent().
		 */
		public function tabBarIsWaiting():void
		{
		}
		
		/**
		 * A hook into after the view is shown,
		 * which can be used to select form default
		 * form elements.
		 */
		public function select():void
		{
		}
		
		/**
		 * A hook into after the view is hidden,
		 * which can be used to deselect form fields.
		 */
		public function deselect():void
		{
		}
	}
}