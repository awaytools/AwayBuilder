package awaybuilder.web.controller
{
	import awaybuilder.controller.events.SceneReadyEvent;
	
	import flash.system.Capabilities;
	import flash.utils.setTimeout;
	
	import mx.core.FlexGlobals;
	import mx.events.ResizeEvent;
	
	import org.robotlegs.mvcs.Command;

	public class SceneReadyCommand extends Command
	{
		[Inject]
		public var event:SceneReadyEvent;
		
		private var _app:AwayBuilderApplication;
		
		override public function execute():void
		{
//			_app = FlexGlobals.topLevelApplication as AwayBuilderApplication;
//			_app.splashScreen.close();
//			_app.visible = true;
//			_app.alwaysInFront = true;
//			_app.alwaysInFront = false;
		}
		
		
	}
}