package awaybuilder.model.vo.scene
{
	[Bindable]
	public class AssetVO
	{
		public function AssetVO( name:String, object:Object )
		{
			this.name = name;
			this.linkedObject = object;
		}
		
		public var name:String;
		
		public var linkedObject:Object; // away3d object, unique field
	}
}