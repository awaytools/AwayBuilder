package awaybuilder.desktop.controller
{
	import awaybuilder.controller.events.SceneReadyEvent;
	
	import flash.utils.setTimeout;
	
	import mx.core.FlexGlobals;
	
	import org.robotlegs.mvcs.Command;

	public class SceneReadyCommand extends Command
	{
		[Inject]
		public var event:SceneReadyEvent;
		
		private var _app:AwayBuilderApplication;
		
		override public function execute():void
		{
			_app = FlexGlobals.topLevelApplication as AwayBuilderApplication;
			_app.splashScreen.close();
			_app.maximize();
			_app.visible = true;
		}
		
	}
}