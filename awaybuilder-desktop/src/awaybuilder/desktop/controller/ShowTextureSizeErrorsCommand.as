package awaybuilder.desktop.controller
{
	import awaybuilder.view.components.popup.TextureSizeWarningPopup;
	import awaybuilder.desktop.controller.events.TextureSizeErrorsEvent;
	import awaybuilder.model.DocumentModel;
	
	
	import org.robotlegs.mvcs.Command;
	
	public class ShowTextureSizeErrorsCommand extends Command
	{
		[Inject]
		public var document:DocumentModel;
		
		[Inject]
		public var event:TextureSizeErrorsEvent;
		
		override public function execute():void
		{				
			TextureSizeWarningPopup.show();
		}
	}
}