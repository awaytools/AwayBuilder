package awaybuilder.model.vo.scene
{
	import away3d.core.base.Geometry;
	import away3d.core.base.ISubGeometry;
	
	import mx.collections.ArrayCollection;

	public class GeometryVO extends AssetVO
	{
		public function GeometryVO( item:Geometry )
		{
			super( item.name, item );
			
			subGeometries = new ArrayCollection();
			for each( var sub:ISubGeometry in item.subGeometries )
			{
				subGeometries.addItem(new SubGeometryVO(sub, this));
			}
			
		}
		
		public var subGeometries:ArrayCollection;
		
	}
}
