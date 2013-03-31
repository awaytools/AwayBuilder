package awaybuilder.controller.document
{
	import awaybuilder.controller.document.events.ImportTextureEvent;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.ProcessDataService;
	
	import org.robotlegs.mvcs.Command;

	public class LoadTextureForMaterialCommand extends Command
	{
		public var document:IDocumentModel;
		
		[Inject]
		public var dataService:ProcessDataService;
		
		[Inject]
		public var event:ImportTextureEvent;
		
		override public function execute():void
		{
			var e:SceneEvent = new SceneEvent(SceneEvent.ADD_NEW_TEXTURE, event.items  );
			dataService.load( this.event.path, e );
		}
	}
}