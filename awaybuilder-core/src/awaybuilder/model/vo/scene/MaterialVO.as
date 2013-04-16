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
    import awaybuilder.utils.AssetFactory;
    
    import flash.display3D.textures.Texture;
    import flash.geom.ColorTransform;
    
    import mx.collections.ArrayCollection;

	[Bindable]
    public class MaterialVO extends MaterialBaseVO implements IDefaultable
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
				colorTransform = textureMaterial.colorTransform;
				
				normalMethod = AssetFactory.GetAsset( textureMaterial.normalMethod ) as NormalMethodVO;
				
				shadowMethod =  AssetFactory.GetAsset( textureMaterial.shadowMethod ) as ShadowMethodVO;
				
				ambientMethod = AssetFactory.GetAsset( textureMaterial.ambientMethod ) as AmbientMethodVO;
				
				diffuseMethod = AssetFactory.GetAsset( textureMaterial.diffuseMethod ) as DiffuseMethodVO;
				
				specularMethod = AssetFactory.GetAsset( textureMaterial.specularMethod ) as SpecularMethodVO;
			}
			else if( item is ColorMaterial )
			{
				type = COLOR;
				var colorMaterial:ColorMaterial = item as ColorMaterial;
//				alpha = colorMaterial.alpha;
			}
			
			effectMethods = new ArrayCollection();
			if( item is SinglePassMaterialBase )
			{
				var singlePassMaterialBase:SinglePassMaterialBase = item as SinglePassMaterialBase;
				for (var i:int = 0; i < singlePassMaterialBase.numMethods; i++) 
				{
					effectMethods.addItem( AssetFactory.GetAsset(singlePassMaterialBase.getMethodAt( i )) );
				}
			}
			
        }
		
		public var type:String;
		
//		public var color:uint = 0x996633;
//		public var alpha:Number; // not clear what alptha to use diffuseAlpha or colortransformAlpha
//		public var texture:TextureVO;
		
		public var alphaBlending:Boolean;
		
		public var colorTransform:ColorTransform;
		
		public var normalMethod:NormalMethodVO;
//		public var normalMap:TextureVO;
		
		public var shadowMethod:ShadowMethodVO;
		
		public var ambientMethod:AmbientMethodVO;
		
//		public var diffuseAlpha:Number;
//		public var diffuseAlphaThreshold:Number;
//		public var diffuseColor:uint;
		public var diffuseMethod:DiffuseMethodVO;
//		public var diffuseTexture:TextureVO;
		
//		public var specular:Number;
//		public var specularColor:uint;
		public var specularMethod:SpecularMethodVO;
//		public var specularMap:TextureVO;
		
		public var effectMethods:ArrayCollection;
		
		override public function apply():void
		{
			super.apply();
			if( type == COLOR )
			{
				var cm:ColorMaterial = linkedObject as ColorMaterial;
//				cm.color = diffuseMethod.diffuseColor;
//				cm.alpha = alpha;
			}
			else if( type == TEXTURE )
			{
				var tm:TextureMaterial = linkedObject as TextureMaterial;
				
				tm.diffuseMethod = null;
				tm.diffuseMethod = diffuseMethod.linkedObject as BasicDiffuseMethod;
				
				tm.ambientMethod = null;
				tm.ambientMethod = ambientMethod.linkedObject as BasicAmbientMethod;
				tm.normalMethod = null;
				tm.normalMethod = normalMethod.linkedObject as BasicNormalMethod;
				tm.specularMethod = null;
				tm.specularMethod = specularMethod.linkedObject as BasicSpecularMethod;
				
				tm.shadowMethod = null;
				if( shadowMethod )
				{
					tm.shadowMethod = shadowMethod.linkedObject as ShadowMapMethodBase;
				}
					
//				tm.diffuseMethod.diffuseAlpha = diffuseAlpha;
//				tm.diffuseMethod.diffuseColor = diffuseColor;
				
//				if( specularMap )
//					tm.specularMethod.texture = specularMap.linkedObject as Texture2DBase;
				
//				if( ambientTexture )
//					tm.ambientMethod.texture = ambientTexture.linkedObject as Texture2DBase;
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
					material.addMethod( EffectMethodVO(effectMethods.getItemAt(i)).linkedObject as EffectMethodBase );
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
			
			vo.alphaBlending = this.alphaBlending;
			vo.colorTransform = this.colorTransform;
			
			vo.normalMethod = this.normalMethod;
			vo.shadowMethod = this.shadowMethod;
			vo.diffuseMethod = this.diffuseMethod;
			vo.ambientMethod = this.ambientMethod;
			vo.specularMethod = this.specularMethod;
			
			vo.id = this.id;
			
            return vo;
        }
    }
}
