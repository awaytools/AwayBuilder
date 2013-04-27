package awaybuilder.controller.document
{
	import awaybuilder.controller.events.DocumentDataOperationEvent;
	import awaybuilder.controller.events.ReadDocumentEvent;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.ProcessDataService;
	
	import org.robotlegs.mvcs.Command;

	public class AppendDocumentCommand extends Command
	{
		[Inject]
		public var document:DocumentModel;
		
		[Inject]
		public var dataService:ProcessDataService;
		
		[Inject]
		public var event:ReadDocumentEvent;
		
		override public function execute():void
		{
			var e:DocumentDataOperationEvent = new DocumentDataOperationEvent(DocumentDataOperationEvent.CONCAT_DOCUMENT_DATA );
			e.canUndo = true;
			dataService.load( this.event.path, e );
			
		}
	}
}