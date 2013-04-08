package awaybuilder.view.components.events
{
	import flash.events.Event;

	public class LibraryPanelEvent extends Event
	{
		public static const TREE_CHANGE:String = "treeChange";
		
		public static const ADD_TEXTURE:String = "addTexture";
		
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