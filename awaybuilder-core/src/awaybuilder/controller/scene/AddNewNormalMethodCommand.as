package awaybuilder.controller.scene
{
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.NormalMethodVO;
	import awaybuilder.utils.AssetFactory;

	public class AddNewNormalMethodCommand extends HistoryCommandBase
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
				material = AssetFactory.assets[event.items[0].linkedObject] as MaterialVO;
			}
			var oldValue:NormalMethodVO = event.oldValue as NormalMethodVO;
			var newValue:NormalMethodVO = event.newValue as NormalMethodVO;
			
			if( material )
			{
				saveOldValue( event, material.normalMethod.clone() );
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
				material.normalMethod = newValue;
				material.apply();
			}
			
			addToHistory( event );
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
		}
		
		
	}
}