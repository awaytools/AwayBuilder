package awaybuilder.utils.encoders
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.core.base.ISubGeometry;
	import away3d.core.base.SkinnedSubGeometry;
	import away3d.core.base.SubMesh;
	import away3d.core.math.MathConsts;
	import away3d.core.math.Matrix3DUtils;
	import away3d.entities.Mesh;
	import away3d.entities.TextureProjector;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.lights.PointLight;
	import away3d.lights.shadowmaps.CascadeShadowMapper;
	import away3d.lights.shadowmaps.CubeMapShadowMapper;
	import away3d.lights.shadowmaps.DirectionalShadowMapper;
	import away3d.lights.shadowmaps.NearDirectionalShadowMapper;
	import away3d.lights.shadowmaps.ShadowMapperBase;
	import away3d.materials.ColorMaterial;
	import away3d.materials.ColorMultiPassMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.MultiPassMaterialBase;
	import away3d.materials.SinglePassMaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.TextureMultiPassMaterial;
	import away3d.materials.lightpickers.LightPickerBase;
	import away3d.materials.methods.*;
	import away3d.materials.methods.ShadingMethodBase;
	import away3d.materials.utils.DefaultMaterialManager;
	import away3d.primitives.CapsuleGeometry;
	import away3d.primitives.ConeGeometry;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.CylinderGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.PrimitiveBase;
	import away3d.primitives.SkyBox;
	import away3d.primitives.SphereGeometry;
	import away3d.primitives.TorusGeometry;
	import away3d.primitives.WireframePrimitiveBase;
	import away3d.textures.BitmapTexture;
	import away3d.textures.CubeTextureBase;
	import away3d.textures.Texture2DBase;
	import away3d.textures.TextureProxyBase;
	
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.vo.ScenegraphGroupItemVO;
	import awaybuilder.model.vo.ScenegraphItemVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.CubeTextureVO;
	import awaybuilder.model.vo.scene.EffectMethodVO;
	import awaybuilder.model.vo.scene.GeometryVO;
	import awaybuilder.model.vo.scene.LightPickerVO;
	import awaybuilder.model.vo.scene.LightVO;
	import awaybuilder.model.vo.scene.MaterialBaseVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.model.vo.scene.ObjectVO;
	import awaybuilder.model.vo.scene.ShadingMethodVO;
	import awaybuilder.model.vo.scene.ShadowMapperVO;
	import awaybuilder.model.vo.scene.ShadowMethodVO;
	import awaybuilder.model.vo.scene.SubGeometryVO;
	import awaybuilder.model.vo.scene.SubMeshVO;
	import awaybuilder.model.vo.scene.TextureVO;
	import awaybuilder.view.scene.controls.ContainerGizmo3D;
	
	import com.adobe.images.PNGEncoder;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.JPEGEncoderOptions;
	import flash.display.PNGEncoderOptions;
	import flash.display3D.textures.TextureBase;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix3D;
	import flash.geom.Orientation3D;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	import mx.collections.ArrayCollection;
	import mx.core.Container;
	import mx.graphics.codec.JPEGEncoder;

	// to do: check if any imports can be removed
	
	
	public class AWDEncoder implements ISceneGraphEncoder
	{
		// set debug to true to get some traces in the console
		private var _debug:Boolean=false;
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
		
		private static const AWD_FIELD_MTX4x4 : uint = 47;
		
		private var blendModeDic:Dictionary;
		
		private var _exportNormals:Boolean=true;
		private var _exportTangents:Boolean=false;
		private var _streaming:Boolean=false;
		private var _compression:uint=0; //1:
		private var _geomStoragePrecision:Boolean=false; 
		private var _matrixStoragePrecision:Boolean=false; 
		private var _embedtextures:Boolean=true; 
		
		
		
		public function AWDEncoder()
		{
			super();
			_blockCache = new Dictionary();
			_elemSizeOffsets = new Vector.<uint>();
			// to do: check if this blendModeDic works for all blendMode-strings in the Scene
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
		
		// this function is called from the app...
		public function encode(document : DocumentModel, output : ByteArray) : Boolean
		{
			
			_body = new ByteArray();
			_body.endian = Endian.LITTLE_ENDIAN;
			_blockId = 0;
			
			// to do: implement Encoder-options.
			// atm - the AWDEncoder will not make use of any options. 
			// I will add this as soon as the Encoder works stabil with default-settings.	
			/*
			_streaming=document.globalOptions.streaming	
			_compression=document.globalOptions.compression	
			_embedtextures=document.globalOptions.embedTextures
			_geomStoragePrecision=document.globalOptions.geometryStorage	
			_matrixStoragePrecision=document.globalOptions.matrixStorage
			_exportNormals=document.globalOptions.includeNormal	
			_exportTangents=document.globalOptions.includeTangent	
			*/
			
			if(_debug)trace("start encoding");
			
			//create a AWDBlock class for all supported Assets
			_createAwdBlocks(document.textures);
			_createAwdBlocks(document.methods);
			_createAwdBlocks(document.lights);
			_createAwdBlocks(document.materials);
			_createAwdBlocks(document.geometry);
			// to do: add export of Animations
			
			// recursive encode all Scene-graph objects (ObjectContainer3d / Mesh) and their dependencies
			var scene:ArrayCollection = document.scene;
			for each ( var vo:AssetVO in scene )
			{
				// type check is done in :encodeChild funtion...
				_encodeChild(vo);
				
			}
			
			//_encode all supported Assets that are not encodet yet
			_encodeAddionalBlocks(document.textures);
			_encodeAddionalBlocks(document.methods);
			_encodeAddionalBlocks(document.lights);
			_encodeAddionalBlocks(document.materials);
			_encodeAddionalBlocks(document.geometry);
			// to do: add export of Animations
			
			// Header
			output.endian = Endian.LITTLE_ENDIAN;
			output.writeUTFBytes("AWD");//MagicString
			output.writeByte(2);//versionNumber
			output.writeByte(1);//RevisionNumber
			output.writeShort(0);//flags //accuracy etc
			output.writeByte(1); // ZLIB //compression (to do)			
			_body.compress();
			output.writeUnsignedInt(_body.length);
			output.writeBytes(_body);
			
			_finalize();
			
			if(_debug)trace("SUCCESS");
			return true;
		}
		
		// encodes all assets in a ArrayCollection, if they have not allready been _encodet
		private function _encodeAddionalBlocks(assetList:ArrayCollection) : void
		{			
			for each ( var asset:AssetVO in assetList )
			{
				if (asset.isDefault)return;
				switch(true){
					case (asset is TextureVO):
					case (asset is CubeTextureVO):
					case (asset is ShadowMethodVO):
					case (asset is EffectMethodVO):
					case (asset is ShadingMethodVO):
					case (asset is LightVO):
					case (asset is LightPickerVO):
					case (asset is MaterialVO):
					case (asset is GeometryVO):
						var newId:uint=_getBlockIDorEncodeAsset(asset);
						if (_debug)trace("addional Block: = "+asset.name+" / id = "+newId);
						break;
				}	
				
			}
		}
		// creates AWDBlocks for a list of Assets
		private function _createAwdBlocks(assetList:ArrayCollection) : void
		{
			for each ( var asset:AssetVO in assetList )
			{
				if (asset.isDefault)return;
				switch(true){
					case (asset is TextureVO):
					case (asset is CubeTextureVO):
					case (asset is ShadowMethodVO):
					case (asset is EffectMethodVO):
					case (asset is ShadingMethodVO):
					case (asset is LightVO):
					case (asset is LightPickerVO):
					case (asset is MaterialVO):
					case (asset is GeometryVO):
						var newBlock:AWDBlock=new AWDBlock();
						_blockCache[asset]=newBlock;
						break;
				}	
				
			}
		}
		
		// gets the AWDBlock-ID for a Asset. Blocks that have not been encoded will get encoded here		
		private function _getBlockIDorEncodeAsset(asset:AssetVO) : uint
		{
			if (!asset){
				if(_debug)trace("assetNotFound");
				return 0;
			}
			if (asset.isDefault){
				if(_debug)trace("AssetisDefault");
				return 0;
			}
			var thisBlock:AWDBlock=_blockCache[asset];
			if (!thisBlock){
				thisBlock=new AWDBlock();
				_blockCache[asset]=thisBlock;
			}
			if (thisBlock.id>=0)return thisBlock.id;
			var returnID:uint=0;
			switch(true){
				case (asset is TextureVO):
					returnID=_encodeTexture(TextureVO(asset));
					if(_debug)trace("encoded texture = "+asset.name);
					break;
				case (asset is CubeTextureVO):
					returnID=_encodeCubeTextures(CubeTextureVO(asset));
					if(_debug)trace("encoded cubeTexture = "+asset.name);
					break;
				case (asset is ShadowMethodVO):
					returnID=_encodeShadowMethod(ShadowMethodVO(asset));
					if(_debug)trace("start encoding ShadowMethodVO = "+asset.name);
					break;
				case (asset is EffectMethodVO):
					returnID=_encodeEffectMethod(EffectMethodVO(asset));
					if(_debug)trace("start encoding EffectMethodVO = "+asset.name);
					break;
				case (asset is LightVO):
					returnID=_encodeLight(LightVO(asset));
					if(_debug)trace("start encoding LIGHT = "+asset.name);
					break;
				case (asset is LightPickerVO):
					returnID=_encodeLightPicker(LightPickerVO(asset));
					if(_debug)trace("start encoding LightPicker = "+asset.name);
					break;
				case (asset is MaterialVO):
					returnID=_encodeMaterial(MaterialVO(asset));
					if(_debug)trace("start encoding Material = "+asset.name);
					break;
				case (asset is GeometryVO):
					returnID=_encodeGeometry(GeometryVO(asset));
					if(_debug)trace("start encoding Geometry = "+asset.name);
					break;
				default:
					if(_debug)trace("unknown asset");
					break;
			}
			thisBlock.id=returnID;
			return returnID;
		}
		// recursive function to encode all scene-graph objects
		private function _encodeChild(vo : AssetVO, parentID:uint = 0) : void
		{
			var thisBlock:AWDBlock=new AWDBlock();
			var newParentID:uint=0;
			switch (true){
				case (vo is MeshVO):
					
					if(_debug)trace("MeshVO = "+MeshVO(vo).name+" parentID = "+parentID);
					_blockCache[vo]=thisBlock;
					newParentID=_encodeMesh(MeshVO(vo),parentID);
					thisBlock.id=newParentID;
					break;
				case (vo is ContainerVO):
					_blockCache[vo]=thisBlock;
					if(_debug)trace("ContainerVO = "+ContainerVO(vo).name+" parentID = "+parentID);
					newParentID=_encodeContainer3D(ContainerVO(vo),parentID);
					thisBlock.id=newParentID;
					break;
				default:
					if(_debug)trace("try to export unknown type of Asset");
			}
			// if this is a Container, we recursivly encode the childs too:
			if (vo is ContainerVO){
				var child : ContainerVO;
				for each (child in ContainerVO(vo).children) {
					_encodeChild(child as ContainerVO,newParentID);
				}
			}
			
		}	
		
		
		
		
		// encode Geometry (id=1)
		private function _encodeGeometry(geom : GeometryVO) : uint
		{	
			var sub:SubGeometryVO;
			var returnID:uint;
			returnID=_encodeBlockHeader(1);
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
				_encodeStream(2, sub.indexData);
				_encodeStream(3, sub.UVData, sub.UVOffset, sub.UVStride);
				if (_exportNormals)	_encodeStream(4, sub.vertexNormalData, sub.vertexNormalOffset, sub.vertexNormalStride);
				if (_exportTangents) _encodeStream(5, sub.vertexTangentData, sub.vertexTangentOffset, sub.vertexTangentStride);
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
			
			return returnID;
		}
		
		
		
		// encode Mesh (id=22)
		private function _encodeContainer3D(container : ContainerVO, parentId:uint=0) : uint
		{
			
			var i : uint;
			var parentId : uint;
			var returnID:uint=_encodeBlockHeader(22);
			_beginElement(); // Block
			
			_body.writeUnsignedInt(parentId);
			_encodeMatrix3D(getTransformMatrix(container));
			_body.writeUTF(container.name);
			// to do: add encoding of pivot.x/.y/.z + visibility + userData
			
			_beginElement(); // Prop list
			_endElement(); // Prop list
			_beginElement(); // Attr list
			_endElement(); // Attr list
			
			_endElement(); // Block
			
			return returnID;
		}
		
		
		// encode Mesh (id=23)
		private function _encodeMesh(mesh : MeshVO, parentId:uint=0) : uint
		{
			var i : uint;
			var geomId : uint;
			var materialIds : Vector.<uint>;
			var returnID:uint;
			// for this function to work, we need MeshVO.material and MeshVO.geometry
			
			geomId = _getBlockIDorEncodeAsset(mesh.geometry);
			materialIds=new Vector.<uint>;
			var subMeshVo:SubMeshVO;
			for each (subMeshVo in mesh.subMeshes) {
				materialIds.push( _getBlockIDorEncodeAsset(subMeshVo.material));
			}
						
			returnID=_encodeBlockHeader(23);
			_beginElement(); // Block
			
			_body.writeUnsignedInt(parentId);
			_encodeMatrix3D(getTransformMatrix(mesh));
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
			
			return returnID;
			
		}
		
		
		// encode LightBlock (id=41)
		private function _encodeLight(light:LightVO) : uint
		{
			var returnID:int;
			var k:int;
			var parentId:int = 0;
			var lightType:uint=1;
			var radius:Number;
			var fallOff:Number;
			
			
			// if the lights will be part of the sceneGraph, we will need to get its parentID 		
			
			
			var shadowMethodsIDs:Vector.<uint>=new Vector.<uint>;
			var shadowMethodsDics:Dictionary=new Dictionary(); // use Dictionary to make shure we do not list a Method twice (Composite-Methods)
			for each (var shadowMethVo:AssetVO in light.shadowMethods){
				var newMethodID:uint=_getBlockIDorEncodeAsset(shadowMethVo);
				if(!shadowMethodsDics[newMethodID.toString()]){
					shadowMethodsIDs.push(newMethodID)
					shadowMethodsDics[newMethodID.toString()]=0;					
				}				
			}
			var methodLength:uint=shadowMethodsIDs.length;
			if(light.shadowMapper)methodLength+=1;
			
			
			returnID=_encodeBlockHeader(41);
			_beginElement(); // Block
			_body.writeUnsignedInt(parentId);//parent		
			_encodeMatrix3D(getTransformMatrix(light));//matrix
			_body.writeUTF(light.name);//name
			
			if (light.type==LightVO.POINT){
				if(_debug)trace("start encode PointLight = "+light.name);
				if(light.radius!=90000)	radius=light.radius;
				if(light.fallOff!=100000)	fallOff=light.fallOff;
			}
			if (light.type==LightVO.DIRECTIONAL){
				if(_debug)trace("start encode DirectionalLight = "+light.name);	
				lightType=2;
			}					
			
			_body.writeByte(lightType);	//lightType	
			_body.writeByte(methodLength);	//num of ShadowMethods	
			
			_beginElement(); // prop list			
			if(radius){_encodeProperty(1,radius, FLOAT32);}//radius
			if(fallOff){_encodeProperty(2,fallOff, FLOAT32);}//fallOff
			if(light.color!=0xffffff){_encodeProperty(3,light.color, COLOR);}//color
			if(light.specular!=1){_encodeProperty(4,light.specular, FLOAT32);}//specular
			if(light.diffuse!=1){_encodeProperty(5,light.diffuse, FLOAT32);}//diffuse
			if(light.castsShadows!=false){_encodeProperty(6,light.castsShadows, BOOL);}//castsShadows
			if(light.ambientColor!=0xffffff){_encodeProperty(7,light.ambientColor, COLOR);}//ambientColor
			if(light.ambient!=0){_encodeProperty(8,light.ambient, FLOAT32);}//color
			_endElement(); // prop list
			// to do: encode shadowMapper and list of ShadowMethods				
			
			if(light.shadowMapper)_encodeShadowMapper(light.shadowMapper);//shadowMapper is not encoded as a own Block, but included as a method;
			for (var i:int=0;i<shadowMethodsIDs.length;i++){
				_encodeMethod(999, [1130] , [shadowMethodsIDs[i]], [0], [BADDR]);
			}		
			
			_beginElement(); // Attr list
			_endElement(); // Attr list
			
			_endElement(); // Block
			
			if(_debug)trace("light = "+light.name + " has been encoded successfully.");	
			return returnID;
		}
		
		// encode LightPicker (id=51)
		private function _encodeLightPicker(_lp :LightPickerVO) : uint
		{
			var returnID:uint;
			var lightIDs:Vector.<int>=new Vector.<int>;
			var k:int;
			for each(var lightAssetVO:AssetVO in _lp.lights){
				lightIDs.push(_getBlockIDorEncodeAsset(lightAssetVO));
			}			
			
			returnID=_encodeBlockHeader(51);
			_beginElement(); // Block
			
			_body.writeUTF(_lp.name);
			_body.writeShort(_lp.lights.length);	//num of lights
			for (k=0;k<_lp.lights.length;k++){	
				_body.writeUnsignedInt(lightIDs[k]);	//light-ids
			}
			
			_beginElement(); // Attr list
			_endElement(); // Attr list
			
			_endElement(); // Block
			
			return returnID;
		}
		
		// encode TextureBlock (id=82)
		private function _encodeTexture(tex:TextureVO) : uint
		{
			var returnID:uint=_encodeBlockHeader(82);
			_beginElement(); // Block			
			_body.writeUTF(tex.name);
			
			var ba : ByteArray = _encodeBitmap(tex.bitmapData);	
			_body.writeByte(1);
			_body.writeUnsignedInt(ba.length);
			_body.writeBytes(ba);
			
			_beginElement(); // Properties (empty)
			_endElement(); // Properties
			
			_beginElement(); // Attributes (empty)
			_endElement(); // Attributes
			
			_endElement(); // Block
			
			if(_debug)trace("texture = "+tex.name + " has been encoded successfully!");
			return returnID;
			
		}
		
		// encode TextureBlock (id=83)
		private function _encodeCubeTextures(cubeTexture:CubeTextureVO) : uint
		{
			var id_posX : ByteArray = _encodeBitmap(cubeTexture.positiveX);	
			var id_negX : ByteArray = _encodeBitmap(cubeTexture.negativeX);	
			var id_posY : ByteArray = _encodeBitmap(cubeTexture.positiveY);	
			var id_negY : ByteArray = _encodeBitmap(cubeTexture.negativeY);	
			var id_posZ : ByteArray = _encodeBitmap(cubeTexture.positiveZ);	
			var id_negZ : ByteArray = _encodeBitmap(cubeTexture.negativeZ);	
			
			var returnID:uint = _encodeBlockHeader(83);
			_beginElement(); // Block	
			
			// write all encodedBitMaps into the file
			_body.writeUTF(cubeTexture.name);
			_body.writeUnsignedInt(id_posX.length);
			_body.writeBytes(id_posX);
			_body.writeUnsignedInt(id_negX.length);
			_body.writeBytes(id_negX);
			_body.writeUnsignedInt(id_posY.length);
			_body.writeBytes(id_posY);
			_body.writeUnsignedInt(id_negY.length);
			_body.writeBytes(id_negY);
			_body.writeUnsignedInt(id_posZ.length);
			_body.writeBytes(id_posZ);
			_body.writeUnsignedInt(id_negZ.length);
			_body.writeBytes(id_negZ);
			
			
			_beginElement(); // Properties (empty)
			_endElement(); // Properties
			
			_beginElement(); // Attributes (empty)
			_endElement(); // Attributes
			
			_endElement(); // Block
			
			
			if(_debug)trace("cubeTexture = "+cubeTexture.name + " has been encoded successfully!");
			return returnID;
		}
		
		// encodes a materialBlock (id=81)
		private function _encodeMaterial(mtl :MaterialVO) : uint
		{
			var returnID:uint;
			// properties:
			var matType:int=1;			
			
			// optional properties:
			var color:uint;//1
			var texture:int;//2
			var normalTexture:int;//3
			var spezialType:uint;//4
			var smooth:Boolean=true;//5
			var mipmap:Boolean=true;//6
			var bothSides:Boolean=false;//7
			var alphaPremultiplied:Boolean=false;//8
			var blendMode:uint;//9
			var alpha:Number;//10
			var alphaBlending:Boolean=false;//11
			var alphaThreshold:Number;//12
			var repeat:Boolean=true;//13
			//var diffuse-Level:Number;//14
			var ambient:uint;//15
			var ambientColor:uint;//16
			var ambientTexture:int;//17
			var specular:Number;//18
			var gloss:Number;//19
			var specularColor:uint;//20
			var specularTexture:uint;//21
			var lightPicker:int;//22
			
			var allMethods:Vector.<AWDmethod>=_encodeAllShadingMethods(mtl);
			
			if (mtl.diffuseTexture) texture=_getBlockIDorEncodeAsset(mtl.diffuseTexture);
			if (mtl.ambientTexture) ambientTexture=_getBlockIDorEncodeAsset(mtl.ambientTexture);	
			if ((texture)||(ambientTexture)) matType=2;			
			if (matType==1) color=mtl.diffuseColor;			
			if (mtl.type==MaterialVO.SINGLEPASS){
				if (mtl.alpha!=1.0)	alpha=mtl.alpha;
				if (mtl.alphaBlending!=false) alphaBlending=mtl.alphaBlending;
			}
			else{
				spezialType=1;
			}
			
			if (mtl.alphaThreshold!=Number(0.0)) alphaThreshold=mtl.alphaThreshold;
			if (mtl.ambientLevel!=Number(1.0)) ambient=mtl.ambientLevel;
			if (mtl.ambientColor!=uint(0xffffff)) ambientColor=mtl.ambientColor;	
			if (mtl.specularLevel!=Number(1.0))	specular=mtl.specularLevel;	
			if (mtl.specularGloss!=Number(50)) gloss=mtl.specularGloss;	
			if (mtl.specularColor!=uint(0xffffff)) specularColor=mtl.specularColor;	
			if (mtl.normalTexture)	normalTexture=_getBlockIDorEncodeAsset(mtl.normalTexture);
			if (mtl.specularTexture)	specularTexture=_getBlockIDorEncodeAsset(mtl.specularTexture);
			
			if (mtl.lightPicker){
				if(_debug)trace("lightPicker");
				if (_getBlockIDorEncodeAsset(mtl.lightPicker)!=0)	lightPicker=_getBlockIDorEncodeAsset(mtl.lightPicker);
			}
			
			smooth=mtl.smooth;
			mipmap=mtl.mipmap;
			bothSides=mtl.bothSides;
			repeat=mtl.repeat;
			alphaPremultiplied=mtl.alphaPremultiplied;		
			var thisBlendMode:uint=blendModeDic[mtl.blendMode];
			if ((thisBlendMode!=1)&&(thisBlendMode!=2)&&(thisBlendMode!=8)&&(thisBlendMode!=10))	thisBlendMode=0;
			if (thisBlendMode>0)	blendMode=thisBlendMode;
			
			
			//write down the material as awdblock 
			
			returnID=_encodeBlockHeader(81);
			_beginElement(); // Block
			
			_body.writeUTF(mtl.name);
			_body.writeByte(matType);	//materialType			
			_body.writeByte(allMethods.length); //num of methods
			
			// Property list
			_beginElement(); // Prop list
			if (color){	_encodeProperty(1,color, COLOR);}//color
			if (texture){_encodeProperty(2,texture, BADDR);}//texture
			if (normalTexture){_encodeProperty(3,normalTexture, BADDR);}//normalMap 
			if (spezialType){_encodeProperty(4,spezialType, UINT8);}// multi/singlepass	
			if (smooth==false){_encodeProperty(5, smooth, BOOL);} // smooth
			if (mipmap==false){_encodeProperty(6, mipmap, BOOL);} // mipmap
			if (bothSides==true){_encodeProperty(7, bothSides, BOOL);} // bothsides
			if (alphaPremultiplied==true){_encodeProperty(8, alphaPremultiplied, BOOL);} // pre-multiplied				
			if (blendMode){_encodeProperty(9, blendMode, UINT8);} // BlendMode
			if (alpha){_encodeProperty(10, alpha, FLOAT32);}// alpha
			if (alphaBlending==true){_encodeProperty(11, alphaBlending, BOOL);}// alphaBlending
			if (alphaThreshold){_encodeProperty(12, alphaThreshold, FLOAT32);}// alphaThreshold
			if (repeat==false){_encodeProperty(13, repeat, BOOL);}// repeat
			//if (diffuse){_encodeProperty(14, diffuse, FLOAT32);}// diffuse-level (might come in later version)
			if (ambient){_encodeProperty(15, ambient, FLOAT32);}// ambient-level
			if (ambientColor){_encodeProperty(16, ambientColor, COLOR);}// ambient-color
			if (ambientTexture){_encodeProperty(17, ambientTexture, BADDR);}//ambientMap 		
			if (specular){_encodeProperty(18, specular, FLOAT32);}// specular-level
			//if (gloss){_encodeProperty(19, gloss, FLOAT32);}// specular-gloss !!! gloss doesnt seam to work in awayBuilder atm, so i do not export for now
			if (specularColor){_encodeProperty(20, specularColor, COLOR);}// specular-color
			if (specularTexture){_encodeProperty(21, specularTexture, BADDR);}//specularMap 
			if (lightPicker){_encodeProperty(22, lightPicker, BADDR);}//lightPicker
			_endElement(); // Prop list			
			
			// _encode all previous stored methods.
			for (var i:int=0;i<allMethods.length;i++){
				if(_debug)trace("allMethods[i]._id "+allMethods[i]._id);
				_encodeMethod(allMethods[i]._id,allMethods[i]._ids,allMethods[i]._values,allMethods[i]._defaultValues , allMethods[i]._types);
			}
			
			
			_beginElement(); // Attr list
			_endElement(); // Attr list
			
			_endElement(); // Block
			
			return returnID;
		}
		
		
		
		// creates a new SharedBlock for a ShadowMethod.
		private function _encodeShadowMethod(methVO:ShadowMethodVO) : uint
		{
			var returnID:uint=0;
			var baseID:uint;
			switch(methVO.type)
			{ 				
				case ShadowMethodVO.FILTERED_SHADOW_MAP_METHOD:		
					returnID=_encodeSharedMethodBlock(methVO.name, 1101, [3,1114], [methVO.alpha,methVO.epsilon], [1,0.002], [FLOAT32,FLOAT32]);			
					break;	
				case ShadowMethodVO.DITHERED_SHADOW_MAP_METHOD:	
					returnID=_encodeSharedMethodBlock(methVO.name, 1102, [3,1114,1127,1119], [methVO.alpha,methVO.epsilon,methVO.samples, methVO.range], [1,0.002,5,1], [FLOAT32,FLOAT32,UINT32,FLOAT32]);				
					break;
				case ShadowMethodVO.SOFT_SHADOW_MAP_METHOD:		
					returnID=_encodeSharedMethodBlock(methVO.name,1103, [3,1114,1127,1119], [methVO.alpha,methVO.epsilon,methVO.samples, methVO.range], [1,0.002,5,1], [FLOAT32,FLOAT32,UINT32,FLOAT32]);				
					break;
				case ShadowMethodVO.HARD_SHADOW_MAP_METHOD:		
					returnID=_encodeSharedMethodBlock(methVO.name,1104, [3,1114], [methVO.alpha,methVO.epsilon], [1,0.002], [FLOAT32,FLOAT32]);			
					break;	
				case ShadowMethodVO.CASCADE_SHADOW_MAP_METHOD:		
					baseID=_getBlockIDorEncodeAsset(methVO.baseMethod);// get id for baseMethod (encode BaseMethod if not allready)
					returnID=_encodeSharedMethodBlock(methVO.name,1001, [1130], [baseID], [0], [BADDR]);
					break;
				case ShadowMethodVO.NEAR_SHADOW_MAP_METHOD:		
					baseID=_getBlockIDorEncodeAsset(methVO.baseMethod);// get id for baseMethod (encode BaseMethod if not allready)
					returnID=_encodeSharedMethodBlock(methVO.name,1002, [1130], [baseID], [0], [BADDR]);
					break;
			}	
			return returnID;
		}
		
		
		
		
		private function _encodeEffectMethod(methVO:EffectMethodVO) : uint
		{
			var returnID:uint=0;
			var cubeTexID:uint;
			var texID:uint;
			var texProjectorID:uint;
			if(_debug)trace("methVO.type = "+methVO.type);
			switch(methVO.type)
			{ 
				case "ColorMatrixMethod"://EffectMethodVO.COLOR_MATRIX:
					var colorMatrixAsVector:Vector.<Number>= new Vector.<Number>;// to do: fill this vector with the colorTransform
					var colorMatrixAsVectorDefault:Vector.<Number>= new Vector.<Number>;// to do: fill this vector with the default ColorTranform
					returnID=_encodeSharedMethodBlock(methVO.name,401, [1001], [colorMatrixAsVector], [colorMatrixAsVectorDefault], [FLOAT32]);
					break;
				case "ColorTransformMethod"://EffectMethodVO.COLOR_TRANSFORM:
					var offSetColor:uint= methVO.aO << 24 | methVO.rO << 16 | methVO.gO << 8 | methVO.bO;
					returnID=_encodeSharedMethodBlock(methVO.name,402, [1101,1102,1103,1104,1105], [methVO.a,methVO.r,methVO.g,methVO.b,offSetColor], [1,1,1,1,0x00000000], [FLOAT32,FLOAT32,FLOAT32,FLOAT32,COLOR]);
					break;
				case "EnvMapMethod"://EffectMethodVO.ENV_MAP:
					cubeTexID=_getBlockIDorEncodeAsset(methVO.cubeTexture);
					texID=_getBlockIDorEncodeAsset(methVO.texture);
					returnID=_encodeSharedMethodBlock(methVO.name,403, [101,3,1146], [cubeTexID,methVO.alpha,texID], [0,1,0], [BADDR,FLOAT32,BADDR]);
					break;
				case "LightMapMethod"://EffectMethodVO.LIGHT_MAP:
					texID=_getBlockIDorEncodeAsset(methVO.texture);
					returnID=_encodeSharedMethodBlock(methVO.name,404, [1124,100], [methVO.mode,texID], [10,0], [UINT8,BADDR]);
					break;
				//case EffectMethodVO.PROJECTIVE_TEXTURE:
				//texProjectorID=_getBlockIDorEncodeAsset(methVO.textureProjector);
				//returnID=_encodeSharedMethodBlock(methVO.name,405, [1124,102], [methVO.mode,texProjectorID], [10,0], [UINT8,BADDR]);
				//break;
				case "RimLightMethod"://EffectMethodVO.RIM_LIGHT:
					returnID=_encodeSharedMethodBlock(methVO.name,406, [1,1107,1106], [methVO.color,methVO.strength,methVO.power], [0xffffff,0.4,2], [COLOR,FLOAT32,FLOAT32]);
					break;
				case "AlphaMaskMethod"://EffectMethodVO.ALPHA_MASK:
					texID=_getBlockIDorEncodeAsset(methVO.texture);
					returnID=_encodeSharedMethodBlock(methVO.name,407, [203,100], [methVO.useSecondaryUV,texID], [false,0], [BOOL,BADDR]);
					break;
				case "RefractionMapMethod"://EffectMethodVO.REFRACTION_ENV_MAP:
					returnID=_encodeSharedMethodBlock(methVO.name,408, [101,1129,1111,1143,1144,3], [methVO.cubeTexture,methVO.refraction,methVO.r,methVO.g,methVO.b,methVO.alpha], [0,0.1,0.01,0.01,0.01,1], [BADDR,FLOAT32,FLOAT32,FLOAT32,FLOAT32,FLOAT32]);
					break;
				case "OutlineMethod"://EffectMethodVO.OUTLINE:
					returnID=_encodeSharedMethodBlock(methVO.name,409, [2,1121,202,201], [methVO.color,methVO.size,methVO.showInnerLines, methVO.dedicatedMesh], [0x00000000,1,true,false], [COLOR,FLOAT32,BOOL,BOOL]);
					break;
				case "FresnelEnvMapoMethod"://EffectMethodVO.FRESNEL_ENV_MAP:
					returnID=_encodeSharedMethodBlock(methVO.name,410, [101,3], [methVO.cubeTexture,methVO.alpha], [2048,1], [0,1]);
					break;
				case "FogMethod"://EffectMethodVO.FOG:
					returnID=_encodeSharedMethodBlock(methVO.name,411, [1122,1145,1], [methVO.minDistance,methVO.maxDistance, methVO.color], [0,1000,0x808080], [FLOAT32,FLOAT32,COLOR]);
					break;
				//EffectMethodVO.FRESNEL_PLANAR_REFLECTION
				//EffectMethodVO.PLANAR_REFLECTION
			}	
			return returnID;
		}
		
		// Creates a SharedMethod-AWDBlock	(id=91) - all dependencies have allready been created !			
		private function _encodeSharedMethodBlock(name:String, id:int, idsVec : Array, valuesAr : Array, defaultValuesAr : Array, typesVec : Array) : uint
		{
			
			var returnID:uint=_encodeBlockHeader(91);
			_beginElement(); // Block			
			_body.writeUTF(name);			
			
			_encodeMethod( id, idsVec, valuesAr, defaultValuesAr, typesVec);
			
			_beginElement(); // Attributes (empty)
			_endElement(); // Attributes
			
			_endElement(); // Block
			
			if(_debug)trace("SharedMethod = "+ name + " has been encoded successfully!");
			return returnID
		}
		
		// encode the ShadowMapper as single method
		private function _encodeShadowMapper(mapperVO:ShadowMapperVO) : void
		{
			
			switch(mapperVO.type){ 
				case "NearDirectionalShadowMapper":
					_encodeMethod(1502, [1125,1120], [mapperVO.depthMapSize,mapperVO.coverage], [2048,0.5], [UINT8,FLOAT32]);
					break;
				case "DirectionalShadowMappe":
					_encodeMethod(1501, [1125], [mapperVO.depthMapSize], [2048], [UINT8]);
					break;
				case "CascadeShadowMapper":
					_encodeMethod(1503, [1125,1128], [mapperVO.depthMapSize,mapperVO.numCascades], [2048,3], [UINT8,UINT32]);
					break;
				case "CubeMapShadowMapper":
					_encodeMethod(1504, [1125], [mapperVO.depthMapSize], [2048], [UINT8]);
					break;
			}
		}
		
		
		
		
		
		// create the DiffuseMethod as a AWDMethod (if its not the BasicDiffuseMethod)
		private function _encodeDiffuseMethod(diffuseMethVO:ShadingMethodVO, materialMethods:Vector.<AWDmethod>) : void
		{
			if(_debug)trace("diffuseMethVO = "+diffuseMethVO.type);
			var texID:uint;
			switch(diffuseMethVO.type){ 
				
				case "LightMapDiffuseMethod":
					_encodeDiffuseMethod(diffuseMethVO.baseMethod,materialMethods);
					var lightMapBlendMode1:uint=blendModeDic[diffuseMethVO.blendMode];
					if ((lightMapBlendMode1!=1)&&(lightMapBlendMode1!=10))lightMapBlendMode1=10;
					texID=_getBlockIDorEncodeAsset(diffuseMethVO.texture);
					materialMethods.push(new AWDmethod(54, [1124,105], [ lightMapBlendMode1, texID], [10], [UINT8,BADDR]));
					break;
				case "CelDiffuseMethod":
					_encodeDiffuseMethod(diffuseMethVO.baseMethod,materialMethods);
					materialMethods.push(new AWDmethod(55, [1123,1117], ["diffuseMethVO.levels", diffuseMethVO.smoothness], [], [UINT8,FLOAT32]));
					break;
				case "SubsurfaceScatteringDiffuseMethod":
					_encodeDiffuseMethod(diffuseMethVO.baseMethod,materialMethods);
					materialMethods.push(new AWDmethod(56, [1140,1141,1142], [diffuseMethVO.scattering,diffuseMethVO.translucency,diffuseMethVO.scatterColor], [0.2,1,0xffffff], [FLOAT32,FLOAT32,COLOR]));
					break;
				case "WrapDiffuseMethod":
					// to do: figured out which parameter of the ShadingMethodVO represents the "wrapFactor" !!!
					materialMethods.push(new AWDmethod(53, [1118], ["diffuseMethVO.wrapFactor"], [0.5], [FLOAT32]));
					break;
				case "DepthDiffuseMethod":
					materialMethods.push(new AWDmethod(51, [], [], [], []));
					break;
				case "GradientDiffuseMethod":
					texID=_getBlockIDorEncodeAsset(diffuseMethVO.texture);
					materialMethods.push(new AWDmethod(52, [104], [texID], [0], [BADDR]));
					break;
			}
			
		}
		
		private function _encodeSpecularMethod(speculareMethVO:ShadingMethodVO, materialMethods:Vector.<AWDmethod>) : void
		{
			if(_debug)trace("speculareMethVO = "+speculareMethVO.type);
			switch(speculareMethVO.type){ 
				case "CelSpecularMethod":	
					_encodeSpecularMethod(speculareMethVO.baseMethod,materialMethods);
					materialMethods.push(new AWDmethod(103, [1115,1117], [speculareMethVO.value, speculareMethVO.smoothness], [0.5,0.1], [FLOAT32,FLOAT32]));
					break;
				case "FresnelSpecularMethod":	
					_encodeSpecularMethod(speculareMethVO.baseMethod,materialMethods);
					// to do: speculareMethVO.normalPower is not mapped
					materialMethods.push(new AWDmethod(104, [204,1106,1113], [speculareMethVO.basedOnSurface, speculareMethVO.fresnelPower,"speculareMethVO.normalPower"], [true,0.5,0.1], [BOOL,FLOAT32,FLOAT32]));
					break;
				case "AnisotropicSpecularMethod":	
					materialMethods.push(new AWDmethod(101, [], [], [], []));
					break;
				case "PhongSpecularMethod":	
					materialMethods.push(new AWDmethod(102, [], [], [], []));
					break;
			}
		}
		
		private function _encodeAmbientMethod(ambientMethVO:ShadingMethodVO,materialMethods:Vector.<AWDmethod>) : void
		{
			if(_debug)trace("ambientMethVO = "+ambientMethVO.type);
			switch(ambientMethVO.type){ 
				case "EnvMapAmbientMethod":
					materialMethods.push(new AWDmethod(1, [101], [ambientMethVO.envMap], [0], [BADDR]));
					break;
			}
		}
		
		private function _encodeNormalMethod(normalMethVO:ShadingMethodVO, materialMethods:Vector.<AWDmethod>) : void
		{
			if(_debug)trace("normalMethVO = "+normalMethVO.type);
			switch(normalMethVO.type){ 
				/*case "HeightMapNormalMethod":
				//var worldSize:Vector3D=HeightMapNormalMethod(normalMeth).worldSize;
				//materialMethods.push(new AWDmethod(151, [1108,1109,1110], [worldSize.x, worldSize.y,worldSize.z], [5,5,5], [FLOAT32,FLOAT32,FLOAT32]));
				break;*/
				case "SimpleWaterNormalMethod":
					materialMethods.push(new AWDmethod(152, [103], [normalMethVO.texture], [0], [BADDR]));
					break;
			}
		}
		
		private function _encodeAllShadingMethods(mat:MaterialVO) : Vector.<AWDmethod>
		{
			var materialMethods:Vector.<AWDmethod>=new Vector.<AWDmethod>;
			
			//_encodeDiffuseMethod(mat.diffuseMethod,materialMethods);
			//_encodeSpecularMethod(mat.specularMethod,materialMethods);
			//_encodeAmbientMethod(mat.ambientMethod,materialMethods);
			//_encodeNormalMethod(mat.normalMethod,materialMethods);
			
			if (mat.shadowMethod)materialMethods.push(new AWDmethod(999, [1130], [_getBlockIDorEncodeAsset(mat.shadowMethod)], [0], [BADDR]));
			for each (var effectMethVO:EffectMethodVO in mat.effectMethods){
				materialMethods.push(new AWDmethod(999, [1130], [_getBlockIDorEncodeAsset(effectMethVO)], [0], [BADDR]));// to do - check the correct id for a "shared methdod block"-method 
			}
			return materialMethods;
		}
		
		
		private function _encodeMethod(id:int, idsVec : Array, valuesAr : Array, defaultValuesAr : Array, typesVec : Array) : void
		{
			//store ID
			
			if ((valuesAr.length!=typesVec.length)||(idsVec.length!=typesVec.length)){
				if(_debug) trace("error in Method encoding !!! method id = "+id);
				return 
			}
			
			_body.writeShort(id);//method type 
			_beginElement(); // start prop list
			var i:int=0;
			for (i=0;i< idsVec.length;i++){
				// we only store the property if it is not the default-value 
				if (defaultValuesAr[i]!=valuesAr[i]){
					_encodeProperty(idsVec[i],valuesAr[i], typesVec[i]);
				}
			}
			_endElement(); // end prop list
			
			_beginElement(); // start prop list
			_endElement(); // end prop list
			
		}
		
		
		// to do: add the skyBox encode
		private function _encodeSkyBoxBlock(_skyBox:Object) : void
		{
			// we need SkyBoxVO to use this function
			//_encodeBlockHeader(31);
		}
		private function _encodePrimitiveBlock(_primitive:Object) : void
		{
			// we nee PrimitivesVOs, to use this function
			/*
			_encodeBlockHeader(11);
			_beginElement(); // Block
			var materialMethods:Vector.<AWDmethod>=new Vector.<AWDmethod>;
			switch(true){ 
			case(_primitive is PlaneGeometry):
			var _plane:PlaneGeometry=PlaneGeometry(_primitive)
			materialMethods.push([1,2,7,8,12], [_plane.width,_plane.height,_plane.segmentsW,_plane.segmentsH,_plane.yUp], [100,100,1,1,true], [FLOAT32,FLOAT32,UINT16,UINT16,BOOL]);
			break;
			case(_primitive is CubeGeometry):
			var _cube:CubeGeometry=CubeGeometry(_primitive)
			materialMethods.push([1,2,3,7,8,9,12], [_cube.width,_cube.height,_cube.depth,_cube.segmentsW,_cube.segmentsH,_cube.segmentsD,_cube.tile6], [100,100,100,1,1,1,true], [FLOAT32,FLOAT32,FLOAT32,UINT16,UINT16,UINT16,BOOL]);	
			break;
			
			case(_primitive is SphereGeometry):
			var _sphere:SphereGeometry=SphereGeometry(_primitive)
			materialMethods.push([4,7,8,12], [_sphere.radius,_sphere.segmentsW,_sphere.segmentsH,_sphere.yUp], [50,16,12,true], [FLOAT32,UINT16,UINT16,BOOL]);
			break;
			case(_primitive is CylinderGeometry):
			//var _cylinder:CylinderGeometry=CylinderGeometry(_primitive)
			//materialMethods.push([2,4,5,6,7,8,10,11,12], [_sphere.radius,_sphere.segmentsW,_sphere.segmentsH], [50,16,12,true], [FLOAT32,UINT16,UINT16,BOOL]));
			case(_primitive is ConeGeometry):
			var _sphere:SphereGeometry=SphereGeometry(_primitive)
			materialMethods.push([4,7,8,12], [_sphere.radius,_sphere.segmentsW,_sphere.segmentsH], [50,16,12,true], [FLOAT32,UINT16,UINT16,BOOL]);
			materialMethods.push(new AWDmethod(101, [], [], [], []));
			break;
			case(_primitive is CapsuleGeometry):
			materialMethods.push(new AWDmethod(102, [], [], [], []));
			case(_primitive is TorusGeometry):
			materialMethods.push(new AWDmethod(102, [], [], [], []));
			break;
			}
			
			_beginElement(); // Attr list
			_endElement(); // Attr list
			
			_endElement(); // Block
			
			*/
		}
		private function _encodeTextureProjectorBlock(_texProjector:Object) : void
		{
			// we nee TextureprojectorVO, to use this function
			_encodeBlockHeader(43);
			//needs to be done
		}
		private function _encodeCameraBlock(_cam:Object) : void
		{
			// we nee CamerasVO, to use this function
			_encodeBlockHeader(42);
			//needs to be done
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
		
		// to do: check if this is accutal the correct way to get the objects matrix, using the given ObjectVO-properties.	
		// to do: research about info from mike: use static myMatrixCompose( params):Matrix 
		private function getTransformMatrix(Asset:ObjectVO) : Matrix3D
		{			
			var transformMatrix:Matrix3D=new Matrix3D();
			var vectorComps:Vector.<Vector3D>=new Vector.<Vector3D>();
			vectorComps.push(new Vector3D(Asset.x,Asset.y,Asset.z));
			vectorComps.push(new Vector3D(Asset.rotationX * MathConsts.DEGREES_TO_RADIANS,Asset.rotationY* MathConsts.DEGREES_TO_RADIANS,Asset.rotationZ* MathConsts.DEGREES_TO_RADIANS));
			vectorComps.push(new Vector3D(Asset.scaleX,Asset.scaleY,Asset.scaleZ));
			transformMatrix.recompose(vectorComps);//,Orientation3D.AXIS_ANGLE);
			return transformMatrix;
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
		
		// encodes a Bitmap into a ByteArray - if the Bitmap contains transparent Pixel, its encodet to PNG, otherwise it is encodet to JPG
		private function _encodeBitmap(bitMap:BitmapData):ByteArray
		{			
			var usePNG : Boolean;	
			var ba : ByteArray;	
			usePNG=bitMapHasTransparency(bitMap,bitMap.rect.width,bitMap.rect.height);
			ba = new ByteArray();
			if (usePNG){
				bitMap.encode(bitMap.rect, new PNGEncoderOptions(), ba);
			}
				
			else {
				bitMap.encode(bitMap.rect, new JPEGEncoderOptions(80), ba);
			}	
			return ba;
		}
		
		
		public function dispose() : void
		{
			_blockCache = null;
		}
		
		private function _encodeBlockHeader(type : uint) : uint
		{
			_blockId++;
			_body.writeUnsignedInt(_blockId);
			_body.writeByte(0);
			_body.writeByte(type);
			_body.writeByte(0);
			return _blockId;
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
		
		
		//checks if a transparent pixel was found in the bitmap (use PNG vs JPG)
		private function bitMapHasTransparency(bmd:BitmapData,w:Number,h:Number):Boolean {
			
			var i:int;
			var j:int;
			
			for(i=0;i<w;i++) for(j=0;j<h;j++) if(bmd.getPixel32(i, j) == 0) return true;
			
			return false;
			
		}
		
		
		
	}
}





/*

General Helper Classes 

*/



internal class AWDBlock
{
	public var id : int;
	public function AWDBlock() {
		id=-1;
	} 
	
	
}
internal class AWDmethod
{
	public var _id : uint;
	public var _ids : Array;
	public var _values: Array;
	public var _defaultValues: Array;
	public var _types: Array;
	public function AWDmethod(id : uint,ids : Array,values: Array,defaultValues: Array,types:Array) {
		
		_id=id;
		_ids=ids;
		_values=values;
		_defaultValues=defaultValues;
		_types=types;
	} 
}
/*

internal dynamic class AWDProperties
{
public function set(key : uint, value : *) : void
{
this[key.toString()] = value;
}

public function get(key : uint, fallback : *) : *
{
if (this.hasOwnProperty(key.toString()))
return this[key.toString()];
else return fallback;
}
}


*/