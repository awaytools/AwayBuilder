package awaybuilder.events
{
	import flash.events.Event;
	
	public class ReadDocumentDataEvent extends Event
	{
		public static const READ_DOCUMENT_DATA:String = "readDocumentData";
		public static const REPLACE_DOCUMENT:String = "readAndReplaceData";
		
		public function ReadDocumentDataEvent(type:String, name:String, path:String)
		{
			super(type, false, false);
			this.name = name;
			this.path = path;
		}
		
		public var name:String;
		public var path:String;
		
		override public function clone():Event
		{
			return new ReadDocumentDataEvent(this.type, this.name, this.path);
		}
	}
}