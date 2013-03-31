package awaybuilder.controller.scene
{
	import away3d.lights.LightBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.scene.LightVO;
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
			var newLight:LightVO = event.newValue as LightVO;
			
			if( event.isUndoAction )
			{
				var oldLight:LightVO = event.oldValue as LightVO;
				for (var j:int = 0; j < document.lights.length; j++) 
				{
					if( document.lights[j].id == oldLight.id )
					{
						document.lights.removeItemAt( j );
						Scene3DManager.removeLight( oldLight.linkedObject as LightBase );
						break;
					}
				}
			}
			else 
			{
				document.lights.addItemAt( newLight.clone(), 0 );
				Scene3DManager.addLight( newLight.linkedObject as LightBase );
			}
			
			addToHistory( event );
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
			
		}
		
	}
}