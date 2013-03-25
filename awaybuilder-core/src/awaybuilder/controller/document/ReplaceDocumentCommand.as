package awaybuilder.controller.document
{
	import awaybuilder.controller.events.DocumentDataOperationEvent;
	import awaybuilder.controller.events.DocumentEvent;
	import awaybuilder.controller.events.ReadDocumentEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.services.ProcessDataService;
	
	import org.robotlegs.mvcs.Command;

	public class ReplaceDocumentCommand extends Command
	{
		[Inject]
		public var document:IDocumentModel;
		
		[Inject]
		public var dataService:ProcessDataService;
		
		[Inject]
		public var event:ReadDocumentEvent;
		
		override public function execute():void
		{
			this.dispatch(new DocumentEvent(DocumentEvent.NEW_DOCUMENT));
			
			document.name = event.name;
			document.path = event.path;
			
			var e:DocumentDataOperationEvent = new DocumentDataOperationEvent(DocumentDataOperationEvent.CONCAT_DOCUMENT_DATA );
			e.canUndo = false;
			dataService.load( this.event.path, e );
			
		}
	}
}