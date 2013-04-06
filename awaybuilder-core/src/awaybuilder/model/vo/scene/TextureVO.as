package awaybuilder.model.vo.scene 
{
	import away3d.materials.utils.DefaultMaterialManager;
	import away3d.textures.BitmapTexture;
	
	import flash.display.BitmapData;
	
	[Bindable]
	public class TextureVO extends AssetVO
	{
	    public function TextureVO( item:BitmapTexture )
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
	
	    public function clone():TextureVO
	    {
	        var vo:TextureVO = new TextureVO( this.linkedObject as BitmapTexture );
			vo.id = this.id;
	        return vo;
	    }
	}
}