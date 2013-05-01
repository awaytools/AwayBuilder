package awaybuilder.view.components.events
{
	import flash.events.Event;

	public class LibraryPanelEvent extends Event
	{
		public static const TREE_CHANGE:String = "treeChange";
		
		public static const ADD_TEXTURE:String = "addTexture";
		public static const ADD_CUBE_TEXTURE:String = "addCubeTexture";
		public static const ADD_MATERIAL:String = "addMaterial";
		
		public static const ADD_EFFECTMETHOD:String = "addEffectMethod";
		
		public static const ADD_DIRECTIONAL_LIGHT:String = "addDirectionalLight";
		public static const ADD_POINT_LIGHT:String = "addPointLight";
		public static const ADD_LIGHTPICKER:String = "addLightPicker";
		
		public function LibraryPanelEvent(type:String, data:Object=null )
		{
			super(type, false, false);
			this.data = data;
		}
		
		public var data:Object;
		
	}
}