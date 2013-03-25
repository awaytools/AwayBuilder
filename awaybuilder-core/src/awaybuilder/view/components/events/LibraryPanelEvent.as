package awaybuilder.view.components.events
{
	import flash.events.Event;

	public class LibraryPanelEvent extends Event
	{
		public static const TREE_CHANGE:String = "treeChange";
		
		public function LibraryPanelEvent(type:String, data:Object )
		{
			super(type, false, false);
			this.data = data;
		}
		
		public var data:Object;
		
	}
}