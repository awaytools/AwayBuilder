package awaybuilder.controller.events
{
	import flash.events.Event;
	
	public class DocumentModelEvent extends Event
	{
		public static const DOCUMENT_NAME_CHANGED:String = "documentNameChanged";
		public static const DOCUMENT_EDITED:String = "documentEdited";
		public static const DOCUMENT_UPDATED:String = "documentUpdated";
		public static const OBJECTS_UPDATED:String = "objectsUpdated";
		
		public function DocumentModelEvent(type:String)
		{
			super(type, false, false);
		}
		
		override public function clone():Event
		{
			return new DocumentModelEvent(this.type);
		}
	}
}