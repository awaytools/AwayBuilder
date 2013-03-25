package awaybuilder.controller.events
{
	import flash.events.Event;
	
	public class ReadDocumentEvent extends Event
	{
		public static const REPLACE_DOCUMENT:String = "replaceData";
		public static const APPEND_DOCUMENT:String = "appendData";
		
		public function ReadDocumentEvent(type:String, name:String=null, path:String=null)
		{
			super(type, false, false);
			this.name = name;
			this.path = path;
		}
		
		public var name:String;
		public var path:String;
		
		override public function clone():Event
		{
			return new ReadDocumentEvent(this.type, this.name, this.path);
		}
	}
}