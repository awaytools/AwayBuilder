package awaybuilder.model.vo
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class ScenegraphTreeVO
	{
		public function ScenegraphTreeVO( label:String )
		{
			this.label = label;
		}
		
		public var label:String;
		
		public var children:ArrayCollection;
		
	}
}