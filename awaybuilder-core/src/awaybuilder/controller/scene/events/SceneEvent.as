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

		public static const CHANGE_GLOBAL_OPTIONS:String = "changeGlobalOptions";
		
		public static const CHANGE_CONTAINER:String = "changeContainer";
		public static const CHANGE_GEOMETRY:String = "changeGeometry";
        public static const CHANGE_MESH:String = "changeMesh";
		public static const CHANGE_TEXTURE_PROJECTOR:String = "changeTextureProjector";
        public static const CHANGE_MATERIAL:String = "changeMaterial";
		public static const CHANGE_LIGHT:String = "changeLight";
		public static const CHANGE_LIGHTPICKER:String = "changeLightPicker";
		public static const CHANGE_CUBE_TEXTURE:String = "changeCubeTexture";
		public static const CHANGE_TEXTURE:String = "changeTexture";
		
		public static const CHANGE_SHADING_METHOD:String = "changeShadingMethod";
		
		public static const CHANGE_SKYBOX:String = "changeSkyBox";
		
		public static const CHANGE_SHADOW_METHOD:String = "changeShadowMethod";
		public static const CHANGE_SHADOW_MAPPER:String = "changeShadowMapper";
		public static const CHANGE_EFFECT_METHOD:String = "changeEffectMethod";
		
		public static const ADD_NEW_LIGHT:String = "addNewLight";
		public static const ADD_NEW_MATERIAL:String = "addNewMaterial";
		public static const ADD_NEW_MESH:String = "addNewMesh";
		public static const ADD_NEW_TEXTURE_PROJECTOR:String = "addNewTextureProjector";
		public static const ADD_NEW_SKYBOX:String = "addNewSkyBox";
		public static const ADD_NEW_SHADOW_METHOD:String = "addNewShadowMethod";
		public static const ADD_NEW_EFFECT_METHOD:String = "addNewEffectMethod";
		public static const ADD_NEW_LIGHTPICKER:String = "addNewLightPicker";
		public static const ADD_NEW_TEXTURE:String = "addNewTexture";
		public static const ADD_NEW_CUBE:String = "addNewCubeTexture";
		public static const ADD_NEW_CUBE_TEXTURE:String = "addNewCubeTexture";
		public static const ADD_NEW_GEOMETRY:String = "addNewGeometry";
		public static const ADD_NEW_ANIMATOR:String = "addNewAnimator";
		public static const ADD_NEW_ANIMATION_SET:String = "addNewAnimationSet";
		
		public static const SWITCH_CAMERA_TO_FREE:String = "switchCameraToFree";
		public static const SWITCH_CAMERA_TO_TARGET:String = "switchCameraToTarget";
		
		public static const SWITCH_TRANSFORM_TRANSLATE:String = "switchTransformToTranslate";
		public static const SWITCH_TRANSFORM_ROTATE:String = "switchTransformToRotate";
		public static const SWITCH_TRANSFORM_SCALE:String = "switchTransformToScale";
		public static const ENABLE_ALL_TRANSFORM_MODES:String = "enableAllTransformModes";
		
		public static const SELECT_ALL:String = "selectAll";
		public static const SELECT_NONE:String = "selectNone";
//		public static const SELECT_OBJECTS:String = "selectObjects";
		public static const DELETE_OBJECTS:String = "deleteObjects";
		
		public static const ENABLE_ROTATE_MODE_ONLY:String = "enableRotateModeOnly";
		public static const ENABLE_TRANSLATE_MODE_ONLY:String = "enableTranslateModeOnly";
		
		
		public function SceneEvent( type:String, items:Array=null, newValue:Object=null, canBeCombined:Boolean=false, oldValue:Object=null )
		{
			super( type,newValue,oldValue );
			this.items = items;
            this.canBeCombined = canBeCombined;
		}
		
		public var items:Array;
		
		public var options:Object;

		override public function clone():Event
		{
			var event:SceneEvent = new SceneEvent( this.type, this.items, this.newValue, this.canBeCombined, oldValue );
			event.options = options;
			return event;
		}
	}
}