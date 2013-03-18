package awaybuilder.utils.encoders
{
	import away3d.core.base.Geometry;
	import away3d.core.base.ISubGeometry;
	import away3d.core.base.SubMesh;
	import away3d.entities.Mesh;
	
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.MeshItemVO;
	import awaybuilder.model.vo.ScenegraphGroupItemVO;
	import awaybuilder.model.vo.ScenegraphItemVO;
	
	import flash.geom.Matrix3D;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	public class AWDEncoder implements ISceneGraphEncoder
	{
		private var _body : ByteArray;
		private var _blockCache : Dictionary;
		private var _blockId : uint;
		
		private var _elemSizeOffsets : Vector.<uint>;
		
		private static const INT8 : uint = 1;
		private static const INT16 : uint = 2;
		private static const INT32 : uint = 3;
		private static const UINT8 : uint = 4;
		private static const UINT16 : uint = 5;
		private static const UINT32 : uint = 6;
		private static const FLOAT32 : uint = 11;
		private static const FLOAT64 : uint = 12;
		
		
		public function AWDEncoder()
		{
			super();
			
			_blockCache = new Dictionary();
			_elemSizeOffsets = new Vector.<uint>();
		}
		
		
		public function encode(document : IDocumentModel, output : ByteArray) : Boolean
		{
			var object : ScenegraphItemVO;
			var scene : ScenegraphGroupItemVO;
			
			_body = new ByteArray();
			_body.endian = Endian.LITTLE_ENDIAN;
			_blockId = 0;
			
			scene = document.getScenegraphGroup(ScenegraphGroupItemVO.SCENE_GROUP);
			for each (object in scene.children) {
				_encodeChild(object);
			}
			
			// Header
			output.endian = Endian.LITTLE_ENDIAN;
			output.writeUTFBytes("AWD");
			output.writeByte(2);
			output.writeByte(0);
			output.writeShort(0);
			output.writeByte(1); // ZLIB
			
			_body.compress();
			output.writeUnsignedInt(_body.length);
			output.writeBytes(_body);
			
			_finalize();
			
			// SUCCESS!
			return true;
		}
		
		
		public function dispose() : void
		{
			_blockCache = null;
		}
		
		private function _encodeBlockHeader(type : uint) : void
		{
			_blockId++;
			_body.writeUnsignedInt(_blockId);
			_body.writeByte(0);
			_body.writeByte(type);
			_body.writeByte(0);
		}
		
		
		private function _beginElement() : void
		{
			_elemSizeOffsets.push(_body.position);
			_body.writeUnsignedInt(0); // Placeholder
		}
		
		private function _endElement() : void
		{
			var size : uint;
			var offs : uint;
			
			offs = _elemSizeOffsets.pop();
			
			size = _body.position - (offs+4);
			if (size) {
				trace('size was ', size);
				_body.position = offs;
				_body.writeUnsignedInt(size);
				_body.position = _body.length;
			}
		}
		
		private function _encodeChild(vo : ScenegraphItemVO) : void
		{
			var child : ScenegraphItemVO;
			
			if (vo is MeshItemVO) {
				_encodeMesh(Mesh(MeshItemVO(vo).item));
			}
			
			for each (child in vo.children) {
				_encodeChild(child);
			}
		}
		
		
		private function _encodeMesh(mesh : Mesh) : void
		{
			var geomId : uint;
			var parentId : uint;
			var materialId : uint;
			
			trace('encoding mesh');
			
			if (!_blockCache[mesh.geometry])
				_encodeGeometry(mesh.geometry);
			geomId = _blockCache[mesh.geometry];
			
			// TODO: Export materials
			materialId = 0;
			
			parentId = 0;
			if (mesh.parent && _blockCache[mesh])
				parentId = _blockCache[mesh];
			
			// TODO: deal with sub-materials
			
			_encodeBlockHeader(23);
			_beginElement(); // Block
			
			_body.writeUnsignedInt(parentId);
			_encodeMatrix3D(mesh.transform);
			_body.writeUTF(mesh.name);
			_body.writeUnsignedInt(geomId);
			
			// TODO: Export materials
			_body.writeShort(1);
			_body.writeUnsignedInt(0);
			
			_beginElement(); // Prop list
			_endElement(); // Prop list
			_beginElement(); // Attr list
			_endElement(); // Attr list
			
			_endElement(); // Block
			
			_blockCache[mesh] = _blockId;
		}
		
		
		private function _encodeGeometry(geom : Geometry) : void
		{
			var sub : ISubGeometry;
			
			_encodeBlockHeader(1);
			_beginElement(); // Block
			
			_body.writeUTF(geom.name);
			_body.writeShort(geom.subGeometries.length);
			
			_beginElement(); // Prop list
			_endElement(); // Prop list
			
			for each (sub in geom.subGeometries) {
				_beginElement(); // Sub-geom
				_beginElement(); // Prop list
				_endElement(); // Prop list
				
				_encodeStream(1, sub.vertexData, sub.vertexOffset, sub.vertexStride);
				_encodeStream(3, sub.UVData, sub.UVOffset, sub.UVStride);
				_encodeStream(2, sub.indexData);
				
				_endElement(); // Sub-geom
				
				_beginElement(); // User attr
				_endElement(); // User attr
			}
			
			_beginElement(); // User attr
			_endElement(); // User attr
			
			_endElement(); // Block
			
			_blockCache[geom] = _blockId;
		}
		
		
		private function _encodeStream(type : uint, data : *, offset : uint = 0, stride : uint = 0) : void
		{
			_body.writeByte(type);
			
			switch (type) {
				case 1:
					_body.writeByte(FLOAT32);
					_beginElement();
					_encodeFloatStream( Vector.<Number>(data), 3, offset, stride);
					_endElement();
					break;
				
				case 2:
					_body.writeByte(UINT16);
					_beginElement();
					_encodeUnsignedShortStream( Vector.<uint>(data) );
					_endElement();
					break;
				
				case 3:
					_body.writeByte(FLOAT32);
					_beginElement();
					_encodeFloatStream( Vector.<Number>(data), 2, offset, stride);
					_endElement();
					break;
			}
		}
		
		private function _encodeFloatStream(str : Vector.<Number>, numPerVertex : uint, offset : uint, stride : uint) : void
		{
			var i : uint;
			
			i = 0;
			for (i=offset; i < str.length; i += stride) {
				var elem : uint;
				
				for (elem=0; elem<numPerVertex; elem++) {
					_body.writeFloat(str[i+elem]);
				}
			}
		}
		
		private function _encodeUnsignedShortStream(str : Vector.<uint>) : void
		{
			var i : uint;
			for (i=0; i<str.length; i++) {
				_body.writeShort(str[i]);
			}
		}
		
		
		private function _encodeMatrix3D(mtx : Matrix3D) : void
		{
			var data : Vector.<Number> = mtx.rawData;
			_body.writeFloat(data[0]);
			_body.writeFloat(data[1]);
			_body.writeFloat(data[2]);
			_body.writeFloat(data[4]);
			_body.writeFloat(data[5]);
			_body.writeFloat(data[6]);
			_body.writeFloat(data[8]);
			_body.writeFloat(data[9]);
			_body.writeFloat(data[10]);
			_body.writeFloat(data[12]);
			_body.writeFloat(data[13]);
			_body.writeFloat(data[14]);
		}
		
		
		private function _finalize() : void
		{
			_body = null;
		}
	}
}