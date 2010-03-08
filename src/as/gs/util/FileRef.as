package gs.util
{
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import gs.util.StringUtils;

	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;

	/**
	 * Dispatched on upload complete.
	 * 
	 * @eventType flash.events.Event
	 */
	[Event("complete", type="flash.events.Event")]
	
	/**
	 * Dispatched on file open.
	 * 
	 * @eventType flash.events.Event
	 */
	[Event("open", type="flash.events.Event")]
	
	/**
	 * Dispatched when a file is selected.
	 * 
	 * @eventType flash.events.Event
	 */
	[Event("select", type="flash.events.Event")]
	
	/**
	 * Dispatched when the user cancels the file browse dialogue.
	 * 
	 * @eventType flash.events.Event
	 */
	[Event("cancel", type="flash.events.Event")]
	
	/**
	 * Dispatched on http status.
	 * 
	 * @eventType flash.events.HTTPStatusEvent
	 */
	[Event("status", type="flash.events.HTTPStatusEvent")]
	
	/**
	 * Dispatched on file upload progress.
	 * 
	 * @eventType flash.events.ProgressEvent
	 */
	[Event("progress", type="flash.events.ProgressEvent")]
	
	/**
	 * Dispatched on security error.
	 * 
	 * @eventType flash.events.SecurityErrorEvent
	 */
	[Event("securityError", type="flash.events.SecurityErrorEvent")]
	
	/**
	 * Dispatched when the upload complete and data is available.
	 * 
	 * @eventType flash.events.DataEvent
	 */
	[Event("uploadCompleteData", type="flash.events.DataEvent")]
	
	/**
	 * Dispatched on IOError.
	 * 
	 * @eventType flash.events.IOErrorEvent
	 */
	[Event("ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 * Dispatched when the size of the file to upload is too large.
	 * 
	 * @eventType flash.events.Event
	 */
	[Event("sizeLimitExceeded", type="flash.events.Event")]
	
	/**
	 * The FileRef class is a wrapper around FileReference
	 * for uploading, downloading, simplifying upload size
	 * limits and events.
	 * 
	 * <p>It simplifies the FileReference by handling all the events
	 * for you, and using callbacks.</p>
	 * 
	 * @example Using the Uploader class
	 * <listing>	
	 * public class Main extends Sprite 
	 * {
	 * 
	 *  public var fileref:FileRef;
	 *  public var selectFile:MovieClip;
	 *  
	 *  public function Main()
	 *  {
	 *      fileref=new FileRef(FileRef.ONE_MB);
	 *      fileref.setCallbacks(onComplete,onCancel,onSelected);
	 *      fileref.setAlternateCallbacks(onSizeTooBig,onProgress);
	 *      selectFile.addEventListener(MouseEvent.CLICK,onSelectFile);
	 *  }
	 *  
	 *  private function onSelectFile(e:MouseEvent):void
	 *  {
	 *      fileref.browse([FileFilters.BitmapFileFilter]);
	 *  }
	 *  
	 *  private function onSizeTooBig():void
	 *  {
	 *      trace("too big");
	 *  }
	 *  
	 *  private function onComplete():void
	 *  {
	 *      trace("upload complete");
	 *  }
	 *  
	 *  private function onCancel():void
	 *  {
	 *      trace("canceled");
	 *  }
	 *  
	 *  private function onSelected():void
	 *  {
	 *      trace("selected");
	 *      trace(fileref.fr.size);
	 *      //you could manually check file size if you wanted to..
	 *      //FileRef.exceedsSizeLimit(fileref,1); //Checks if size is > 1KB
	 *      fileref.upload("http://uploader/upload.php");
	 *  }
	 *  
	 *  private function onProgress():void
	 *  {
	 *      trace("progress");
	 *      var pe:ProgressEvent = fileref.progressEvent;
	 *      trace(MathUtils.spread(pe.bytesLoaded,pe.bytesTotal,100));
	 *  }
	 * }
	 * </listing>
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class FileRef extends EventDispatcher 
	{
		
		/**
		 * Shortcut for supplying filesize of 1MB.
		 */
		public static const ONE_MB:Number = 1024;
		
		/**
		 * Shortcut for supplying filesize of 3MB.
		 */
		public static const THREE_MB:Number = 3072;
		
		/**
		 * Shortcut for supplying filesize of 5MB.
		 */
		public static const FIVE_MB:Number = 5120;
		
		/**
		 * Internal FileReference instance.
		 */
		public var fr:FileReference;
		
		/**
		 * A size limit for a file when uploading.
		 */
		public var uploadSizeLimit:Number;
		
		/**
		 * Data after the upload is complete.
		 */
		public var uploadCompleteData:*;
		
		/**
		 * The http status code if one is available.
		 */
		public var httpStatus:int;
		
		/**
		 * The latest progress event.
		 */
		public var progressEvent:ProgressEvent;
		
		/**
		 * (Optional) A callback for the complete event.
		 */
		public var onComplete:Function;
		
		/**
		 * (Optional) A callback for the canceled event.
		 */
		public var onCancel:Function;
		
		/**
		 * (Optional) A callback for the upload data complete event.
		 */
		public var onUploadData:Function;
		
		/**
		 * (Optional) A callback for the selected file event.
		 */
		public var onSelected:Function;
		
		/**
		 * (Optional) A callback for the http status event.
		 */
		public var onHTTPStatus:Function;
		
		/**
		 * (Optional) A callback for progress events.
		 */
		public var onProgress:Function;
		
		/**
		 * (Optional) A callback for the io error event.
		 */
		public var onIOError:Function;
		
		/**
		 * (Optional) A callback for the security error event.
		 */
		public var onSecurityError:Function;
		
		/**
		 * (Optional) A callback for the open event.
		 */
		public var onOpen:Function;
		
		/**
		 * (Optional) A callback for the size limit exceeded event.
		 */
		public var onUploadSizeLimitExceeded:Function;
		
		/**
		 * Whether or not a selection was made before calling
		 * uploadTo.
		 */
		private var hasSelected:Boolean;
		
		/**
		 * A timeout set when waiting to dispatch the complete event.
		 */
		private var waitingForData:Number;
		
		/**
		 * Constructor for FileRef instances.
		 * 
		 * @param size A maximum file size for uploads in kilobytes (default is 3MB).
		 */
		public function FileRef(_uploadSizeLimit:Number=3072)
		{
			waitingForData=NaN;
			uploadSizeLimit=_uploadSizeLimit;
		}

		/**
		 * Set callbacks for this Uploader.
		 * 
		 * @param complete The onComplete callback.
		 * @param cancel The onCancel callback.
		 * @param selected The onSelected callback.
		 * @param uploadData The onUploadData callback.
		 */
		public function setCallbacks(complete:Function=null,cancel:Function=null,selected:Function=null,uploadData:Function=null):void
		{
			onComplete=complete;
			onCancel=cancel;
			onSelected=selected;
			onUploadData=uploadData;
		}
		
		/**
		 * Set alternate callbacks.
		 * 
		 * @param size The onUploadFileSizeExceeded callback.
		 * @param progress The onProgress callback.
		 * @param open The onOpen callback.
		 * @param ioerror The onIOError callback.
		 * @param security The onSecurityError callback.
		 * @param status The onHTTPStatus callback.
		 */
		public function setAlternateCallbacks(size:Function=null,progress:Function=null,open:Function=null,ioerror:Function=null,security:Function=null,status:Function=null):void
		{
			onProgress=progress;
			onUploadSizeLimitExceeded=size;
			onOpen=open;
			onHTTPStatus=status;
			onIOError=ioerror;
			onSecurityError=security;
		}
		
		/**
		 * Check whether or not a FileRef's size exceeds
		 * maximum kilobytes.
		 * 
		 * @param fr A FileRef instance.
		 * @param kbytes The max file size in kilobytes (default is 1.5 MB).
		 */
		public static function exceedsSizeLimit(fr:FileRef,kbytes:Number=1526):Boolean
		{
			if(!fr||!fr.fr)return false;
			if(Math.max((fr.fr.size/1024),0)>kbytes) return true;
			return false;
		}
		
		/**
		 * Adds listeners.
		 */
		private function addListeners():void
		{
			if(!fr)return;
			fr.addEventListener(Event.SELECT,_onFileSelected);
			fr.addEventListener(Event.COMPLETE,_onUploadComplete);
			fr.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,_onUploadCompleteData);
			fr.addEventListener(Event.CANCEL,_onCancel);
			fr.addEventListener(HTTPStatusEvent.HTTP_STATUS,_onHTTPStatus);
			fr.addEventListener(IOErrorEvent.IO_ERROR,_onIOError);
			fr.addEventListener(IOErrorEvent.DISK_ERROR,_onIOError);
			fr.addEventListener(IOErrorEvent.NETWORK_ERROR,_onIOError);
			fr.addEventListener(IOErrorEvent.VERIFY_ERROR,_onIOError);
			fr.addEventListener(SecurityErrorEvent.SECURITY_ERROR,_onSecurityError);
			fr.addEventListener(ProgressEvent.PROGRESS,_onProgress);
			fr.addEventListener(Event.OPEN,_onOpen);
		}
		
		/**
		 * Removes listeners.
		 */
		private function removeListeners():void
		{
			if(!fr)return;
			fr.removeEventListener(Event.SELECT,_onFileSelected);
			fr.removeEventListener(Event.COMPLETE,_onUploadComplete);
			fr.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA,_onUploadCompleteData);
			fr.removeEventListener(Event.CANCEL,_onCancel);
			fr.removeEventListener(HTTPStatusEvent.HTTP_STATUS,_onHTTPStatus);
			fr.removeEventListener(IOErrorEvent.IO_ERROR,_onIOError);
			fr.removeEventListener(IOErrorEvent.DISK_ERROR,_onIOError);
			fr.removeEventListener(IOErrorEvent.NETWORK_ERROR,_onIOError);
			fr.removeEventListener(IOErrorEvent.VERIFY_ERROR,_onIOError);
			fr.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,_onSecurityError);
			fr.removeEventListener(ProgressEvent.PROGRESS,_onProgress);
			fr.removeEventListener(Event.OPEN,_onOpen);
		}
		
		/**
		 * The name of the local file.
		 */
		public function get name():String
		{
			return fr.name;
		}

		/**
		 * Get the selected file type.
		 */
		public function get type():String
		{
			if(!fr.type && fr.name) return StringUtils.findFileType(fr.name);
			if(!fr||!fr.type)return null;
			return fr.type;
		}
		
		/**
		 * Let the user browse for and choose a file.
		 * 
		 * @param typeFilter An array of FileFilter instances.
		 */
		public function browse(typeFilter:Array):void
		{
			removeListeners();
			fr=new FileReference();
			addListeners();
			fr.browse(typeFilter);
			hasSelected=true;
		}
		
		/**
		 * Upload the file to a url.
		 * 
		 * <p>You can only upload the selected file one time. This
		 * is a limitation by the flash player. To upload again the
		 * user has to choose a file again.</p>
		 * 
		 * @param url The url to upload to.
		 * @param fileFieldName The file field name that get's sent to the server.
		 */
		public function upload(url:String,fileFieldName:String="Filedata"):void
		{
			if(!hasSelected)throw new Error("You can't upload the same file more than once, the use has to initiate it more than once.");
			fr.upload(new URLRequest(url),fileFieldName);
			hasSelected=false;
		}
		
		/**
		 * Download a file.
		 * 
		 * @param url The file to download.
		 * @param defaultFileName A default file name to show in the save as dialog.
		 */
		public function download(url:String,defaultFileName:String=null):void
		{
			removeListeners();
			fr=new FileReference();
			addListeners();
			fr.download(new URLRequest(url),defaultFileName);
		}

		/**
		 * On file selected.
		 */
		private function _onFileSelected(e:Event):void
		{
			if(FileRef.exceedsSizeLimit(this,uploadSizeLimit))
			{
				if(onUploadSizeLimitExceeded!=null)onUploadSizeLimitExceeded();
				else dispatchEvent(new Event("sizeLimitExceeded"));
			}
			else
			{
				if(onSelected!=null)onSelected();
				else dispatchEvent(e);
			}
		}
		
		/**
		 * On file upload complete.
		 */
		private function _onUploadComplete(e:Event):void
		{
			waitingForData=setTimeout(reallyComplete,100,e); //slight timeout to wait for the upload data event (if it fires).
		}
		
		/**
		 * Actually fires complete event.
		 */
		private function reallyComplete(e:Event):void
		{
			clearTimeout(waitingForData);
			waitingForData=NaN;
			if(onComplete!=null)onComplete();
			else dispatchEvent(e);
		}
		
		/**
		 * On upload complete data.
		 */
		private function _onUploadCompleteData(e:DataEvent):void
		{
			var dc:Boolean=false;
			if(!isNaN(waitingForData))dc=true;
			uploadCompleteData=e.data;
			if(onUploadData!=null)onUploadData();
			else dispatchEvent(e);
			if(dc)
			{
				clearTimeout(waitingForData);
				waitingForData=NaN;
				reallyComplete(new Event(Event.COMPLETE));
			}
		}
		
		/**
		 * On cancel.
		 */
		private function _onCancel(e:Event):void
		{
			if(onCancel!=null)onCancel();
			else dispatchEvent(e);
		}
		
		/**
		 * On http status.
		 */
		private function _onHTTPStatus(e:HTTPStatusEvent):void
		{
			if(e.status == 0 || e.status == 200) return; //everything's ok.
			httpStatus=e.status;
			if(onHTTPStatus!=null)onHTTPStatus();
			else dispatchEvent(e);
		}
		
		/**
		 * On IO Error.
		 */
		private function _onIOError(e:IOErrorEvent):void
		{
			if(onIOError!=null)onIOError();
			else dispatchEvent(e);
		}
		
		/**
		 * On security error.
		 */
		private function _onSecurityError(e:SecurityErrorEvent):void
		{
			if(onSecurityError!=null)onSecurityError();
			else dispatchEvent(e);
		}
		
		/**
		 * On progress.
		 */
		private function _onProgress(e:ProgressEvent):void
		{
			if(e.bytesLoaded<0)return;
			progressEvent=e;
			if(onProgress!=null)onProgress();
			else dispatchEvent(e);
		}
		
		/**
		 * on open.
		 */
		private function _onOpen(e:Event):void
		{
			if(onOpen!=null)onOpen();
			else dispatchEvent(e);
		}
		
		/**
		 * Resets the internal FileReference state.
		 */
		public function reset():void
		{
			removeListeners();
			fr=new FileReference();
			addListeners();
		}
		
		/**
		 * Dispose of this uploader.
		 */
		public function dispose():void
		{
			removeListeners();
			fr=null;
			onCancel=null;
			onComplete=null;
			onHTTPStatus=null;
			onIOError=null;
			onOpen=null;
			onProgress=null;
			onSecurityError=null;
			onSelected=null;
			onUploadData=null;
			uploadCompleteData=null;
			httpStatus=0;
			progressEvent=null;
		}
	}
}