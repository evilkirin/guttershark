package gs.util 
{
	import flash.net.FileFilter;	

	/**
	 * The FileFilterUtils class provides static variables that have predefined
	 * file filter instances, to save time.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class FileFilters 
	{
		
		/**
		 * A FileFilter containing bitmap extensions - it contains .jpg,.jpeg,.gif,.png,.bmp.
		 */
		public static const BitmapFileFilter:FileFilter=new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png, *.bmp)","*.jpg;*.jpeg;*.gif;*.png;*.bmp");
		
		/**
		 * A FileFilter containing video extensions - it contains .mov,.mp4,.f4v,.flv.
		 */
		public static const VideoFileFilter:FileFilter=new FileFilter("Video (*.mov, *.mp4, *.f4v, *.flv)","*.mov;*.mp4;*.f4v;*.flv");
		
		/**
		 * A FileFilter containing the swf extension - it contains .swf.
		 */
		public static const SWFFileFilter:FileFilter=new FileFilter("SWF (*.swf)","*.swf");
		
		/**
		 * A FileFilter containing the css extension - it contains .css.
		 */
		public static const CSSFileFilter:FileFilter=new FileFilter("CSS (*.css)","*.css");
		
		/**
		 * A FileFilter containing the html extension - it contains .html.
		 */
		public static const HTMLFileFilter:FileFilter=new FileFilter("HTML (*.html, *.htm)","*.html;*.htm");
		
		/**
		 * A FileFilter containing text extensions - it contains .txt,.rtf.
		 */
		public static const TextFileFilter:FileFilter=new FileFilter("Text Files (*.txt, *.rtf)", "*.txt;*.rtf");
		
		/**
		 * A FileFilter containing more text extensions - it contains .doc,.docx.
		 */
		public static const ExtendedTextFileFilter:FileFilter=new FileFilter("Word Doc Files (*.doc, *.docx)", "*.doc;*.docx");
		
		/**
		 * A FileFilter containing xml extension - it contains .xml.
		 */
		public static const XMLFileFilter:FileFilter=new FileFilter("XML Files (*.xml)","*.xml");
		
		/**
		 * A FileFilter containing .zip file.
		 */
		public static const ZIPFileFilter:FileFilter=new FileFilter("ZIP Archive (*.zip,*.ZIP)","*.zip;*.ZIP)");
	}
}