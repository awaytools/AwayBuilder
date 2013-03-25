package awaybuilder.controller.document
{
	import awaybuilder.controller.events.ReadDocumentEvent;
	import awaybuilder.services.IDocumentService;
	
	import flash.utils.setTimeout;
	
	import org.robotlegs.mvcs.Command;

	public class ImportDocumentCommand extends Command
	{
		[Inject]
		public var fileService:IDocumentService;
		
		override public function execute():void
		{
			var nextEvent:ReadDocumentEvent = new ReadDocumentEvent(ReadDocumentEvent.APPEND_DOCUMENT, null, null);
			this.fileService.open( "all", nextEvent );
		}
	}
}