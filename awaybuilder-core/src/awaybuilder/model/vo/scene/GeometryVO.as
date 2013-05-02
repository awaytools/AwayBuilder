package awaybuilder.model.vo.scene
{
	import away3d.core.base.Geometry;
	import away3d.core.base.ISubGeometry;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class GeometryVO extends AssetVO
	{
		
		public var subGeometries:ArrayCollection;
		
		public function clone():GeometryVO
		{
			var vo:GeometryVO = new GeometryVO();
			vo.fillFromGeometry( this );
			return vo;
		}
		
		public function fillFromGeometry( asset:GeometryVO ):void
		{
			this.name = asset.name;
			
			this.subGeometries = asset.subGeometries;
			
			this.id = asset.id;
		}
	}
}
