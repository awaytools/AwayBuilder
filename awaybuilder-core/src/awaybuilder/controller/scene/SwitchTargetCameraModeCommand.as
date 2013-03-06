package awaybuilder.controller.scene
{
	import awaybuilder.controller.events.EditingSurfaceRequestEvent;
	import awaybuilder.utils.scene.CameraManager;
	import awaybuilder.utils.scene.modes.CameraMode;
	
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