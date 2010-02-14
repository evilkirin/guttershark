package
{
	import gs.TweenMax;
	import gs.display.GSClip;
	import gs.display.tabbar.ITabButton;

	import flash.events.MouseEvent;

	public class TabButton extends GSClip implements ITabButton 
	{
		
		private var active:Boolean;
		
		public function TabButton()
		{
			this.addEventListener(MouseEvent.CLICK,onThisClick);
		}
		
		public function activate():void
		{
			active=true;
			TweenMax.to(this,.2,{tint:0x00BBEB});
		}
		
		public function deactivate():void
		{
			active=false;
			TweenMax.to(this,.3,{removeTint:true});
		}
		
		public function onThisMouseOver():void
		{
			if(active)TweenMax.to(this,.2,{tint:0x00BBEB});
			else TweenMax.to(this,.2,{tint:0xD50055});
		}
		
		public function onThisMouseOut():void
		{
			if(active)TweenMax.to(this,.3,{tint:0x00CCFF});
			else TweenMax.to(this,.3,{removeTint:true});
		}
		
		public function onThisClick(e:*):void
		{
			
		}	}}