package 
{
	import flash.events.MouseEvent;	
	import flash.display.MovieClip;	
	
	import net.guttershark.display.list.List;
	
	import flash.display.Sprite;		

	public class Main extends Sprite 
	{
		
		private var ls:List;
		public var deselect:MovieClip;

		public function Main()
		{
			super();
			deselect.addEventListener(MouseEvent.CLICK,onDeselect);
			ls=new List();
			//ls.selectable=false;
			var dp:Array=[];
			addChild(ls);
			var i:int=0;
			var l:int=3;
			var item:*;
			for(i;i<l;i++)
			{
				item=new ListItemTest();
				dp.push(item);
			}
			ls.activatable=false;
			ls.dataProvider=dp;
			//ls.width=150;
			//ls.height=120;
			ls.rowsVisible=8;
			ls.addItem(new ListItemTest());
			ls.addItemAt(2,new ListItemTest());
			i=0;
			l=14;
			for(i;i<l;i++)
			{
				item=new ListItemTest();
				ls.addItem(item);
			}
			ls.setDataAt(1,{name:"HELLO"});
			trace(ls.getItemAt(1).data.name);
			ls.setDataAt(0,{name:"WORLD"});
			trace(ls.getDataAt(0).name);
			ls.x=100;
			ls.y=30;
			//ls.useMask=true;
			//ls.initFromObject({useMask:true});
			//ls.initFromObject({rowsVisible:4,useMask:true});
			//ls.rowsVisible=2;
			//ls.width=10;
			//ls.height=120;
		}
		
		private function onDeselect(e:*):void
		{
			ls.deselectAll();
		}	}}