package awaybuilder.utils.encoders
{
	import away3d.core.base.Geometry;
	import away3d.core.base.ISubGeometry;
	import away3d.core.base.SubMesh;
	import away3d.entities.Mesh;
	import away3d.containers.ObjectContainer3D;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.utils.DefaultMaterialManager;
	import away3d.textures.BitmapTexture;
	import away3d.textures.Texture2DBase;
	import away3d.textures.TextureProxyBase;
	
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.ScenegraphGroupItemVO;
	import awaybuilder.model.vo.ScenegraphItemVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.utils.AssetFactory;
	
	import flash.display.PNGEncoderOptions;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Matrix3D;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	import mx.collections.ArrayCollection;
	
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
		private static const BOOL : uint = 21;
		private static const COLOR : uint = 22;
		private static const BADDR : uint = 23;
		
		
		public function AWDEncoder()
		{
			super();
			
			_blockCache = new Dictionary();
			_elemSizeOffsets = new Vector.<uint>();
		}
		
		
		public function encode(document : IDocumentModel, output : ByteArray) : Boolean
		{
			var scene : Array;
			
			_body = new ByteArray();
			_body.endian = Endian.LITTLE_ENDIAN;
			_blockId = 0;
			
			scene = document.scene.source;
			for each ( var vo:AssetVO in scene ) 
			{
				_encodeChild( vo as ContainerVO );
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
		
		
		private function _encodeProperty(id : int, value : *, type : uint) : void
		{
			var i : uint;
			var len  : uint;
			var flen : uint;
			var values : Array;
			
			if (value is Array) {
				len = value.length;
				values = value;
			}
			else {
				values = [ value ];
				len = 1;
			}
			
			switch (type) {
				case INT8:
				case UINT8:
					flen = 1;
					break;
				case INT16:
				case UINT16:
					flen = 2;
					break;
				case INT32:
				case UINT32:
				case COLOR:
				case BADDR:
				case FLOAT32:
					flen = 4;
					break;
				case FLOAT64:
					flen = 8;
					break;
			}
			
			_body.writeShort(id);
			_body.writeUnsignedInt(len * flen);
			
			for (i=0; i<len; i++) {
				switch (type) {
					case INT8:
					case UINT8:
						_body.writeByte(values[i]);
						break;
					
					case BOOL:
						_body.writeByte(values[i]? 1 : 0);
						break;
					
					case INT16:
					case UINT16:
						_body.writeShort(values[i]);
						break;
					
					case INT32:
						_body.writeInt(values[i]);
						break;
					
					case UINT32:
					case COLOR:
					case BADDR:
						_body.writeUnsignedInt(values[i]);
						break;
					
					case FLOAT32:
						_body.writeFloat(values[i]);
						break;
					
					case FLOAT64:
						_body.writeDouble(values[i]);
						break;
				}
			}
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
				//trace('size was ', size);
				_body.position = offs;
				_body.writeUnsignedInt(size);
				_body.position = _body.length;
			}
		}
		
		private function _encodeChild(vo : ContainerVO) : void
		{
			var child : ContainerVO;
			if (vo is MeshVO) {
				_encodeMesh(AssetFactory.GetObject(vo) as Mesh);
			}
				
			else if (vo is ContainerVO) {
				_encodeContainer3D(AssetFactory.GetObject(vo) as ObjectContainer3D);
			}
			for each (child in vo.children) {
					_encodeChild(child as ContainerVO);
			}
		}
		
		
		private function _encodeTexture(tex : Texture2DBase) : void
		{
			if (tex is BitmapTexture) {
				var ba : ByteArray;
				var btex : BitmapTexture;
				
				btex = BitmapTexture(tex);
				
				_encodeBlockHeader(82);
				_beginElement(); // Block
				
				_body.writeUTF(tex.name);
				
				// TODO: Check whether to embed or use external textures,
				// depending on some app-specific configuration
				ba = new ByteArray();
				btex.bitmapData.encode(btex.bitmapData.rect, new PNGEncoderOptions(), ba);
				_body.writeByte(1);
				_body.writeUnsignedInt(ba.length);
				_body.writeBytes(ba);
				
				_beginElement(); // Properties (empty)
				_endElement(); // Properties
				
				_beginElement(); // Attributes (empty)
				_endElement(); // Attributes
				
				_endElement(); // Block
				
				_blockCache[tex] = _blockId;
			}
			else {
				// Fail on unsupported type (e.g. ATF?)
			}
		}
		
		
		private function _encodeMaterial(mtl : MaterialBase) : void
		{
			if (mtl is TextureMaterial) {
				var tmtl : TextureMaterial;
				
				tmtl = TextureMaterial(mtl);
				
				if (!_blockCache[tmtl.texture])
					_encodeTexture(tmtl.texture);
				
				if (tmtl.normalMap){					
					if (!_blockCache[tmtl.normalMap])
						_encodeTexture(tmtl.normalMap);
				}
				_encodeBlockHeader(81);
				_beginElement(); // Block
				
				_body.writeUTF(mtl.name);
				_body.writeByte(2);
				
				// TODO: Implement shading methods
				_body.writeByte(0);
				
				// Property list
				_beginElement(); // Prop list
				_encodeProperty(2, _blockCache[tmtl.texture], BADDR);
				if (tmtl.normalMap){
					_encodeProperty(3, _blockCache[tmtl.normalMap], BADDR);					
				}
				_encodeProperty(10, tmtl.alpha, FLOAT32);
				_encodeProperty(11, tmtl.alphaBlending, BOOL);
				_encodeProperty(12, tmtl.alphaThreshold, FLOAT32);
				_endElement(); // Prop list
				
				// TODO: Add shading methods here
				
				_beginElement(); // Attr list
				_endElement(); // Attr list
				
				_endElement(); // Block
				
				_blockCache[mtl] = _blockId;
			}
			else if (mtl is ColorMaterial) {
				var cmtl : ColorMaterial;
				
				cmtl = ColorMaterial(mtl);
				
				if (cmtl.normalMap){					
					if (!_blockCache[cmtl.normalMap])
						_encodeTexture(cmtl.normalMap);
				}
				_encodeBlockHeader(81);
				_beginElement(); // Block
				
				_body.writeUTF(mtl.name);
				_body.writeByte(1);
				
				// TODO: Implement shading methods
				_body.writeByte(0);
				
				// Property list
				_beginElement(); // Prop list
				_encodeProperty(1, cmtl.color, COLOR);
				if (cmtl.normalMap){
					_encodeProperty(3, _blockCache[cmtl.normalMap], BADDR);					
				}
				_encodeProperty(10, cmtl.alpha, FLOAT32);
				_encodeProperty(11, cmtl.alphaBlending, BOOL);
				_encodeProperty(12, cmtl.alphaThreshold, FLOAT32);
				_endElement(); // Prop list
				
				// TODO: Add shading methods here
				
				_beginElement(); // Attr list
				_endElement(); // Attr list
				
				_endElement(); // Block
				
				_blockCache[mtl] = _blockId;
			}
		}
		
		private function _encodeContainer3D(container : ObjectContainer3D) : void
		{
			
			var i : uint;
			var parentId : uint;
			
			parentId = 0;
			if (container.parent)
				parentId = _blockCache[container.parent];
			
			_encodeBlockHeader(22);
			_beginElement(); // Block
			
			_body.writeUnsignedInt(parentId);
			_encodeMatrix3D(container.transform);
			_body.writeUTF(container.name);
			
			
			_beginElement(); // Prop list
			_endElement(); // Prop list
			_beginElement(); // Attr list
			_endElement(); // Attr list
			
			_endElement(); // Block
			
			_blockCache[container] = _blockId;
		}
		
		
		private function _encodeMesh(mesh : Mesh) : void
		{
			var i : uint;
			var geomId : uint;
			var parentId : uint;
			var materialIds : Vector.<uint>;
			var hasSubMaterials : Boolean;
			
			trace('encoding mesh');
			
			if (!_blockCache[mesh.geometry])
				_encodeGeometry(mesh.geometry);
			geomId = _blockCache[mesh.geometry];
			
			for (i=0; i<mesh.subMeshes.length; i++) {
				if (mesh.subMeshes[i].material != mesh.material) {
					hasSubMaterials = true;
					break;
				}
			}
			
			materialIds = new Vector.<uint>();
			if (hasSubMaterials) {
				for (i=0; i<mesh.subMeshes.length; i++) {
					var sub : SubMesh = mesh.subMeshes[i];
					if (!_blockCache[sub.material])
						_encodeMaterial(sub.material);
					
					materialIds[i] = _blockCache[sub.material];
				}
			}
			else if (mesh.material) {
				if (!_blockCache[mesh.material])
					_encodeMaterial(mesh.material);
				
				materialIds[0] = _blockCache[mesh.material];
			}
			else {
				materialIds[0] = 0;
			}
			
			parentId = 0;
			if (mesh.parent)
				parentId = _blockCache[mesh.parent];
			
			_encodeBlockHeader(23);
			_beginElement(); // Block
			
			_body.writeUnsignedInt(parentId);
			_encodeMatrix3D(mesh.transform);
			_body.writeUTF(mesh.name);
			_body.writeUnsignedInt(geomId);
			
			_body.writeShort(materialIds.length);
			for (i=0; i<materialIds.length; i++) {
				_body.writeUnsignedInt(materialIds[i]);
			}
			
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