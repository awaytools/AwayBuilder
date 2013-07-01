package awaybuilder.model.vo.scene 
{
	import away3d.core.base.SubMesh;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	
	import awaybuilder.utils.AssetUtil;
	
	import flash.display3D.textures.Texture;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class SubMeshVO extends AssetVO
	{
	
	    public var material:MaterialVO;
		
		public var subGeometry:SubGeometryVO;
		
		public var parentMesh:MeshVO;
		
		public function clone():SubMeshVO
		{
			var m:SubMeshVO = new SubMeshVO();
			m.id = this.id;
			m.material = this.material;
			m.subGeometry = this.subGeometry;
			m.parentMesh = this.parentMesh;
			return m;
		}
		
	}
}
