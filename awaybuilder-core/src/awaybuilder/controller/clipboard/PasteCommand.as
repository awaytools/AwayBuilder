package awaybuilder.controller.clipboard
{
	import away3d.entities.Mesh;
	
	import awaybuilder.controller.clipboard.events.PasteEvent;
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.DocumentVO;
	import awaybuilder.model.vo.scene.MeshVO;
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
		public var document:DocumentModel;
		
		override public function execute():void
		{
			if( event.isUndoAction )
			{
				undo(); 
				return;
			}
			var newObjects:Vector.<AssetVO>;
			if( !event.newValue )
			{
				newObjects = new Vector.<AssetVO>();
				for each( var vo:AssetVO in document.copiedObjects ) 
				{
					if( vo is MeshVO ) 
					{
//						var newMesh:MeshVO = AssetFactory.CreateMaterialCopy(new MeshVO( Mesh(vo.linkedObject).clone() as Mesh );
//						newObjects.push( newMesh );
					}
				}
				event.newValue = newObjects;
				
			}
			newObjects = event.newValue as Vector.<AssetVO>;
			for each( var asset:AssetVO in newObjects ) 
			{
				if( asset is MeshVO ) 
				{
//					Scene3DManager.addMesh( asset.linkedObject as Mesh );
					document.scene.addItemAt( asset, 0 );
				}
			}
			
			addToHistory( event );
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
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
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
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
		
	}
}