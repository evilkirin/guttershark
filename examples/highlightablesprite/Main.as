package 
{
	import gs.display.decorators.HighlightableSprite;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class Main extends Sprite
	{
		
		public var button1:MovieClip;
		public var sexyButton:MovieClip;
		
		private var hsd1:HighlightableSprite;
		private var hsd2:HighlightableSprite;
		private var hsd3:HighlightableSprite;
		private var hsd4:HighlightableSprite;
		
		public function Main()
		{
			//simple 1 button highlight decorator
			hsd1=new HighlightableSprite(button1.underline,button1,{tint:0xff0066},{tint:0x00ccff},button1,MouseEvent.MOUSE_OVER,MouseEvent.MOUSE_OUT);
			
			//slightly more complicated, 3 decorators to highlight 3 text elements, at different durations.
			//this is only to illustrate that you can use multiple decorators to achieve different effects,
			//without writing any event handler code.
			sexyButton.buttonMode=true;
			hsd2=new HighlightableSprite(sexyButton.s1,sexyButton.hit,{time:.1,tint:0xff0066},{time:.5,tint:0x333333});
			hsd3=new HighlightableSprite(sexyButton.s2,sexyButton.hit,{time:.3,tint:0x00ccff},{time:.3,tint:0x666666});
			hsd4=new HighlightableSprite(sexyButton.s3,sexyButton.hit,{time:.5,tint:0xff0066},{time:.1,tint:0x000000});
			
			//hsd2.highlightAndLock();
			hsd4.highlight();
			
			//uses the decorated object for reads
			//trace(hsd2.x);
			
			//uses the proxy through object for reads and writes.
			//trace(hsd1.y);
			//hsd1.x = 400;
		}	}}