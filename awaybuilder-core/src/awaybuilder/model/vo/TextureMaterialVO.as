package awaybuilder.model.vo {
    import away3d.materials.TextureMaterial;
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

public class TextureMaterialVO extends MaterialItemVO
    {
        public function TextureMaterialVO( item:TextureMaterial )
        {
            super( item );
            if( item.texture is BitmapTexture )
            {
                texture = new BitmapTextureVO( item.texture as BitmapTexture );
            }
            alphaBlending = item.alphaBlending;
            alphaThreshold = item.alphaThreshold;
            colorTransform = item.colorTransform;
            gloss = item.gloss;
            normalMethod = item.normalMethod;
            normalTexture = item.texture;

//          trace( "normalTexture.assetType = " + normalTexture.assetType );
            shadowMethod = item.shadowMethod;
            ambient = item.ambient;
            ambientColor = item.ambientColor;
            ambientMethod = item.ambientMethod;
            ambientTexture = item.ambientTexture;
//            diffuse = item.diff
//            diffuseColor = item.di
            diffuseMethod = item.diffuseMethod;
//            diffuseTexture = item.diffuse
            specular = item.specular;
            specularColor = item.specularColor;
            specularMethod = item.specularMethod;
            specularTexture = item.specularMap;
        }

        public var texture:BitmapTextureVO;

        public var alphaBlending:Boolean;
        public var alphaThreshold:Boolean;

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

        override public function clone():MaterialItemVO
        {
            var vo:TextureMaterialVO = new TextureMaterialVO( this.item as TextureMaterial );
            return vo;
        }
    }
}
