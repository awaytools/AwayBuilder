/**
 * Created with IntelliJ IDEA.
 * User: Mike
 * Date: 14.03.13
 * Time: 17:13
 * To change this template use File | Settings | File Templates.
 */
package awaybuilder.model.vo
{
    import away3d.materials.MaterialBase;
import away3d.materials.lightpickers.LightPickerBase;
import away3d.materials.methods.BasicAmbientMethod;
import away3d.materials.methods.BasicDiffuseMethod;
import away3d.materials.methods.BasicNormalMethod;
import away3d.materials.methods.BasicSpecularMethod;
import away3d.materials.methods.ShadowMapMethodBase;

import flash.display3D.textures.Texture;
import flash.geom.ColorTransform;

import mx.collections.ArrayCollection;

import mx.states.AddItems;

[Bindable]
    public class MaterialItemVO extends ScenegraphItemVO
    {
        public function MaterialItemVO( item:MaterialBase )
        {
            super( item.name, item );

            name = item.name;
            repeat = item.repeat;

//            alphaBlending = item.alphaB
            alphaPremultiplied = item.alphaPremultiplied;
//            alphaThreshold = item.alphaT

            bothSides = item.bothSides;
//            colorTransform = item.c
            extra = item.extra;
//            gloss = item.
            lightPicker = item.lightPicker;
            mipmap = item.mipmap;
//            normalMethod = item.n
//            normalTexture = item.
//            shadowMethod = item.sh
            smooth = item.smooth;

//            ambient = item.am
//            ambientColor
//            ambientMethod
//            ambientTexture
//            diffuse = item.d
//            diffuseColor
//            diffuseMe
//            diffuseTe
//            specular = item.s
//            specularC
//            specularM
//            specularT
        }

        public var name:String;
        public var repeat:Boolean;

        public var alphaPremultiplied:Boolean;

        public var bothSides:Boolean;
        public var extra:Object;
        public var lightPicker:LightPickerBase;
        public var mipmap:Boolean;
        public var smooth:Boolean;

        public function clone():MaterialItemVO
        {
            var vo:MaterialItemVO = new MaterialItemVO( this.item as MaterialBase );
            return vo;
        }
    }
}
