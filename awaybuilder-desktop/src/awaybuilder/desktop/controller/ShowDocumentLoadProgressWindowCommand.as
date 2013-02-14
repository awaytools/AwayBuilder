package awaybuilder.desktop.controller
{
	import flash.display.Screen;
	
	import awaybuilder.desktop.view.components.DocumentLoadProgressWindow;
	
	import org.robotlegs.mvcs.Command;
	
	public class ShowDocumentLoadProgressWindowCommand extends Command
	{
		[Inject]
		public var mainWindow:AwayBuilderApplication;
		
		override public function execute():void
		{
			var window:DocumentLoadProgressWindow = new DocumentLoadProgressWindow();			
			window.open();
			window.validateNow();
			
			this.mediatorMap.createMediator(window);
			
			
			window.width = window.measuredWidth;
			window.height = window.measuredHeight;
			window.nativeWindow.x = mainWindow.nativeWindow.x + (mainWindow.nativeWindow.width - window.nativeWindow.width) / 2;
			window.nativeWindow.y = mainWindow.nativeWindow.y + (mainWindow.nativeWindow.height - window.nativeWindow.height) / 2;
		}
	}
}