package awaybuilder.model.vo
{
	import mx.collections.ArrayCollection;

	[Bindable]
	public class DocumentVO
	{
		public var name:String = "untitled";
		
		public var animations:ArrayCollection = new ArrayCollection();
		
		public var geometry:ArrayCollection = new ArrayCollection();
		
		public var materials:ArrayCollection = new ArrayCollection();
		
		public var scene:ArrayCollection = new ArrayCollection();
		
//		public var skeletons:ArrayCollection = new ArrayCollection();
		
		public var textures:ArrayCollection = new ArrayCollection();
		
		public var lights:ArrayCollection = new ArrayCollection();
		
		public var methods:ArrayCollection = new ArrayCollection();
	}
}