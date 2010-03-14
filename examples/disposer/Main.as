package
{
	import gs.managers.AssetManager;
	import gs.audio.AudioGroup;
	import gs.audio.AudioObject;
	import gs.util.Disposer;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class Main extends Sprite
	{
		
		public var test:String;
		public var test1:Number;
		public var test2:int;
		public var test3:MovieClip;
		public var test4:AudioObject;
		public var test5:AudioGroup;
		public var test6:Boolean;
		
		private var disposer:Disposer;
		
		public function Main()
		{
			disposer=new Disposer();
			
			test="test";
			test1=1000;
			test2=1234;
			test3=new MovieClip();
			test4=new AudioObject(AssetManager.getSound("sparkle"));
			test5=new AudioGroup();
			test6=true;
			
			disposer.addObject(test4);
			disposer.addObject(test5);
			disposer.removeObject(test4);
			disposer.disposeType(AudioObject);
			
			disposer.clearvars(this,"test","test1","test2","test3","test4","test5","test6");
			
			trace(test,test1,test2,test3,test4,test5,test6);
		}
	}
}