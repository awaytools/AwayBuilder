package awaybuilder.events
{
	import flash.events.Event;
	
	public class DocumentModelEvent extends Event
	{
		public static const DOCUMENT_NAME_CHANGED:String = "documentNameChanged";
		public static const DOCUMENT_EDITED:String = "documentEdited";
		
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