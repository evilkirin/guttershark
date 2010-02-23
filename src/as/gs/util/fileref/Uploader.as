package gs.util.fileref
{
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
	 * The Uploader class is a simple wrapper around FileReference
	 * for selecting and uploading an image.
	 * 
	 * @example Using the Uploader class
	 * <listing>	
	 * public class Main extends Sprite
	 * {
	 * 
	 *  public var uploader:Uploader;
	 *  public var selectFile:MovieClip; //clip on the stage.
	 *  
	 *  public function Main()
	 *  {
	 *      uploader=new Uploader();
	 *      uploader.setCallbacks(onComplete,onCancel,onSelected,onProgress);
	 *      selectFile.addEventListener(MouseEvent.CLICK,onSelectFile);
	 *  }
	 *  
	 *  private function onSelectFile(e:MouseEvent):void
	 *  {
	 *      uploader.selectFile([FileFilters.BitmapFileFilter]);
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
	 *      uploader.uploadTo("http://uploader/upload.php");
	 *  }
	 *  
	 *  private function onProgress():void
	 *  {
	 *      trace("progress");
	 *      var pe:ProgressEvent = uploader.progressEvent;
	 *      trace(MathUtils.spread(pe.bytesLoaded,pe.bytesTotal,100));
	 *  }
	 * }
	 * </listing>
	 */
	public class Uploader extends EventDispatcher 
	{
		
		/**
		 * A file reference instance.
		 */
		protected var fr:FileReference;
		
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
		 * Whether or not a selection was made before calling
		 * uploadTo.
		 */
		private var hasSelected:Boolean;
		
		/**
		 * Constructor for Uploader instances.
		 */
		public function Uploader(){}
		
		/**
		 * Set callbacks for this Uploader.
		 * 
		 * @param complete The onComplete callback.
		 * @param cancel The onCancel callback.
		 * @param selected The onSelected callback.
		 * @param progress The onProgress callback.
		 * @param uploadData The onUploadData callback.
		 * @param open The onOpen callback.
		 * @param status The onHTTPStatus callback.
		 * @param ioerror The onIOError callback.
		 * @param securityerror The onSecurityError callback.
		 */
		public function setCallbacks(complete:Function=null,cancel:Function=null,selected:Function=null,progress:Function=null,uploadData:Function=null,open:Function=null,status:Function=null,ioerror:Function=null,securityerror:Function=null):void
		{
			onCancel=cancel;
			onComplete=complete;
			onUploadData=uploadData;
			onProgress=progress;
			onHTTPStatus=status;
			onIOError=ioerror;
			onSecurityError=securityerror;
			onSelected=selected;
			onOpen=open;
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
		public function selectFile(typeFilter:Array):void
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
		public function uploadTo(url:String,fileFieldName:String="Filedata"):void
		{
			if(!hasSelected)throw new Error("You can't upload the same file more than once, the use has to initiate it more than once.");
			fr.upload(new URLRequest(url),fileFieldName);
			hasSelected=false;
		}

		/**
		 * On file selected.
		 */
		private function _onFileSelected(e:Event):void
		{
			if(onSelected!=null)onSelected();
			else dispatchEvent(e);
		}
		
		/**
		 * On file upload complete.
		 */
		private function _onUploadComplete(e:Event):void
		{
			if(onComplete!=null)onComplete();
			else dispatchEvent(e);
		}
		
		/**
		 * On upload complete data.
		 */
		private function _onUploadCompleteData(e:DataEvent):void
		{
			uploadCompleteData=e.data;
			if(onUploadData!=null)onUploadData();
			else dispatchEvent(e);
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
		}
	}
}