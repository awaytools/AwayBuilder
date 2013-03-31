package awaybuilder.model.vo.scene
{
	import away3d.library.assets.NamedAssetBase;
	
	import mx.utils.UIDUtil;

	[Bindable]
	public class AssetVO
	{
		public function AssetVO( name:String, object:Object )
		{
			this.id = UIDUtil.createUID();
			this.name = name;
			this.linkedObject = object;
		}
		
		public var id:String; // unique ID to compare objects
		
		public var name:String;
		
		public var isDefault:Boolean = false;
		
		public var linkedObject:Object; // away3d object, unique field
		
		public function apply():void // TODO: move sceneObject applying elsewhere
		{
			var asset:NamedAssetBase = linkedObject as NamedAssetBase;
			if( asset )
			{
				linkedObject.name = name;
			}
			
		}
	}
}