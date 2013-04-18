package awaybuilder.controller.scene
{
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.ShadowMethodVO;
	import awaybuilder.utils.AssetFactory;

	public class AddNewShadowMethodCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:SceneEvent;
		
		[Inject]
		public var document:IDocumentModel;
		
		override public function execute():void
		{
			var material:MaterialVO;
			if( event.items && event.items.length )
			{
				material = event.items[0] as MaterialVO;
			}
			var oldValue:ShadowMethodVO = event.oldValue as ShadowMethodVO;
			var newValue:ShadowMethodVO = event.newValue as ShadowMethodVO;
			
			if( material && material.shadowMethod  )
			{
				saveOldValue( event, material.shadowMethod.clone() );
			}
			
			if( event.isUndoAction )
			{
				document.removeAsset( document.methods, oldValue );
			}
			else 
			{
				document.methods.addItemAt( newValue, 0 );
			}
			
			if( material )
			{
				material.shadowMethod = newValue;
			}
			
			addToHistory( event );
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
		}
		
		
	}
}