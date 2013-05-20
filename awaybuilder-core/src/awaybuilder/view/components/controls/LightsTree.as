package awaybuilder.view.components.controls
{
	import awaybuilder.view.components.controls.tree.Tree;
	
	import mx.core.DragSource;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import spark.layouts.supportClasses.DropLocation;
	
	public class LightsTree extends Tree
	{
		public function LightsTree()
		{
			super();
		}
		
//		override protected function calculateDropLocation(event:DragEvent):DropLocation
//		{
//			// Verify data format
//			if (!enabled || !event.dragSource.hasFormat("itemsByIndex"))
//				return null;
//			
//			// Calculate the drop location
//			return layout.calculateDropLocation(event);
//		}
//		
//		override protected function moveItemFrom(indix:int):Boolean
//		{
//			dataProvider.removeItemAt(indix);
//		}
//		override protected function dropItemTo( item:Object, index:int ):void
//		{
//			dataProvider.addItemAt(item, index);
//		}
		
	}
}