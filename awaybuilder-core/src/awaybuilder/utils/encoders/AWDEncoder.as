package awaybuilder.utils.encoders
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.core.base.ISubGeometry;
	import away3d.core.base.SkinnedSubGeometry;
	import away3d.core.base.SubMesh;
	import away3d.entities.Mesh;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.ColorMultiPassMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.MultiPassMaterialBase;
	import away3d.materials.SinglePassMaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.TextureMultiPassMaterial;
	import away3d.materials.lightpickers.LightPickerBase;
	import away3d.materials.utils.DefaultMaterialManager;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PrimitiveBase;
	import away3d.textures.BitmapTexture;
	import away3d.textures.Texture2DBase;
	import away3d.textures.TextureProxyBase;
	
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.ScenegraphGroupItemVO;
	import awaybuilder.model.vo.ScenegraphItemVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.LightPickerVO;
	import awaybuilder.model.vo.scene.LightVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.utils.AssetFactory;
	
	import com.adobe.images.PNGEncoder;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.JPEGEncoderOptions;
	import flash.display.PNGEncoderOptions;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
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
		private static const FLOAT32 : uint = 7;
		private static const FLOAT64 : uint = 8;
		private static const BOOL : uint = 21;
		private static const COLOR : uint = 22;
		private static const BADDR : uint = 23;
		
		
		//public static const AWD_FIELD_STRING : uint = 31;
		//public static const AWD_FIELD_BYTEARRAY : uint = 32;
		
		//public static const AWD_FIELD_VECTOR2x1 : uint = 41;
		//public static const AWD_FIELD_VECTOR3x1 : uint = 42;
		//public static const AWD_FIELD_VECTOR4x1 : uint = 43;
		//public static const AWD_FIELD_MTX3x2 : uint = 44;
		//public static const AWD_FIELD_MTX3x3 : uint = 45;
		//public static const AWD_FIELD_MTX4x3 : uint = 46;
		//public static const AWD_FIELD_MTX4x4 : uint = 47;
		
		private var blendModeDic:Dictionary;
		
		public function AWDEncoder()
		{
			super();
			BlendMode.NORMAL
			_blockCache = new Dictionary();
			_elemSizeOffsets = new Vector.<uint>();
			blendModeDic=new Dictionary();
			blendModeDic[BlendMode.NORMAL]=0;
			blendModeDic[BlendMode.ADD]=1;
			blendModeDic[BlendMode.ALPHA]=2;
			blendModeDic[BlendMode.DARKEN]=3;
			blendModeDic[BlendMode.DIFFERENCE]=4;
			blendModeDic[BlendMode.ERASE]=5;
			blendModeDic[BlendMode.HARDLIGHT]=6;
			blendModeDic[BlendMode.INVERT]=7;
			blendModeDic[BlendMode.LAYER]=8;
			blendModeDic[BlendMode.LIGHTEN]=9;
			blendModeDic[BlendMode.MULTIPLY]=10;
			blendModeDic[BlendMode.NORMAL]=11;
			blendModeDic[BlendMode.OVERLAY]=12;
			blendModeDic[BlendMode.SCREEN]=13;
			blendModeDic[BlendMode.SHADER]=14;
			blendModeDic[BlendMode.OVERLAY]=15;
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
			output.writeUTFBytes("AWD");//MagicString
			output.writeByte(0);//versionNumber
			output.writeByte(0);//RevisionNumber
			output.writeShort(0);//flags
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
				case BOOL:
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
			
			size = _body.position - (offs);
			if (size) {
				size-=4;
				//trace('size was ', size);
				_body.position = offs;
				_body.writeUnsignedInt(size);
				_body.position = _body.length;
			}
		}
		
		private function _encodeChild(vo : ContainerVO) : void
		{
			if (vo is MeshVO) {
				_encodeMesh(AssetFactory.GetObject(vo) as Mesh);	
			}
				
			else if (vo is ContainerVO) {
				_encodeContainer3D(AssetFactory.GetObject(vo) as ObjectContainer3D);
			}
			
			var child : ContainerVO;
			for each (child in vo.children) {
					_encodeChild(child as ContainerVO);
			}
		}
		
		
		private function _encodeTexture(tex : Texture2DBase) : void
		{
			if (tex is BitmapTexture) {
				var ba : ByteArray;
				var btex : BitmapTexture;
				var usePNG : Boolean;
				
				btex = BitmapTexture(tex);
				
				_encodeBlockHeader(82);
				_beginElement(); // Block
				
				_body.writeUTF(tex.name);
				
				// TODO: Check whether to embed or use external textures,
				// depending on some app-specific configuration
				ba = new ByteArray();
				usePNG=bitMapHasTransparency(btex.bitmapData,btex.bitmapData.rect.width,btex.bitmapData.rect.height);
				if (usePNG){
					//ba = PNGEncoder.encode( btex.bitmapData );
					btex.bitmapData.encode(btex.bitmapData.rect, new PNGEncoderOptions(), ba);}
				else {
					btex.bitmapData.encode(btex.bitmapData.rect, new JPEGEncoderOptions(100), ba);}
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
		private function bitMapHasTransparency(bmd:BitmapData,w:Number,h:Number):Boolean {
						
			var i:int;
			var j:int;
			
			for(i=0;i<w;i++) for(j=0;j<h;j++) if(bmd.getPixel32(i, j) == 0) return true;
			
			return false;
			
		}
		private function _encodeMaterial(mtl : MaterialBase) : void
		{
			//this vars will have allways have to be exported (since they are block-properties)
			var matType:int=1;			
			
			var color:uint;//1
			var texture:int;//2
			var normalTexture:int;//3
			var isSingle:Boolean=true;//4
			var smooth:Boolean=true;//5
			var mipmap:Boolean=true;//6
			var bothSides:Boolean=false;//7
			var alphaPremultiplied:Boolean=false;//8
			var blendMode:uint;//9
			var alpha:Number;//10
			var alphaBlending:Boolean=true;//11
			var alphaThreshold:Number;//12
			var repeat:Boolean=false;//13
			//var diffuse-Level:Number;//14
			var ambient:uint;//15
			var ambientColor:uint;//16
			var ambientTexture:int;//17
			var specular:Number;//18
			var gloss:Number;//19
			var specularColor:uint;//20
			var specularTexture:uint;//21
			var lightPicker:int;//22
			
			
			// ColorMaterial
			if ((mtl is ColorMaterial) || (mtl is ColorMultiPassMaterial)) {
				matType=1;
				if (mtl is ColorMaterial) {
					color=ColorMaterial(mtl).color;
					if (ColorMaterial(mtl).alpha!=Number(1.0)){
						alpha=ColorMaterial(mtl).alpha;}
					}
				if (mtl is ColorMultiPassMaterial) {
					color=ColorMultiPassMaterial(mtl).color;}
				
			}
			// TextureMaterial
			if ((mtl is TextureMaterial) || (mtl is TextureMultiPassMaterial)) {
				matType=2;
				if (mtl is TextureMaterial) {
					if (!_blockCache[TextureMaterial(mtl).texture]){
						_encodeTexture(TextureMaterial(mtl).texture);}	
					texture=_blockCache[TextureMaterial(mtl).texture];
					if (TextureMaterial(mtl).ambientTexture!=null){
						if (!_blockCache[TextureMaterial(mtl).ambientTexture]){
							_encodeTexture(TextureMaterial(mtl).ambientTexture);}	
						ambientTexture=_blockCache[TextureMaterial(mtl).ambientTexture];}
					if (TextureMaterial(mtl).alpha!=Number(1.0)){		alpha=TextureMaterial(mtl).alpha;	}
				}
				if (mtl is TextureMultiPassMaterial) {
					if (!_blockCache[TextureMultiPassMaterial(mtl).texture]){
						_encodeTexture(TextureMultiPassMaterial(mtl).texture);}	
					texture=_blockCache[TextureMultiPassMaterial(mtl).texture];
					if (TextureMultiPassMaterial(mtl).ambientTexture!=null){
						if (!_blockCache[TextureMultiPassMaterial(mtl).ambientTexture]){
							_encodeTexture(TextureMultiPassMaterial(mtl).ambientTexture);}	
						ambientTexture=_blockCache[TextureMultiPassMaterial(mtl).ambientTexture];}
				}
			}
			// SinglePassMaterial
			if (mtl is SinglePassMaterialBase){				
				if (SinglePassMaterialBase(mtl).alphaThreshold!=Number(0.0)){	alphaThreshold=SinglePassMaterialBase(mtl).alphaThreshold;	}
				if (SinglePassMaterialBase(mtl).ambient!=Number(0.0)){	ambient=SinglePassMaterialBase(mtl).ambient;	}
				if (SinglePassMaterialBase(mtl).ambientColor!=uint(0xffffff)){	ambientColor=SinglePassMaterialBase(mtl).ambientColor;	}
				if (SinglePassMaterialBase(mtl).specular!=Number(1.0)){	specular=SinglePassMaterialBase(mtl).specular;	}
				if (SinglePassMaterialBase(mtl).gloss!=Number(50)){	gloss=SinglePassMaterialBase(mtl).gloss;	}
				if (SinglePassMaterialBase(mtl).specularColor!=uint(0xffffff)){	specularColor=SinglePassMaterialBase(mtl).specularColor;	}
				
				if (SinglePassMaterialBase(mtl).alphaBlending!=false){	alphaBlending=SinglePassMaterialBase(mtl).alphaBlending;	}
				
				//NormalMap for SinglePassMaterial
				if (SinglePassMaterialBase(mtl).normalMap){				
					if (!_blockCache[SinglePassMaterialBase(mtl).normalMap]){
						_encodeTexture(SinglePassMaterialBase(mtl).normalMap);}
					normalTexture=_blockCache[SinglePassMaterialBase(mtl).normalMap];}
				//SpecularMap for SinglePassMaterial
				if (SinglePassMaterialBase(mtl).specularMap){				
					if (!_blockCache[SinglePassMaterialBase(mtl).specularMap]){
						_encodeTexture(SinglePassMaterialBase(mtl).specularMap);}
					specularTexture=_blockCache[SinglePassMaterialBase(mtl).specularMap];}
			}	
			
			// MultiPassMaterial
			if (mtl is MultiPassMaterialBase){
				isSingle=false;
				
				
				if (MultiPassMaterialBase(mtl).alphaThreshold!=Number(0.0)){	alphaThreshold=MultiPassMaterialBase(mtl).alphaThreshold;	}
				if (MultiPassMaterialBase(mtl).ambient!=Number(0.0)){	ambient=MultiPassMaterialBase(mtl).ambient;	}
				if (MultiPassMaterialBase(mtl).ambientColor!=uint(0xffffff)){	ambientColor=MultiPassMaterialBase(mtl).ambientColor;	}
				if (MultiPassMaterialBase(mtl).specular!=Number(1.0)){	specular=MultiPassMaterialBase(mtl).specular;	}
				if (MultiPassMaterialBase(mtl).gloss!=Number(50)){	gloss=MultiPassMaterialBase(mtl).gloss;	}
				if (MultiPassMaterialBase(mtl).specularColor!=uint(0xffffff)){	specularColor=MultiPassMaterialBase(mtl).specularColor;	}
				
				//NormalMap for MultiPassMaterial
				if (MultiPassMaterialBase(mtl).normalMap){				
					if (!_blockCache[MultiPassMaterialBase(mtl).normalMap]){
						_encodeTexture(MultiPassMaterialBase(mtl).normalMap);}
					normalTexture=_blockCache[MultiPassMaterialBase(mtl).normalMap];}
				//SpecularMap for MultiPassMaterial
				if (MultiPassMaterialBase(mtl).specularMap){				
					if (!_blockCache[MultiPassMaterialBase(mtl).specularMap]){
						_encodeTexture(MultiPassMaterialBase(mtl).specularMap);}
					specularTexture=_blockCache[MultiPassMaterialBase(mtl).specularMap];}
			}	
			
			//MaterialBase-Propeties
			
			if (mtl.lightPicker){
				//trace("mtl.lightPicker = "+mtl.lightPicker);
				if (!_blockCache[mtl.lightPicker]){
					_encodeLightPicker(mtl.lightPicker);	}
				lightPicker=_blockCache[mtl.lightPicker];	}
			if (mtl.smooth!=true){	smooth=false;	}
			if (mtl.mipmap!=true){	mipmap=false;	}
			if (mtl.bothSides!=false){bothSides=true;}
			if (mtl.alphaPremultiplied!=false){alphaPremultiplied=true;}			
			var thisBlendMode:uint=blendModeDic[mtl.blendMode];
			if ((thisBlendMode!=1)&&(thisBlendMode!=2)&&(thisBlendMode!=8)&&(thisBlendMode!=10)){
				thisBlendMode=0;
			}
			if (thisBlendMode>0){	blendMode=thisBlendMode;	}
			
					
			//write down the material as awdblock 
					
			_encodeBlockHeader(81);
			_beginElement(); // Block
			
			_body.writeUTF(mtl.name);
			_body.writeByte(matType);	//materialType			
			_body.writeByte(0); //num of methods
			
			// Property list
			_beginElement(); // Prop list
			if (color){	_encodeProperty(1,color, COLOR);}//color
			if (texture){_encodeProperty(2,texture, BADDR);}//texture
			if (normalTexture){_encodeProperty(3,normalTexture, BADDR);}//normalMap 
			if (isSingle==false){_encodeProperty(4,isSingle, BOOL);}// multi/singlepass	
			if (smooth==false){_encodeProperty(5, smooth, BOOL);} // smooth
			if (mipmap==false){_encodeProperty(6, mipmap, BOOL);} // mipmap
			if (bothSides==true){_encodeProperty(7, bothSides, BOOL);} // bothsides
			if (alphaPremultiplied==true){_encodeProperty(8, alphaPremultiplied, BOOL);} // pre-multiplied				
			if (blendMode){_encodeProperty(9, blendMode, UINT8);} // BlendMode
			if (alpha){_encodeProperty(10, alpha, FLOAT32);}// alpha
			if (alphaBlending==false){_encodeProperty(11, alphaBlending, BOOL);}// alphaBlending
			if (alphaThreshold){_encodeProperty(12, alphaThreshold, FLOAT32);}// alphaThreshold
			if (repeat==true){_encodeProperty(13, repeat, BOOL);}// repeat
			//if (diffuse){_encodeProperty(14, diffuse, FLOAT32);}// diffuse-level (might come in later version)
			if (ambient){_encodeProperty(15, ambient, FLOAT32);}// ambient-level
			if (ambientColor){_encodeProperty(16, ambientColor, COLOR);}// ambient-color
			if (ambientTexture){_encodeProperty(17, ambientTexture, BADDR);}//ambientMap (optional)				
			if (specular){_encodeProperty(18, specular, FLOAT32);}// specular-level
			if (gloss){_encodeProperty(19, gloss, FLOAT32);}// specular-gloss
			if (specularColor){_encodeProperty(20, specularColor, COLOR);}// specular-color
			if (specularTexture){_encodeProperty(21, specularTexture, BADDR);}//specularMap (optional)		
			if (lightPicker){_encodeProperty(22, lightPicker, BADDR);}//specularMap (optional)				
			_endElement(); // Prop list				
			// TODO: Add shading methods here
					
			_beginElement(); // Attr list
			_endElement(); // Attr list
				
			_endElement(); // Block
				
			_blockCache[mtl] = _blockId;	
					


		}
		
		private function _encodeLightPicker(_lp : LightPickerBase) : void
		{
			var lightIDs:Vector.<int>=new Vector.<int>;
			var k:int;
			
			for (k=0;k<_lp.allPickedLights.length;k++){		
				if (!_blockCache[_lp.allPickedLights[k]])
					_encodeLight(_lp.allPickedLights[k]);
				lightIDs.push(_blockCache[_lp.allPickedLights[k]]);
			}
			
			_encodeBlockHeader(51);
			_beginElement(); // Block
			
			_body.writeUTF(_lp.name);
			_body.writeShort(_lp.allPickedLights.length);	//num of lights
			for (k=0;k<_lp.allPickedLights.length;k++){	
				_body.writeUnsignedInt(lightIDs[k]);	//light-ids
				}
			
			_beginElement(); // Attr list
			_endElement(); // Attr list
			
			_endElement(); // Block
			
			_blockCache[_lp] = _blockId;
			
		}
		private function _encodeLight(_light : LightBase) : void
		{
			var k:int;
			var parentId:int = 0;
			var lightType:uint=1;
			var radius:Number;
			var fallOff:Number;
		//	if (_light.parent){
		//		if (_blockCache[_light.parent]){
		//			parentId = _blockCache[_light.parent];					
		//			}
		//		}			
			
			_encodeBlockHeader(41);
			_beginElement(); // Block
			_body.writeUnsignedInt(parentId);//parent	
			//var thisLight:LightBase=AssetFactory.GetObject(_light) as LightBase;		
			_encodeMatrix3D(_light.transform);//matrix
			_body.writeUTF(_light.name);//name
			
			
			if (_light is PointLight){
				if(PointLight(_light).radius!=90000){
					radius=PointLight(_light).radius;
				}
				if(PointLight(_light).fallOff!=100000){
					fallOff=PointLight(_light).fallOff;
				}
			}
			if (_light is DirectionalLight){
				lightType=2;
			}			
			//LightBase(thisLight).shadowMapper;
			_body.writeByte(lightType);	//lightType	
			
			_beginElement(); // prop list			
			if(radius){_encodeProperty(1,radius, FLOAT32);}//radius
			if(fallOff){_encodeProperty(2,fallOff, FLOAT32);}//fallOff
			if(_light.color!=0xffffff){_encodeProperty(3,_light.color, COLOR);}//color
			if(_light.specular!=1){_encodeProperty(4,_light.specular, FLOAT32);}//specular
			if(_light.diffuse!=1){_encodeProperty(5,_light.diffuse, FLOAT32);}//diffuse
			if(_light.castsShadows!=false){_encodeProperty(6,_light.castsShadows, BOOL);}//castsShadows
			if(_light.ambientColor!=0xffffff){_encodeProperty(7,_light.ambientColor, COLOR);}//ambientColor
			if(_light.ambient!=0){_encodeProperty(8,_light.ambient, FLOAT32);}//color
			_endElement(); // prop list
			
			_beginElement(); // Shadow list
			_endElement(); // Shadow list
			
			_beginElement(); // Attr list
			_endElement(); // Attr list
			
			_endElement(); // Block
			
			_blockCache[_light] = _blockId;
			
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
			
			//trace('encoding mesh');
			
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
			
			if (geom is PrimitiveBase){				
			}
			else {
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
					_encodeStream(4, sub.vertexNormalData, sub.vertexNormalOffset, sub.vertexNormalStride);
					/*if(sub is SkinnedSubGeometry){
						var skinnedSub:SkinnedSubGeometry= sub as SkinnedSubGeometry;
						_encodeStream(6, skinnedSub., sub.vertexNormalOffset, sub.vertexNormalStride);
						_encodeStream(7, sub.vertexNormalData, sub.vertexNormalOffset, sub.vertexNormalStride);
						
					}*/
					
					_endElement(); // Sub-geom
					
					_beginElement(); // User attr
					_endElement(); // User attr
				}
				
				_beginElement(); // User attr
				_endElement(); // User attr
				
				_endElement(); // Block
			}
			_blockCache[geom] = _blockId;
		}
		
		
		private function _encodeStream(type : uint, data : *, offset : uint = 0, stride : uint = 0) : void
		{
			_body.writeByte(type);
			
			switch (type) {
				case 4:
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