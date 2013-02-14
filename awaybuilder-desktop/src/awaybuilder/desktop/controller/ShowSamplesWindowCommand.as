package awaybuilder.desktop.controller
{
	import flash.display.Screen;
	
	import awaybuilder.desktop.view.components.SamplesWindow;
	import awaybuilder.model.IEditorModel;
	
	import org.robotlegs.mvcs.Command;
	
	public class ShowSamplesWindowCommand extends Command
	{
		private static const SAMPLES_WINDOW_TITLE:String = "Application Name - Sample Documents";
		
		[Inject]
		public var mainWindow:AwayBuilderApplication;
		
		[Inject]
		public var editor:IEditorModel;
		
		override public function execute():void
		{
			var window:SamplesWindow = new SamplesWindow();
			this.mediatorMap.createMediator(window);
			
			window.open();
			
			window.nativeWindow.x = (Screen.mainScreen.bounds.width - window.nativeWindow.width) / 2;
			window.nativeWindow.y =(Screen.mainScreen.bounds.height - window.nativeWindow.height) / 2;
		}
	}
}