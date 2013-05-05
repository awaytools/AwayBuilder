package awaybuilder.model.vo.scene
{
	import away3d.core.base.Geometry;
	import away3d.core.base.ISubGeometry;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class GeometryVO extends AssetVO
	{
		
		public var type:String;
		
		public var radius:Number;
		public var yUp:Boolean;
		
		public var width:Number;
		public var height:Number;
		public var depth:Number;
		public var tile6:Boolean;
		public var segmentsW:uint;
		public var segmentsH:uint;
		public var segmentsD:Number;
		
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
			this.type = asset.type;
			
			this.width = asset.width;
			this.height = asset.height;
			this.depth = asset.depth;
			this.tile6 = asset.tile6;
			this.segmentsW = asset.segmentsW;
			this.segmentsH = asset.segmentsH;
			this.segmentsD = asset.segmentsD;
			this.radius = asset.radius;
			this.yUp = asset.yUp;
			
			this.id = asset.id;
		}
	}
}
