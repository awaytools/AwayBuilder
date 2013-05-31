package awaybuilder.model.vo.scene
{

	public class SubGeometryVO extends AssetVO
	{
		
		public var type : String;
		
		public var vertexData : Vector.<Number>;
		public var vertexOffset : int;
		public var vertexStride: uint;
		
		public var UVData : Vector.<Number>;
		public var UVStride : uint;
		public var UVOffset : int;
		
		public var vertexNormalData : Vector.<Number>;
		public var vertexNormalOffset : int;
		public var vertexNormalStride : uint;
		
		public var vertexTangentData : Vector.<Number>;
		public var vertexTangentOffset : int;
		public var vertexTangentStride : uint;
		
		public var jointWeightsData : Vector.<Number>;
		public var jointIndexData : Vector.<Number>;
		
		public var indexData : Vector.<uint>;
		
//		public var parentGeometry:GeometryVO;
		
		public function clone():SubGeometryVO
		{
			var vo:SubGeometryVO = new SubGeometryVO();
			vo.id = this.id;
			vo.type = this.type;
			vo.vertexData = this.vertexData;
			vo.vertexOffset = this.vertexOffset;
			vo.vertexStride = this.vertexStride;
			vo.UVData = this.UVData;
			vo.UVStride = this.UVStride;
			vo.UVOffset = this.UVOffset;
			vo.vertexNormalData = this.vertexNormalData;
			vo.vertexNormalOffset = this.vertexNormalOffset;
			vo.vertexNormalStride = this.vertexNormalStride;
			vo.vertexTangentData = this.vertexTangentData;
			vo.vertexTangentOffset = this.vertexTangentOffset;
			vo.vertexTangentStride = this.vertexTangentStride;
			vo.indexData = this.indexData;
			vo.jointWeightsData = this.jointWeightsData;
			vo.jointIndexData = this.jointIndexData;
			return vo;
		}
	}
}
