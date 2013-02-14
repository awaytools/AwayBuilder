package awaybuilder.view.mediators
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import awaybuilder.events.SettingsEvent;
	import awaybuilder.model.ISettingsModel;
	import awaybuilder.model.SettingsModel;
	import awaybuilder.view.components.EditingSurfaceSettingsForm;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class EditingSurfaceSettingsFormMediator extends Mediator
	{
		[Inject]
		public var form:EditingSurfaceSettingsForm;
		
		[Inject]
		public var settings:ISettingsModel;
		
		override public function onRegister():void
		{
			this.form.gridSizeStepper.value = this.settings.gridSize;
			this.form.snapToGridCheck.selected = this.settings.snapToGrid;
			this.form.showGridCheck.selected = this.settings.showGrid;
			
			this.eventMap.mapListener(this.eventDispatcher, SettingsEvent.GRID_SIZE_CHANGE, eventDispatcher_gridSizeChangeHandler);
			this.eventMap.mapListener(this.eventDispatcher, SettingsEvent.SNAP_TO_GRID_CHANGE, eventDispatcher_snapToGridChangeHandler);
			this.eventMap.mapListener(this.eventDispatcher, SettingsEvent.SHOW_GRID_CHANGE, eventDispatcher_showGridChangeHandler);
			
			this.eventMap.mapListener(this.form.gridSizeStepper, Event.CHANGE, gridSizeStepper_changeHandler);
			this.eventMap.mapListener(this.form.snapToGridCheck, Event.CHANGE, snapToGridCheck_changeHandler);
			this.eventMap.mapListener(this.form.showGridCheck, Event.CHANGE, showGridCheck_changeHandler);
		}
		
		private function eventDispatcher_gridSizeChangeHandler(event:SettingsEvent):void
		{
			this.form.gridSizeStepper.value = this.settings.gridSize;
		}
		
		private function eventDispatcher_snapToGridChangeHandler(event:SettingsEvent):void
		{
			this.form.snapToGridCheck.selected = this.settings.snapToGrid;
		}
		
		private function eventDispatcher_showGridChangeHandler(event:SettingsEvent):void
		{
			this.form.showGridCheck.selected = this.settings.showGrid;
		}
		
		private function gridSizeStepper_changeHandler(event:Event):void
		{
			this.settings.gridSize = this.form.gridSizeStepper.value;
		}
		
		private function snapToGridCheck_changeHandler(event:Event):void
		{
			this.settings.snapToGrid = this.form.snapToGridCheck.selected;
		}
		
		private function showGridCheck_changeHandler(event:Event):void
		{
			this.settings.showGrid = this.form.showGridCheck.selected;
		}
	}
}