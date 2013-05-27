package awaybuilder.controller.clipboard
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import away3d.entities.Mesh;
	
	import awaybuilder.controller.clipboard.events.PasteEvent;
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.model.AssetsModel;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.vo.DocumentVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.model.vo.scene.ObjectVO;
	import awaybuilder.model.vo.scene.TextureVO;
	import awaybuilder.utils.AssetUtil;
	import awaybuilder.utils.scene.Scene3DManager;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Command;

	public class PasteCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:PasteEvent;
		
		[Inject]
		public var assets:AssetsModel;
		
		override public function execute():void
		{
			if( event.isUndoAction )
			{
				undo(); 
				return;
			}
			var asset:AssetVO;
			var newObjects:Vector.<AssetVO>;
			if( !event.newValue )
			{
				newObjects = new Vector.<AssetVO>();
				for each( var copy:AssetVO in document.copiedObjects ) 
				{
					asset = getAssetById( copy.id, document.scene );
					if( asset is ObjectVO ) 
					{
						var oldObject:Object3D = assets.GetObject( asset ) as Object3D;
						var newObject:Object3D = oldObject.clone();
						newObject.name = oldObject.name + " copy";
						var newAsset:ObjectVO = assets.GetAsset( newObject ) as ObjectVO;
						newObjects.push( newAsset );
					}
				}
				event.newValue = newObjects;
				
			}
			newObjects = event.newValue as Vector.<AssetVO>;
			for each( asset in newObjects ) 
			{
				if( asset is MeshVO ) 
				{
					var obj:Object3D =  assets.GetObject( asset ) as Object3D; 
					document.scene.addItemAt( asset, 0 );
					Scene3DManager.addObject( obj as ObjectContainer3D );
				}
			}
			
			commitHistoryEvent( event );
		}
		
		private function undo():void
		{
			var objects:Vector.<AssetVO> = event.oldValue as Vector.<AssetVO>;
			for each( var vo:AssetVO in objects ) {
				if( vo is MeshVO ) {
					Scene3DManager.removeMesh( AssetUtil(vo) as Mesh );
				}
			}
			removeItems( document.scene, objects );
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.OBJECTS_UPDATED));
		}
		
		private function removeItems( source:ArrayCollection, items:Vector.<AssetVO> ):void
		{
			for (var i:int = 0; i < source.length; i++) 
			{
				var item:AssetVO = source[i] as AssetVO;
				for each( var oddItem:AssetVO in items ) 
				{
					if( item.equals( oddItem ) )
					{
						source.removeItemAt( i );
						i--;
					}
				}
			}
		}
		
		private function getAssetById( id:String, children:ArrayCollection ):AssetVO
		{
			for each( var asset:AssetVO in children )
			{
				if( asset.id == id )
				{
					return asset;
				}
				var container:ContainerVO = asset as ContainerVO;
				if( container && container.children && container.children.length )
				{
					var rez:AssetVO = getAssetById( id, container.children );
					if( rez ) return rez;
				}
			}
			return null;
		}
		
	}
}