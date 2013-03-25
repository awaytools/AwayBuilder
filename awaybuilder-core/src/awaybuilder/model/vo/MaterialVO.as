package awaybuilder.model.vo
{
    import away3d.materials.ColorMaterial;
    import away3d.materials.MaterialBase;
    import away3d.materials.TextureMaterial;
    import away3d.materials.lightpickers.LightPickerBase;
    import away3d.materials.methods.BasicAmbientMethod;
    import away3d.materials.methods.BasicDiffuseMethod;
    import away3d.materials.methods.BasicNormalMethod;
    import away3d.materials.methods.BasicSpecularMethod;
    import away3d.materials.methods.ShadowMapMethodBase;
    import away3d.textures.BitmapTexture;
    import away3d.textures.Texture2DBase;
    
    import flash.display3D.textures.Texture;
    import flash.geom.ColorTransform;
    
    import mx.collections.ArrayCollection;

	[Bindable]
    public class MaterialVO extends AssetVO
    {
		
		public static const COLOR:String = "colorType";
		public static const TEXTURE:String = "textureType";
		
        public function MaterialVO( item:MaterialBase )
        {
            super( item.name, item );

            repeat = item.repeat;

            alphaPremultiplied = item.alphaPremultiplied;

            bothSides = item.bothSides;
            extra = item.extra;
            lightPicker = item.lightPicker;
            mipmap = item.mipmap;
            smooth = item.smooth;

			if( item is TextureMaterial )
			{
				type = TEXTURE;
				var textureMaterial:TextureMaterial = item as TextureMaterial;
				
				if( textureMaterial.texture is BitmapTexture )
				{
					texture = new BitmapTextureVO( textureMaterial.texture as BitmapTexture );
				}
				
				alphaBlending = textureMaterial.alphaBlending;
				alphaThreshold = textureMaterial.alphaThreshold;
				colorTransform = textureMaterial.colorTransform;
				gloss = textureMaterial.gloss;
				normalMethod = textureMaterial.normalMethod;
				normalTexture = textureMaterial.texture;
				
				shadowMethod = textureMaterial.shadowMethod;
				ambient = textureMaterial.ambient;
				ambientColor = textureMaterial.ambientColor;
				ambientMethod = textureMaterial.ambientMethod;
				ambientTexture = textureMaterial.ambientTexture;
				diffuseMethod = textureMaterial.diffuseMethod;
				specular = textureMaterial.specular;
				specularColor = textureMaterial.specularColor;
				specularMethod = textureMaterial.specularMethod;
				specularTexture = textureMaterial.specularMap;
				alpha = textureMaterial.alpha;
			}
			else if( item is ColorMaterial )
			{
				type = COLOR;
				var colorMaterial:ColorMaterial = item as ColorMaterial;
				this.color = colorMaterial.color;
				alpha = colorMaterial.alpha;
			}
			
        }
		
		public var type:String;
		
		public var color:uint = 0x996633;
		public var alpha:Number;
		public var texture:BitmapTextureVO;
		
		public var alphaBlending:Boolean;
		public var alphaThreshold:Number;
		
		public var colorTransform:ColorTransform;
		public var gloss:Number;
		public var normalMethod:BasicNormalMethod;
		public var normalTexture:Texture2DBase;
		public var shadowMethod:ShadowMapMethodBase;
		
		public var ambient:Number;
		public var ambientColor:uint;
		public var ambientMethod:BasicAmbientMethod;
		public var ambientTexture:Texture2DBase;
		public var diffuse:Number;
		public var diffuseColor:uint;
		public var diffuseMethod:BasicDiffuseMethod;
		public var diffuseTexture:Texture;
		public var specular:Number;
		public var specularColor:uint;
		public var specularMethod:BasicSpecularMethod;
		public var specularTexture:Texture2DBase;
		
		public var linkedTextures:ArrayCollection;
		
		public var materialType:String;
		
        public var repeat:Boolean;

        public var alphaPremultiplied:Boolean;

        public var bothSides:Boolean;
        public var extra:Object;
        public var lightPicker:LightPickerBase;
        public var mipmap:Boolean;
        public var smooth:Boolean;

		
		public function get material():MaterialBase
		{
			return linkedObject as MaterialBase;
		}
		
        public function clone():MaterialVO
        {
            var vo:MaterialVO = new MaterialVO( this.linkedObject as MaterialBase );
            return vo;
        }
    }
}
