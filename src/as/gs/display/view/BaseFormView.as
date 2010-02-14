package gs.display.view
{
	import flash.display.MovieClip;	
	
	/**
	 * The BaseFormView class defines the base form view
	 * should implement, to follow a good pattern of the most commonly
	 * used form functionality.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class BaseFormView extends BaseView
	{
		
		/**
		 * The mask that turns on the cancel button.
		 */
		public static const CANCEL_BTN:int=1;
		
		/**
		 * The mask that turns on the ok button.
		 */
		public static const OK_BTN:int=2;
		
		/**
		 * The mask that turns on the confirm button.
		 */
		public static const CONFIRM_BTN:int=4;
		
		/**
		 * The mask that turns on the yes button.
		 */
		public static const YES_BTN:int=8;
		
		/**
		 * The mask that turns on the no button.
		 */
		public static const NO_BTN:int=16;
		
		/**
		 * The mask that turns on the delete button.
		 */
		public static const DELETE_BTN:int=32;
		
		/**
		 * An ok button.
		 */
		public var okButton:MovieClip;
		
		/**
		 * A cancel button.
		 */
		public var cancelButton:MovieClip;
		
		/**
		 * A confirm button.
		 */
		public var confirmButton:MovieClip;
		
		/**
		 * A yes button.
		 */
		public var yesButton:MovieClip;
		
		/**
		 * A delete button.
		 */
		public var deleteButton:MovieClip;
		
		/**
		 * A no button.
		 */
		public var noButton:MovieClip;
		
		/**
		 * A container for BaseErrorView's to show and hide
		 * during validation.
		 */
		public var errorViews:MovieClip;
		
		/**
		 * A function delegate you should use and call
		 * when the user cancels the form operation and
		 * any validation has passed.
		 */
		public var onCancel:Function;
		
		/**
		 * A function delegate you should use and call
		 * when the user confirms the form operation and
		 * any validation has passed.
		 */
		public var onConfirm:Function;
		
		/**
		 * A function delegate you should use and
		 * call when the user ok's a form operatoin
		 * and any validation has passed.
		 */
		public var onOK:Function;
		
		/**
		 * A function delegate you should use and call
		 * when the user agrees to the form operation and
		 * any validation has passed.
		 */
		public var onYes:Function;
		
		/**
		 * A function delegate you should use and call
		 * when the user declines the form operation and
		 * any validation has passed.
		 */
		public var onNo:Function;
		
		/**
		 * A function delegate you should use and call
		 * when the user agrees to delete (something) and
		 * any validation has passed.
		 */
		public var onDelete:Function;

		/**
		 * Constructor for CoreFormView instances.
		 */
		public function BaseFormView()
		{
			super();
			if(cancelButton)cancelButton.visible=false;
			if(yesButton)yesButton.visible=false;
			if(noButton)noButton.visible=false;
			if(confirmButton)confirmButton.visible=false;
			if(okButton)okButton.visible=false;
			if(deleteButton)deleteButton.visible=false;
		}
		
		/**
		 * Show this form view - this calls <a href='#addKeyMappings()'>addKeyMappings()</a>
		 * and <a href='#selectField()'>selectField()</a>.
		 */
		override public function show():void
		{
			if(visible) return;
			super.show();
			addKeyMappings();
			selectField();
		}
		
		/**
		 * Hide this form view - this calls <a href='#removeKeyMappings()'>removeKeyMappings()</a> 
		 * and <a href='#deselectField()'>deselectField()</a>.
		 */
		override public function hide():void
		{
			if(!visible) return;
			super.hide();
			removeKeyMappings();
			deselectField();
		}
		
		/**
		 * Override this and add key event mappings with the
		 * keyboard event manager.
		 * 
		 * <p>This is called when the view is shown.</p>
		 */
		protected function addKeyMappings():void{}
		
		/**
		 * Override this and remove key event mappings with the
		 * keyboard event manager.
		 * 
		 * <p>This is called when the view is hidden.</p>
		 */
		protected function removeKeyMappings():void{}
		
		/**
		 * Override this and do some select/focus logic for the form field.
		 * 
		 * <p>The is called when the view is shown.</p>
		 */
		protected function selectField():void{}
		
		/**
		 * Override this and do some deselect logic for the form fields.
		 * 
		 * <p>This is called with the view is hidden.</p>
		 */
		protected function deselectField():void{}
		
		/**
		 * Override this and do some form validation.
		 */
		protected function validate():Boolean
		{
			return false;
		}
		
		/**
		 * Override this method, and use as the the click event
		 * handler for a "confirm" button - validate this
		 * form and then call the onConfirm delegate function.
		 * 
		 * @example Correctly using a delegate function:
		 * <listing>	
		 * public class MyFormView extends BaseFormView
		 * {
		 *     
		 *     public var confirm:MovieClip;
		 *     public var email:TextField;
		 *     
		 *     public function MyFormView()
		 *     {
		 *         super();
		 *     }
		 *     
		 *     override protected function addEventHandlers():void
		 *     {
		 *         em.handleEvents(confirm,this,"onConfirm");
		 *     }
		 *     
		 *     override protected function removeEventHandlers():void
		 *     {
		 *         em.disposeEvents(confirm);
		 *     }
		 *     
		 *     override protected function validate():Boolean
		 *     {
		 *         if(!utils.string.isemail(email.text))
		 *         {
		 *             errorViews.badEmail.showAndHide(3000); //see BaseErrorView for showAndHide()
		 *             return false;
		 *         }
		 *         return true;
		 *     }
		 *     
		 *     override public function onConfirmClick():void
		 *     {
		 *         super.onConfirmClick();
		 *         
		 *         //in this case, the delegate function (onConfirm) 
		 *         //would have to accept one parameter - an email.
		 *         //This pattern is taken from apple's cocoa
		 *         //framework. This type of pattern is extremly
		 *         //useful, and leads to less bugs and good design.
		 *         if(validate()) onConfirm(email.text);
		 *     }
		 * }
		 * </listing>
		 */
		public function onConfirmClick():void{}
		
		/**
		 * Override this method, and use as the the click event
		 * handler for a "yes" button - validate this
		 * form and then call the onYes delegate function.
		 */
		public function onYesClick():void{}
		
		/**
		 * Override this method, and use as the the click event
		 * handler for a "no" button - validate this
		 * form and then call the onNo delegate function.
		 */
		public function onNoClick():void{}
		
		/**
		 * Override this method, and use as the the click event
		 * handler for a "delete" button - validate this
		 * form and then call the onDelete delegate function.
		 */
		public function onDeleteClick():void{}
		
		/**
		 * Override this method, and use as the click event
		 * handler for an "ok" button - validate this
		 * form and then call the onOK delegate function.
		 */
		public function onOKClick():void{};
		
		/**
		 * Override this method and implement a modal blocker,
		 * which can then be called when a sub form view is shown
		 * and this view needs to be blocked from interaction.
		 */
		protected function blockForInput():void{}
		
		/**
		 * Override this method, and disable a modal blocker.
		 */
		protected function unblockFromInput():void{}
		
		/**
		 * Hide's any form buttons that are currently visible.
		 */
		public function hideButtons():void
		{
			if(okButton && okButton.visible) hideOKButton();
			if(cancelButton && cancelButton.visible) hideCancelButton();
			if(yesButton && yesButton.visible) hideYesButton();
			if(noButton && noButton.visible) hideNoButton();
			if(confirmButton && confirmButton.visible) hideConfirmButton();
			if(deleteButton && deleteButton.visible) hideDeleteButton();
		}
		
		/**
		 * Hides the delete button.
		 */
		protected function hideDeleteButton():void
		{
			deleteButton.visible=false;
		}
		
		/**
		 * Hides the confirm button.
		 */
		protected function hideConfirmButton():void
		{
			confirmButton.visible=false;
		}
		
		/**
		 * Hides the no button.
		 */
		protected function hideNoButton():void
		{
			noButton.visible=false;
		}
		
		/**
		 * Hides the yes button.
		 */
		protected function hideYesButton():void
		{
			yesButton.visible=false;
		}
		
		/**
		 * Hides the cancel button.
		 */
		protected function hideCancelButton():void
		{
			cancelButton.visible=false;
		}
		
		/**
		 * Hides the ok button.
		 */
		protected function hideOKButton():void
		{
			okButton.visible=false;
		}
		
		/**
		 * Show any button, (yes,no,confirm,delete,ok,cancel)
		 * based off of what is or'ed (|) together - for each
		 * button that is shown, it calls the appropriate
		 * method (showOKButton, showYesButton, etc), which
		 * you could override if needed.
		 * 
		 * @example Showing combinations of buttons:
		 * <listing>	
		 * myView.showButtons(BaseFormView.OK_BTN|BaseFormView.CANCEL_BTN);
		 * myView.showButtons(BaseFormView.YES_BTN|BaseFormView.NO_BTN);
		 * </listing>
		 */
		public function showButtons(buttons:uint):void
		{
			if(buttons&CANCEL_BTN) showCancelButton();
			if(buttons&OK_BTN) showOKButton();
			if(buttons&CONFIRM_BTN) showConfirmButton();
			if(buttons&YES_BTN) showYesButton();
			if(buttons&NO_BTN) showNoButton();
			if(buttons&DELETE_BTN) showDeleteButton();
		}
		
		/**
		 * Shows the ok button, (sets visible to true),
		 * override to use something other than visible.
		 */
		protected function showOKButton():void
		{
			okButton.visible=true;
		}
		
		/**
		 * Shows the cancel button, (sets visible to true),
		 * override to use something other than visible.
		 */
		protected function showCancelButton():void
		{
			cancelButton.visible=true;
		}
		
		/**
		 * Shows the confirm button, (sets visible to true),
		 * override to use something other than visible.
		 */
		protected function showConfirmButton():void
		{
			confirmButton.visible=true;
		}
		
		/**
		 * Shows the yes button, (sets visible to true),
		 * override to use something other than visible.
		 */
		protected function showYesButton():void
		{
			yesButton.visible=true;
		}
		
		/**
		 * Shows the no button, (sets visible to true),
		 * override to use something other than visible.
		 */
		protected function showNoButton():void
		{
			noButton.visible=true;
		}
		
		/**
		 * Shows the delete button, (sets visible to true),
		 * override to use something other than visible.
		 */
		protected function showDeleteButton():void
		{
			deleteButton.visible=true;
		}
	}
}
