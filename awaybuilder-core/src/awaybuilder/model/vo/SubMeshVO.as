package awaybuilder.model.vo {
import away3d.core.base.SubMesh;

import mx.collections.ArrayCollection;
[Bindable]
public class SubMeshVO
{
    public function SubMeshVO( object:SubMesh )
    {
        this.linkedObject = object;
        material = new MaterialItemVO( object.material );
    }

    public var linkedObject:SubMesh;

    public var name:String;

    public var material:MaterialItemVO;

    public var linkedMaterials:ArrayCollection;

    public function clone():SubMeshVO
    {
        var vo:SubMeshVO = new SubMeshVO( this.linkedObject );
        return vo;
    }
}
}
