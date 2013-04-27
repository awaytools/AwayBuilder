package awaybuilder.controller.events
{
	import awaybuilder.controller.history.HistoryEvent;
	import awaybuilder.model.vo.DocumentVO;
	
	import flash.events.Event;

	public class DocumentDataOperationEvent extends HistoryEvent
	{
		public static const CONCAT_DOCUMENT_DATA:String = "concatenateDocumentData";
		
		public function DocumentDataOperationEvent( type:String )
		{
			super(type, null);
		}
		
		public var canUndo:Boolean = false;
		
		override public function clone():Event
		{
			var e:DocumentDataOperationEvent = new DocumentDataOperationEvent( this.type );
			e.newValue = this.newValue;
			e.oldValue = this.oldValue;
			return e;
		}
	}
}