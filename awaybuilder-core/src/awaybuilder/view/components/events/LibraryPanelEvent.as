package awaybuilder.view.components.events
{
	import flash.events.Event;

	public class LibraryPanelEvent extends Event
	{
		public static const TREE_CHANGE:String = "treeChange";
		
		public static const ADD_TEXTURE:String = "addTexture";
		
		public static const ADD_SHADOWMETHOD:String = "addShadowMethod";
		public static const ADD_EFFECTMETHOD:String = "addEffectMethod";
		public static const ADD_AMBIENTMETHOD:String = "addAmbientMethod";
		public static const ADD_NORMALMETHOD:String = "addNormalMethod";
		public static const ADD_DIFFUSEMETHOD:String = "addDiffuseMethod";
		public static const ADD_SPECULARMETHOD:String = "addSpecularMethod";
		
		public static const ADD_LIGHT:String = "addLight";
		public static const ADD_LIGHTPICKER:String = "addLightPicker";
		
		public function LibraryPanelEvent(type:String, data:Object=null )
		{
			super(type, false, false);
			this.data = data;
		}
		
		public var data:Object;
		
	}
}