package awaybuilder.controller.scene
{
	import away3d.entities.TextureProjector;
	import awaybuilder.model.vo.scene.TextureProjectorVO;
	import away3d.containers.ObjectContainer3D;
	import away3d.lights.LightBase;
	import awaybuilder.model.vo.scene.LightVO;
	import away3d.entities.Mesh;
	
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.AssetsModel;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.model.vo.scene.TextureVO;
	import awaybuilder.utils.AssetUtil;
	import awaybuilder.utils.scene.Scene3DManager;
	
	import flash.display3D.textures.Texture;
	
	import mx.collections.ArrayCollection;

	public class DeleteObjectCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:SceneEvent;
		
		[Inject]
		public var assets:AssetsModel;
		
		[Inject]
		public var document:DocumentModel;
		
		override public function execute():void
		{
			if( event.isUndoAction )
			{
				undo(); 
				return;
			}
			var objects:Vector.<AssetVO> = event.newValue as Vector.<AssetVO>;
			for each( var vo:AssetVO in objects ) {
				if( vo is MeshVO ) 
				{
					Scene3DManager.removeMesh( assets.GetObject(vo) as Mesh );
				}
				else if( vo is TextureProjectorVO ) 
				{
					Scene3DManager.removeTextureProjector( assets.GetObject(vo) as TextureProjector );
				}
				else if( vo is ContainerVO ) 
				{
					Scene3DManager.removeContainer( assets.GetObject(vo) as ObjectContainer3D );
				}
				else if( vo is LightVO ) 
				{
					Scene3DManager.removeLight( assets.GetObject(vo) as LightBase );
				}
			}
			
			Scene3DManager.currentGizmo.hide();
			
			removeItemsFromDocument( objects );
			
			addToHistory( event );
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.OBJECTS_UPDATED));
		}
		
		private function undo():void
		{
			var objects:Vector.<AssetVO> = event.oldValue as Vector.<AssetVO>;
			for each( var vo:AssetVO in objects ) {
				if( vo is ContainerVO ) 
				{
					if( vo is MeshVO ) 
					{
						Scene3DManager.addObject( assets.GetObject(vo) as Mesh );
					}
					document.scene.addItemAt( vo, 0 );
				}
				else if( vo is TextureVO ) 
				{
					document.textures.addItemAt( vo, 0 );
				}
				else if( vo is MaterialVO ) 
				{
					document.materials.addItemAt( vo, 0 );
				}
//				else if( vo is LightVO ) {
//					document.lights.addItemAt( vo, 0 );
//				}
//				else if( vo is SkeletonVO ) {
//					document.textures.addItemAt( vo, 0 );
//				}
//				else if( vo is BitmapTextureVO ) {
//					document.textures.addItemAt( vo, 0 );
//				}
//				else if( vo is BitmapTextureVO ) {
//					document.textures.addItemAt( vo, 0 );
//				}
			}
			
//			this.dispatch(new DocumentModelEvent(DocumentModelEvent.OBJECTS_UPDATED));
		}
		private function removeItemsFromDocument( items:Vector.<AssetVO> ):void
		{
			removeItems( document.scene, items );
			removeItems( document.materials, items );
			removeItems( document.animations, items );
			removeItems( document.geometry, items );
			removeItems( document.textures, items );
			removeItems( document.skeletons, items );
			removeItems( document.lights, items );
		}
		private function removeItems( source:ArrayCollection, items:Vector.<AssetVO> ):void
		{
			var isRemoved:Boolean = false;
			for (var i:int = 0; i < source.length; i++) 
			{
				
				var item:AssetVO = source[i] as AssetVO;
				isRemoved = false;
				for each( var oddItem:AssetVO in items ) 
				{
					if( item.equals( oddItem ) )
					{
						source.removeItemAt( i );
						isRemoved = true;
						i--;
					}
				}
				var container:ContainerVO = item as ContainerVO;
				if( container && !isRemoved )
				{
					removeItems( container.children, items );
				}
				
			}
		}
		
		
	}
}