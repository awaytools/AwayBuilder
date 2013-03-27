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
	import awaybuilder.model.vo.BitmapTextureVO;
	import awaybuilder.model.vo.ContainerVO;
	import awaybuilder.model.vo.MaterialVO;
	import awaybuilder.model.vo.MeshVO;
	import awaybuilder.model.vo.SubMeshVO;

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
			var mesh:MeshVO = document.getSceneObject( tempMesh.linkedObject ) as MeshVO;
			
			if( !event.oldValue ) {
				event.oldValue = getSubmesh( mesh, newSubMesh.linkedObject as SubMesh ).clone();
			}
			
			var subMeshes:Vector.<SubMesh> = new Vector.<SubMesh>();
			var newSubMeshes:Array = new Array();
			
			for( var i:int = 0; i < mesh.subMeshes.length; i++ )
			{
				var subMesh:SubMeshVO = mesh.subMeshes[i] as SubMeshVO;
				if( subMesh.linkedObject == newSubMesh.linkedObject )
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
					if( document.materials[j].linkedObject == oldSubMesh.material.linkedObject )
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