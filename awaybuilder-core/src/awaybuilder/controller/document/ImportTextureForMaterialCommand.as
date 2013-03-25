package awaybuilder.controller.document
{
	import awaybuilder.controller.document.events.ImportTextureForMaterialEvent;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.services.IDocumentService;
	
	import org.robotlegs.mvcs.Command;

	public class ImportTextureForMaterialCommand extends Command
	{
		[Inject]
		public var event:ImportTextureForMaterialEvent;
		
		[Inject]
		public var fileService:IDocumentService;
		
		
		override public function execute():void
		{
			var nextEvent:ImportTextureForMaterialEvent = new ImportTextureForMaterialEvent(ImportTextureForMaterialEvent.LOAD, event.items);
			this.fileService.open( "images", nextEvent );
		}
	}
}