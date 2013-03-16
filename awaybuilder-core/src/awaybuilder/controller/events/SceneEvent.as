package awaybuilder.controller.events
{
import awaybuilder.controller.history.HistoryEvent;

import flash.events.Event;

	public class SceneEvent extends HistoryEvent
	{
		public static const ITEMS_SELECT:String = "sceneItemSelect";
        public static const CHANGING:String = "sceneItemChanging";
        public static const TRANSLATE_OBJECT:String = "translateObject";
        public static const ROTATE_OBJECT:String = "rotateObject";
        public static const SCALE_OBJECT:String = "scaleObject";

        public static const CHANGE_MESH:String = "changeMesh";
        public static const CHANGE_MATERIAL:String = "changeMaterial";
		
		public function SceneEvent( type:String, items:Array, oldValue:Object=null, newValue:Object=null, canBeCombined:Boolean=false )
		{
			super(type,oldValue,newValue);
			this.items = items;
            this.canBeCombined = canBeCombined;
		}
		
		public var items:Array;

		override public function clone():Event
		{
			return new SceneEvent(this.type, this.items, this.oldValue, this.newValue, this.canBeCombined);
		}
	}
}