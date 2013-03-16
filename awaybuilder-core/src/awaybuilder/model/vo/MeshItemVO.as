package awaybuilder.model.vo {

    import away3d.containers.ObjectContainer3D;
import away3d.core.base.SubMesh;
import away3d.entities.Mesh;

import mx.collections.ArrayCollection;

[Bindable]
    public class MeshItemVO extends ScenegraphItemVO
    {
        public function MeshItemVO( item:Mesh )
        {
            super( item.name, item );
            x = item.x;
            y = item.y;
            z = item.z;
            scaleX = item.scaleX;
            scaleY = item.scaleY;
            scaleZ = item.scaleZ;
            rotationX = item.rotationX;
            rotationY = item.rotationY;
            rotationZ = item.rotationZ;

            name = item.name;

            subMeshes = new ArrayCollection();

            for each( var subMesh:SubMesh in item.subMeshes )
            {
                subMeshes.addItem(new SubMeshVO(subMesh));
            }
        }

        public var x:Number;
        public var y:Number;
        public var z:Number;

        public var scaleX:Number;
        public var scaleY:Number;
        public var scaleZ:Number;

        public var rotationX:Number;
        public var rotationY:Number;
        public var rotationZ:Number;

        public var name:String;

        public var castShadows:Boolean;

        public var subMeshes:ArrayCollection;

        public function clone():MeshItemVO
        {
            var vo:MeshItemVO = new MeshItemVO( this.item as Mesh );
            return vo;
        }
    }
}
