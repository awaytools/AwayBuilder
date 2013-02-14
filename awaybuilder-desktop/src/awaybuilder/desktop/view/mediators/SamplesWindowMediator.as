package awaybuilder.desktop.view.mediators
{
	import flash.display.Screen;
	import flash.events.Event;
	
	import awaybuilder.desktop.utils.ModalityManager;
	import awaybuilder.desktop.view.components.SamplesWindow;
	import awaybuilder.events.HelpEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class SamplesWindowMediator extends Mediator
	{
		[Inject]
		public var window:SamplesWindow;
		
		override public function onRegister():void
		{
			ModalityManager.modalityManager.addModalNature(this.window);
			window.nativeWindow.x = (Screen.mainScreen.bounds.width - window.nativeWindow.width) / 2;
			window.nativeWindow.y = (Screen.mainScreen.bounds.height - window.nativeWindow.height) / 2;
			trace( "onRegister" );
			this.eventMap.mapListener(this.eventDispatcher, HelpEvent.HIDE_SAMPLES, eventDispatcher_hideSamplesHandler);
			this.eventMap.mapListener(this.window, Event.CLOSING, window_closingHandler);
		}
		
		private function eventDispatcher_hideSamplesHandler(event:HelpEvent):void
		{
			trace( "eventDispatcher_hideSamplesHandler" );
			this.window.close();
		}
		
		private function window_closingHandler(event:Event):void
		{
			this.mediatorMap.removeMediator(this);
		}
	}
}