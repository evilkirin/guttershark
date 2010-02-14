package gs.display.view
{
	import flash.text.TextField;
	import flash.utils.setTimeout;	

	/**
	 * The BaseErrorView class provides some default functionality
	 * that might want to be used for an "error" state of a form.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class BaseErrorView extends BaseFormView
	{
		
		/**
		 * An error message text field.
		 */
		public var errorField:TextField;
		
		/**
		 * Constructor for BaseErrorView instances.
		 */
		public function BaseErrorView()
		{
			super();
		}
		
		/**
		 * A stub method you can use to set a message.
		 * 
		 * @param str The message.
		 */
		public function set message(str:String):void{}
		
		/**
		 * This is an alternative to the default method (show), which
		 * autoHide's this error view, after a specified amount of time.
		 * 
		 * @param autoHideTimeout The time the error view is shown before it auto hides.
		 */
		public function showAndHide(autoHideTimeout:int=2000):void
		{
			super.show();
			setTimeout(hide,autoHideTimeout);
		}
	}
}
