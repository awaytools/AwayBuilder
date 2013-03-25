package awaybuilder.controller.document
{
	import away3d.entities.Mesh;
	
	import awaybuilder.controller.events.DocumentDataOperationEvent;
	import awaybuilder.controller.events.DocumentEvent;
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.events.ReadDocumentEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.AssetVO;
	import awaybuilder.model.vo.DocumentVO;
	import awaybuilder.model.vo.MeshVO;
	import awaybuilder.services.ProcessDataService;
	import awaybuilder.utils.scene.Scene3DManager;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Command;

	public class ConcatenateDocumentDataCommand extends HistoryCommandBase
	{
		[Inject]
		public var document:IDocumentModel;
		
		[Inject]
		public var event:DocumentDataOperationEvent;
		
		override public function execute():void
		{
			if( event.isUndoAction )
			{
				undo(); 
				return;
			}
			var data:DocumentVO = event.newValue as DocumentVO;
			for each( var vo:AssetVO in data.scene ) {
				if( vo is MeshVO ) {
					Scene3DManager.addMesh( vo.linkedObject as Mesh );
				}
			}
			document.animations = new ArrayCollection(document.animations.source.concat( data.animations.source ));
			document.geometry = new ArrayCollection(document.geometry.source.concat( data.geometry.source ));
			document.materials = new ArrayCollection(document.materials.source.concat( data.materials.source ));
			document.scene = new ArrayCollection(document.scene.source.concat( data.scene.source ));
			document.skeletons = new ArrayCollection(document.skeletons.source.concat( data.skeletons.source ));
			document.textures = new ArrayCollection(document.textures.source.concat( data.textures.source ));
			document.lights = new ArrayCollection(document.lights.source.concat( data.lights.source ));
			
			if( event.canUndo ) 
			{
				addToHistory( event );
			}
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
		}
		
		private function undo():void
		{
			var data:DocumentVO = event.oldValue as DocumentVO;
			for each( var vo:AssetVO in data.scene ) {
				if( vo is MeshVO ) {
					Scene3DManager.removeMesh( vo.linkedObject as Mesh );
				}
			}
			removeItems( document.animations, data.animations );
			removeItems( document.geometry, data.geometry );
			removeItems( document.materials, data.materials );
			removeItems( document.scene, data.scene );
			removeItems( document.skeletons, data.skeletons );
			removeItems( document.textures, data.textures );
			removeItems( document.lights, data.lights );
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
		}
		
		private function removeItems( source:ArrayCollection, items:ArrayCollection ):void
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