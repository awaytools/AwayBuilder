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
    import awaybuilder.utils.AssetFactory;
    
    import flash.display3D.textures.Texture;
    import flash.geom.ColorTransform;
    
    import mx.collections.ArrayCollection;

	[Bindable]
    public class MaterialVO extends MaterialBaseVO implements IDefaultable
    {
		
		public static const SINGLEPASS:String = "singlepass";
		public static const MULTIPASS:String = "multipass ";
		
		public var type:String;
		
		public var alpha:Number;
		
		public var alphaBlending:Boolean;
		
		public var colorTransform:ColorTransform;
		
		
		public var ambientLevel:Number;
		public var ambientColor:uint;
		public var ambientTexture:TextureVO;
		public var ambientMethodType:String;
		
		public var diffuseColor:uint;
		public var diffuseTexture:TextureVO;
		public var diffuseMethodType:String;
		
		public var normalColor:uint;
		public var normalTexture:TextureVO;
		public var normalMethodType:String;
		
		public var specularLevel:Number;
		public var specularColor:uint;
		public var specularTexture:TextureVO;
		public var specularGloss:int;
		public var specularMethodType:String;
		
		public var shadowMethod:ShadowMethodVO;
		
		public var effectMethods:ArrayCollection;
		
        public function clone():MaterialVO
        {
            var vo:MaterialVO = new MaterialVO();
			vo.name = this.name;
			vo.alpha = this.alpha;
			vo.alphaPremultiplied = this.alphaPremultiplied;
			
			vo.repeat = this.repeat;
			vo.isDefault = this.isDefault;
			
			vo.bothSides = this.bothSides;
			vo.extra = this.extra;
			
			vo.mipmap = this.mipmap;
			vo.smooth = this.smooth;
			vo.blendMode = this.blendMode;
			
			vo.alphaBlending = this.alphaBlending;
			vo.colorTransform = this.colorTransform;
			
			vo.lightPicker = this.lightPicker;
			vo.light = this.light;
			vo.shadowMethod = this.shadowMethod;
			
			vo.normalTexture = this.normalTexture;
			vo.normalMethodType = this.normalMethodType;
			
			vo.diffuseTexture = this.diffuseTexture;
			vo.diffuseColor = this.diffuseColor;
			vo.diffuseMethodType = this.diffuseMethodType;
			
			vo.ambientLevel = this.ambientLevel;
			vo.ambientColor = this.ambientColor;
			vo.ambientTexture = this.ambientTexture;
			vo.ambientMethodType = this.ambientMethodType;
			
			vo.specularLevel = this.specularLevel;
			vo.specularColor = this.specularColor;
			vo.specularGloss = this.specularGloss;
			vo.specularTexture = this.specularTexture;
			vo.specularMethodType = this.specularMethodType;
			
			vo.id = this.id;
			
            return vo;
        }
    }
}
