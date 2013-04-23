package awaybuilder.controller.document
{
	import awaybuilder.controller.document.events.ImportTextureEvent;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.IDocumentService;
	
	import org.robotlegs.mvcs.Command;

	public class ImportTextureForMaterialCommand extends Command
	{
		[Inject]
		public var event:ImportTextureEvent;
		
		[Inject]
		public var fileService:IDocumentService;
		
		
		override public function execute():void
		{
			var nextEvent:ImportTextureEvent = new ImportTextureEvent(ImportTextureEvent.LOAD_AND_ADD, event.items, event.options);
			this.fileService.open( "images", nextEvent );
		}
	}
}