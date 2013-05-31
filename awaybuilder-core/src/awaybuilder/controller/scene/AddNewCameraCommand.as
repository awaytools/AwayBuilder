package awaybuilder.controller.scene
{
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.vo.scene.CameraVO;
	
	import mx.containers.Canvas;

	public class AddNewCameraCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:SceneEvent;
		
		override public function execute():void
		{
			var oldValue:CameraVO = event.oldValue as CameraVO;
			var newValue:CameraVO = event.newValue as CameraVO;
			
			if( event.isUndoAction )
			{
				document.removeAsset( document.scene, oldValue );
			}
			else 
			{
				document.scene.addItemAt( newValue, 0 );
			}
			
			commitHistoryEvent( event );
		}
		
	}
}