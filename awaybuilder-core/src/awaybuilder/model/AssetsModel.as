package awaybuilder.model
{
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.materials.SinglePassMaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.AlphaMaskMethod;
	import away3d.materials.methods.CascadeShadowMapMethod;
	import away3d.materials.methods.ColorMatrixMethod;
	import away3d.materials.methods.ColorTransformMethod;
	import away3d.materials.methods.DitheredShadowMapMethod;
	import away3d.materials.methods.EffectMethodBase;
	import away3d.materials.methods.EnvMapMethod;
	import away3d.materials.methods.FilteredShadowMapMethod;
	import away3d.materials.methods.FogMethod;
	import away3d.materials.methods.FresnelEnvMapMethod;
	import away3d.materials.methods.HardShadowMapMethod;
	import away3d.materials.methods.LightMapMethod;
	import away3d.materials.methods.NearShadowMapMethod;
	import away3d.materials.methods.OutlineMethod;
	import away3d.materials.methods.RefractionEnvMapMethod;
	import away3d.materials.methods.RimLightMethod;
	import away3d.materials.methods.SoftShadowMapMethod;
	import away3d.textures.CubeTextureBase;
	import away3d.textures.Texture2DBase;
	
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.CubeTextureVO;
	import awaybuilder.model.vo.scene.EffectMethodVO;
	import awaybuilder.model.vo.scene.LightPickerVO;
	import awaybuilder.model.vo.scene.LightVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.ShadowMethodVO;
	import awaybuilder.model.vo.scene.TextureVO;
	import awaybuilder.utils.AssetUtil;
	
	import flash.geom.ColorTransform;
	import flash.utils.Dictionary;
	
	import mx.utils.UIDUtil;

	public class AssetsModel extends SmartModelBase
	{
		public function GetObjectsByType( type:Class, property:String=null, value:Object=null ):Vector.<Object> 
		{
			var objects:Vector.<Object> = new Vector.<Object>();
			for (var object:Object in _assets)
			{
				if( object is type )
				{
					if( property && (object["property"] == value) ) 
					{
						objects.push( object );
					}
					else 
					{
						objects.push( object );
					}
				}
			}
			return objects;
		}
		public function RemoveObject( obj:Object ):void 
		{
			var asset:AssetVO = _assets[obj] as AssetVO;
			delete _objectsByAsset[asset];
			delete _assets[obj];
			
			trace( _assets[obj] );
		}
		public function GetObject( asset:AssetVO ):Object 
		{
			if( !asset ) return null;
			return _objectsByAsset[asset];
		}
		override public function GetAsset( obj:Object ):AssetVO
		{
			if( !obj ) return null;
			
			if( _assets[obj] ) return _assets[obj];
			
			var asset:AssetVO = createAsset( obj );
			asset.id = UIDUtil.createUID();
			if( !asset )
			{
				trace( obj +" has no VO" );
				asset = new AssetVO();
			}
			_assets[obj] = asset;
			_objectsByAsset[asset] = obj;
			return asset;
		}
		
		public function CreateMaterial( material:MaterialVO ):MaterialVO
		{
			var newMaterial:SinglePassMaterialBase;
			
			//			if( material.type == MaterialVO.TEXTURE )
			//			{
			var textureMaterial:TextureMaterial = GetObject(material) as TextureMaterial;
			newMaterial = new TextureMaterial( textureMaterial.texture, textureMaterial.smooth, textureMaterial.repeat, textureMaterial.mipmap );
			//			}
			//			else
			//			{
			//				var colorMaterial:ColorMaterial = GetObject(material) as ColorMaterial;
			//				newMaterial = new ColorMaterial( colorMaterial.color, colorMaterial.alpha );
			//			}
			var base:SinglePassMaterialBase = GetObject(material) as SinglePassMaterialBase;
			newMaterial.diffuseMethod = base.diffuseMethod;
			
			newMaterial.shadowMethod = base.shadowMethod;
			newMaterial.ambientMethod = base.ambientMethod;
			newMaterial.normalMethod = base.normalMethod;
			newMaterial.specularMethod = base.specularMethod;
			newMaterial.name = base.name + "(copy)";
			
			return GetAsset(newMaterial) as MaterialVO;
		}
		
		public function CreateEffectMethod( type:String ):EffectMethodVO
		{
			var method:EffectMethodBase;
			switch( type )
			{
				case "LightMapMethod":
					method = new LightMapMethod(GetObject(_defaultTexture) as Texture2DBase);
					break;
				case "ProjectiveTextureMethod":
					//					method = new ProjectiveTextureMethod();
					break;
				case "RimLightMethod":
					method = new RimLightMethod();
					break;
				case "ColorTransformMethod":
					method = new ColorTransformMethod();
					ColorTransformMethod(method).colorTransform = new ColorTransform();
					break;
				case "AlphaMaskMethod":
					method = new AlphaMaskMethod(GetObject(_defaultTexture) as Texture2DBase, false);
					break;
				case "ColorMatrixMethod":
					method = new ColorMatrixMethod([ 0.2225, 0.7169, 0.0606, 0, 0, 0.2225, 0.7169, 0.0606, 0, 0, 0.2225, 0.7169, 0.0606, 0, 0, 0, 0, 0, 1, 1]);
					break;
				case "RefractionEnvMapMethod":
					method = new RefractionEnvMapMethod( GetObject(_defaultCubeTexture) as CubeTextureBase );
					break;
				case "OutlineMethod":
					method = new OutlineMethod();
					break;
				case "FresnelEnvMapMethod":
					method = new FresnelEnvMapMethod( GetObject(_defaultCubeTexture) as CubeTextureBase );
					break;
				case "FogMethod":
					method = new FogMethod(0,1000);
					break;
				case "EnvMapMethod":
					method = new EnvMapMethod( GetObject(_defaultCubeTexture) as CubeTextureBase );
					break;
			}
			return GetAsset( method ) as EffectMethodVO;
		}
		public function CreateDirectionalLight():LightVO
		{
			var light:DirectionalLight = new DirectionalLight();
			light.name = "Directional Light " + awaybuilder.utils.AssetUtil.GetNextId("directionalLight");
			light.castsShadows = false;
			var asset:LightVO = GetAsset( light ) as LightVO;
			return asset;
		}
		public function CreatePointLight():LightVO
		{
			var light:PointLight = new PointLight();
			light.name = "Point Light " + awaybuilder.utils.AssetUtil.GetNextId("pointLight");
			light.castsShadows = false;
			var asset:LightVO = GetAsset( light ) as LightVO;
			return asset;
		}
		public function CreateLightPicker():LightPickerVO
		{
			var lightPicker:StaticLightPicker = new StaticLightPicker([]);
			lightPicker.name = "Light Picker " + awaybuilder.utils.AssetUtil.GetNextId("lightPicker");
			var asset:LightPickerVO = GetAsset( lightPicker ) as LightPickerVO;
			return asset;
		}
		
		public function CreateFilteredShadowMapMethod( light:LightVO ):ShadowMethodVO
		{
			var method:FilteredShadowMapMethod = new FilteredShadowMapMethod( GetObject(light) as DirectionalLight );
			var asset:ShadowMethodVO = GetAsset( method ) as ShadowMethodVO;
			asset.name = "FilteredShadow " + awaybuilder.utils.AssetUtil.GetNextId("FilteredShadowMapMethod");
			return asset;
		}
		public function CreateDitheredShadowMapMethod( light:LightVO ):ShadowMethodVO
		{
			var method:DitheredShadowMapMethod = new DitheredShadowMapMethod( GetObject(light) as DirectionalLight );
			var asset:ShadowMethodVO = GetAsset( method ) as ShadowMethodVO;
			asset.name = "DitheredShadow " + awaybuilder.utils.AssetUtil.GetNextId("DitheredShadowMapMethod");
			return asset;
		}
		public function CreateSoftShadowMapMethod( light:LightVO ):ShadowMethodVO
		{
			var method:SoftShadowMapMethod = new SoftShadowMapMethod( GetObject(light) as DirectionalLight );
			var asset:ShadowMethodVO = GetAsset( method ) as ShadowMethodVO;
			asset.name = "SoftShadow " + awaybuilder.utils.AssetUtil.GetNextId("SoftShadowMapMethod");
			return asset;
		}
		public function CreateHardShadowMapMethod( light:LightVO ):ShadowMethodVO
		{
			var method:HardShadowMapMethod = new HardShadowMapMethod( GetObject(light) as DirectionalLight );
			var asset:ShadowMethodVO = GetAsset( method ) as ShadowMethodVO;
			asset.name = "HardShadow " + awaybuilder.utils.AssetUtil.GetNextId("HardShadowMapMethod");
			return asset;
		}
		public function CreateNearShadowMapMethod( light:LightVO ):ShadowMethodVO
		{
			var simple:SoftShadowMapMethod = new SoftShadowMapMethod( GetObject(light) as DirectionalLight );
			var method:NearShadowMapMethod = new NearShadowMapMethod( simple );
			var asset:ShadowMethodVO = GetAsset( method ) as ShadowMethodVO;
			asset.name = "NearShadow " + awaybuilder.utils.AssetUtil.GetNextId("NearShadowMapMethod");
			return asset;
		}
		public function CreateCascadeShadowMapMethod( light:LightVO ):ShadowMethodVO
		{
			var simple:SoftShadowMapMethod = new SoftShadowMapMethod( GetObject(light) as DirectionalLight );
			var method:CascadeShadowMapMethod = new CascadeShadowMapMethod( simple );
			var asset:ShadowMethodVO = GetAsset( method ) as ShadowMethodVO;
			asset.name = "CascadeShadow " + awaybuilder.utils.AssetUtil.GetNextId("CascadeShadowMapMethod");
			return asset;
		}
		
		//-- Defaults ---
		
		public function GetDefaultMaterial():MaterialVO
		{
			createDefaults();
			return _defaultMaterial;
		}
		public function GetDefaultTexture():TextureVO
		{
			createDefaults();
			return _defaultTexture;
		}
		public function GetDefaultCubeTexture():CubeTextureVO
		{
			createDefaults();
			return _defaultCubeTexture;
		}
		public function Clear():void
		{
			_defaultMaterial = null;
			_defaultTexture = null;
			_assets = new Dictionary();
			_objectsByAsset = new Dictionary();
			AssetUtil.Clear();
		}
		
	}
}