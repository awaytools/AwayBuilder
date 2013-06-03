package awaybuilder.controller.scene
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.entities.TextureProjector;
	import away3d.lights.LightBase;
	import away3d.primitives.SkyBox;
	
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.history.HistoryEvent;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.AssetsModel;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.vo.LibraryItemVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.LightVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.model.vo.scene.ObjectVO;
	import awaybuilder.model.vo.scene.SkyBoxVO;
	import awaybuilder.model.vo.scene.TextureProjectorVO;
	import awaybuilder.utils.scene.Scene3DManager;
	import awaybuilder.model.vo.DroppedTreeItemVO;
	
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
			
			var container:ContainerVO;
			var newContainer:ContainerVO;
			
			for each( var item:DroppedTreeItemVO in event.newValue ) 
			{
				var vo:LibraryItemVO = item.value as LibraryItemVO;
				
				if( vo.asset is ObjectVO )
				{
					
					if( item.newParent == item.oldParent ) return;
					
					if( item.newParent )
					{
						container = item.newParent.asset as ContainerVO;
						if( container && !itemIsInList(container.children, vo.asset as AssetVO) ) 
						{
							if( item.newPosition < container.children.length )
							{
								container.children.addItemAt( vo.asset, item.newPosition );
							}
							else
							{
								container.children.addItem( vo.asset );
								addObjectToScene( vo.asset );
							}
						}
					}
					else
					{
						document.scene.addItemAt( vo.asset, item.newPosition );
					}
					
					if( item.oldParent )
					{ 
						container = item.oldParent.asset as ContainerVO;
						if( container && itemIsInList(container.children, vo.asset as AssetVO) ) 
						{
							removeItem( container.children, vo.asset );
						}
					}
					else
					{
						removeItem( document.scene, vo.asset );
						removeObjectFromScene( vo.asset );
					}
				}
			}
			
			commitHistoryEvent( event );
		}
		
		private function addObjectToScene( asset:AssetVO ):void
		{
			if( asset is MeshVO ) 
			{
				Scene3DManager.addObject( assets.GetObject(asset) as ObjectContainer3D );
			}
			else if( asset is TextureProjectorVO ) 
			{
				Scene3DManager.addTextureProjector( assets.GetObject(asset) as TextureProjector );
			}
			else if( asset is ContainerVO ) 
			{
				Scene3DManager.addObject( assets.GetObject(asset) as ObjectContainer3D );
			}
			else if( asset is LightVO ) 
			{
				Scene3DManager.addLight( assets.GetObject(asset) as LightBase );
			}
			else if( asset is SkyBoxVO ) 
			{
				Scene3DManager.addSkybox( assets.GetObject(asset) as SkyBox );
			}
		}
		
		private function removeObjectFromScene( asset:AssetVO ):void
		{
			if( asset is MeshVO ) 
			{
				Scene3DManager.removeMesh( assets.GetObject(asset) as Mesh );
			}
			else if( asset is TextureProjectorVO ) 
			{
				Scene3DManager.removeTextureProjector( assets.GetObject(asset) as TextureProjector );
			}
			else if( asset is ContainerVO ) 
			{
				Scene3DManager.removeContainer( assets.GetObject(asset) as ObjectContainer3D );
			}
			else if( asset is LightVO ) 
			{
				Scene3DManager.removeLight( assets.GetObject(asset) as LightBase );
			}
			else if( asset is SkyBoxVO ) 
			{
				Scene3DManager.removeSkyBox( assets.GetObject(asset) as SkyBox );
			}
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