package awaybuilder.controller.scene.events
{
import awaybuilder.controller.history.HistoryEvent;

import flash.events.Event;

	public class SceneEvent extends HistoryEvent
	{
		public static const FOCUS_SELECTION:String = "focusOnSelection";
		
		public static const SELECT:String = "sceneItemSelect";
        public static const CHANGING:String = "sceneItemChanging";
        public static const TRANSLATE_OBJECT:String = "translateObject";
        public static const ROTATE_OBJECT:String = "rotateObject";
        public static const SCALE_OBJECT:String = "scaleObject";

        public static const CHANGE_MESH:String = "changeMesh";
        public static const CHANGE_MATERIAL:String = "changeMaterial";
		public static const CHANGE_LIGHT:String = "changeLight";
		public static const CHANGE_LIGHTPICKER:String = "changeLightPicker";
		
		public static const ADD_NEW_LIGHT:String = "addNewLight";
		public static const ADD_NEW_MATERIAL:String = "addNewMaterial";
		public static const ADD_NEW_LIGHTPICKER:String = "addNewLightPicker";
		public static const ADD_NEW_TEXTURE:String = "addNewTexture";
		public static const REPLACE_TEXTURE:String = "replaceTexture";
		
		public static const SWITCH_CAMERA_TO_FREE:String = "switchCameraToFree";
		public static const SWITCH_CAMERA_TO_TARGET:String = "switchCameraToTarget";
		
		public static const SWITCH_TRANSFORM_TRANSLATE:String = "switchTransformToTranslate";
		public static const SWITCH_TRANSFORM_ROTATE:String = "switchTransformToRotate";
		public static const SWITCH_TRANSFORM_SCALE:String = "switchTransformToScale";
		
		public static const SELECT_ALL:String = "selectAll";
		public static const SELECT_NONE:String = "selectNone";
//		public static const SELECT_OBJECTS:String = "selectObjects";
		public static const DELETE_OBJECTS:String = "deleteObjects";
		
		public function SceneEvent( type:String, items:Array=null, newValue:Object=null, canBeCombined:Boolean=false, oldValue:Object=null )
		{
			super( type,newValue,oldValue );
			this.items = items;
            this.canBeCombined = canBeCombined;
		}
		
		public var items:Array;

		override public function clone():Event
		{
			return new SceneEvent( this.type, this.items, this.newValue, this.canBeCombined, oldValue );
		}
	}
}