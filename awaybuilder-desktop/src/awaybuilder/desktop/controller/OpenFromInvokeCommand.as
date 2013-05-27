package awaybuilder.desktop.controller
{
	import awaybuilder.controller.events.DocumentDataOperationEvent;
	import awaybuilder.controller.events.DocumentEvent;
	import awaybuilder.desktop.controller.events.OpenFromInvokeEvent;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.IDocumentService;
	import awaybuilder.view.components.popup.ImportWarningPopup;
	
	import flash.filesystem.File;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.robotlegs.mvcs.Command;
	
	public class OpenFromInvokeCommand extends Command
	{
		[Inject]
		public var document:DocumentModel;
		
		[Inject]
		public var documentService:IDocumentService;
		
		[Inject]
		public var event:OpenFromInvokeEvent;
		
		override public function execute():void
		{
			if( document.empty ) 
			{
				
				var nextEvent:DocumentDataOperationEvent = new DocumentDataOperationEvent(DocumentDataOperationEvent.CONCAT_DOCUMENT_DATA );
				nextEvent.canUndo = true;
				documentService.load( event.file.url, event.file.name, nextEvent );
				return;
			}
				
			var popup:ImportWarningPopup = ImportWarningPopup.show( popup_closeHandler );
		}
		
		private function popup_closeHandler( e:CloseEvent ):void 
		{
			var nextEvent:DocumentDataOperationEvent = new DocumentDataOperationEvent(DocumentDataOperationEvent.CONCAT_DOCUMENT_DATA );
			
			switch( e.detail )
			{
				case Alert.YES:
					nextEvent.canUndo = true;
					documentService.load( event.file.url, event.file.name, nextEvent  );
					break;
				case Alert.NO:
					this.dispatch(new DocumentEvent(DocumentEvent.NEW_DOCUMENT));
					nextEvent.canUndo = false;
					documentService.load( event.file.url, event.file.name, nextEvent  );
					break;
			}
		}
	}
}