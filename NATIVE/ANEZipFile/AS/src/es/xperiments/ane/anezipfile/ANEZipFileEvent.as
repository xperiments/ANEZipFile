package es.xperiments.ane.anezipfile
{

	import flash.events.Event;
	import flash.utils.ByteArray;

	public class ANEZipFileEvent extends Event
	{
		public var eventInfo:Object;
		public var resultBytes:ByteArray;

		public static const UNZIP_START:String = "UNZIP_START";
		public static const UNZIP_END:String = "UNZIP_END";
		public static const UNZIP_PROGRESS:String = "UNZIP_PROGRESS";
		public static const UNZIP_ERROR:String = "UNZIP_ERROR";
		
		public static const UNZIP_FILE_BYTES:String = "UNZIP_FILE_BYTES";

		public static const ZIP_START:String = "ZIP_START";
		public static const ZIP_END:String = "ZIP_END";
		public static const ZIP_PROGRESS:String = "ZIP_PROGRESS";


		public static const ZIP_WRITE_BYTES:String = "ZIP_WRITE_BYTES";
		public static const ZIP_WRITE_FILE:String = "ZIP_WRITE_FILE";

		public function ANEZipFileEvent(type:String, eventData:String ="", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			if( eventData!="" ) eventInfo = JSON.parse( eventData );
		}

	
	}
	
}
