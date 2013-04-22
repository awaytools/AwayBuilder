package awaybuilder.model.vo.scene
{

    import away3d.core.base.SubMesh;
    import away3d.entities.Mesh;
    import away3d.materials.MaterialBase;
    
    import awaybuilder.utils.AssetFactory;
    
    import mx.collections.ArrayCollection;

	[Bindable]
    public class MeshVO extends ContainerVO
    {
			
        public var castsShadows:Boolean;

        public var subMeshes:ArrayCollection;
		
		public var extras:ArrayCollection;
		
//		override public function apply():void
//		{
//			super.apply();
//			var mesh:Mesh = Mesh( linkedObject );
//			mesh.x = x;
//			mesh.y = y;
//			mesh.z = z;
//			
//			mesh.scaleX = scaleX;
//			mesh.scaleY = scaleY;
//			mesh.scaleZ = scaleZ;
//			
//			mesh.rotationX = rotationX;
//			mesh.rotationY = rotationY;
//			mesh.rotationZ = rotationZ;
//			
//			mesh.castsShadows = castsShadows;
//			
////			for (var i:int = 0; i < subMeshes.length; i++) 
////			{
////				var subMesh:SubMeshVO = subMeshes.getItemAt(i) as SubMeshVO;
////				mesh.subMeshes[i].material = subMesh.material.linkedObject as MaterialBase;
////			}
//			
//		}
		
		override public function clone():ObjectVO
        {
			var m:MeshVO = fill( new MeshVO() ) as MeshVO;
			m.x = this.x;
			m.y = this.y;
			m.z = this.z;
			m.scaleX = this.scaleX;
			m.scaleY = this.scaleY;
			m.scaleZ = this.scaleZ;
			m.rotationX = this.rotationX;
			m.rotationY = this.rotationY;
			m.rotationZ = this.rotationZ;
			m.pivotX = this.pivotX;
			m.pivotY = this.pivotX;
			m.pivotZ = this.pivotZ;
			m.subMeshes = new ArrayCollection(this.subMeshes.source);
			m.name = this.name;
			m.castsShadows = this.castsShadows;
			m.id = this.id;
            return m;
        }
		
		
    }
}
