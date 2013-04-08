package awaybuilder.controller.scene
{
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.scene.LightPickerVO;
	import awaybuilder.model.vo.scene.MaterialVO;

	public class AddNewLightPickerCommand extends HistoryCommandBase
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
				material = document.getMaterial(event.items[0].linkedObject) as MaterialVO;
			}
			var oldValue:LightPickerVO = event.oldValue as LightPickerVO;
			var newValue:LightPickerVO = event.newValue as LightPickerVO;
			
			if( material )
			{
				saveOldValue( event, material.clone() );
			}
			
			
			if( event.isUndoAction )
			{
				document.removeAsset( document.lights, oldValue );
			}
			else 
			{
				document.lights.addItemAt( newValue.clone(), 0 );
			}
			
			if( material )
			{
				material.lightPicker = newValue;
				material.apply();
			}
			
			addToHistory( event );
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
		}
		
		
	}
}