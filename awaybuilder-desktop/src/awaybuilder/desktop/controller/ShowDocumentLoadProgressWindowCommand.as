package awaybuilder.desktop.controller
{
	import awaybuilder.desktop.view.components.DocumentLoadProgressWindow;
	
	import flash.display.Screen;
	
	import mx.core.FlexGlobals;
	
	import org.robotlegs.mvcs.Command;
	
	public class ShowDocumentLoadProgressWindowCommand extends Command
	{
		
		override public function execute():void
		{
			var window:DocumentLoadProgressWindow = new DocumentLoadProgressWindow();			
			window.open();
			window.validateNow();
			
			this.mediatorMap.createMediator(window);
			
			var app:AwayBuilderApplication = FlexGlobals.topLevelApplication as AwayBuilderApplication;
			
			window.width = window.measuredWidth;
			window.height = window.measuredHeight;
			window.nativeWindow.x = app.nativeWindow.x + (app.nativeWindow.width - window.nativeWindow.width) / 2;
			window.nativeWindow.y = app.nativeWindow.y + (app.nativeWindow.height - window.nativeWindow.height) / 2;
		}
	}
}