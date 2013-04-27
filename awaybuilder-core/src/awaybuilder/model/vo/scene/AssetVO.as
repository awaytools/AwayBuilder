package awaybuilder.model.vo.scene
{
	import away3d.library.assets.NamedAssetBase;

	
	[Bindable]
	public class AssetVO
	{
		
		public function AssetVO()
		{
			//Must be instantiate only for clonning or inside AssetsFactory.
		}
		
		public var id:String; // unique ID to compare objects
		
		public var name:String = "undefined";
		
		public var isDefault:Boolean = false;
		public var isNull:Boolean = false;
		
		public function equals( asset:AssetVO ):Boolean
		{
			return (asset.id == this.id); 
		}
	}
}