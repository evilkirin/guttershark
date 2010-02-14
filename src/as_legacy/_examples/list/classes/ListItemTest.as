package
{
	import gs.TweenMax;

	import net.guttershark.display.list.BaseListItem;

	import flash.display.MovieClip;
	import flash.text.TextField;

	public class ListItemTest extends BaseListItem
	{
		
		public var label:TextField;
		public var vector:MovieClip;

		public function ListItemTest()
		{
			super();
			em.he(this,this,"onThis");
		}
		
		override public function activate():void
		{
			super.activate();
		}
		
		override public function deactivate():void
		{
			super.deactivate();
			TweenMax.to(label,.2,{x:label.x-5});
			outColor();
		}
		
		public function onThisMouseOver():void
		{
			if(active)return;
			label.x+=5;
			TweenMax.to(vector,.3,{tint:0x00CCFF});
		}

		public function onThisMouseOut():void
		{
			if(active)return;
			label.x-=5;
			outColor();
		}
		
		private function outColor():void
		{
			TweenMax.to(vector,.3,{removeTint:true});
		}	}}