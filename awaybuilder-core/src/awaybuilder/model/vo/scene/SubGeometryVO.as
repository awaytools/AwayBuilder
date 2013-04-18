package awaybuilder.model.vo.scene
{
	import away3d.core.base.ISubGeometry;

	public class SubGeometryVO extends AssetVO
	{
//		public function SubGeometryVO( object:ISubGeometry, parentGeometry:GeometryVO )
//		{
//			super( "subGeometry", object );
//			this.parentGeometry = parentGeometry;
//		}
		
		public var parentGeometry:GeometryVO;
		
//		public function apply():void
//		{
//			var subMesh:SubMesh = linkedObject as SubMesh;
//			subMesh.material = material.linkedObject as MaterialBase;
//		}
		public function clone():SubGeometryVO
		{
			var vo:SubGeometryVO = new SubGeometryVO();
//			vo.id = this.id;
			return vo;
		}
	}
}
