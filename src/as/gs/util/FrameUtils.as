package gs.util
{
	import flash.display.MovieClip;
	
	/**
	 * The FrameUtils class contains utilities for movie clip frames.
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class FrameUtils 
	{
		
		/**
		 * Returns the frame number of a label.
		 * 
		 * @param target The movie clip.
		 * @param label The frame label.
		 */
		public static function getFrameNumberForLabel(target:MovieClip,label:String):int
		{
			var labels:Array=target.currentLabels;
			var l:int=labels.length;
			while(l--) if(labels[l].name==label) return labels[l].frame;
			return -1;
		}
		
		/**
		 * Adds a frame script to a clip.
		 * 
		 * @param target The movie clip.
		 * @param frame A frame number or frame label.
		 * @param callback A function callback.
		 */
		public static function addFrameScript(target:MovieClip,frame:*,callback:Function):Boolean
		{
			if(!target)return false;
			if(frame is String)frame=FrameUtils.getFrameNumberForLabel(target,frame);
			else if(!(frame is uint)) throw new ArgumentError('frame');
			if(frame==-1||frame==0||frame>target.totalFrames) return false;
			target.addFrameScript(frame-1,callback);
			return true;
		}
		
		/**
		 * Remove a frame script from a clip.
		 * 
		 * @param target The movie clip.
		 * @param frame A frame number or frame label.
		 */
		public static function removeFrameScript(target:MovieClip,frame:*):void
		{
			if(!target) return;
			if(frame is String)frame=FrameUtils.getFrameNumberForLabel(target,frame);
			else if(!(frame is uint)) throw new ArgumentError('frame');
			if(frame==-1||frame==0||frame>target.totalFrames) return;
			target.addFrameScript(frame-1,null);
		}
	}
}
