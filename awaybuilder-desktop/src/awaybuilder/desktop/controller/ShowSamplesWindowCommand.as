package awaybuilder.desktop.controller
{
	import flash.display.Screen;
	
	import awaybuilder.desktop.view.components.WelcomeWindow;
	
	import org.robotlegs.mvcs.Command;
	
	public class ShowSamplesWindowCommand extends Command
	{
		private static const SAMPLES_WINDOW_TITLE:String = "Application Name - Sample Documents";
		
		[Inject]
		public var mainWindow:AwayBuilderApplication;
		
		override public function execute():void
		{
			var window:WelcomeWindow = new WelcomeWindow();
			this.mediatorMap.createMediator(window);
			
			window.open();
			
			window.nativeWindow.x = (Screen.mainScreen.bounds.width - window.nativeWindow.width) / 2;
			window.nativeWindow.y =(Screen.mainScreen.bounds.height - window.nativeWindow.height) / 2;
		}
	}
}