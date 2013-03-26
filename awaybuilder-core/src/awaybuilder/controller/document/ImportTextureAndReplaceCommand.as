package awaybuilder.controller.document
{
	import awaybuilder.controller.document.events.ImportTextureEvent;
	import awaybuilder.services.IDocumentService;
	
	import org.robotlegs.mvcs.Command;

	public class ImportTextureAndReplaceCommand extends Command
	{
		[Inject]
		public var event:ImportTextureEvent;
		
		[Inject]
		public var fileService:IDocumentService;
		
		override public function execute():void
		{
			var nextEvent:ImportTextureEvent = new ImportTextureEvent(ImportTextureEvent.LOAD_AND_REPLACE, event.items);
			this.fileService.open( "images", nextEvent );
		}
	}
}