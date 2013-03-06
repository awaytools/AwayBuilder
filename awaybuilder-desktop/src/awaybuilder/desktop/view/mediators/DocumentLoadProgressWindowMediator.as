package awaybuilder.desktop.view.mediators
{
	import flash.events.Event;
	
	import awaybuilder.desktop.utils.ModalityManager;
	import awaybuilder.desktop.view.components.DocumentLoadProgressWindow;
	import awaybuilder.controller.events.DocumentLoadEvent;
	
	import org.robotlegs.mvcs.Mediator;

	public class DocumentLoadProgressWindowMediator extends Mediator
	{
		[Inject]
		public var window:DocumentLoadProgressWindow;
		
		override public function onRegister():void
		{
			this.window.progress = 0;
			ModalityManager.modalityManager.addModalNature(this.window);
			
			this.eventMap.mapListener(this.window, Event.CLOSING, window_closingHandler);
			
			this.eventMap.mapListener(this.eventDispatcher, DocumentLoadEvent.UPDATE_DOCUMENT_LOAD_PROGRESS, awaybuilder_updateDocumentLoadProgressHandler);
			this.eventMap.mapListener(this.eventDispatcher, DocumentLoadEvent.HIDE_DOCUMENT_LOAD_PROGRESS, awaybuilder_hideDocumentLoadProgressHandler);
		}
		
		private function awaybuilder_updateDocumentLoadProgressHandler(event:DocumentLoadEvent):void
		{
			this.window.progress = event.progress;
		}
		
		private function awaybuilder_hideDocumentLoadProgressHandler(event:DocumentLoadEvent):void
		{
			this.window.progress = 1;
			this.window.close();
		}
		
		private function window_closingHandler(event:Event):void
		{
			this.mediatorMap.removeMediator(this);
		}
	}
}