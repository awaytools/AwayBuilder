package awaybuilder.desktop.view.mediators
{
	
	import flash.events.Event;
	
	import awaybuilder.desktop.controller.events.AboutEvent;
	import awaybuilder.desktop.utils.ModalityManager;
	import awaybuilder.desktop.view.components.AboutWindow;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class AboutWindowMediator extends Mediator
	{
		[Inject]
		public var about:AboutWindow;
		
		override public function onRegister():void
		{
			ModalityManager.modalityManager.addModalNature(this.about);
			
			this.eventMap.mapListener(this.about, Event.CLOSING, window_closingHandler);
			this.eventMap.mapListener(this.about, Event.COMPLETE, window_completeHandler);
		}
		
		private function window_closingHandler(event:Event):void
		{
			this.dispatch(new AboutEvent(AboutEvent.HIDE_ABOUT));
		}
		
		private function window_completeHandler(event:Event):void
		{
			this.about.close();
		}
	}
}