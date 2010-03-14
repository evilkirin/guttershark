package
{
	import gs.audio.AudioObject;
	import gs.audio.AudioTimeline;
	import gs.audio.AudioTimelineAction;
	import gs.managers.AssetManager;

	import flash.display.Sprite;

	public class Main extends Sprite
	{
		
		private var at:AudioTimeline;
		private var sparkle:AudioObject;
		
		public function Main()
		{
			sparkle=new AudioObject(AssetManager.getSound("sparkle"));
			at=new AudioTimeline();
			at.add(new AudioTimelineAction(sparkle,"play",300)); //will call sparkle.play()
			at.add(new AudioTimelineAction(sparkle,"pause",600)); //will call sparkle.pause()
			at.add(new AudioTimelineAction(sparkle,"play",1000)); //will call sparkle.play()
			at.add(new AudioTimelineAction(sparkle,"setVolume",1000,[.3])); //will call sparkle.setVolume(.3)
			
			var ata:AudioTimelineAction=new AudioTimelineAction(sparkle,"setVolume",1600,[1]);
			at.add(ata); //will call sparkle.setVolume(1)
			//at.remove(ata); //test removing the action
			
			at.start();
		}
	}
}