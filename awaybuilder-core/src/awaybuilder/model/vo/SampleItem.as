package awaybuilder.model.vo
{
	

	public class SampleItem
	{
		public function SampleItem(name:String, description:String, fileName:String, image:Class, data:Class)
		{
			this.name = name;
			this.description = description;
			this.fileName = fileName;
			this.image = image;
			this.data = data;
		}
		
		public var name:String;
		public var description:String;
		public var fileName:String;
		public var image:Class;
		public var data:Class;
	}
}