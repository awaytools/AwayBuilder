package awaybuilder.view.mediators
{
	import flash.events.Event;
	
	import awaybuilder.events.HelpEvent;
	import awaybuilder.model.SamplesModel;
	import awaybuilder.model.SettingsModel;
	import awaybuilder.view.components.SamplePicker;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class SamplePickerMediator extends Mediator
	{
		[Inject]
		public var picker:SamplePicker;
		
		[Inject]
		public var samples:SamplesModel;
		
		[Inject]
		public var settings:SettingsModel;
		
		override public function onRegister():void
		{
			this.picker.samples = this.samples.samples;
			this.picker.showAtStartupCheck.selected = this.settings.showSamplesAtStartup;
			this.eventMap.mapListener(this.picker, Event.CANCEL, picker_cancelHandler);
			this.eventMap.mapListener(this.picker.showAtStartupCheck, Event.CHANGE, showAtStartupCheck_changeHandler);
		}
		
		private function picker_cancelHandler(event:Event):void
		{
			this.dispatch(new HelpEvent(HelpEvent.HIDE_SAMPLES));
		}
		
		private function showAtStartupCheck_changeHandler(event:Event):void
		{
			this.settings.showSamplesAtStartup = this.picker.showAtStartupCheck.selected;
		}
	}
}