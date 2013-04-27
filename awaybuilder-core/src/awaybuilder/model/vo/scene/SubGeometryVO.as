package awaybuilder.model.vo.scene
{
	import away3d.core.base.ISubGeometry;

	public class SubGeometryVO extends AssetVO
	{
		
		public var parentGeometry:GeometryVO;
		
		public function clone():SubGeometryVO
		{
			var vo:SubGeometryVO = new SubGeometryVO();
			vo.id = this.id;
			return vo;
		}
	}
}
