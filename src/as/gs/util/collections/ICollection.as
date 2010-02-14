package gs.util.collections 
{
	
	public interface ICollection 
	{
		
		function getName():String;
		
		function addItem(item:*):void;
		
		function addItemAt(index:Number, item:*):void;
		
		function getItem(index:Number):*;
		
		function removeItem(index:Number):void;
		
		function setItemAt(item:*, index:int):Boolean;
		
		function clear():void;
		
		function getLength():uint;
	}
}