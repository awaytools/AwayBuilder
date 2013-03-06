package awaybuilder.controller.scene
{
	import awaybuilder.controller.events.EditingSurfaceRequestEvent;
	import awaybuilder.utils.scene.CameraManager;
	import awaybuilder.utils.scene.Scene3DManager;
	import awaybuilder.utils.scene.modes.GizmoMode;
	
	import org.robotlegs.mvcs.Command;

	public class SwitchTransformTranslateModeCommand extends Command
	{
		
		[Inject]
		public var event:EditingSurfaceRequestEvent;
		
		override public function execute():void
		{
			Scene3DManager.setTransformMode(GizmoMode.TRANSLATE);
		}
	}
}