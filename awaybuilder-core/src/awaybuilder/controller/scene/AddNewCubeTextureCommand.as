package awaybuilder.controller.scene
{
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.AssetsModel;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.vo.scene.CubeTextureVO;

	public class AddNewCubeTextureCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:SceneEvent;
		
		[Inject]
		public var assets:AssetsModel;
		
		[Inject]
		public var document:DocumentModel;
		
		override public function execute():void
		{
			var oldValue:CubeTextureVO = event.oldValue as CubeTextureVO;
			var newValue:CubeTextureVO = event.newValue as CubeTextureVO;
			
			if( event.isUndoAction )
			{
				document.removeAsset( document.textures, oldValue );
			}
			else 
			{
				document.textures.addItemAt( newValue, 0 );
			}
			
			addToHistory( event );
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
		}
		
	}
}