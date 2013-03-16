package awaybuilder.view.components.propertyEditors
{
    import flash.events.Event;

    public class PropertyEditorEvent extends Event
    {

        public static const TRANSLATE:String = "objectTranslate";
        public static const SCALE:String = "objectScale";
        public static const ROTATE:String = "objectRotate";

        public static const MESH_CHANGE:String = "meshChange";
        public static const MESH_NAME_CHANGE:String = "meshNameChange";

        public static const MESH_SUBMESH_CHANGE:String = "meshSubmeshChange";

        public static const MATERIAL_CHANGE:String = "materialChange";
        public static const MATERIAL_NAME_CHANGE:String = "materialNameChange";

        public static const SHOW_MATERIAL_PROPERTIES:String = "showMaterialProperties";

        public function PropertyEditorEvent( type:String, data:Object=null, bubbles:Boolean=false ) {
            super( type, bubbles, cancelable );
            this.data = data;
        }

        public var data:Object;
    }
}
