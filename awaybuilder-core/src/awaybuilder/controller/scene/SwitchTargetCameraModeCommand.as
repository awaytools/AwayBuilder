package awaybuilder.controller.scene
{
	import awaybuilder.events.EditingSurfaceRequestEvent;
	import awaybuilder.scene.controllers.CameraManager;
	import awaybuilder.scene.modes.CameraMode;
	
	import org.robotlegs.mvcs.Command;

	public class SwitchTargetCameraModeCommand extends Command
	{
		
		[Inject]
		public var event:EditingSurfaceRequestEvent;
		
		override public function execute():void
		{
			CameraManager.mode = CameraMode.TARGET;
		}
	}
}