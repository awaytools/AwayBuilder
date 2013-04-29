package awaybuilder.view.components.controls
{
	import spark.components.SkinnableContainer;
	
	public class PropertiesItemContainer extends SkinnableContainer
	{
		public function PropertiesItemContainer()
		{
			super();
		}
		
		[Bindable]
		public var label:String;
	}
}