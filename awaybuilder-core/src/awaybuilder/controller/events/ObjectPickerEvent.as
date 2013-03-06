package awaybuilder.controller.events
{
	import flash.events.Event;
	
	public class ObjectPickerEvent extends Event
	{
		public static const SHOW_OBJECT_PICKER:String = "showObjectPicker";
		
		public function ObjectPickerEvent(type:String)
		{
			super(type, false, false);
		}
		
		override public function clone():Event
		{
			return new ObjectPickerEvent(this.type)
		}
	}
}