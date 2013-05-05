package awaybuilder.controller.scene
{
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.vo.scene.LightVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.ShadowMethodVO;
	import awaybuilder.utils.AssetUtil;

	public class AddNewShadowMethodCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:SceneEvent;
		
		[Inject]
		public var document:DocumentModel;
		
		override public function execute():void
		{
			var asset:LightVO;
			if( event.items && event.items.length )
			{
				asset = event.items[0] as LightVO;
			}
			var oldValue:ShadowMethodVO = event.oldValue as ShadowMethodVO;
			var newValue:ShadowMethodVO = event.newValue as ShadowMethodVO;
			
			if( asset )
			{
				if( event.isUndoAction )
				{
					document.removeAsset( asset.shadowMethods, oldValue );
				}
				else 
				{
					asset.shadowMethods.addItem(newValue);
				}
			}
			
			addToHistory( event );
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
			document.empty = false;
			document.edited = true;
		}
		
		
	}
}