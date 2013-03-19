package awaybuilder.model.vo {
import away3d.textures.BitmapTexture;

import flash.display.BitmapData;
import flash.display3D.textures.Texture;
import flash.display3D.textures.TextureBase;

[Bindable]
public class BitmapTextureVO extends DocumentBaseVO
{
    public function BitmapTextureVO( item:BitmapTexture )
    {
        super( item.name, item );

        bitmapData = item.bitmapData

    }

    public var bitmapData:BitmapData;

    public function clone():BitmapTextureVO
    {
        var vo:BitmapTextureVO = new BitmapTextureVO( this.linkedObject as BitmapTexture );
        return vo;
    }
}
}