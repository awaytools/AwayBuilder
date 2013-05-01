package awaybuilder.view.mediators
{
	import awaybuilder.model.DocumentModel;
	import awaybuilder.utils.scene.CameraManager;
	import awaybuilder.view.components.EditStatusBar;
	import awaybuilder.view.components.events.ToolBarZoomEvent;
	import awaybuilder.view.scene.events.Scene3DManagerEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class EditStatusBarMediator extends Mediator
	{
		[Inject]
		public var view:EditStatusBar;
		
		[Inject]
		public var document:DocumentModel;
		
		[Inject]
		public var statusBar:EditStatusBar;
		
		override public function onRegister():void
		{	
			this.eventMap.mapListener(this.statusBar, ToolBarZoomEvent.ZOOM_IN, statusBar_zoomInHandler);
			this.eventMap.mapListener(this.statusBar, ToolBarZoomEvent.ZOOM_OUT, statusBar_zoomOutHandler);
			this.eventMap.mapListener(this.statusBar, ToolBarZoomEvent.ZOOM_TO, statusBar_zoomToHandler);
			
			addContextListener( Scene3DManagerEvent.ZOOM_TO_DISTANCE, eventDispatcher_zoomChangeHandler);
		}
		
		private function eventDispatcher_zoomChangeHandler(event:Scene3DManagerEvent):void
		{
			statusBar.zoom += event.currentValue.x*8;
			CameraManager.radius = CameraManager.zoomFunction(statusBar.zoom);
		}
		
		private function statusBar_zoomToHandler(event:ToolBarZoomEvent):void
		{
			CameraManager.radius = CameraManager.zoomFunction(statusBar.zoom);
		}
		
		private function statusBar_zoomInHandler(event:ToolBarZoomEvent):void
		{
			statusBar.zoom += 0.05;
			CameraManager.radius = CameraManager.zoomFunction(statusBar.zoom);
		}
		
		private function statusBar_zoomOutHandler(event:ToolBarZoomEvent):void
		{
			statusBar.zoom -= 0.05;
			CameraManager.radius = CameraManager.zoomFunction(statusBar.zoom);
		}
	}
}