package awaybuilder.view.mediators
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	import awaybuilder.events.SettingsEvent;
	import awaybuilder.model.ISettingsModel;
	import awaybuilder.view.components.DocumentDefaultsSettingsForm;

	import org.robotlegs.mvcs.Mediator;

	public class DocumentDefaultsSettingsFormMediator extends Mediator
	{
		[Inject]
		public var form:DocumentDefaultsSettingsForm;
		
		[Inject]
		public var settings:ISettingsModel;
		
		override public function onRegister():void
		{
			this.eventMap.mapListener(this.form.documentSettingsLink, MouseEvent.CLICK, documentSettingsLink_clickHandler);
		}
		
		private function documentSettingsLink_clickHandler(event:Event):void
		{
			this.dispatch(new SettingsEvent(SettingsEvent.SHOW_DOCUMENT_SETTINGS));
		}
	}
}