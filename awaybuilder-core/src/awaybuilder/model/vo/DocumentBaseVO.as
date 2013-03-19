package awaybuilder.model.vo
{
	[Bindable]
	public class DocumentBaseVO
	{
		public function DocumentBaseVO( name:String, object:Object )
		{
			this.name = name;
			this.linkedObject = object;
		}
		
		public var name:String;
		
		public var linkedObject:Object; // away3d object, unique field
	}
}