package awaybuilder.controller.scene
{
	import away3d.containers.ObjectContainer3D;
	
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.history.HistoryEvent;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.AssetsModel;
	import awaybuilder.model.vo.DroppedTreeItemVO;
	import awaybuilder.model.vo.LibraryItemVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.ObjectVO;
	import awaybuilder.utils.scene.Scene3DManager;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;

	public class ReparentObjectCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:SceneEvent;
		
		[Inject]
		public var assets:AssetsModel;
		
		override public function execute():void
		{
			saveOldValue( event, event.newValue );
			
			var oldContainer:ContainerVO;
			var newContainer:ContainerVO;
			
			for each( var item:DroppedTreeItemVO in event.newValue ) 
			{
				var vo:LibraryItemVO = item.value as LibraryItemVO;
				
				if( vo.asset is ObjectVO )
				{
					
					if( item.newParent == item.oldParent ) return;
					
					if( item.newParent )
					{
						newContainer = item.newParent.asset as ContainerVO;
						if( newContainer && !itemIsInList(newContainer.children, vo.asset as AssetVO) ) 
						{
							if( item.newPosition < newContainer.children.length )
							{
								newContainer.children.addItemAt( vo.asset, item.newPosition );
							}
							else
							{
								newContainer.children.addItem( vo.asset );
							}
						}
					}
					else
					{
						document.scene.addItemAt( vo.asset, item.newPosition );
					}
					
					if( item.oldParent )
					{ 
						oldContainer = item.oldParent.asset as ContainerVO;
						if( oldContainer && itemIsInList(oldContainer.children, vo.asset as AssetVO) ) 
						{
							removeItem( oldContainer.children, vo.asset );
						}
					}
					else
					{
						removeItem( document.scene, vo.asset );
					}
					
					Scene3DManager.reparentObject(assets.GetObject(vo.asset) as ObjectContainer3D, newContainer ? assets.GetObject(newContainer) as ObjectContainer3D : null);
				}
			}
			
			commitHistoryEvent( event );
		}
		
		private function itemIsInList( collection:ArrayCollection, asset:AssetVO ):Boolean
		{
			for each( var a:AssetVO in collection )
			{
				if( a.equals( asset ) ) return true;
			}
			return false;
		}
		
		private function removeItem( source:ArrayCollection, oddItem:AssetVO ):void
		{
			for (var i:int = 0; i < source.length; i++) 
			{
				var item:AssetVO = source[i] as AssetVO;
				if( item.equals( oddItem ) )
				{
					source.removeItemAt( i );
					i--;
				}
				
			}
		}
		
		override protected function saveOldValue( event:HistoryEvent, prevValue:Object ):void 
		{
			if( !event.oldValue ) 
			{
				var oldValue:Dictionary = new Dictionary();
				for each( var item:DroppedTreeItemVO in event.newValue ) 
				{
					var newItem:DroppedTreeItemVO = new DroppedTreeItemVO( item.value );
					newItem.newParent = item.oldParent;
					newItem.newPosition = item.newPosition;
					newItem.oldParent = item.newParent;
					newItem.oldPosition = item.oldPosition;
					oldValue[item.value] = newItem;
				}
				event.oldValue = oldValue;
			}
		}
		
	}
}