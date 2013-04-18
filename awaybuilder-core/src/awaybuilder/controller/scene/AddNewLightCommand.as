package awaybuilder.controller.scene
{
	import away3d.lights.LightBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.scene.LightPickerVO;
	import awaybuilder.model.vo.scene.LightVO;
	import awaybuilder.utils.AssetFactory;
	import awaybuilder.utils.scene.Scene3DManager;
	import awaybuilder.view.components.LibraryPanel;

	public class AddNewLightCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:SceneEvent;
		
		[Inject]
		public var document:IDocumentModel;
		
		override public function execute():void
		{
			var picker:LightPickerVO;
			if( event.items && event.items.length )
			{
				picker = event.items[0] as LightPickerVO;
			}
			
			var oldValue:LightVO = event.oldValue as LightVO;
			var newValue:LightVO = event.newValue as LightVO;
			
			if( picker && picker.lights )
			{
//				saveOldValue( event, material.lightPicker.clone() );
			}
			
			if( event.isUndoAction )
			{
				document.removeAsset( document.lights, oldValue );
				Scene3DManager.removeLight( AssetFactory.GetObject(oldValue) as LightBase );
			}
			else 
			{
				document.lights.addItemAt( newValue, 0 );
				Scene3DManager.addLight( AssetFactory.GetObject(newValue) as LightBase );
			}
			
			if( picker )
			{
				if( event.isUndoAction )
				{
					document.removeAsset( picker.lights, oldValue );
				}
				else 
				{
					picker.lights.addItem(newValue);
				}
			}
			
			addToHistory( event );
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
		}
		
	}
}