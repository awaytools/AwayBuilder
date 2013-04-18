package awaybuilder.utils
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
	import away3d.lights.shadowmaps.CubeMapShadowMapper;
	import away3d.lights.shadowmaps.DirectionalShadowMapper;
	import away3d.lights.shadowmaps.NearDirectionalShadowMapper;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.SinglePassMaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.LightPickerBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.BasicAmbientMethod;
	import away3d.materials.methods.BasicDiffuseMethod;
	import away3d.materials.methods.BasicNormalMethod;
	import away3d.materials.methods.BasicSpecularMethod;
	import away3d.materials.methods.CascadeShadowMapMethod;
	import away3d.materials.methods.ColorMatrixMethod;
	import away3d.materials.methods.EffectMethodBase;
	import away3d.materials.methods.HardShadowMapMethod;
	import away3d.materials.methods.MethodVO;
	import away3d.materials.methods.NearShadowMapMethod;
	import away3d.materials.methods.ShadowMapMethodBase;
	import away3d.materials.methods.SimpleShadowMapMethodBase;
	import away3d.materials.methods.SoftShadowMapMethod;
	import away3d.materials.utils.DefaultMaterialManager;
	import away3d.textures.BitmapTexture;
	import away3d.textures.Texture2DBase;
	
	import awaybuilder.model.vo.scene.AnimationNodeVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.EffectMethodVO;
	import awaybuilder.model.vo.scene.GeometryVO;
	import awaybuilder.model.vo.scene.LightPickerVO;
	import awaybuilder.model.vo.scene.LightVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.model.vo.scene.ObjectVO;
	import awaybuilder.model.vo.scene.ShadowMethodVO;
	import awaybuilder.model.vo.scene.SkeletonVO;
	import awaybuilder.model.vo.scene.SubGeometryVO;
	import awaybuilder.model.vo.scene.SubMeshVO;
	import awaybuilder.model.vo.scene.TextureVO;
	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.utils.UIDUtil;

	public class AssetFactory
	{
		public static function GetObject( asset:AssetVO ):Object 
		{
			for (var object:Object in assets)
			{
				if( asset.equals( assets[object] as AssetVO ) ) 
				{
					return object;
				}
			}
			return null;
		}
		public static function GetAsset( item:Object ):AssetVO
		{
			if( !item ) return null;
			
			if( assets[item] ) return assets[item];
			
			var asset:AssetVO = createAsset( item );
			asset.id = UIDUtil.createUID();
			if( !asset )
			{
				trace( item +" has no VO" );
				asset = fillAsset( new AssetVO(), item );
			}
			assets[item] = asset;
			return asset;
		}
		private static function createAsset( item:Object ):AssetVO
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
				case(item is TextureMaterial):
				case(item is ColorMaterial):
					return fillMaterial( new MaterialVO(), item as SinglePassMaterialBase );
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
					asset = fillShadowMethod( new ShadowMethodVO(), item as ShadowMapMethodBase );
					asset.name = "Shadow Method " + GetNextId("shadow");
					return asset;
				case(item is SubMesh):
					return fillSubMesh( new SubMeshVO(), item as SubMesh );
				case(item is EffectMethodBase):
					asset = fillAsset( new EffectMethodVO(), item as EffectMethodBase );
					asset.name =  "Effect Method " + GetNextId("effect");
					return asset;
				case(item is LightPickerBase):
					return fillLightPicker( new LightPickerVO(),  item as StaticLightPicker );
			}
			
			return null;
		}
		private static function fillLightPicker( asset:LightPickerVO, item:StaticLightPicker ):LightPickerVO
		{
			asset = fillAsset( asset, item ) as LightPickerVO;
			asset.name = item.name;
			asset.lights = new ArrayCollection();
			for each( var light:LightBase in item.lights )
			{
				asset.lights.addItem( AssetFactory.GetAsset( light ) );
			}
			return asset;
		}
		private static function fillSubMesh( asset:SubMeshVO, item:SubMesh ):SubMeshVO
		{
			asset.name = "subMesh";
			asset.material = AssetFactory.GetAsset( item.material ) as MaterialVO;
//			this.subGeometry = AssetFactory.GetAsset( object.subGeometry ) as SubGeometryVO;
			return asset;
		}
		private static function fillShadowMethod( asset:ShadowMethodVO, item:ShadowMapMethodBase ):ShadowMethodVO
		{
			asset = fillAsset( asset, item ) as ShadowMethodVO;
			asset.epsilon = item.epsilon;
			asset.alpha = item.alpha;
			asset.light = AssetFactory.GetAsset( item.castingLight ) as LightVO;
			asset.type = getQualifiedClassName( item );
			return asset;
		}
		private static function fillLight( asset:LightVO, item:LightBase ):LightVO
		{
			asset = fillObject( asset, item ) as LightVO;
			asset.color = item.color;
			asset.ambientColor = item.ambientColor;
			asset.ambient = item.ambient;
			asset.diffuse = item.diffuse;
			
			asset.specular = item.specular;
			
			asset.castsShadows = item.castsShadows;
			
			asset.shadowMapper = item.shadowMapper;
			
			if( item is DirectionalLight ) 
			{
				var dl:DirectionalLight = DirectionalLight( item );
				asset.directionX = dl.direction.x;
				asset.directionY = dl.direction.y;
				asset.directionZ = dl.direction.z;
				asset.type = LightVO.DIRECTIONAL;
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
		private static function fillGeometry( asset:GeometryVO, item:Geometry ):GeometryVO
		{
			asset = fillAsset( asset, item ) as GeometryVO;
			asset.subGeometries = new ArrayCollection();
//			for each( var sub:ISubGeometry in item.subGeometries )
//			{
//				asset.subGeometries.addItem(new SubGeometryVO());
//			}
			return asset;
		}
		private static function fillTexture( asset:TextureVO, item:BitmapTexture ):TextureVO
		{
			asset = fillAsset( asset, item ) as TextureVO;
			asset.bitmapData = item.bitmapData;
			return asset;
		}
		private static function fillMaterial( asset:MaterialVO, item:MaterialBase ):MaterialVO
		{
			asset = fillAsset( asset, item ) as MaterialVO;
			
			asset.alphaPremultiplied = item.alphaPremultiplied;
			
			asset.repeat = item.repeat;
			
			asset.bothSides = item.bothSides;
			asset.extra = item.extra;
			if( item.lightPicker ) 
			{
				asset.lightPicker = AssetFactory(item.lightPicker) as LightPickerVO;
			}
			asset.mipmap = item.mipmap;
			asset.smooth = item.smooth;
			asset.blendMode = item.blendMode;
			
			if( item is TextureMaterial )
			{
				asset.type = MaterialVO.TEXTURE;
				var textureMaterial:TextureMaterial = item as TextureMaterial;
				
				asset.alphaBlending = textureMaterial.alphaBlending;
				asset.colorTransform = textureMaterial.colorTransform;
				
//				asset.normalMethod = AssetFactory.GetAsset( textureMaterial.normalMethod ) as NormalMethodVO;
				
				asset.shadowMethod = AssetFactory.GetAsset( textureMaterial.shadowMethod ) as ShadowMethodVO;
				
				asset.texture = AssetFactory.GetAsset( textureMaterial.texture ) as TextureVO;
//				asset.ambientMethod = AssetFactory.GetAsset( textureMaterial.ambientMethod ) as AmbientMethodVO;
				
//				asset.diffuseMethod = AssetFactory.GetAsset( textureMaterial.diffuseMethod ) as DiffuseMethodVO;
				
//				asset.specularMethod = AssetFactory.GetAsset( textureMaterial.specularMethod ) as SpecularMethodVO;
			}
			else if( item is ColorMaterial )
			{
				asset.type = MaterialVO.COLOR;
				var colorMaterial:ColorMaterial = item as ColorMaterial;
				//				alpha = colorMaterial.alpha;
			}
			
			asset.effectMethods = new ArrayCollection();
			if( item is SinglePassMaterialBase )
			{
				var singlePassMaterialBase:SinglePassMaterialBase = item as SinglePassMaterialBase;
				for (var i:int = 0; i < singlePassMaterialBase.numMethods; i++) 
				{
					asset.effectMethods.addItem( AssetFactory.GetAsset(singlePassMaterialBase.getMethodAt( i )) );
				}
			}
			return asset;
		}
		private static function fillMesh( asset:MeshVO, item:Mesh ):MeshVO
		{
			asset = fillContainer( asset, item ) as MeshVO;
			asset.castsShadows = item.castsShadows;
			asset.subMeshes = new ArrayCollection();
			for each( var subMesh:SubMesh in item.subMeshes )
			{
				var sm:SubMeshVO = AssetFactory.GetAsset(subMesh) as SubMeshVO;
				sm.parentMesh = asset;
				asset.subMeshes.addItem( sm );
			}
			return asset;
		}
		private static function fillContainer( asset:ContainerVO, item:ObjectContainer3D ):ContainerVO
		{
			asset = fillObject( asset, item ) as ContainerVO;
			asset.children = new ArrayCollection();
			for (var i:int = 0; i < item.numChildren; i++) 
			{
				asset.children.addItem(AssetFactory.GetAsset( item.getChildAt(i) ) );
			}
			return asset;
		}
		private static function fillObject( asset:ObjectVO, item:Object3D ):ObjectVO
		{
			asset = fillAsset( asset, item ) as ObjectVO;
			asset.x = item.x;
			asset.y = item.y;
			asset.z = item.z;
			asset.scaleX = item.scaleX;
			asset.scaleY = item.scaleY;
			asset.scaleZ = item.scaleZ;
			asset.rotationX = item.rotationX;
			asset.rotationY = item.rotationY;
			asset.rotationZ = item.rotationZ;
			return asset;
		}
		private static function fillAsset( asset:AssetVO, item:Object ):AssetVO
		{
			if( item is NamedAssetBase )
			{
				asset.name = NamedAssetBase(item).name;
			}
			return asset;
		}
		public static function CreateMeshCopy( material:MeshVO ):MeshVO
		{
			// create new Mesh and add it to parent
			return new MeshVO();
		}
		public static function CreateMaterialCopy( material:MaterialVO ):MaterialVO
		{
			var newMaterial:SinglePassMaterialBase;

			if( material.type == MaterialVO.TEXTURE )
			{
				var textureMaterial:TextureMaterial = GetObject(material) as TextureMaterial;
				newMaterial = new TextureMaterial( textureMaterial.texture, textureMaterial.smooth, textureMaterial.repeat, textureMaterial.mipmap );
			}
			else
			{
				var colorMaterial:ColorMaterial = GetObject(material) as ColorMaterial;
				newMaterial = new ColorMaterial( colorMaterial.color, colorMaterial.alpha );
			}
			var base:SinglePassMaterialBase = GetObject(material) as SinglePassMaterialBase;
			newMaterial.diffuseMethod = base.diffuseMethod;
			
			newMaterial.shadowMethod = base.shadowMethod;
			newMaterial.ambientMethod = base.ambientMethod;
			newMaterial.normalMethod = base.normalMethod;
			newMaterial.specularMethod = base.specularMethod;
			newMaterial.name = base.name + "(copy)";
			
			return AssetFactory.GetAsset(newMaterial) as MaterialVO;
		}
		public static function CreateSahdowMapMethod( light:LightVO ):ShadowMethodVO
		{
			var simple:SimpleShadowMapMethodBase = new SimpleShadowMapMethodBase( GetObject(light) as LightBase );
			
			var method:ShadowMapMethodBase;
			if( light.shadowMapper is DirectionalShadowMapper )
			{
				method = new HardShadowMapMethod( GetObject(light) as LightBase );
			}
			if( light.shadowMapper is CascadeShadowMapper )
			{
				method = new CascadeShadowMapMethod( simple );
			}
			if( light.shadowMapper is NearDirectionalShadowMapper )
			{
				method = new NearShadowMapMethod( simple );
			}
			if( light.shadowMapper is CubeMapShadowMapper )
			{
				method = new SoftShadowMapMethod( GetObject(light) as DirectionalLight );
			}
//			DitheredShadowMapMethod, FilteredShadowMapMethod, HardShadowMapMethod, NearShadowMapMethod, SoftShadowMapMethod, TripleFilteredShadowMapMethod
			return AssetFactory.GetAsset( method ) as ShadowMethodVO;
		}
		
		public static function CreateEffectMethod():EffectMethodVO
		{
			var method:EffectMethodBase = new ColorMatrixMethod([ 0.2225, 0.7169, 0.0606, 0, 0, 0.2225, 0.7169, 0.0606, 0, 0, 0.2225, 0.7169, 0.0606, 0, 0, 0, 0, 0, 1, 1]);
			return AssetFactory.GetAsset( method ) as EffectMethodVO;
		}
		public static function CreateLight():LightVO
		{
			var light:DirectionalLight = new DirectionalLight();
			light.name = "Light " + GetNextId("light");
			light.castsShadows = true;
			var asset:LightVO = AssetFactory.GetAsset( light ) as LightVO;
			return asset;
		}
		public static function CreateLightPicker():LightPickerVO
		{
			var lightPicker:StaticLightPicker = new StaticLightPicker([]);
			lightPicker.name = "Light Picker " + GetNextId("lightPicker");
			var asset:LightPickerVO = AssetFactory.GetAsset( lightPicker ) as LightPickerVO;
			return asset;
		}
		public static function GetDefaultMaterial():MaterialVO
		{
			createDefaults();
			return defaultMaterial;
		}
		public static function GetDefaultTexture():TextureVO
		{
			createDefaults();
			return defaultTexture;
		}
		
		private static function createDefaults():void 
		{
			if( !defaultMaterial )
			{
				var material:TextureMaterial = DefaultMaterialManager.getDefaultMaterial();
				material.name = "Default"
				defaultMaterial = GetAsset( material ) as MaterialVO;
				defaultMaterial.isDefault = true;
			}
			if( !defaultTexture )
			{
				var texture:BitmapTexture = DefaultMaterialManager.getDefaultTexture();
				texture.name = "Default";
				defaultTexture = GetAsset( texture ) as TextureVO;
				defaultTexture.isDefault = true;
			}
		}
		
		public static function clear():void
		{
			defaultMaterial = null;
			defaultTexture = null;
			assets = new Dictionary();
			ids = new Dictionary();
		}
		
		public static function GetNextId( type:String ):String
		{
			if( !ids[type] )
			{
				ids[type] = 0;
			}
			ids[type] = ids[type] + 1;
			return ids[type]++;
		}
		
		public static var assets:Dictionary = new Dictionary();
		
		private static var ids:Dictionary = new Dictionary();
		
		private static var defaultMaterial:MaterialVO;
		private static var defaultTexture:TextureVO;
	}
}