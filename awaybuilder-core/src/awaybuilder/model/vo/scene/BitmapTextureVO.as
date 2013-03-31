package awaybuilder.model.vo.scene 
{
	import away3d.materials.utils.DefaultMaterialManager;
	import away3d.textures.BitmapTexture;
	
	import flash.display.BitmapData;
	
	[Bindable]
	public class BitmapTextureVO extends AssetVO
	{
	    public function BitmapTextureVO( item:BitmapTexture )
	    {
	        super( item.name, item );
			if( item == DefaultMaterialManager.getDefaultTexture() )
			{
				isDefault = true;
				name = item.name = "Away3D Default";
			}
			
			
	        bitmapData = item.bitmapData
	    }
	
	    public var bitmapData:BitmapData;
	
	    public function clone():BitmapTextureVO
	    {
	        var vo:BitmapTextureVO = new BitmapTextureVO( this.linkedObject as BitmapTexture );
			vo.id = this.id;
	        return vo;
	    }
	}
}