package awaybuilder.model.vo 
{
	import away3d.textures.BitmapTexture;
	
	import flash.display.BitmapData;
	
	[Bindable]
	public class BitmapTextureVO extends AssetVO
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