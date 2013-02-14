package awaybuilder.events
{
	import flash.events.Event;
	
	public class EditingSurfaceRequestEvent extends Event
	{
		public static const ADD_OBJECTS:String = "addObjects";
		public static const PASTE_OBJECTS:String = "pasteObjects";
		public static const DELETE_OBJECTS:String = "deleteObjects";
		
		public static const DELETE_SELECTION:String = "deleteSelection";
		public static const ROTATE_SELECTION_CLOCKWISE:String = "rotateSelectionClockwise";
		public static const ROTATE_SELECTION_COUNTER_CLOCKWISE:String = "rotateSelectionCounterClockwise";
		
		public static const PAN_TO_CENTER:String = "panToCenter";
		
		public static const SWITCH_TO_PAN_TOOL:String = "switchToPanTool";
		public static const SWITCH_TO_SELECTION_TOOL:String = "switchToSelectionTool";
		
		public static const SELECT_ALL:String = "selectAll";
		public static const SELECT_NONE:String = "selectNone";
		public static const SELECT_OBJECTS:String = "selectObjects";
		
		public function EditingSurfaceRequestEvent(type:String, objects:Vector.<Object> = null, allowUndo:Boolean = false)
		{
			super(type, false, false);
			this.objects = objects;
			this.allowUndo = allowUndo;
		}
		
		public var objects:Vector.<Object>;
		public var allowUndo:Boolean;
		
		override public function clone():Event
		{
			return new EditingSurfaceRequestEvent(this.type, this.objects, this.allowUndo);
		}
	}
}