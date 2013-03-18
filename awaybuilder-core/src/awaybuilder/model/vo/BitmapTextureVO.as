/**
 * Created with IntelliJ IDEA.
 * User: Mike
 * Date: 17.03.13
 * Time: 19:49
 * To change this template use File | Settings | File Templates.
 */
package awaybuilder.model.vo {
import away3d.textures.BitmapTexture;

import flash.display.BitmapData;

import flash.display3D.textures.Texture;
import flash.display3D.textures.TextureBase;

[Bindable]
public class BitmapTextureVO extends ScenegraphItemVO
{
    public function BitmapTextureVO( item:BitmapTexture )
    {
        super( "Texture (" + item.originalName.split("/").pop() +")", item );

        name = item.name;
        bitmapData = item.bitmapData

    }

    public var name:String;
    public var bitmapData:BitmapData;

    public function clone():BitmapTextureVO
    {
        var vo:BitmapTextureVO = new BitmapTextureVO( this.item as BitmapTexture );
        return vo;
    }
}
}