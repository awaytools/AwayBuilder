package awaybuilder.view.components.controls.tree
{
	public class DroppedItemVO
	{
		public function DroppedItemVO( value:Object ):void
		{
			this.value = value;
		}
		public var value:Object;
		
		public var oldPosition:int;
		public var newPosition:int;
		
		public var oldParent:Object;
		public var newParent:Object;
		
	}
}