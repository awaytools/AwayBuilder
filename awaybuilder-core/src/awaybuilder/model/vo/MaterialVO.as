package awaybuilder.model.vo
{
    import away3d.materials.MaterialBase;
    import away3d.materials.lightpickers.LightPickerBase;

	[Bindable]
    public class MaterialVO extends DocumentBaseVO
    {
        public function MaterialVO( item:MaterialBase )
        {
            super( item.name, item );

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

        public var repeat:Boolean;

        public var alphaPremultiplied:Boolean;

        public var bothSides:Boolean;
        public var extra:Object;
        public var lightPicker:LightPickerBase;
        public var mipmap:Boolean;
        public var smooth:Boolean;

        public function clone():MaterialVO
        {
            var vo:MaterialVO = new MaterialVO( this.linkedObject as MaterialBase );
            return vo;
        }
    }
}
