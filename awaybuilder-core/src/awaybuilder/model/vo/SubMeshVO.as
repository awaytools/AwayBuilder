package awaybuilder.model.vo 
{
	import away3d.core.base.SubMesh;
	import away3d.materials.TextureMaterial;
	
	import flash.display3D.textures.Texture;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class SubMeshVO extends AssetVO
	{
	    public function SubMeshVO( object:SubMesh )
	    {
			super( "subMesh", object );
			if( object.material is TextureMaterial ) {
				material = new MaterialVO( object.material as TextureMaterial );
			}
	    }
	
	    public var material:MaterialVO;
		
	    public var linkedMaterials:ArrayCollection;
	
	    public function clone():SubMeshVO
	    {
	        var vo:SubMeshVO = new SubMeshVO( this.linkedObject as SubMesh );
	        return vo;
	    }
	}
}
