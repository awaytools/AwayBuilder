package awaybuilder.controller.scene
{
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.AssetsModel;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.vo.scene.TextureProjectorVO;

	public class AddNewTextureProjectorCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:SceneEvent;
		
		[Inject]
		public var document:DocumentModel;
		
		[Inject]
		public var assets:AssetsModel;
		
		override public function execute():void
		{
			var oldValue:TextureProjectorVO = event.oldValue as TextureProjectorVO;
			var newValue:TextureProjectorVO = event.newValue as TextureProjectorVO;
			
			if( event.isUndoAction )
			{
				document.removeAsset( document.scene, oldValue );
//				Scene3DManager.removeSkyBox( assets.GetObject(oldValue) as SkyBox );
			}
			else
			{
				document.scene.addItemAt( newValue, 0 );
//				Scene3DManager.addSkybox( assets.GetObject(newValue) as SkyBox );
			}
			
			addToHistory( event );
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
			document.empty = false;
			document.edited = true;
		}
		
	}
}