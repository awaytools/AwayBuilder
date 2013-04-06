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
	    public function SubMeshVO( object:SubMesh, parentMesh:MeshVO )
	    {
			super( "subMesh", object );
			
			material = AssetFactory.CreateAsset( object.material ) as MaterialVO;
			trace( object.subGeometry );
			
//			this.subGeometry = AssetFactory.CreateAsset( object.subGeometry ) as SubGeometryVO;
			this.parentMesh = parentMesh;
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
	    public function clone():SubMeshVO
	    {
	        var vo:SubMeshVO = new SubMeshVO( this.linkedObject as SubMesh, parentMesh );
			vo.id = this.id;
	        return vo;
	    }
	}
}
