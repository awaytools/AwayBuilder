package awaybuilder.desktop.controller
{
	import awaybuilder.controller.events.ReadDocumentDataEvent;
	import awaybuilder.desktop.controller.events.OpenFromInvokeEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.view.components.popup.ImportWarningPopup;
	
	import flash.filesystem.File;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.robotlegs.mvcs.Command;
	
	public class OpenFromInvokeCommand extends Command
	{
		[Inject]
		public var document:IDocumentModel;
		
		[Inject]
		public var event:OpenFromInvokeEvent;
		
		override public function execute():void
		{
			var popup:ImportWarningPopup = ImportWarningPopup.show( popup_closeHandler );
		}
		
		private function popup_closeHandler( e:CloseEvent ):void 
		{
			switch( e.detail )
			{
				case Alert.YES:
					this.dispatch(new ReadDocumentDataEvent(ReadDocumentDataEvent.READ_DOCUMENT_DATA, event.file.name, event.file.url));
					break;
				case Alert.NO:
					this.dispatch(new ReadDocumentDataEvent(ReadDocumentDataEvent.REPLACE_DOCUMENT, event.file.name, event.file.url));
					break;
				default:
					break;
			}
		}
	}
}