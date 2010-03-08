package
{
	import gs.util.FileFilters;
	import gs.util.FileRef;
	import gs.util.MathUtils;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;

	public class Main extends Sprite
	{
		
		public var fileref:FileRef;
		public var selectFile:MovieClip;
		
		public function Main()
		{
			fileref=new FileRef(FileRef.ONE_MB);
			fileref.setCallbacks(onComplete,onCancel,onSelected);
			fileref.setAlternateCallbacks(onSizeTooBig,onProgress);
			selectFile.addEventListener(MouseEvent.CLICK,onSelectFile);
		}
		
		private function onSelectFile(e:MouseEvent):void
		{
			fileref.browse([FileFilters.BitmapFileFilter]);
		}
		
		private function onSizeTooBig():void
		{
			trace("too big");
		}
		
		private function onComplete():void
		{
			trace("upload complete");
		}
		
		private function onCancel():void
		{
			trace("canceled");
		}
		
		private function onSelected():void
		{
			trace("selected");
			trace(fileref.fr.size);
			//you could manually check file size if you wanted to..
			//FileRef.exceedsSizeLimit(fileref,1); //Checks if size is > 1KB
			fileref.upload("http://uploader/upload.php");
		}
		
		private function onProgress():void
		{
			trace("progress");
			var pe:ProgressEvent = fileref.progressEvent;
			trace(MathUtils.spread(pe.bytesLoaded,pe.bytesTotal,100));
		}
	}
}