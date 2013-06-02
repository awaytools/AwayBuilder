package awaybuilder.view.components.controls
{
	import awaybuilder.model.vo.LibraryItemVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.model.vo.scene.ObjectVO;
	import awaybuilder.model.vo.scene.TextureProjectorVO;
	import awaybuilder.view.components.controls.tree.ITreeItemRenderer;
	import awaybuilder.view.components.controls.tree.Tree;
	import awaybuilder.view.components.controls.tree.TreeDataProvider;
	
	import mx.collections.IList;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import spark.layouts.supportClasses.DropLocation;

	public class SceneTree extends Tree
	{
		public function SceneTree()
		{
			super();
		}
		
		override protected function renderer_dragEnterHandler(event:DragEvent):void
		{
			var dropArea:UIComponent = event.target as UIComponent;
			var items:Vector.<Object> = event.dragSource.dataForFormat("itemsByIndex") as Vector.<Object>;
			validateDropRenderer( event.target as UIComponent, event.dragSource.dataForFormat("itemsByIndex") as Vector.<Object> );
		}
		
		override protected function renderer_dragOverHandler(event:DragEvent):void
		{
			event.stopPropagation();
			event.stopImmediatePropagation();
			validateDropRenderer( event.target as UIComponent, event.dragSource.dataForFormat("itemsByIndex") as Vector.<Object> );
		}
		
		private function validateDropRenderer( dropArea:UIComponent, items:Vector.<Object> ):void
		{
			if( !items ) return;
			var renderer:ITreeItemRenderer = dropArea.parent as ITreeItemRenderer;
			if( renderer.data == items[0] ) return;
			if( LibraryItemVO(renderer.data).asset is MeshVO ) return;
			if( LibraryItemVO(renderer.data).asset is TextureProjectorVO ) return;
			if( LibraryItemVO(renderer.data).asset is ContainerVO )
			{
				if( LibraryItemVO(items[0]).asset is ObjectVO )
				{
					renderer.showDropIndicator = true;
					DragManager.acceptDragDrop(dropArea);
					_druggingOverItem = true;
				}
			}
		}
		
		override protected function calculateDropLocation(event:DragEvent):DropLocation
		{
			// Verify data format
			if (!enabled || !event.dragSource.hasFormat("itemsByIndex"))
				return null;
			
			if( _druggingOverItem ) return null;
			
			// Calculate the drop location
			var dropLocation:DropLocation = layout.calculateDropLocation(event);
//			
//			var effectiveItem:Object = dataProvider.getItemAt( Math.min(dropLocation.dropIndex, dataProvider.length-1) );
//			var parent:Object = TreeDataProvider(dataProvider).getItemParent(effectiveItem);
//			
//			for (var i:int = selectedIndices.length - 1; i >= 0; i--)
//			{
//				var item:Object = dataProvider.getItemAt(  Math.min(selectedIndices[i], dataProvider.length-1) );
//				var oldParent:Object = TreeDataProvider(dataProvider).getItemParent(effectiveItem);
//				
//				if( oldParent == parent )
//				{
//					return null;
//				}
//			}
			
			return dropLocation;
		}
		
	}
}