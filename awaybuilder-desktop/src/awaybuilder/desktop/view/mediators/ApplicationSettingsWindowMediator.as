package awaybuilder.desktop.view.mediators
{
	import flash.events.Event;
	
	import awaybuilder.desktop.utils.ModalityManager;
	import awaybuilder.desktop.view.components.ApplicationSettingsWindow;
	import awaybuilder.controller.events.SettingsEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class ApplicationSettingsWindowMediator extends Mediator
	{
		[Inject]
		public var window:ApplicationSettingsWindow;
		
		override public function onRegister():void
		{
			ModalityManager.modalityManager.addModalNature(this.window);
			
			this.eventMap.mapListener(this.eventDispatcher, SettingsEvent.SHOW_DOCUMENT_SETTINGS, eventDispatcher_showDocumentSettingsHandler);
			this.eventMap.mapListener(this.window.form, Event.COMPLETE, form_completeHandler);
			this.eventMap.mapListener(this.window, Event.CLOSING, window_closingHandler);
		}
		
		private function eventDispatcher_showDocumentSettingsHandler(event:SettingsEvent):void
		{
			if(!this.window.closed)
			{
				this.window.close();
			}
		}
		
		private function form_completeHandler(event:Event):void
		{
			this.window.close();
		}
		
		private function window_closingHandler(event:Event):void
		{
			this.mediatorMap.removeMediator(this);
		}
	}
}