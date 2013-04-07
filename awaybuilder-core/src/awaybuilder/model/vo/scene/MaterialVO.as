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
    
    import awaybuilder.utils.AssetFactory;
    
    import flash.display3D.textures.Texture;
    import flash.geom.ColorTransform;
    
    import mx.collections.ArrayCollection;

	[Bindable]
    public class MaterialVO extends MaterialBaseVO
    {
		
		public static const COLOR:String = "colorType";
		public static const TEXTURE:String = "textureType";
		
        public function MaterialVO( item:MaterialBase )
        {
			
            super( item );
			
			if( item is TextureMaterial )
			{
				type = TEXTURE;
				var textureMaterial:TextureMaterial = item as TextureMaterial;
				
				alphaBlending = textureMaterial.alphaBlending;
				alphaThreshold = textureMaterial.alphaThreshold;
				colorTransform = textureMaterial.colorTransform;
				
				normalMethod = textureMaterial.normalMethod;
				normalMap = AssetFactory.CreateAsset( textureMaterial.normalMethod.normalMap ) as TextureVO;
				
				shadowMethod = textureMaterial.shadowMethod;
				
				ambient = textureMaterial.ambient;
				ambientColor = textureMaterial.ambientColor;
				ambientMethod = textureMaterial.ambientMethod;
				ambientTexture = AssetFactory.CreateAsset(  textureMaterial.ambientTexture ) as TextureVO;
				
				diffuseMethod = textureMaterial.diffuseMethod;
				diffuseTexture = AssetFactory.CreateAsset( textureMaterial.diffuseMethod.texture ) as TextureVO;
				
				specular = textureMaterial.specular;
				specularColor = textureMaterial.specularColor;
				specularMethod = textureMaterial.specularMethod;
				gloss = textureMaterial.gloss;
				specularMap = AssetFactory.CreateAsset( textureMaterial.specularMap ) as TextureVO;
				diffuseAlpha = textureMaterial.diffuseMethod.diffuseAlpha;
			}
			else if( item is ColorMaterial )
			{
				type = COLOR;
				var colorMaterial:ColorMaterial = item as ColorMaterial;
				diffuseColor = colorMaterial.color;
//				alpha = colorMaterial.alpha;
			}
			
			effectMethods = new ArrayCollection();
			if( item is SinglePassMaterialBase )
			{
				var singlePassMaterialBase:SinglePassMaterialBase = item as SinglePassMaterialBase;
				for (var i:int = 0; i < singlePassMaterialBase.numMethods; i++) 
				{
					effectMethods.addItem( singlePassMaterialBase.getMethodAt( i ) );
				}
				
			}
			
        }
		
		public var type:String;
		
//		public var color:uint = 0x996633;
//		public var alpha:Number; // not clear what alptha to use diffuseAlpha or colortransformAlpha
//		public var texture:TextureVO;
		
		public var alphaBlending:Boolean;
		public var alphaThreshold:Number;
		
		public var colorTransform:ColorTransform;
		public var gloss:Number;
		
		public var normalMethod:BasicNormalMethod;
		public var normalMap:TextureVO;
		
		public var shadowMethod:ShadowMapMethodBase;
		
		public var ambient:Number;
		public var ambientColor:uint;
		public var ambientMethod:BasicAmbientMethod;
		public var ambientTexture:TextureVO;
		
		public var diffuseAlpha:Number;
		public var diffuseAlphaThreshold:Number;
		public var diffuseColor:uint;
		public var diffuseMethod:BasicDiffuseMethod;
		public var diffuseTexture:TextureVO;
		
		public var specular:Number;
		public var specularColor:uint;
		public var specularMethod:BasicSpecularMethod;
		public var specularMap:TextureVO;
		
		public var linkedTextures:ArrayCollection; //hepler
		
		public var effectMethods:ArrayCollection;
		
		override public function apply():void
		{
			super.apply();
			if( type == COLOR )
			{
				var cm:ColorMaterial = linkedObject as ColorMaterial;
				cm.color = diffuseColor;
//				cm.alpha = alpha;
			}
			else if( type == TEXTURE )
			{
				var tm:TextureMaterial = linkedObject as TextureMaterial;
				if( diffuseTexture )
					tm.diffuseMethod.texture = diffuseTexture.linkedObject as Texture2DBase;
				
				tm.diffuseMethod.diffuseAlpha = diffuseAlpha;
				tm.diffuseMethod.diffuseColor = diffuseColor;
				
				if( specularMap )
					tm.specularMethod.texture = specularMap.linkedObject as Texture2DBase;
				
				if( normalMap )
					tm.normalMethod.normalMap = normalMap.linkedObject as Texture2DBase;
				
				if( ambientTexture )
					tm.ambientMethod.texture = ambientTexture.linkedObject as Texture2DBase;
			}
			var material:SinglePassMaterialBase = linkedObject as SinglePassMaterialBase;
			if( material ) 
			{
				var i:int;
//				for (i = 0; i < material.numMethods; i++) 
//				{
//					if( (i < effectMethods.length) && material.getMethodAt( i ) != material.getMethodAt( i ) ) 
//					{
//						material.removeMethod( material.getMethodAt( i ) );
//						i--;
//					}
//				}
//				for (i = 0; i < effectMethods.length; i++) 
//				{
//					if( (i < material.numMethods) && effectMethods.getItemAt( i ) != material.getMethodAt( i ) ) 
//					{
//						material.addMethodAt( effectMethods.getItemAt( i ) as 
//					}
//				}
				for (i = 0; i < material.numMethods; i++) 
				{
					material.removeMethod( material.getMethodAt(i) );
					i--;
				}
				for (i = 0; i < effectMethods.length; i++) 
				{
					material.addMethod( effectMethods.getItemAt(i) as EffectMethodBase );
				}
				
			}
		}
		
		
		
        public function clone():MaterialVO
        {
            var vo:MaterialVO = new MaterialVO( this.linkedObject as MaterialBase );
			vo.name = this.name;
			vo.alphaPremultiplied = this.alphaPremultiplied;
			
			vo.repeat = this.repeat;
			
			vo.bothSides = this.bothSides;
			vo.extra = this.extra;
			vo.lightPicker = this.lightPicker;
			vo.mipmap = this.mipmap;
			vo.smooth = this.smooth;
			vo.blendMode = this.blendMode;
			
			vo.diffuseMethod = this.diffuseMethod;
			vo.diffuseColor = this.diffuseColor;
			vo.diffuseAlpha = this.diffuseAlpha;
			vo.diffuseTexture =  this.diffuseTexture;
			
			vo.alphaBlending = this.alphaBlending;
			vo.alphaThreshold = this.alphaThreshold;
			vo.colorTransform = this.colorTransform;
			vo.gloss = this.gloss;
			vo.normalMethod = this.normalMethod;
			vo.normalMap =  this.normalMap;
			
			vo.shadowMethod = this.shadowMethod;
			vo.ambient = this.ambient;
			vo.ambientColor = this.ambientColor;
			vo.ambientMethod = this.ambientMethod;
			vo.ambientTexture =  this.ambientTexture;
			
			vo.specular = this.specular;
			vo.specularColor = this.specularColor;
			vo.specularMethod = this.specularMethod;
			vo.specularMap =  this.specularMap;
			
			vo.id = this.id;
			
            return vo;
        }
    }
}
