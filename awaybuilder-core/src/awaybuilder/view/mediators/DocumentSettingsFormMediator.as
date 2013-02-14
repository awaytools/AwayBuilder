package awaybuilder.view.mediators
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import awaybuilder.events.SettingsEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.view.components.DocumentSettingsForm;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class DocumentSettingsFormMediator extends Mediator
	{
		[Inject]
		public var form:DocumentSettingsForm;
		
		[Inject]
		public var document:IDocumentModel;
		
		override public function onRegister():void
		{
			this.refreshWhatever();
			//this.eventMap.mapListener(this.form.whateverInput, Event.CHANGE, whateverInput_changeHandler);
			this.eventMap.mapListener(this.form.documentDefaultsLink, MouseEvent.CLICK, documentDefaultsLink_clickHandler);
		}
		
		private function refreshWhatever():void
		{
			//this.form.whateverInput.text = this.document.whatever;
		}
		
		private function whateverInput_changeHandler(event:Event):void
		{
			//this.document.whatever = this.form.whateverInput.text;
		}
		
		private function documentDefaultsLink_clickHandler(event:Event):void
		{
			this.dispatch(new SettingsEvent(SettingsEvent.SHOW_APPLICATION_SETTINGS_DOCUMENT_DEFAULTS));
		}
	}
}