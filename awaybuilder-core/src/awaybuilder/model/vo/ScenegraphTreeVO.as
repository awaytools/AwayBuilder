package awaybuilder.model.vo
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class ScenegraphTreeVO
	{
		public function ScenegraphTreeVO( label:String, item:Object )
		{
			this.label = label;
			this.item = item;
		}
		
		public var label:String;
		
		public var item:Object;
		
		public var children:ArrayCollection;
		
	}
}