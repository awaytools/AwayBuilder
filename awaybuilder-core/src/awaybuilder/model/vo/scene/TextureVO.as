package awaybuilder.model.vo.scene 
{
	import away3d.materials.utils.DefaultMaterialManager;
	import away3d.textures.BitmapTexture;
	
	import awaybuilder.model.vo.scene.interfaces.IDefaultable;
	
	import flash.display.BitmapData;
	
	[Bindable]
	public class TextureVO extends AssetVO implements IDefaultable
	{
	    public function TextureVO( item:BitmapTexture )
	    {
	        super( item.name, item );
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