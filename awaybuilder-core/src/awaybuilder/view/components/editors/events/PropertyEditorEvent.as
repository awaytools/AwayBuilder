package awaybuilder.view.components.editors.events
{
    import flash.events.Event;

    public class PropertyEditorEvent extends Event
    {

        public static const TRANSLATE:String = "objectTranslate";
        public static const SCALE:String = "objectScale";
        public static const ROTATE:String = "objectRotate";

        public static const MESH_CHANGE:String = "meshChange";
        public static const MESH_NAME_CHANGE:String = "meshNameChange";
		public static const MESH_SUBMESH_ADD_NEW_MATERIAL:String = "submeshAddNewMaterial";
		
		public static const MATERIAL_CHANGE:String = "materialChange";
		public static const MATERIAL_ADD_SHADOWMETHOD:String = "materialAddShadowMethod";
		public static const MATERIAL_ADD_LIGHTPICKER:String = "materialAddLightPicker";
		public static const MATERIAL_ADD_DIFFUSE_METHOD:String = "materialAddDiffuseMethod";
		public static const MATERIAL_ADD_NORMAL_METHOD:String = "materialAddNormalMethod";
		public static const MATERIAL_ADD_SPECULAR_METHOD:String = "materialAddSpecularMethod";
		public static const MATERIAL_ADD_AMBIENT_METHOD:String = "materialAddAmbientMethod";
		public static const MATERIAL_ADD_EFFECT_METHOD:String = "materialAddEffectMethod";
		public static const MATERIAL_REMOVE_EFFECT_METHOD:String = "materialRemoveEffectMethod";
		public static const MATERIAL_NAME_CHANGE:String = "materialNameChange";
		
		public static const REPLACE_TEXTURE:String = "replaceTexture";

        public static const MESH_SUBMESH_CHANGE:String = "meshSubmeshChange";

		public static const CONTAINER_CHANGE:String = "containerChange";
		
		public static const LIGHT_CHANGE:String = "lightChange";
		public static const LIGHT_STEPPER_CHANGE:String = "lightStepperChange";
		public static const LIGHT_MAPPER_CHANGE:String = "lightMapperChange";
		public static const LIGHT_POSITION_CHANGE:String = "lightPositionChange";
		
		public static const SHADOWMETHOD_CHANGE:String = "shadowmethodChange";
		public static const SHADOWMETHOD_STEPPER_CHANGE:String = "shadowmethodStepperChange";
		public static const SHADOWMETHOD_ADD_LIGHT:String = "shadowmethodAddLight";
		
		public static const DIFFUSE_METHOD_CHANGE:String = "diffuseMethodChange";
		public static const DIFFUSE_METHOD_STEPPER_CHANGE:String = "diffuseMethodStepperChange";
		public static const DIFFUSE_METHOD_ADD_TEXTURE:String = "diffuseMethodAddNewTextureChange";
		
		public static const AMBIENT_METHOD_CHANGE:String = "ambientMethodChange";
		public static const AMBIENT_METHOD_STEPPER_CHANGE:String = "ambientMethodStepperChange";
		public static const AMBIENT_METHOD_ADD_TEXTURE:String = "ambientMethodAddNewTextureChange";
		
		public static const NORMAL_METHOD_CHANGE:String = "normalMethodChange";
		public static const NORMAL_METHOD_STEPPER_CHANGE:String = "normalMethodStepperChange";
		public static const NORMAL_METHOD_ADD_TEXTURE:String = "normalMethodAddNewTextureChange";
		
		public static const SPECULAR_METHOD_CHANGE:String = "specularMethodChange";
		public static const SPECULAR_METHOD_STEPPER_CHANGE:String = "specularMethodStepperChange";
		public static const SPECULAR_METHOD_ADD_TEXTURE:String = "specularMethodAddNewTextureChange";
		
		public static const LIGHTPICKER_CHANGE:String = "lightPickerChange";
		public static const LIGHTPICKER_STEPPER_CHANGE:String = "lightPickerStepperChange";
		
		public static const SHOW_CHILD_PROPERTIES:String = "showChildProperties";
		
		public static const SHOW_PARENT_MESH_PROPERTIES:String = "showParentMeshProperties";
		public static const SHOW_PARENT_MATERIAL_PROPERTIES:String = "showParentTextureProperties";

        public function PropertyEditorEvent( type:String, data:Object=null, bubbles:Boolean=false ) {
            super( type, bubbles, cancelable );
            this.data = data;
        }

        public var data:Object;
    }
}
