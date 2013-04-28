package awaybuilder.model
{
	import away3d.animators.AnimationSetBase;
	import away3d.animators.data.Skeleton;
	import away3d.animators.data.SkeletonPose;
	import away3d.animators.nodes.AnimationNodeBase;
	import away3d.animators.states.AnimationStateBase;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
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
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.MultiPassMaterialBase;
	import away3d.materials.SinglePassMaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.LightPickerBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.AlphaMaskMethod;
	import away3d.materials.methods.CascadeShadowMapMethod;
	import away3d.materials.methods.ColorMatrixMethod;
	import away3d.materials.methods.ColorTransformMethod;
	import away3d.materials.methods.DitheredShadowMapMethod;
	import away3d.materials.methods.EffectMethodBase;
	import away3d.materials.methods.EnvMapMethod;
	import away3d.materials.methods.FogMethod;
	import away3d.materials.methods.FresnelEnvMapMethod;
	import away3d.materials.methods.LightMapMethod;
	import away3d.materials.methods.NearShadowMapMethod;
	import away3d.materials.methods.OutlineMethod;
	import away3d.materials.methods.ProjectiveTextureMethod;
	import away3d.materials.methods.RefractionEnvMapMethod;
	import away3d.materials.methods.RimLightMethod;
	import away3d.materials.methods.ShadingMethodBase;
	import away3d.materials.methods.ShadowMapMethodBase;
	import away3d.materials.methods.SoftShadowMapMethod;
	import away3d.materials.utils.DefaultMaterialManager;
	import away3d.textures.BitmapCubeTexture;
	import away3d.textures.BitmapTexture;
	
	import awaybuilder.model.vo.scene.AnimationNodeVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.CubeTextureVO;
	import awaybuilder.model.vo.scene.EffectMethodVO;
	import awaybuilder.model.vo.scene.GeometryVO;
	import awaybuilder.model.vo.scene.LightPickerVO;
	import awaybuilder.model.vo.scene.LightVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.model.vo.scene.ObjectVO;
	import awaybuilder.model.vo.scene.ShadingMethodVO;
	import awaybuilder.model.vo.scene.ShadowMapperVO;
	import awaybuilder.model.vo.scene.ShadowMethodVO;
	import awaybuilder.model.vo.scene.SkeletonVO;
	import awaybuilder.model.vo.scene.SubMeshVO;
	import awaybuilder.model.vo.scene.TextureVO;
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
				case(item is Entity):
				case(item is ObjectContainer3D):
					return fillContainer( new ContainerVO(), item as ObjectContainer3D );
				case(item is MaterialBase):
					return fillMaterial( new MaterialVO(), item as MaterialBase );
				case(item is BitmapTexture):
					return fillTexture( new TextureVO(), item as BitmapTexture );
				case(item is Geometry):
					return fillGeometry( new GeometryVO(), item as Geometry );
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
			switch( true ) 
			{
				case(item is AlphaMaskMethod):
					with (item as AlphaMaskMethod) 
					{ 
						asset.texture = awaybuilder.utils.AssetUtil.GetAsset(texture) as TextureVO;
						asset.useSecondaryUV = useSecondaryUV;
					}
					break;
				case(item is ColorTransformMethod):
					with (item as ColorTransformMethod) 
					{ 
						asset.r = colorTransform.redMultiplier;
						asset.g = colorTransform.greenMultiplier;
						asset.b = colorTransform.blueMultiplier;
						asset.a = colorTransform.alphaMultiplier;
						asset.rO = colorTransform.redOffset;
						asset.gO = colorTransform.greenOffset;
						asset.bO = colorTransform.blueOffset;
						asset.aO = colorTransform.alphaOffset;
					}
					break;
				case(item is ColorMatrixMethod):
					with (item as ColorMatrixMethod) 
					{ 
						asset.r = colorMatrix[0];
						asset.g = colorMatrix[1];
						asset.b = colorMatrix[2];
						asset.a = colorMatrix[3];
						asset.rG = colorMatrix[5];
						asset.gG = colorMatrix[6];
						asset.gG = colorMatrix[7];
						asset.gG = colorMatrix[8];
						asset.rB = colorMatrix[10];
						asset.gB = colorMatrix[11];
						asset.bB = colorMatrix[12];
						asset.aB = colorMatrix[13];
						asset.rA = colorMatrix[15];
						asset.gA = colorMatrix[16];
						asset.bA = colorMatrix[17];
						asset.aA = colorMatrix[18];
						asset.rO = colorMatrix[4];
						asset.gO = colorMatrix[9];
						asset.bO = colorMatrix[14];
						asset.aO = colorMatrix[19];
					}
					break;
				case(item is EnvMapMethod):
					with (item as EnvMapMethod) 
					{ 
						asset.cubeTexture = awaybuilder.utils.AssetUtil.GetAsset(cubeTexture) as CubeTextureVO;
						asset.alpha = alpha;
						asset.mask = awaybuilder.utils.AssetUtil.GetAsset(texture) as TextureVO;
					}
					break;
				case(item is FogMethod):
					with (item as FogMethod) 
					{ 
						asset.color = fogColor;
						asset.minDistance = minDistance;
						asset.maxDistance = maxDistance;
					}
					break;
				case(item is FresnelEnvMapMethod):
					with (item as FresnelEnvMapMethod) 
					{ 
						asset.cubeTexture = awaybuilder.utils.AssetUtil.GetAsset(cubeTexture) as CubeTextureVO;
						asset.power = fresnelPower;
						asset.normalReflectance = normalReflectance;
						asset.alpha = alpha;
						asset.mask = awaybuilder.utils.AssetUtil.GetAsset(mask) as TextureVO;;
					}
					break;
				case(item is LightMapMethod):
					with (item as LightMapMethod) 
					{ 
						asset.texture = awaybuilder.utils.AssetUtil.GetAsset(texture) as TextureVO;
						asset.mode = blendMode;
						asset.useSecondaryUV = useSecondaryUV;
					}
					break;
				case(item is OutlineMethod):
					with (item as OutlineMethod) 
					{ 
						asset.size = outlineSize;
						asset.color = outlineColor;
						asset.showInnerLines = showInnerLines;
						asset.dedicatedMesh = dedicatedMesh;
					}
					break;
				case(item is ProjectiveTextureMethod):
					with (item as ProjectiveTextureMethod) 
					{ 
						asset.textureProjector = getQualifiedClassName( projector ).split("::")[1];
						asset.mode = outlineSize;
					}
					break;
				case(item is RefractionEnvMapMethod):
					with (item as RefractionEnvMapMethod) 
					{ 
						asset.cubeTexture = awaybuilder.utils.AssetUtil.GetAsset(envMap) as CubeTextureVO;
						asset.r = dispersionR;
						asset.g = dispersionG;
						asset.b = dispersionB;
						asset.alpha = alpha;
						asset.refractionIndex = refractionIndex;
					}
					break;
				case(item is RimLightMethod):
					with (item as RimLightMethod) 
					{ 
						asset.color = RimLightMethod(item).color;
						asset.strength = RimLightMethod(item).strength;
						asset.power = RimLightMethod(item).power;
					}
					break;
			}
			
			return asset;
		}
		private function fillSubMesh( asset:SubMeshVO, item:SubMesh ):SubMeshVO
		{
			asset.name = "SubMesh";
			asset.material = GetAsset( item.material ) as MaterialVO;
			//			this.subGeometry = AssetFactory.GetAsset( object.subGeometry ) as SubGeometryVO;
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
		private function fillGeometry( asset:GeometryVO, item:Geometry ):GeometryVO
		{
			asset = fillAsset( asset, item ) as GeometryVO;
			asset.subGeometries = new ArrayCollection();
			//			for each( var sub:ISubGeometry in item.subGeometries )
			//			{
			//				asset.subGeometries.addItem(new SubGeometryVO());
			//			}
			return asset;
		}
		
		private function fillShadingMethod( asset:ShadingMethodVO, obj:ShadingMethodBase ):ShadingMethodVO
		{
			asset.type = getQualifiedClassName( obj ).split("::")[1];
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
			
			if( item is MultiPassMaterialBase )
			{
				asset.type = MaterialVO.MULTIPASS;
				var multiPassMaterialBase:MultiPassMaterialBase = item as MultiPassMaterialBase;
				asset.alphaThreshold = multiPassMaterialBase.alphaThreshold;
			}
			else
			{
				asset.type = MaterialVO.SINGLEPASS;
			}
			
			if( item is TextureMaterial )
			{
				var textureMaterial:TextureMaterial = item as TextureMaterial;
				
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
				
//				asset.normalColor = textureMaterial.normalMethod.
				asset.normalTexture = GetAsset( textureMaterial.normalMap ) as TextureVO;
				asset.normalMethod = GetAsset( textureMaterial.normalMethod ) as ShadingMethodVO;
				
				
				asset.shadowMethod = GetAsset( textureMaterial.shadowMethod ) as ShadowMethodVO;
				
				
//				asset.ambientMethod = AssetFactory.GetAsset( textureMaterial.ambientMethod ) as AmbientMethodVO;
//				asset.diffuseMethod = AssetFactory.GetAsset( textureMaterial.diffuseMethod ) as DiffuseMethodVO;
//				asset.normalMethod = AssetFactory.GetAsset( textureMaterial.normalMethod ) as NormalMethodVO;
//				asset.specularMethod = AssetFactory.GetAsset( textureMaterial.specularMethod ) as SpecularMethodVO;
			}
			else if( item is ColorMaterial )
			{
				var colorMaterial:ColorMaterial = item as ColorMaterial;
				asset.alpha = colorMaterial.alpha;
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
			if( !_defaultMaterial )
			{
				var material:TextureMaterial = DefaultMaterialManager.getDefaultMaterial();
				material.name = "Default"
				_defaultMaterial = GetAsset( material ) as MaterialVO;
				_defaultMaterial.isDefault = true;
			}
			if( !_defaultTexture )
			{
				var texture:BitmapTexture = DefaultMaterialManager.getDefaultTexture();
				texture.name = "Default";
				_defaultTexture = GetAsset( texture ) as TextureVO;
				_defaultTexture.isDefault = true;
			}
			if( !_defaultCubeTexture )
			{
				var bitmap:BitmapData = new BitmapData(8, 8, false, 0x0);
				
				for( var i:uint=0; i<8*8; i+=2 ) //create chekerboard
				{
					bitmap.setPixel(i%8 + Math.floor(i/8)%2, Math.floor(i/8), 0XFFFFFF);
				}
				
				var cubeTexture:BitmapCubeTexture = new BitmapCubeTexture( bitmap, bitmap, bitmap, bitmap, bitmap, bitmap );
				cubeTexture.name = "CubeDefault";
				_defaultCubeTexture = GetAsset( cubeTexture ) as CubeTextureVO;
				_defaultCubeTexture.isDefault = true;
			}
		}
		
		protected var _assets:Dictionary = new Dictionary();
		protected var _objectsByAsset:Dictionary = new Dictionary();
		
		protected var _defaultMaterial:MaterialVO;
		protected var _defaultTexture:TextureVO;
		protected var _defaultCubeTexture:CubeTextureVO;
	}
}