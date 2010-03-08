package 
{
	import fl.controls.Button;

	import gs.display.GSSprite;
	import gs.display.flv.FLV;
	import gs.display.flv.FLVControls;
	import gs.util.SetterUtils;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Main extends GSSprite
	{
		
		public var flvHolder:MovieClip;
		public var play1:Button;
		public var play2:Button;
		public var play3:Button;
		public var play4:Button;
		public var backbar:MovieClip;
		
		public var availableBytes:MovieClip;
		
		public var playAgain:MovieClip;
		public var initialPlay:MovieClip;
		public var playb:MovieClip;
		public var pauseb:MovieClip;
		public var played:MovieClip;
		public var buffer:MovieClip;
		public var handle:MovieClip;
		public var mute:MovieClip;
		public var bufferIndicator:MovieClip;
		
		private var flv:FLV;
		private var controls:FLVControls;

		public function Main()
		{
			super();
			init();
		}

		protected function init():void
		{
			SetterUtils.buttonMode(true,pauseb,playb,initialPlay,playAgain,mute);
			flv=new FLV(262,100);
			flvHolder.addChild(flv.video);
			controls=new FLVControls(flv,playb,pauseb,null,played,handle,buffer,bufferIndicator,initialPlay,playAgain,mute);
			play1.addEventListener(MouseEvent.CLICK,onPlay1Click);
			play2.addEventListener(MouseEvent.CLICK,onPlay2Click);
			play3.addEventListener(MouseEvent.CLICK,onPlay3Click);
			play4.addEventListener(MouseEvent.CLICK,onPlay4Click);
			onPlay3Click();
		}
		
		public function onPlay1Click(e:MouseEvent =null):void
		{
			flv.load("gears_madworld.flv",320,240,4,true,false);
		}
		
		public function onPlay2Click(e:MouseEvent =null):void
		{
			flv.load("adidas_carry.flv",320,240,4,true,false);
		}
		
		public function onPlay3Click(e:MouseEvent =null):void
		{
			flv.load("gears_madworld.flv");
		}
		
		public function onPlay4Click(e:MouseEvent =null):void
		{
			flv.load("adidas_carry.flv");
		}	}}