package awaybuilder.controller.scene
{
	import away3d.lights.LightBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
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
			var oldValue:LightVO = event.oldValue as LightVO;
			var newValue:LightVO = event.newValue as LightVO;
			
			if( event.isUndoAction )
			{
				document.removeAsset( document.lights, oldValue );
				Scene3DManager.removeLight( oldValue.linkedObject as LightBase );
			}
			else 
			{
				document.lights.addItemAt( newValue, 0 );
				Scene3DManager.addLight( newValue.linkedObject as LightBase );
			}
			
			addToHistory( event );
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
		}
		
	}
}