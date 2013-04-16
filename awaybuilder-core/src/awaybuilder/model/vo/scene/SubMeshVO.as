package awaybuilder.model.vo.scene 
{
	import away3d.core.base.SubMesh;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	
	import awaybuilder.utils.AssetFactory;
	
	import flash.display3D.textures.Texture;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class SubMeshVO extends AssetVO
	{
	    public function SubMeshVO( object:SubMesh )
	    {
			super( "subMesh", object );
			
			material = AssetFactory.GetAsset( object.material ) as MaterialVO;
//			this.subGeometry = AssetFactory.GetAsset( object.subGeometry ) as SubGeometryVO;
	    }
	
	    public var material:MaterialVO;
		
		public var subGeometry:SubGeometryVO;
		
		public var parentMesh:MeshVO;
		
	    public var linkedMaterials:ArrayCollection;
	
		override public function apply():void
		{
			var subMesh:SubMesh = linkedObject as SubMesh;
			subMesh.material = material.linkedObject as MaterialBase;
		}
	}
}
