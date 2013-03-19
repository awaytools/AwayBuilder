package awaybuilder.model.vo 
{
	import away3d.core.base.SubMesh;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class SubMeshVO extends DocumentBaseVO
	{
	    public function SubMeshVO( object:SubMesh )
	    {
			super( "subMesh", object );
	        material = new MaterialVO( object.material );
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
