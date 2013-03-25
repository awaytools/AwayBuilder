package awaybuilder.controller.scene
{
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
	import awaybuilder.model.vo.MaterialVO;
	import awaybuilder.model.vo.MeshVO;
	import awaybuilder.model.vo.SubMeshVO;

	public class AddNewMaterialCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:SceneEvent;
		
		[Inject]
		public var document:IDocumentModel;
		
		override public function execute():void
		{
			var subMesh:SubMeshVO = event.items[0] as SubMeshVO;
			
//			var mesh:MeshVO = event.newValue as MeshVO;
//			var vo:MeshVO = document.getSceneObject( mesh.linkedObject ) as MeshVO;
			
			var material:MaterialVO = event.newValue as MaterialVO;
			var newMaterial:MaterialBase;
			if( material.material is TextureMaterial )
			{
				var textureMaterial:TextureMaterial =  material.material as TextureMaterial;
				newMaterial = new TextureMaterial( textureMaterial.texture, textureMaterial.smooth, textureMaterial.repeat, textureMaterial.mipmap );
				newMaterial.name = material.name + " (copy)";
			}
			if( material.material is ColorMaterial )
			{
				var colorMaterial:ColorMaterial =  material.material as ColorMaterial;
				newMaterial = new ColorMaterial( colorMaterial.color, colorMaterial.alpha );
				newMaterial.name = material.name + " (copy)";
			}
			
			var materialVO:MaterialVO = new MaterialVO(newMaterial);
			
			document.materials.addItemAt( materialVO, 0 );
			
			subMesh.material = materialVO;
			subMesh.linkedObject.material = newMaterial;
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
			
//			addToHistory( event );
		}
	}
}