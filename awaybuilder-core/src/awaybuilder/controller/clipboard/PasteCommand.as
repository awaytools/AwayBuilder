package awaybuilder.controller.clipboard
{
	import away3d.entities.Mesh;
	
	import awaybuilder.controller.clipboard.events.PasteEvent;
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.AssetVO;
	import awaybuilder.model.vo.BitmapTextureVO;
	import awaybuilder.model.vo.DocumentVO;
	import awaybuilder.model.vo.MeshVO;
	import awaybuilder.utils.scene.Scene3DManager;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Command;

	public class PasteCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:PasteEvent;
		
		[Inject]
		public var document:IDocumentModel;
		
		override public function execute():void
		{
			if( event.isUndoAction )
			{
				undo(); 
				return;
			}
			if( !event.newValue )
			{
				event.newValue = document.copiedObjects.concat();
			}
			var objects:Vector.<AssetVO> = event.newValue as Vector.<AssetVO>;
			for each( var vo:AssetVO in objects ) {
				if( vo is MeshVO ) {
					Scene3DManager.addMesh( vo.linkedObject as Mesh );
					document.scene.addItemAt( vo, 0 );
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
					Scene3DManager.removeMesh( vo.linkedObject as Mesh );
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
					if( item.linkedObject == oddItem.linkedObject )
					{
						source.removeItemAt( i );
						i--;
					}
				}
			}
		}
		
	}
}