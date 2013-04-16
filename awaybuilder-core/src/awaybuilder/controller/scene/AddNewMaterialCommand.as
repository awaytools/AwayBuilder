package awaybuilder.controller.scene
{
	import away3d.arcane;
	import away3d.core.base.SubMesh;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.utils.DefaultMaterialManager;
	
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.model.vo.scene.SubMeshVO;
	import awaybuilder.model.vo.scene.TextureVO;
	import awaybuilder.utils.AssetFactory;
	
	import mx.collections.ArrayCollection;
	
	use namespace arcane;
	
	public class AddNewMaterialCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:SceneEvent;
		
		[Inject]
		public var document:IDocumentModel;
		
		override public function execute():void
		{
			var subMesh:SubMeshVO = event.items[0] as SubMeshVO;
			
			var newMaterial:MaterialVO = event.newValue as MaterialVO;
			
			saveOldValue( event, subMesh.material.clone() );
			
			subMesh.material = AssetFactory.GetAsset(newMaterial.linkedObject) as MaterialVO;
			subMesh.apply();
			
			if( event.isUndoAction )
			{
				var oldMaterial:MaterialVO = event.oldValue as MaterialVO;
				for (var j:int = 0; j < document.materials.length; j++) 
				{
					if( document.materials[j].id == oldMaterial.id )
					{
						document.materials.removeItemAt( j );
						break;
					}
				}
			}
			else 
			{
				document.materials.addItemAt( newMaterial, 0 );
			}
			
			addToHistory( event );
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
		}
		
	}
}