package awaybuilder.controller.scene
{
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.AssetsModel;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.vo.scene.CubeTextureVO;
	import awaybuilder.model.vo.scene.EffectMethodVO;

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
			var asset:EffectMethodVO;
			if( event.items && event.items.length )
			{
				asset = event.items[0] as EffectMethodVO;
			}
			
			var oldValue:CubeTextureVO = event.oldValue as CubeTextureVO;
			var newValue:CubeTextureVO = event.newValue as CubeTextureVO;
			
			if( asset ) {
				saveOldValue( event, asset.cubeTexture );
			}
			
			if( event.isUndoAction )
			{
				document.removeAsset( document.textures, oldValue );
			}
			else 
			{
				document.textures.addItemAt( newValue, 0 );
			}
			
			if( asset )
			{
				asset.cubeTexture = newValue;
			}
			
			addToHistory( event );
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
			document.empty = false;
			document.edited = true;
		}
		
	}
}