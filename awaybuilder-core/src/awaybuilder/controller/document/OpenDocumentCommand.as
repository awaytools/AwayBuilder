package awaybuilder.controller.document
{
	import awaybuilder.controller.events.DocumentEvent;
	import awaybuilder.controller.events.DocumentDataOperationEvent;
	import awaybuilder.model.IDocumentService;
	
	import org.robotlegs.mvcs.Command;
	
	public class OpenDocumentCommand extends Command
	{
		[Inject]
		public var fileService:IDocumentService;
		
		override public function execute():void
		{
			var nextEvent:DocumentDataOperationEvent = new DocumentDataOperationEvent(DocumentDataOperationEvent.CONCAT_DOCUMENT_DATA );
			nextEvent.canUndo = false;
			this.fileService.open( "open", true, nextEvent );
		}
	}
}