package awaybuilder.utils
{
	import away3d.animators.AnimationSetBase;
	import away3d.animators.data.Skeleton;
	import away3d.animators.data.SkeletonPose;
	import away3d.animators.nodes.AnimationNodeBase;
	import away3d.animators.states.AnimationStateBase;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.core.base.SubMesh;
	import away3d.entities.Entity;
	import away3d.entities.Mesh;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.lights.shadowmaps.CascadeShadowMapper;
	import away3d.lights.shadowmaps.CubeMapShadowMapper;
	import away3d.lights.shadowmaps.DirectionalShadowMapper;
	import away3d.lights.shadowmaps.NearDirectionalShadowMapper;
	import away3d.materials.ColorMaterial;
	import away3d.materials.SinglePassMaterialBase;
	import away3d.materials.TextureMaterial;
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
	
	import awaybuilder.model.vo.scene.AmbientMethodVO;
	import awaybuilder.model.vo.scene.AnimationNodeVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.DiffuseMethodVO;
	import awaybuilder.model.vo.scene.EffectMethodVO;
	import awaybuilder.model.vo.scene.GeometryVO;
	import awaybuilder.model.vo.scene.LightPickerVO;
	import awaybuilder.model.vo.scene.LightVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.model.vo.scene.NormalMethodVO;
	import awaybuilder.model.vo.scene.ShadowMethodVO;
	import awaybuilder.model.vo.scene.SkeletonVO;
	import awaybuilder.model.vo.scene.SpecularMethodVO;
	import awaybuilder.model.vo.scene.SubMeshVO;
	import awaybuilder.model.vo.scene.TextureVO;
	
	import flash.utils.Dictionary;

	public class AssetFactory
	{
		
		public static var assets:Dictionary = new Dictionary();
		
		public static function GetAsset( item:Object ):AssetVO
		{
			if( !item ) return null;
			
			if( assets[item] ) {
//				trace( "already in dictionary " + item + " " + assets[item] );
				return assets[item];
			}
			var asset:AssetVO = getByItem( item );
			
			if( !asset )
			{
				trace( item +" has no VO" );
				asset = new AssetVO( item.name, item );
			}
			assets[item] = asset;
			return asset;
		}
		private static function getByItem( item:Object ):AssetVO
		{
			if( item is Mesh ) return new MeshVO( item as Mesh );
			if( item is SubMeshVO ) return new SubMeshVO( item as SubMesh );
			if( item is TextureMaterial ) return new MaterialVO( item as SinglePassMaterialBase );
			if( item is ColorMaterial ) return new MaterialVO( item as SinglePassMaterialBase );
			if( item is BitmapTexture ) return new TextureVO( item as BitmapTexture );
			if( item is Geometry ) return new GeometryVO( item as Geometry );
			if( item is AnimationNodeBase ) return new AnimationNodeVO( item as AnimationNodeBase );
			if( item is AnimationSetBase ) return new AssetVO( "Animation Set (" + item.name +")",item );
			if( item is AnimationStateBase ) return new AssetVO( "Animation State" ,item );
			if( item is SkeletonPose ) return new AssetVO( "Skeleton Pose (" + item.name +")", item );
			if( item is Skeleton ) return new SkeletonVO( item as Skeleton );
			if( item is LightBase ) return new LightVO( item as LightBase  );
			if( item is ShadowMapMethodBase ) return new ShadowMethodVO( "Shadow Method " + GetNextId("shadow"), item as ShadowMapMethodBase  );
			if( item is SubMesh ) return new SubMeshVO( item as SubMesh  );
			if( item is Entity ) return new ContainerVO( item as ObjectContainer3D );
			if( item is ObjectContainer3D ) return new ContainerVO( item as ObjectContainer3D );
			if( item is EffectMethodBase ) return new EffectMethodVO( "Effect Method " + GetNextId("effect"), item as EffectMethodBase );
			if( item is BasicAmbientMethod ) return new AmbientMethodVO( "Ambient Method " + GetNextId("ambient"), item as BasicAmbientMethod );
			if( item is BasicNormalMethod ) return new NormalMethodVO( "Normal Method " + GetNextId("normal"), item as BasicNormalMethod );
			if( item is BasicDiffuseMethod ) return new DiffuseMethodVO( "Diffuse Method " + GetNextId("diffuse"), item as BasicDiffuseMethod );
			if( item is BasicSpecularMethod ) return new SpecularMethodVO( "Specular Method " + GetNextId("specular"), item as BasicSpecularMethod );
			if( item is StaticLightPicker ) return new LightPickerVO( item as StaticLightPicker );
			
			return null;
		}
		public static function CreateMaterialCopy( material:MaterialVO ):MaterialVO
		{
			var newMaterial:SinglePassMaterialBase;

			if( material.linkedObject is TextureMaterial )
			{
				var textureMaterial:TextureMaterial =  material.linkedObject as TextureMaterial;
				newMaterial = new TextureMaterial( textureMaterial.texture, textureMaterial.smooth, textureMaterial.repeat, textureMaterial.mipmap );
							}
			if( material.linkedObject is ColorMaterial )
			{
				var colorMaterial:ColorMaterial = material.linkedObject as ColorMaterial;
				newMaterial = new ColorMaterial( colorMaterial.color, colorMaterial.alpha );
			}
			var base:SinglePassMaterialBase =  material.linkedObject as SinglePassMaterialBase;
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
			var simple:SimpleShadowMapMethodBase = new SimpleShadowMapMethodBase( light.linkedObject as LightBase );
			
			var method:ShadowMapMethodBase;
			if( light.shadowMapper is DirectionalShadowMapper )
			{
				method = new HardShadowMapMethod( light.linkedObject as LightBase );
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
				method = new SoftShadowMapMethod( light.linkedObject as DirectionalLight );
			}
//			DitheredShadowMapMethod, FilteredShadowMapMethod, HardShadowMapMethod, NearShadowMapMethod, SoftShadowMapMethod, TripleFilteredShadowMapMethod
			return AssetFactory.GetAsset( method ) as ShadowMethodVO;
		}
		
		public static function CreateEffectMethod():EffectMethodVO
		{
			var method:EffectMethodBase = new ColorMatrixMethod([ 0.2225, 0.7169, 0.0606, 0, 0, 0.2225, 0.7169, 0.0606, 0, 0, 0.2225, 0.7169, 0.0606, 0, 0, 0, 0, 0, 1, 1]);
			return AssetFactory.GetAsset( method ) as EffectMethodVO;
		}
		public static function CreateAmbientMethod( copy:AmbientMethodVO=null ):AmbientMethodVO
		{
			var method:BasicAmbientMethod = new BasicAmbientMethod();
			if( copy ) {
				if( copy.texture ) 
				{
					method.texture = copy.texture.linkedObject as Texture2DBase;
				}
				
				method.ambient = copy.ambient;
				method.ambientColor = copy.color;
			}
			var asset:AmbientMethodVO = AssetFactory.GetAsset( method ) as AmbientMethodVO;
			if( copy ) {
				asset.name = copy.name + "(copy)";
			}
			return asset;
		}
		public static function CreateDiffuseMethod( copy:DiffuseMethodVO=null ):DiffuseMethodVO
		{
			var method:BasicDiffuseMethod = new BasicDiffuseMethod();
			if( copy ) {
				if( copy.texture ) 
				{
					method.texture = copy.texture.linkedObject as Texture2DBase;
				}
				method.diffuseColor = copy.color;
				method.diffuseAlpha = copy.alpha;
			}
			var asset:DiffuseMethodVO = AssetFactory.GetAsset( method ) as DiffuseMethodVO;
			if( copy ) {
				asset.name = copy.name + "(copy)";
			}
			return asset;
		}
		public static function CreateNormalMethod( copy:NormalMethodVO=null ):NormalMethodVO
		{
			var method:BasicNormalMethod = new BasicNormalMethod();
			if( copy ) {
				if( copy.texture ) 
				{
					method.normalMap = copy.texture.linkedObject as Texture2DBase;
				}
			}
			var asset:NormalMethodVO = AssetFactory.GetAsset( method ) as NormalMethodVO;
			if( copy ) {
				asset.name = copy.name + "(copy)";
			}
			return asset;
		}
		public static function CreateSpecularMethod( copy:SpecularMethodVO=null ):SpecularMethodVO
		{
			var method:BasicSpecularMethod = new BasicSpecularMethod();
			if( copy ) {
				if( copy.texture ) 
				{
					method.texture = copy.texture.linkedObject as Texture2DBase;
				}
				method.specularColor = copy.color;
				method.specular = copy.specular;
				method.gloss = copy.gloss;
			}
			var asset:SpecularMethodVO = AssetFactory.GetAsset( method ) as SpecularMethodVO;
			if( copy ) {
				asset.name = copy.name + "(copy)";
			}
			return asset;
		}
		public static function CreateLight():LightVO
		{
			var light:DirectionalLight = new DirectionalLight();
			light.name = "Light " + GetNextId("light");
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
		public static function GetDefaultDiffuseMethod():DiffuseMethodVO
		{
			createDefaults();
			return defaultDiffuseMethod;
		}
		public static function GetDefaultNormalMethod():NormalMethodVO
		{
			createDefaults();
			return defaultNormalMethod;
		}
		public static function GetDefaultAmbientMethod():AmbientMethodVO
		{
			createDefaults();
			return defaultAmbientMethod;
		}
		public static function GetDefaultSpecularMethod():SpecularMethodVO
		{
			createDefaults();
			return defaultSpecularMethod;
		}
		public static function GetDefaultTexture():TextureVO
		{
			createDefaults();
			return defaultTexture;
		}
		
		private static var defaultMaterial:MaterialVO;
		private static var defaultDiffuseMethod:DiffuseMethodVO;
		private static var defaultNormalMethod:NormalMethodVO;
		private static var defaultAmbientMethod:AmbientMethodVO;
		private static var defaultSpecularMethod:SpecularMethodVO;
		private static var defaultTexture:TextureVO;
		
		private static function createDefaults():void 
		{
			if( !defaultMaterial )
			{
				var material:TextureMaterial = DefaultMaterialManager.getDefaultMaterial();
				defaultMaterial = GetAsset( material ) as MaterialVO;
				defaultMaterial.isDefault = true;
			}
			if( !defaultDiffuseMethod )
			{
				defaultDiffuseMethod = defaultMaterial.diffuseMethod;
				defaultDiffuseMethod.isDefault = true;
				defaultDiffuseMethod.name = "Default Diffuse";
			}
			if( !defaultNormalMethod )
			{
				defaultNormalMethod = defaultMaterial.normalMethod;
				defaultNormalMethod.isDefault = true;
				defaultNormalMethod.name = "Default Normal";
			}
			if( !defaultAmbientMethod )
			{
				defaultAmbientMethod = defaultMaterial.ambientMethod;
				defaultAmbientMethod.isDefault = true;
				defaultAmbientMethod.name = "Default Ambient";
			}
			if( !defaultSpecularMethod )
			{
				defaultSpecularMethod = defaultMaterial.specularMethod;
				defaultSpecularMethod.isDefault = true;
				defaultSpecularMethod.name = "Default Specular";
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
			defaultDiffuseMethod = null;
			defaultNormalMethod = null;
			defaultAmbientMethod = null;
			defaultSpecularMethod = null;
			defaultTexture = null;
			assets = new Dictionary();
			ids = new Dictionary();
		}
		
		private static var ids:Dictionary = new Dictionary();
		public static function GetNextId( type:String ):String
		{
			if( !ids[type] )
			{
				ids[type] = 0;
			}
			ids[type] = ids[type] + 1;
			return ids[type]++;
		}
	}
}