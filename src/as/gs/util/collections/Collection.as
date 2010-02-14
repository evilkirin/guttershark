package gs.util.collections 
{
	
	public class Collection implements ICollection
	{
		
		private var name:String;
		private var values:Array;
		
		public function Collection(name:String)
		{
			name=name;
			values=new Array();
		}
		
		public function getName():String
		{
			return name;
		}
		
		public function getItem(index:Number):* 
		{
			return values[index];
		}
		
		public function addItem(item:*):void 
		{
			values.push(item);
		}
		
		public function addItemAt(index:Number, item:*):void 
		{
			values.splice(index,0,item);
		}
		
		public function setItemAt(item:*, index:int):Boolean 
		{
			if(index<getLength())
			{
				values[index]=item;
				return true;
			}
			else
			{
				return false;	
			}
		}
		
		public function removeItem(index:Number):void 
		{
			values.splice(index,1);
		}
		
		public function clear():void 
		{
			values=new Array();
		}
		
		public function getLength():uint 
		{
			return values.length;
		}
	}
}