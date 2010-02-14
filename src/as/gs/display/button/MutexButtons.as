package gs.display.button 
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**
	 * The MutexButtons class is a button controller that only
	 * allows one button at a time to be enabled.
	 */
	public class MutexButtons
	{
		
		/**
		 * Lookup for buttons this class is managing.
		 */
		protected var buttons:Dictionary;
		
		/**
		 * Constructor for MutexButtons instances.
		 */
		public function MutexButtons()
		{
			buttons=new Dictionary(true);
		}
		
		/**
		 * Add a button.
		 * 
		 * @param obj A button that can be turned on and off.
		 */
		public function addButton(obj:IButton):void
		{
			if(!obj)return;
			var ob:Object;
			if(!buttons[obj])
			{
				if(Object(obj).hit)
				{
					ob=Object(obj).hit;
					buttons[ob]=true;
					ob.addEventListener(MouseEvent.CLICK,onClick,false,11,true);
				}
				else
				{
					buttons[obj]=true;
					obj.addEventListener(MouseEvent.CLICK,onClick,false,11,true);
				}
			}
		}
		
		/**
		 * Remove a button.
		 * 
		 * @param obj A button that can be turned on and off.
		 */
		public function removeButton(obj:IButton):void
		{
			if(!obj)return;
			var ob:Object;
			if(Object(obj).hit)ob=Object(obj).hit;
			else obj=obj;
			EventDispatcher(ob).removeEventListener(MouseEvent.CLICK,onClick);
			delete buttons[ob];
		}
		
		/**
		 * On the button click
		 */
		protected function onClick(e:MouseEvent):void
		{
			var obj:MovieClip;
			for each(obj in buttons)
			{
				if(obj==e.target||obj==e.currentTarget)obj.state=true;
				obj.state=false;
			}
		}
	}
}
