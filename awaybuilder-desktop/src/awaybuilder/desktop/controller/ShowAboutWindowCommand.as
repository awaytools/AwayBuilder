package awaybuilder.desktop.controller
{
	import flash.display.Screen;
	
	import awaybuilder.desktop.view.components.AboutWindow;
	import awaybuilder.events.EditingSurfaceRequestEvent;
	
	import org.robotlegs.mvcs.Command;
	
	public class ShowAboutWindowCommand extends Command
	{
		[Inject]
		public var awaybuilder:AwayBuilderApplication;
		
		override public function execute():void
		{
			//deselect so that the editor window doesn't interfere.
			this.dispatch(new EditingSurfaceRequestEvent(EditingSurfaceRequestEvent.SELECT_NONE));
			
			var window:AboutWindow = new AboutWindow();
			this.mediatorMap.createMediator(window);
			
			window.open();
			
			window.nativeWindow.x = (Screen.mainScreen.bounds.width - window.nativeWindow.width) / 2;
			window.nativeWindow.y = (Screen.mainScreen.bounds.height - window.nativeWindow.height) / 2;
		}
	}
}