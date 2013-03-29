package awaybuilder.model.vo.scene 
{
	import away3d.core.base.SubMesh;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	
	import flash.display3D.textures.Texture;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class SubMeshVO extends AssetVO
	{
	    public function SubMeshVO( object:SubMesh, parentMesh:MeshVO )
	    {
			super( "subMesh", object );
			
			material = new MaterialVO( object.material );
			this.parentMesh = parentMesh;
	    }
	
	    public var material:MaterialVO;
		
		public var parentMesh:MeshVO;
		
	    public var linkedMaterials:ArrayCollection;
	
		public function apply():void
		{
			var subMesh:SubMesh = linkedObject as SubMesh;
			subMesh.material = material.linkedObject as MaterialBase;
		}
	    public function clone():SubMeshVO
	    {
	        var vo:SubMeshVO = new SubMeshVO( this.linkedObject as SubMesh, parentMesh );
	        return vo;
	    }
	}
}
