package awaybuilder.controller.scene
{
	import away3d.arcane;
	import away3d.core.base.SubMesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.utils.DefaultMaterialManager;
	
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.scene.BitmapTextureVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.model.vo.scene.SubMeshVO;

	use namespace arcane;
	
	public class AddNewMaterialCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:SceneEvent;
		
		[Inject]
		public var document:IDocumentModel;
		
		override public function execute():void
		{
			var tempMesh:MeshVO = event.items[0] as MeshVO;
			var newSubMesh:SubMeshVO = event.newValue as SubMeshVO;
			var mesh:MeshVO = document.getSceneObject( tempMesh.id ) as MeshVO;
			
			if( !event.oldValue ) {
				event.oldValue = getSubmesh( mesh, newSubMesh.id as SubMesh ).clone();
			}
			
			var subMeshes:Vector.<SubMesh> = new Vector.<SubMesh>();
			var newSubMeshes:Array = new Array();
			
			for( var i:int = 0; i < mesh.subMeshes.length; i++ )
			{
				var subMesh:SubMeshVO = mesh.subMeshes[i] as SubMeshVO;
				if( subMesh.id == newSubMesh.id )
				{
					subMesh.material = newSubMesh.material.clone(); 
					subMesh.apply();
				}
			}
			
			if( event.isUndoAction )
			{
				var oldSubMesh:SubMeshVO = event.oldValue as SubMeshVO;
				for (var j:int = 0; j < document.materials.length; j++) 
				{
					if( document.materials[j].id == oldSubMesh.material.id )
					{
						document.materials.removeItemAt( j );
						break;
					}
				}
			}
			else 
			{
				document.materials.addItemAt( newSubMesh.material.clone(), 0 );
			}
			
			addToHistory( event );
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
			
		}
		
		private function getSubmesh( mesh:MeshVO, linked:SubMesh ):SubMeshVO
		{
			for each( var sub:SubMeshVO in mesh.subMeshes )
			{
				if( sub.linkedObject == linked ) return sub;
			}
			return null;
		}
	}
}