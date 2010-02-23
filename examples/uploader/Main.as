package
{
	import gs.util.FileFilters;
	import gs.util.MathUtils;
	import gs.util.fileref.Uploader;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;

	public class Main extends Sprite 
	{
		
		public var uploader:Uploader;
		public var selectFile:MovieClip;
		
		public function Main()
		{
			uploader=new Uploader();
			uploader.setCallbacks(onComplete,onCancel,onSelected,onProgress);
			selectFile.addEventListener(MouseEvent.CLICK,onSelectFile);
		}
		
		private function onSelectFile(e:MouseEvent):void
		{
			uploader.selectFile([FileFilters.BitmapFileFilter]);
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
			uploader.uploadTo("http://uploader/upload.php");
		}
		
		private function onProgress():void
		{
			trace("progress");
			var pe:ProgressEvent = uploader.progressEvent;
			trace(MathUtils.spread(pe.bytesLoaded,pe.bytesTotal,100));
		}
	}
}