package awaybuilder.controller.events
{
	import flash.events.Event;
	
	public class SettingsEvent extends Event
	{
		//application settings events
		
		public static const SHOW_DOCUMENT_SETTINGS:String = "showDocumentSettings";
		public static const SHOW_APPLICATION_SETTINGS_DOCUMENT_DEFAULTS:String = "showApplicationSettingsDocumentDefaults";
		
		public static const GRID_SIZE_CHANGE:String = "gridSizeChange";
		public static const SNAP_TO_GRID_CHANGE:String = "snapToGridChange";
		public static const SHOW_GRID_CHANGE:String = "showChange";
		
		public static const SHOW_OBJECT_PICKER_CHANGE:String = "showObjectPickerChange";
		
		public function SettingsEvent(type:String)
		{
			super(type, false, false);
		}
		
		override public function clone():Event
		{
			return new SettingsEvent(this.type);
		}
	}
}