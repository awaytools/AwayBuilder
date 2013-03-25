package awaybuilder.desktop.controller
{
	
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.controller.events.SettingsEvent;
	import awaybuilder.desktop.view.components.ApplicationSettingsWindow;
	
	import flash.display.Screen;
	
	import org.robotlegs.mvcs.Command;
	
	public class ShowApplicationSettingsWindowCommand extends Command
	{	
		[Inject]
		public var event:SettingsEvent;
		
		override public function execute():void
		{
			//deselect so that the editor window doesn't interfere.
			this.dispatch(new SceneEvent(SceneEvent.SELECT_NONE));
			
			var window:ApplicationSettingsWindow = new ApplicationSettingsWindow();
			this.mediatorMap.createMediator(window);
			window.open();
			
			window.nativeWindow.x = (Screen.mainScreen.bounds.width - window.nativeWindow.width) / 2;
			window.nativeWindow.y = (Screen.mainScreen.bounds.height - window.nativeWindow.height) / 2;
			
			if(event.type == SettingsEvent.SHOW_APPLICATION_SETTINGS_DOCUMENT_DEFAULTS)
			{
				window.form.pages.selectedChild = window.form.documentDefaultsContent;
			}
		}
	}
}