package awaybuilder.model.vo.scene
{
    import away3d.materials.ColorMaterial;
    import away3d.materials.MaterialBase;
    import away3d.materials.SinglePassMaterialBase;
    import away3d.materials.TextureMaterial;
    import away3d.materials.lightpickers.LightPickerBase;
    import away3d.materials.methods.BasicAmbientMethod;
    import away3d.materials.methods.BasicDiffuseMethod;
    import away3d.materials.methods.BasicNormalMethod;
    import away3d.materials.methods.BasicSpecularMethod;
    import away3d.materials.methods.EffectMethodBase;
    import away3d.materials.methods.ShadowMapMethodBase;
    import away3d.materials.utils.DefaultMaterialManager;
    import away3d.textures.BitmapTexture;
    import away3d.textures.Texture2DBase;
    
    import awaybuilder.model.vo.scene.interfaces.IDefaultable;
    import awaybuilder.model.vo.scene.interfaces.ITextured;
    import awaybuilder.utils.AssetUtil;
    
    import flash.display3D.textures.Texture;
    import flash.geom.ColorTransform;
    
    import mx.collections.ArrayCollection;

	[Bindable]
    public class MaterialVO extends MaterialBaseVO implements IDefaultable
    {
		
		public static const SINGLEPASS:String = "singlepass";
		public static const MULTIPASS:String = "multipass";
		
		public var type:String;
		
		public var alpha:Number;
		
		public var alphaBlending:Boolean;
		
		public var colorTransform:ColorTransform;
		
		public var alphaThreshold:Number;
		
		public var ambientLevel:Number;
		public var ambientColor:uint;
		public var ambientTexture:TextureVO;
		public var ambientMethod:ShadingMethodVO;
		
		public var diffuseColor:uint;
		public var diffuseTexture:TextureVO;
		public var diffuseMethod:ShadingMethodVO;
		
		public var normalColor:uint;
		public var normalTexture:TextureVO;
		public var normalMethod:ShadingMethodVO;
		
		public var specularLevel:Number;
		public var specularColor:uint;
		public var specularTexture:TextureVO;
		public var specularGloss:Number;
		public var specularMethod:ShadingMethodVO;
		
		public var shadowMethod:ShadowMethodVO;
		
		public var effectMethods:ArrayCollection = new ArrayCollection();
		
        public function clone():MaterialVO
        {
            var vo:MaterialVO = new MaterialVO();
			vo.fillFromMaterial( this );
            return vo;
        }
		
		public function fillFromMaterial( asset:MaterialVO ):void
		{
			this.name = asset.name;
			this.alpha = asset.alpha;
			this.alphaThreshold = asset.alphaThreshold;
			
			this.alphaPremultiplied = asset.alphaPremultiplied;
			this.type = asset.type;
			this.repeat = asset.repeat;
			this.isDefault = asset.isDefault;
			
			this.bothSides = asset.bothSides;
			this.extra = asset.extra;
			
			this.mipmap = asset.mipmap;
			this.smooth = asset.smooth;
			this.blendMode = asset.blendMode;
			
			this.alphaBlending = asset.alphaBlending;
			this.colorTransform = asset.colorTransform;
			
			this.lightPicker = asset.lightPicker;
			this.light = asset.light;
			this.shadowMethod = asset.shadowMethod;
			
			this.normalTexture = asset.normalTexture;
			this.normalMethod = asset.normalMethod;
			
			this.diffuseTexture = asset.diffuseTexture;
			this.diffuseColor = asset.diffuseColor;
			this.diffuseMethod = asset.diffuseMethod;
			
			this.ambientLevel = asset.ambientLevel;
			this.ambientColor = asset.ambientColor;
			this.ambientTexture = asset.ambientTexture;
			this.ambientMethod = asset.ambientMethod;
			
			this.specularLevel = asset.specularLevel;
			this.specularColor = asset.specularColor;
			this.specularGloss = asset.specularGloss;
			this.specularTexture = asset.specularTexture;
			this.specularMethod = asset.specularMethod;
			
			var effects:Array = [];
			for each( var effect:EffectMethodVO in asset.effectMethods )
			{
				effects.push( effect );
			}
			this.effectMethods = new ArrayCollection( effects );
			
			this.id = asset.id;
		}
    }
}
