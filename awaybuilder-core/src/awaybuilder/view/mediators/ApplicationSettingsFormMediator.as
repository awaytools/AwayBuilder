package awaybuilder.view.mediators
{
	import awaybuilder.events.SettingsEvent;
	import awaybuilder.view.components.ApplicationSettingsForm;
	import awaybuilder.view.components.events.ApplicationSettingsFormEvent;

	import org.robotlegs.mvcs.Mediator;

	public class ApplicationSettingsFormMediator extends Mediator
	{
		[Inject]
		public var form:ApplicationSettingsForm;
		
		override public function onRegister():void
		{
			this.eventMap.mapListener(this.form, ApplicationSettingsFormEvent.RESET_DEFAULT_SETTINGS, form_resetDefaultSettingsHandler);	
		}
		
		private function form_resetDefaultSettingsHandler(event:ApplicationSettingsFormEvent):void
		{
			this.dispatch(new SettingsEvent(SettingsEvent.RESET_DEFAULT_SETTINGS));
		}
	}
}