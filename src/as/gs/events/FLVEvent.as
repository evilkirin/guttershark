package gs.events
{
	import flash.events.Event;

	/**
	 * The FLVEvent class is dispatched from an FLV instance.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.display.flv.FLV
	 */
	final public class FLVEvent extends Event
	{
	
		/**
		 * FLV Start.
		 */
		public static const START:String = 'start';
		
		/**
		 * FLV Stop.
		 */
		public static const STOP:String = 'stop';
		
		/**
		 * FLV Progress.
		 */
		public static const PROGRESS:String = 'progress';
		
		/**
		 * FLV Meta Data.
		 */
		public static const METADATA:String = 'metaData';
		
		/**
		 * Buffer Empty.
		 */
		public static const BUFFER_EMPTY:String = 'bufferEmpty';
		
		/**
		 * Buffer Full.
		 */
		public static const BUFFER_FULL:String = 'bufferFull';
		
		/**
		 * Buffer Flush.
		 */
		public static const BUFFER_FLUSH:String = 'bufferFlush';
		
		/**
		 * Invalid seek time.
		 */
		public static const SEEK_INVALID_TIME:String = 'seekInvalidTime';
		
		/**
		 * Seek notify
		 */
		public static const SEEK_NOTIFY:String = 'seekNotify';
		
		/**
		 * Stream not found.
		 */
		public static const STREAM_NOT_FOUND:String = 'streamNotFound';
		
		/**
		 * FLV url change.
		 */
		public static const URL_CHANGE:String = "urlChange";
		
		/**
		 * Cue point.
		 */
		public static const CUE_POINT:String = "cuePoint";
		
		/**
		 * XMP data.
		 */	
		public static const XMP_DATA:String = "xmpData";
		
		/**
		 * The MPEG-4 file structure is invalid.
		 */
		public static const FILE_STRUCTURE_INVALID:String = "fileStructureInvalid";
		
		/**
		 * None of the audio or video tracks in the MPEG-4 file is supported. 
		 */
		public static const NO_SUPPORTED_TRACK_FOUND:String = "noSupportedTrackFound";
		
		/**
		 * A cuepoint object.
		 */
		public var cuepoint:Object;
		
		/**
		 * The percent loaded.
		 */
		public var percentLoaded:Number;
		
		/**
		 * Percent played.
		 */
		public var percentPlayed:Number;
		
		/**
		 * The percent of the video that is in buffer.
		 */
		public var percentBuffered:Number;
		
		/**
		 * The amount of pixels that are buffered out of the total buffer.
		 */
		public var pixelsBuffered:int;
		
		/**
		 * The amount of pixels that have been played.
		 */
		public var pixelsPlayed:int;
		
		/**
		 * FLV meta data object.
		 */
		public var metadata:Object;
		
		/**
		 * Video XMP data object.
		 */
		public var xmpdata:Object;
		
		/**
		 * The currently playing, or the attempted flv url.
		 */
		public var url:String;
		
		/**
		 * The current bytes loaded of the flv.
		 */
		public var bytesLoaded:Number;
		
		/**
		 * The bytes total of the flv.
		 */
		public var bytesTotal:Number;
		
		/**
		 * Constructor for FLVEvent instances.
		 */
		public function FLVEvent(type:String,url:String=null,percentLoaded:Number=0,percentPlayed:Number=0,percentBuffered:Number=0,pixelsBuffered:Number=0,pixelsPlayed:Number=0,cuepoint:Object=null,metadata:Object=null,xmpdata:Object=null,bytesLoaded:Number=0,bytesTotal:Number=0) 
		{
			super(type,false,true);
			this.bytesLoaded = bytesLoaded;
			this.bytesTotal = bytesTotal;
			this.percentLoaded = percentLoaded;
			this.percentPlayed = percentPlayed;
			this.percentBuffered = percentBuffered;
			this.pixelsBuffered = pixelsBuffered;
			this.pixelsPlayed = pixelsPlayed;
			this.metadata = metadata;
			this.xmpdata = xmpdata;
			this.cuepoint = cuepoint;
			this.url = url;
		}

		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new FLVEvent(type,url,percentLoaded,percentPlayed,percentBuffered,pixelsBuffered,pixelsPlayed,cuepoint,metadata,xmpdata,bytesLoaded,bytesTotal);
		}														
	}
}
