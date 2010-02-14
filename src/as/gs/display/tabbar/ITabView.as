package gs.display.tabbar 
{
	
	/**
	 * The ITabView interface defines a contract
	 * for views that work with the TabBar class.
	 */
	public interface ITabView 
	{
		
		/**
		 * A query method that the TabBar uses to
		 * decide if switching to another view - other
		 * than the current view, is allowed.
		 * 
		 * <p>You need to return true, to allow a switch
		 * to another view, or false to deny the switch.</p>
		 * 
		 * <p>This can be useful in situation where forms
		 * are being used, and you need to make sure a
		 * form is filled out before switching to the next
		 * view.</p>
		 */
		function shouldActivateOther():Boolean;
		
		/**
		 * Called if the "shouldActivateOther" method
		 * returns false, indicating that a view switch
		 * was not allowed.
		 */
		function couldNotActivateOther():void;
		
		/**
		 * Tells the tab bar to wait for an event
		 * to fire, before switching to the next view.
		 * 
		 * <p>Return null to not wait, or any string,
		 * as the event to wait for.</p>
		 */
		function waitForEvent():String;
		
		/**
		 * Tell's the view that the tab manager is waiting
		 * for the event specified from waitForEvent().
		 */
		function tabBarIsWaiting():void;
		
		/**
		 * Show the view.
		 */
		function show():void;
		
		/**
		 * Hide the view.
		 */
		function hide():void;
		
		/**
		 * A hook into after the view is shown,
		 * which can be used to select default
		 * form elements or any display object.
		 */
		function select():void;
		
		/**
		 * A hook into after the view is hidden,
		 * which can be used to deselect form fields
		 * or any display objects.
		 */
		function deselect():void;
	}
}
