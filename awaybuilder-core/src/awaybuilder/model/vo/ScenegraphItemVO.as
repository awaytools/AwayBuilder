package awaybuilder.model.vo
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class ScenegraphItemVO
	{
		
		public function ScenegraphItemVO( label:String, item:DocumentBaseVO )
		{
			this.label = label;
			this.item = item;
		}
		
		public var label:String;
		
		public var item:DocumentBaseVO;
		
		public var children:ArrayCollection;
		
	}
}