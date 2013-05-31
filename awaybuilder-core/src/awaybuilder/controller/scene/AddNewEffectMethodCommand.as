package awaybuilder.controller.scene
{
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.vo.scene.EffectMethodVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.utils.AssetUtil;

	public class AddNewEffectMethodCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:SceneEvent;
		
		override public function execute():void
		{
			var material:MaterialVO;
			if( event.items && event.items.length )
			{
				material = event.items[0] as MaterialVO;
			}
			var oldValue:EffectMethodVO = event.oldValue as EffectMethodVO;
			var newValue:EffectMethodVO = event.newValue as EffectMethodVO;
			
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
				if( event.isUndoAction )
				{
					document.removeAsset( material.effectMethods, oldValue );
				}
				else 
				{
					material.effectMethods.addItem(newValue);
				}
			}
			
			commitHistoryEvent( event );
		}
		
	}
}