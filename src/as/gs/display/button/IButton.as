package gs.display.button 
{
	import flash.events.IEventDispatcher;
	
	public interface IButton extends IEventDispatcher
	{
		
		function set state(val:Boolean):void;
		function get state():Boolean;
	}
}
