package awaybuilder.model
{
	import away3d.animators.AnimationSetBase;
	import away3d.animators.data.Skeleton;
	import away3d.animators.data.SkeletonPose;
	import away3d.animators.nodes.AnimationNodeBase;
	import away3d.animators.states.AnimationStateBase;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.core.base.ISubGeometry;
	import away3d.core.base.Object3D;
	import away3d.core.base.SubMesh;
	import away3d.entities.Entity;
	import away3d.entities.Mesh;
	import away3d.library.assets.NamedAssetBase;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.lights.PointLight;
	import away3d.lights.shadowmaps.CascadeShadowMapper;
	import away3d.lights.shadowmaps.NearDirectionalShadowMapper;
	import away3d.lights.shadowmaps.ShadowMapperBase;
	import away3d.materials.*;
	import away3d.materials.lightpickers.LightPickerBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.*;
	import away3d.materials.utils.DefaultMaterialManager;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.SkyBox;
	import away3d.primitives.SphereGeometry;
	import away3d.textures.BitmapCubeTexture;
	import away3d.textures.BitmapTexture;
	
	import awaybuilder.model.vo.scene.*;
	import awaybuilder.utils.AssetUtil;
	
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;


	public class SmartFactoryModelBase
	{
		
		public function GetAsset( obj:Object ):AssetVO
		{
			return null;
		}
		
		protected function createAsset( item:Object ):AssetVO
		{
			var asset:AssetVO;
			switch(true)
			{
				case(item is Mesh):
					return fillMesh( new MeshVO(), item as Mesh );
				case(item is LightBase):
					return fillLight( new LightVO(), item as LightBase  );
				case(item is SkyBox):
					return fillSkyBox( new SkyBoxVO(), item as SkyBox  );
				case(item is Entity):
				case(item is ObjectContainer3D):
					return fillContainer( new ContainerVO(), item as ObjectContainer3D );
				case(item is MaterialBase):
					return fillMaterial( new MaterialVO(), item as MaterialBase );
				case(item is BitmapTexture):
					return fillTexture( new TextureVO(), item as BitmapTexture );
				case(item is Geometry):
					return fillGeometry( new GeometryVO(), item as Geometry );
				case(item is ISubGeometry):
					return fillSubGeometry( new SubGeometryVO(), item as ISubGeometry );
				case(item is AnimationNodeBase):
					asset = fillAsset( new AnimationNodeVO(), item );
					return asset;
				case(item is AnimationSetBase):
					asset = fillAsset( new AnimationNodeVO(), item );
					asset.name = "Animation Set (" + item.name +")";
					return asset;
				case(item is AnimationStateBase):
					asset = fillAsset( new AnimationNodeVO(), item );
					asset.name = "Animation State (" + item.name +")";
					return asset;
				case(item is SkeletonPose):
					asset = fillAsset( new AnimationNodeVO(), item );
					asset.name = "Skeleton Pose (" + item.name +")";
					return asset;
				case(item is Skeleton):
					return fillAsset( new SkeletonVO(), item as Skeleton );
				case(item is ShadowMapMethodBase):
					return  fillShadowMethod( new ShadowMethodVO(), item as ShadowMapMethodBase );
				case(item is SubMesh):
					return fillSubMesh( new SubMeshVO(), item as SubMesh );
				case(item is EffectMethodBase):
					return fillEffectMethod( new EffectMethodVO(), item as EffectMethodBase );
				case(item is LightPickerBase):
					return fillLightPicker( new LightPickerVO(),  item as StaticLightPicker );
				case(item is BitmapCubeTexture):
					return fillCubeTexture( new CubeTextureVO(),  item as BitmapCubeTexture );
				case(item is ShadowMapperBase):
					return fillShadowMapper( new ShadowMapperVO(),  item as ShadowMapperBase );
				case(item is ShadingMethodBase):
					return fillShadingMethod( new ShadingMethodVO(),  item as ShadingMethodBase );
			}
			
			return null;
		}
		private function fillLightPicker( asset:LightPickerVO, item:StaticLightPicker ):LightPickerVO
		{
			asset = fillAsset( asset, item ) as LightPickerVO;
			asset.name = item.name;
			asset.lights = new ArrayCollection();
			for each( var light:LightBase in item.lights )
			{
				asset.lights.addItem( GetAsset( light ) );
			}
			return asset;
		}
		private function fillEffectMethod( asset:EffectMethodVO, item:EffectMethodBase ):EffectMethodVO
		{
			asset.type = getQualifiedClassName( item ).split("::")[1];
			asset.name = item.name;
			switch( true ) 
			{
				case(item is AlphaMaskMethod):
					var alphaMaskMethod:AlphaMaskMethod = item as AlphaMaskMethod;
					asset.texture = GetAsset(alphaMaskMethod.texture) as TextureVO;
					asset.useSecondaryUV = alphaMaskMethod.useSecondaryUV;
					break;
				case(item is ColorTransformMethod):
					var colorTransformMethod:ColorTransformMethod = item as ColorTransformMethod;
						asset.r = colorTransformMethod.colorTransform.redMultiplier;
						asset.g = colorTransformMethod.colorTransform.greenMultiplier;
						asset.b = colorTransformMethod.colorTransform.blueMultiplier;
						asset.a = colorTransformMethod.colorTransform.alphaMultiplier;
						asset.rO = colorTransformMethod.colorTransform.redOffset;
						asset.gO = colorTransformMethod.colorTransform.greenOffset;
						asset.bO = colorTransformMethod.colorTransform.blueOffset;
						asset.aO = colorTransformMethod.colorTransform.alphaOffset;
					break;
				case(item is ColorMatrixMethod):
				var colorMatrixMethod:ColorMatrixMethod = item as ColorMatrixMethod;
						asset.r = colorMatrixMethod.colorMatrix[0];
						asset.g = colorMatrixMethod.colorMatrix[1];
						asset.b = colorMatrixMethod.colorMatrix[2];
						asset.a = colorMatrixMethod.colorMatrix[3];
						asset.rG = colorMatrixMethod.colorMatrix[5];
						asset.gG = colorMatrixMethod.colorMatrix[6];
						asset.bG = colorMatrixMethod.colorMatrix[7];
						asset.aG = colorMatrixMethod.colorMatrix[8];
						asset.rB = colorMatrixMethod.colorMatrix[10];
						asset.gB = colorMatrixMethod.colorMatrix[11];
						asset.bB = colorMatrixMethod.colorMatrix[12];
						asset.aB = colorMatrixMethod.colorMatrix[13];
						asset.rA = colorMatrixMethod.colorMatrix[15];
						asset.gA = colorMatrixMethod.colorMatrix[16];
						asset.bA = colorMatrixMethod.colorMatrix[17];
						asset.aA = colorMatrixMethod.colorMatrix[18];
						asset.rO = colorMatrixMethod.colorMatrix[4];
						asset.gO = colorMatrixMethod.colorMatrix[9];
						asset.bO = colorMatrixMethod.colorMatrix[14];
						asset.aO = colorMatrixMethod.colorMatrix[19];
					break;
				case(item is EnvMapMethod):
					var envMapMethod:EnvMapMethod = item as EnvMapMethod;
					asset.cubeTexture = GetAsset(envMapMethod.envMap) as CubeTextureVO;
					asset.alpha = envMapMethod.alpha;
					asset.texture = GetAsset(envMapMethod.mask) as TextureVO;
					break;
				case(item is FogMethod):
				var fogMethod:FogMethod = item as FogMethod; 
					asset.color = fogMethod.fogColor;
					asset.minDistance = fogMethod.minDistance;
					asset.maxDistance = fogMethod.maxDistance;
					break;
				case(item is FresnelEnvMapMethod):
					var fresnelEnvMapMethod:FresnelEnvMapMethod = item as FresnelEnvMapMethod;
					asset.cubeTexture = GetAsset(fresnelEnvMapMethod.envMap) as CubeTextureVO;
					asset.power = fresnelEnvMapMethod.fresnelPower;
					asset.normalReflectance = fresnelEnvMapMethod.normalReflectance;
					asset.alpha = fresnelEnvMapMethod.alpha;
					asset.texture = GetAsset(fresnelEnvMapMethod.mask) as TextureVO;
					break;
				case(item is LightMapMethod):
					var lightMapMethod:LightMapMethod = item as LightMapMethod; 
					asset.texture = GetAsset(lightMapMethod.texture) as TextureVO;
					asset.mode = lightMapMethod.blendMode;
//					asset.useSecondaryUV = lightMapMethod.useSecondaryUV;
					break;
				case(item is OutlineMethod):
					var outlineMethod:OutlineMethod = item as OutlineMethod;
					asset.size = outlineMethod.outlineSize;
					asset.color = outlineMethod.outlineColor;
					asset.showInnerLines = outlineMethod.showInnerLines;
//					asset.dedicatedMesh = outlineMethod.dedicatedMesh;
					break;
				case(item is ProjectiveTextureMethod):
					var projectiveTextureMethod:ProjectiveTextureMethod = item as ProjectiveTextureMethod;
					asset.textureProjector = GetAsset( projectiveTextureMethod.projector ) as TextureProjectorVO;
					asset.mode = projectiveTextureMethod.mode;
					break;
				case(item is RefractionEnvMapMethod):
					var refractionEnvMapMethod:RefractionEnvMapMethod = item as RefractionEnvMapMethod; 
					asset.cubeTexture = GetAsset(refractionEnvMapMethod.envMap) as CubeTextureVO;
					asset.r = refractionEnvMapMethod.dispersionR;
					asset.g = refractionEnvMapMethod.dispersionG;
					asset.b = refractionEnvMapMethod.dispersionB;
					asset.alpha = refractionEnvMapMethod.alpha;
					asset.refraction = refractionEnvMapMethod.refractionIndex;
					break;
				case(item is RimLightMethod):
					var rimLightMethod:RimLightMethod = item as RimLightMethod;
					asset.color = RimLightMethod(item).color;
					asset.strength = RimLightMethod(item).strength;
					asset.power = RimLightMethod(item).power;
					break;
			}
			
			return asset;
		}
		private function fillSubMesh( asset:SubMeshVO, item:SubMesh ):SubMeshVO
		{
			asset.name = "SubMesh";
			asset.material = GetAsset( item.material ) as MaterialVO;
			asset.subGeometry = GetAsset( item.subGeometry ) as SubGeometryVO;
			return asset;
		}
		private function fillShadowMethod( asset:ShadowMethodVO, item:ShadowMapMethodBase ):ShadowMethodVO
		{
			asset = fillAsset( asset, item ) as ShadowMethodVO;
			asset.epsilon = item.epsilon;
			asset.alpha = item.alpha;
			asset.type = getQualifiedClassName( item ).split("::")[1];
			
			if( item is SoftShadowMapMethod )
			{
				var softShadowMapMethod:SoftShadowMapMethod = item as SoftShadowMapMethod;
				asset.samples = softShadowMapMethod.numSamples;
				asset.range = softShadowMapMethod.range;
			}
			else if( item is DitheredShadowMapMethod )
			{
				var ditheredShadowMapMethod:DitheredShadowMapMethod = item as DitheredShadowMapMethod;
				asset.samples = ditheredShadowMapMethod.numSamples;
				asset.range = ditheredShadowMapMethod.range;
			}
			else if( item is CascadeShadowMapMethod )
			{
				var cascadeShadowMapMethod:CascadeShadowMapMethod = item as CascadeShadowMapMethod;
				asset.baseMethod = GetAsset( cascadeShadowMapMethod.baseMethod ) as ShadowMethodVO;
			}
			else if( item is NearShadowMapMethod )
			{
				var nearShadowMapMethod:NearShadowMapMethod = item as NearShadowMapMethod;
//				asset.baseMethod = GetAsset( nearShadowMapMethod.baseMethod ) as ShadowMethodVO;
			}
			return asset;
		}
		
		private function fillSkyBox( asset:SkyBoxVO, obj:SkyBox ):SkyBoxVO
		{
			asset = fillAsset( asset, obj ) as SkyBoxVO;
			asset.cubeMap = GetAsset( SkyBoxMaterial(obj.material).cubeMap ) as CubeTextureVO;
			return asset;
		}
		private function fillLight( asset:LightVO, item:LightBase ):LightVO
		{
			asset = fillObject( asset, item ) as LightVO;
			asset.color = item.color;
			asset.ambientColor = item.ambientColor;
			asset.ambient = item.ambient;
			asset.diffuse = item.diffuse;
			
			asset.specular = item.specular;
			
			asset.castsShadows = item.castsShadows;
			
			asset.shadowMapper = GetAsset( item.shadowMapper ) as ShadowMapperVO;
			
			if( item is DirectionalLight ) 
			{
				var dl:DirectionalLight = DirectionalLight( item );
				dl.direction.normalize();
				asset.type = LightVO.DIRECTIONAL;
				
				asset.elevationAngle = Math.round(-Math.asin( dl.direction.y )*180/Math.PI);
				var a:Number = Math.atan2(dl.direction.x, dl.direction.z )*180/Math.PI;
				asset.azimuthAngle = Math.round(a<0?a+360:a);
			}
			else if( item is PointLight ) 
			{
				var pl:PointLight = PointLight( item );
				asset.type = LightVO.POINT;
				asset.radius = pl.radius;
				asset.fallOff = pl.fallOff;
			}
			return asset;
		}
		
		private function fillSubGeometry( asset:SubGeometryVO, item:ISubGeometry ):SubGeometryVO
		{
			asset = fillAsset( asset, item ) as SubGeometryVO;
			asset.vertexData = item.vertexData;
			asset.vertexOffset = item.vertexOffset;
			asset.vertexStride = item.vertexStride;
			asset.UVData = item.UVData;
			asset.UVStride = item.UVStride;
			asset.UVOffset = item.UVOffset;
			asset.vertexNormalData = item.vertexNormalData;
			asset.vertexNormalOffset = item.vertexNormalOffset;
			asset.vertexNormalStride = item.vertexNormalStride;
			asset.vertexTangentData = item.vertexTangentData;
			asset.vertexTangentOffset = item.vertexTangentOffset;
			asset.vertexTangentStride = item.vertexTangentStride;
			asset.indexData = item.indexData;
			return asset;
		}
		private function fillGeometry( asset:GeometryVO, obj:Geometry ):GeometryVO
		{
			asset = fillAsset( asset, obj ) as GeometryVO;
			asset.type = getQualifiedClassName( obj ).split("::")[1];
			asset.subGeometries = new ArrayCollection();
			for each( var sub:ISubGeometry in obj.subGeometries )
			{
				asset.subGeometries.addItem( GetAsset(sub) );
			}
			if( obj is CubeGeometry )
			{
				var cubeGeometry:CubeGeometry = obj as CubeGeometry;
				asset.width = cubeGeometry.width;
				asset.height = cubeGeometry.height;
				asset.depth = cubeGeometry.depth;
				asset.tile6 = cubeGeometry.tile6;
				asset.segmentsW = cubeGeometry.segmentsW;
				asset.segmentsH = cubeGeometry.segmentsH;
				asset.segmentsD = cubeGeometry.segmentsD;
			}
			else if( obj is SphereGeometry )
			{
				var sphereGeometry:SphereGeometry = obj as SphereGeometry;
				asset.radius = sphereGeometry.radius;
				asset.yUp = sphereGeometry.yUp;
				asset.segmentsW = sphereGeometry.segmentsW;
				asset.segmentsH = sphereGeometry.segmentsH;
			}
			return asset;
		}
		
		private function fillShadingMethod( asset:ShadingMethodVO, obj:ShadingMethodBase ):ShadingMethodVO
		{
			asset.type = getQualifiedClassName( obj ).split("::")[1];
			switch( true ) 
			{	
				case(obj is EnvMapAmbientMethod):
				{
					var envMapAmbientMethod:EnvMapAmbientMethod = obj as EnvMapAmbientMethod;
					asset.envMap = GetAsset( envMapAmbientMethod.envMap ) as CubeTextureVO;
					break;
				}
				case(obj is GradientDiffuseMethod):
				{
					var gradientDiffuseMethod:GradientDiffuseMethod = obj as GradientDiffuseMethod;
					asset.texture = GetAsset( gradientDiffuseMethod.gradient ) as TextureVO;
					break;
				}
				case(obj is WrapDiffuseMethod):
				{
					var wrapDiffuseMethod:WrapDiffuseMethod = obj as WrapDiffuseMethod;
					asset.value = wrapDiffuseMethod.wrapFactor;
					break;
				}
				case(obj is LightMapDiffuseMethod):
				{
					var lightMapDiffuseMethod:LightMapDiffuseMethod = obj as LightMapDiffuseMethod;
					asset.blendMode = lightMapDiffuseMethod.blendMode;
					asset.texture = GetAsset( lightMapDiffuseMethod.lightMapTexture ) as TextureVO;
					asset.baseMethod = GetAsset( lightMapDiffuseMethod.baseMethod ) as ShadingMethodVO;
					break;
				}
				case(obj is CelDiffuseMethod):
				{
					var celDiffuseMethod:CelDiffuseMethod = obj as CelDiffuseMethod;
					asset.value = celDiffuseMethod.levels;
					asset.smoothness = celDiffuseMethod.smoothness;
					asset.baseMethod = GetAsset( celDiffuseMethod.baseMethod ) as ShadingMethodVO;
					break;
				}
				case(obj is SubsurfaceScatteringDiffuseMethod):
				{
					var subsurfaceScatterDiffuseMethod:SubsurfaceScatteringDiffuseMethod = obj as SubsurfaceScatteringDiffuseMethod;
					asset.scattering = subsurfaceScatterDiffuseMethod.scattering;
					asset.translucency = subsurfaceScatterDiffuseMethod.translucency;
					asset.baseMethod = GetAsset( subsurfaceScatterDiffuseMethod.baseMethod ) as ShadingMethodVO;
					break;
				}
				case(obj is CelSpecularMethod):
				{
					var celSpecularMethod:CelSpecularMethod = obj as CelSpecularMethod;
					asset.value = celSpecularMethod.specularCutOff;
					asset.smoothness = celSpecularMethod.smoothness;
					asset.baseMethod = GetAsset( celSpecularMethod.baseMethod ) as ShadingMethodVO;
					break;
				}
				case(obj is FresnelSpecularMethod):
				{
					var fresnelSpecularMethod:FresnelSpecularMethod = obj as FresnelSpecularMethod;
					asset.basedOnSurface = fresnelSpecularMethod.basedOnSurface;
					asset.fresnelPower = fresnelSpecularMethod.fresnelPower;
					asset.value = fresnelSpecularMethod.normalReflectance;
					asset.baseMethod = GetAsset( fresnelSpecularMethod.baseMethod ) as ShadingMethodVO;
					break;
				}
				case(obj is HeightMapNormalMethod):
				{
					var heightMapNormalMethod:HeightMapNormalMethod = obj as HeightMapNormalMethod;
					break;
				}
				case(obj is SimpleWaterNormalMethod):
				{
					var simpleWaterNormalMethod:SimpleWaterNormalMethod = obj as SimpleWaterNormalMethod;
					asset.texture = GetAsset( simpleWaterNormalMethod.secondaryNormalMap ) as TextureVO;
					break;
				}
			}
					
			return asset;
		}
		private function fillShadowMapper( asset:ShadowMapperVO, obj:ShadowMapperBase ):ShadowMapperVO
		{
			asset.depthMapSize = obj.depthMapSize;
			asset.type = getQualifiedClassName( obj ).split("::")[1];
			if( obj is NearDirectionalShadowMapper )
			{
				var nearDirectionalShadowMapper:NearDirectionalShadowMapper = obj as NearDirectionalShadowMapper;
				asset.coverage = nearDirectionalShadowMapper.coverageRatio;
			}
			else if( obj is CascadeShadowMapper )
			{
				var cascadeShadowMapper:CascadeShadowMapper = obj as CascadeShadowMapper;
				asset.numCascades = cascadeShadowMapper.numCascades;
			}
			return asset;
		}
		private function fillCubeTexture( asset:CubeTextureVO, item:BitmapCubeTexture ):CubeTextureVO
		{
			asset = fillAsset( asset, item ) as CubeTextureVO;
			asset.positiveX = item.positiveX;
			asset.negativeX = item.negativeX;
			asset.positiveY = item.positiveY;
			asset.negativeY = item.negativeY;
			asset.positiveZ = item.positiveZ;
			asset.negativeZ = item.negativeZ;
			return asset;
		}
		private function fillTexture( asset:TextureVO, item:BitmapTexture ):TextureVO
		{
			asset = fillAsset( asset, item ) as TextureVO;
			asset.bitmapData = item.bitmapData;
			return asset;
		}
		private function fillMaterial( asset:MaterialVO, item:MaterialBase ):MaterialVO
		{
			asset = fillAsset( asset, item ) as MaterialVO;
			
			asset.alphaPremultiplied = item.alphaPremultiplied;
			
			asset.repeat = item.repeat;
			asset.bothSides = item.bothSides;
			asset.extra = item.extra;
			asset.lightPicker = GetAsset(item.lightPicker) as LightPickerVO;
			asset.mipmap = item.mipmap;
			asset.smooth = item.smooth;
			asset.blendMode = item.blendMode;
			
			if( item is TextureMaterial )
			{
				asset.type = MaterialVO.SINGLEPASS;
				var textureMaterial:TextureMaterial = item as TextureMaterial;
				asset.alphaThreshold = textureMaterial.alphaThreshold;
				asset.alpha = textureMaterial.alpha;
				
				asset.alphaBlending = textureMaterial.alphaBlending;
				asset.colorTransform = textureMaterial.colorTransform;
				
				asset.ambientLevel = textureMaterial.ambient; 
				asset.ambientColor = textureMaterial.ambientColor;
				asset.ambientTexture = GetAsset( textureMaterial.ambientTexture ) as TextureVO;
				asset.ambientMethod = GetAsset( textureMaterial.ambientMethod ) as ShadingMethodVO;
				
				asset.diffuseColor= textureMaterial.diffuseMethod.diffuseColor;
				asset.diffuseTexture = GetAsset( textureMaterial.texture ) as TextureVO;
				asset.diffuseMethod = GetAsset( textureMaterial.diffuseMethod ) as ShadingMethodVO;
				
				asset.specularLevel = textureMaterial.specular;
				asset.specularColor = textureMaterial.specularColor;
				asset.specularGloss = textureMaterial.gloss;
				asset.specularTexture = GetAsset( textureMaterial.specularMap ) as TextureVO;
				asset.specularMethod = GetAsset( textureMaterial.specularMethod ) as ShadingMethodVO;
				
				asset.normalTexture = GetAsset( textureMaterial.normalMap ) as TextureVO;
				asset.normalMethod = GetAsset( textureMaterial.normalMethod ) as ShadingMethodVO;
				
				asset.shadowMethod = GetAsset( textureMaterial.shadowMethod ) as ShadowMethodVO;
				
			}
			else if( item is ColorMaterial )
			{
				asset.type = MaterialVO.SINGLEPASS;
				var colorMaterial:ColorMaterial = item as ColorMaterial;
				asset.alpha = colorMaterial.alpha;
				asset.alphaThreshold = colorMaterial.alphaThreshold;
			}
			else if( item is TextureMultiPassMaterial )
			{
				asset.type = MaterialVO.MULTIPASS;
				var textureMultiPassMaterial:TextureMultiPassMaterial = item as TextureMultiPassMaterial;
				asset.alphaThreshold = textureMultiPassMaterial.alphaThreshold;
				asset.alphaBlending = textureMaterial.alphaBlending;
				asset.colorTransform = textureMaterial.colorTransform;
				
				asset.ambientLevel = textureMaterial.ambient; 
				asset.ambientColor = textureMaterial.ambientColor;
				asset.ambientTexture = GetAsset( textureMaterial.ambientTexture ) as TextureVO;
				asset.ambientMethod = GetAsset( textureMaterial.ambientMethod ) as ShadingMethodVO;
				
				asset.diffuseColor= textureMaterial.diffuseMethod.diffuseColor;
				asset.diffuseTexture = GetAsset( textureMaterial.texture ) as TextureVO;
				asset.diffuseMethod = GetAsset( textureMaterial.diffuseMethod ) as ShadingMethodVO;
				
				asset.specularLevel = textureMaterial.specular;
				asset.specularColor = textureMaterial.specularColor;
				asset.specularGloss = textureMaterial.gloss;
				asset.specularTexture = GetAsset( textureMaterial.specularMap ) as TextureVO;
				asset.specularMethod = GetAsset( textureMaterial.specularMethod ) as ShadingMethodVO;
				
				asset.normalTexture = GetAsset( textureMaterial.normalMap ) as TextureVO;
				asset.normalMethod = GetAsset( textureMaterial.normalMethod ) as ShadingMethodVO;
				
				asset.shadowMethod = GetAsset( textureMaterial.shadowMethod ) as ShadowMethodVO;
			}
			else if( item is ColorMultiPassMaterial )
			{
				asset.type = MaterialVO.MULTIPASS;
				var colorMultiPassMaterial:ColorMultiPassMaterial = item as ColorMultiPassMaterial;
				asset.alphaThreshold = colorMultiPassMaterial.alphaThreshold;
			}
			
			asset.effectMethods = new ArrayCollection();
			if( item is SinglePassMaterialBase )
			{
				var singlePassMaterialBase:SinglePassMaterialBase = item as SinglePassMaterialBase;
				asset.alphaThreshold = singlePassMaterialBase.alphaThreshold;
				for (var i:int = 0; i < singlePassMaterialBase.numMethods; i++) 
				{
					asset.effectMethods.addItem( GetAsset(singlePassMaterialBase.getMethodAt( i )) );
				}
			}
			return asset;
		}
		private function fillMesh( asset:MeshVO, item:Mesh ):MeshVO
		{
			asset = fillContainer( asset, item ) as MeshVO;
			asset.castsShadows = item.castsShadows;
			asset.subMeshes = new ArrayCollection();
			asset.geometry = GetAsset(item.geometry) as GeometryVO;
			for each( var subMesh:SubMesh in item.subMeshes )
			{
				var sm:SubMeshVO = GetAsset(subMesh) as SubMeshVO;
				sm.parentMesh = asset;
				asset.subMeshes.addItem( sm );
			}
			return asset;
		}
		private function fillContainer( asset:ContainerVO, item:ObjectContainer3D ):ContainerVO
		{
			asset = fillObject( asset, item ) as ContainerVO;
			asset.children = new ArrayCollection();
			
			for (var i:int = 0; i < item.numChildren; i++) 
			{
				asset.children.addItem(GetAsset( item.getChildAt(i) ) );
			}
			return asset;
		}
		private function fillObject( asset:ObjectVO, item:Object3D ):ObjectVO
		{
			asset = fillAsset( asset, item ) as ObjectVO;
			asset.x = item.x;
			asset.y = item.y;
			asset.z = item.z;
			asset.pivotX = item.pivotPoint.x;
			asset.pivotY = item.pivotPoint.y;
			asset.pivotZ = item.pivotPoint.z;
			asset.scaleX = item.scaleX;
			asset.scaleY = item.scaleY;
			asset.scaleZ = item.scaleZ;
			asset.rotationX = item.rotationX;
			asset.rotationY = item.rotationY;
			asset.rotationZ = item.rotationZ;
			
			asset.extras = new ArrayCollection();
			
			for( var name:String in item.extra )
			{
				var extra:ExtraItemVO = new ExtraItemVO();
				extra.name = name;
				extra.value = item.extra[name];
				asset.extras.addItem( extra );
			}
				
			return asset;
		}
		private function fillAsset( asset:AssetVO, item:Object ):AssetVO
		{
			if( item is NamedAssetBase )
			{
				asset.name = NamedAssetBase(item).name;
			}
			return asset;
		}
		
		protected function createDefaults():void 
		{
			if( !_defaultTexture )
			{
				var texture:BitmapTexture = DefaultMaterialManager.getDefaultTexture();
				texture.name = "Default";
				_defaultTexture = GetAsset( texture ) as TextureVO;
				_defaultTexture.isDefault = true;
			}
			if( !_defaultMaterial )
			{
				var material:TextureMaterial = DefaultMaterialManager.getDefaultMaterial();
				material.name = "Default";
				material.texture = DefaultMaterialManager.getDefaultTexture();
				_defaultMaterial = GetAsset( material ) as MaterialVO;
				_defaultMaterial.isDefault = true;
			}
			if( !_defaultCubeTexture )
			{
				var bitmap:BitmapData = getChekerboard();
				var cubeTexture:BitmapCubeTexture = new BitmapCubeTexture( bitmap, bitmap, bitmap, bitmap, bitmap, bitmap );
				cubeTexture.name = "CubeDefault";
				_defaultCubeTexture = GetAsset( cubeTexture ) as CubeTextureVO;
				_defaultCubeTexture.isDefault = true;
			}
		}
		protected function getChekerboard( color:uint = 0xFFFFFF ):BitmapData
		{
			var bitmap:BitmapData = new BitmapData(8, 8, false, 0x0);
			for( var i:uint=0; i<8*8; i+=2 ) //create chekerboard
			{
				bitmap.setPixel(i%8 + Math.floor(i/8)%2, Math.floor(i/8), color);
			}
			return bitmap;
		}
		
		protected var _assets:Dictionary = new Dictionary();
		protected var _objectsByAsset:Dictionary = new Dictionary();
		
		protected var _defaultMaterial:MaterialVO;
		protected var _defaultTexture:TextureVO;
		protected var _defaultCubeTexture:CubeTextureVO;
	}
}