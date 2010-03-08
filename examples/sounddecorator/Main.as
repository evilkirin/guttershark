package 
{
	import gs.display.decorators.SoundDecorator;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class Main extends Sprite
	{
		
		public var b1:MovieClip;

		var sd:SoundDecorator;
		
		public function Main():void
		{
			super();
			b1.doubleClickEnabled=true;
			var test1:Object = {clickSound:"Sparkle"};
			var test2:Object = {doubleClickSound:"Sparkle"};
			var test3:Object = {overSound:"Sparkle"};
			var test4:Object = {downSound:"Sparkle"};
			var test5:Object = {upSound:"Sparkle"};
			var test6:Object = {outSound:"Sparkle"};
			var test7:Object = {upOutsideSound:"Sparkle"};
			sd=new SoundDecorator(b1,test1);
		}	}}