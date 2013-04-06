package awaybuilder.model.vo.scene
{

    import away3d.core.base.SubMesh;
    import away3d.entities.Mesh;
    import away3d.materials.MaterialBase;
    
    import mx.collections.ArrayCollection;

	[Bindable]
    public class MeshVO extends ContainerVO
    {
        public function MeshVO( item:Mesh )
        {
            super( item );
			
			castsShadows = item.castsShadows;
            subMeshes = new ArrayCollection();

            for each( var subMesh:SubMesh in item.subMeshes )
            {
                subMeshes.addItem(new SubMeshVO(subMesh, this));
            }
        }

        public var castsShadows:Boolean;

        public var subMeshes:ArrayCollection;
		
		override public function apply():void
		{
			super.apply();
			var mesh:Mesh = Mesh( linkedObject );
			mesh.x = x;
			mesh.y = y;
			mesh.z = z;
			
			mesh.scaleX = scaleX;
			mesh.scaleY = scaleY;
			mesh.scaleZ = scaleZ;
			
			mesh.rotationX = rotationX;
			mesh.rotationY = rotationY;
			mesh.rotationZ = rotationZ;
			
			mesh.castsShadows = castsShadows;
			
//			for (var i:int = 0; i < subMeshes.length; i++) 
//			{
//				var subMesh:SubMeshVO = subMeshes.getItemAt(i) as SubMeshVO;
//				mesh.subMeshes[i].material = subMesh.material.linkedObject as MaterialBase;
//			}
			
		}
		
		override public function clone():ObjectVO
        {
			var m:MeshVO = new MeshVO( this.linkedObject as Mesh );
			m.id = this.id;
            return m;
        }
    }
}
