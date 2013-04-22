package awaybuilder.controller.scene 
{
	import away3d.core.base.SubMesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.utils.DefaultMaterialManager;
	import away3d.textures.BitmapTexture;
	import away3d.textures.Texture2DBase;
	
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.LightPickerVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.model.vo.scene.SubMeshVO;
	import awaybuilder.model.vo.scene.TextureVO;
	import awaybuilder.utils.AssetFactory;
	
	import mx.collections.ArrayCollection;
	
	public class ChangeMaterialCommand extends HistoryCommandBase
	{
	    [Inject]
	    public var event:SceneEvent;
	
	    [Inject]
	    public var document:IDocumentModel;
	
	    override public function execute():void
	    {
	        var newMaterial:MaterialVO = event.newValue as MaterialVO;
	        var vo:MaterialVO = event.items[0] as MaterialVO;
			
//			var prevMaterial:MaterialBase = newMaterial.linkedObject as MaterialBase;
			
			saveOldValue( event, vo.clone() );
			
	        vo.name = newMaterial.name;
	        vo.repeat = newMaterial.repeat;
			vo.smooth = newMaterial.smooth;
			vo.bothSides = newMaterial.bothSides;
			vo.mipmap = newMaterial.mipmap;
			vo.alphaPremultiplied = newMaterial.alphaPremultiplied;
			vo.blendMode = newMaterial.blendMode;
			vo.lightPicker = newMaterial.lightPicker;
			vo.light = newMaterial.light;
			
			vo.type = newMaterial.type;
			
			vo.shadowMethod = newMaterial.shadowMethod;
			
			vo.texture = newMaterial.texture;
			
			if( newMaterial.effectMethods )
			{
				vo.effectMethods = new ArrayCollection( newMaterial.effectMethods.source );
			}
			
			
			var linkedObjectChanged:Boolean = false;
//			if( newMaterial.type == MaterialVO.TEXTURE && vo.linkedObject is ColorMaterial )
//			{
//				vo.linkedObject = new TextureMaterial( vo.diffuseMethod.texture.linkedObject as Texture2DBase, newMaterial.smooth, newMaterial.repeat, newMaterial.mipmap );
//				linkedObjectChanged = true;
//			}
//			if( newMaterial.type == MaterialVO.COLOR && vo.linkedObject is TextureMaterial )
//			{
//				vo.linkedObject = new ColorMaterial( newMaterial.diffuseMethod.color, 1 );
//				linkedObjectChanged = true;
//			}
			
			
			if( linkedObjectChanged ) // update all meshes that use current material
			{
//				update( prevMaterial, vo );
			}
			
	        addToHistory( event );
	    }
//		private function update( prevMaterial:MaterialBase, newMaterial:MaterialVO ):void 
//		{
//			for each( var asset:AssetVO in AssetFactory.assets )
//			{
//				var mesh:MeshVO = asset as MeshVO;
//				if( mesh )
//				{
//					trace( mesh.name );
//					for each( var subMesh:SubMeshVO in mesh.subMeshes )
//					{
//						if( subMesh.material.equals( prevMaterial ) ) 
//						{
//							subMesh.material = newMaterial.clone();
//						}
//					}
//				}
//			}
//		}
	}
}