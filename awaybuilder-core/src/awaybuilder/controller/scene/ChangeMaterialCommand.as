package awaybuilder.controller.scene 
{
	import away3d.core.base.SubMesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.materials.utils.DefaultMaterialManager;
	import away3d.textures.BitmapTexture;
	import away3d.textures.Texture2DBase;
	
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.BitmapTextureVO;
	import awaybuilder.model.vo.ContainerVO;
	import awaybuilder.model.vo.MaterialVO;
	import awaybuilder.model.vo.MeshVO;
	import awaybuilder.model.vo.SubMeshVO;
	
	public class ChangeMaterialCommand extends HistoryCommandBase
	{
	    [Inject]
	    public var event:SceneEvent;
	
	    [Inject]
	    public var document:IDocumentModel;
	
	    override public function execute():void
	    {
	        var newMaterial:MaterialVO = event.newValue as MaterialVO;
	        var vo:MaterialVO = document.getMaterial( newMaterial.linkedObject ) as MaterialVO;
	
			if( !event.oldValue ) {
				event.oldValue = vo.clone();
			}
			
	        vo.name = newMaterial.name;
	        vo.repeat = newMaterial.repeat;
			vo.color = newMaterial.color;
			vo.alpha = newMaterial.alpha;
			vo.type = newMaterial.type;
	
			if( newMaterial.type == MaterialVO.TEXTURE )
			{
				//vo.texture = new BitmapTextureVO( material.texture.linkedObject as BitmapTexture );
				if( newMaterial.texture ) 
				{
					vo.texture = newMaterial.texture;
				}
				if( !vo.texture ) 
				{
					vo.texture = document.getTexture(DefaultMaterialManager.getDefaultTexture()) as BitmapTextureVO;
				}
				if( vo.linkedObject is ColorMaterial )
				{
					vo.linkedObject = new TextureMaterial( vo.texture.linkedObject as Texture2DBase, newMaterial.smooth, newMaterial.repeat, newMaterial.mipmap );
				}
				vo.linkedObject.alpha = vo.alpha;
				vo.linkedObject.repeat = vo.repeat;
			}
			if( newMaterial.type == MaterialVO.COLOR )
			{
				
				//vo.texture = new BitmapTextureVO( material.texture.linkedObject as BitmapTexture );
				if( vo.linkedObject is TextureMaterial )
				{
					vo.linkedObject = new ColorMaterial( newMaterial.color, newMaterial.alpha );
				}
				vo.linkedObject.color = vo.color;
				vo.linkedObject.alpha = vo.alpha;
			}
			
			for each( var asset:ContainerVO in document.scene )
			{
				var mesh:MeshVO = asset as MeshVO;
				if( mesh )
				{
					for each( var subMesh:SubMeshVO in mesh.subMeshes )
					{
						subMesh.material = vo;
						SubMesh(subMesh.linkedObject).material = vo.material;
					}
				}
			}
			
			
			event.items = [vo];
	        addToHistory( event );
	    }
	}
}