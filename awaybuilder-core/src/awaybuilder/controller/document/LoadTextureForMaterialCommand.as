package awaybuilder.controller.document
{
	import awaybuilder.controller.document.events.ImportTextureForMaterialEvent;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.services.ProcessDataService;
	
	import org.robotlegs.mvcs.Command;

	public class LoadTextureForMaterialCommand extends Command
	{
		public var document:IDocumentModel;
		
		[Inject]
		public var dataService:ProcessDataService;
		
		[Inject]
		public var event:ImportTextureForMaterialEvent;
		
		override public function execute():void
		{
			var e:SceneEvent = new SceneEvent(SceneEvent.ADD_NEW_TEXTURE, event.items  );
			dataService.load( this.event.path, e );
		}
	}
}