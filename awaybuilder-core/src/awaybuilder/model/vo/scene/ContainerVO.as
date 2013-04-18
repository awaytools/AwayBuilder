package awaybuilder.model.vo.scene
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.primitives.WireframeCube;
	
	import awaybuilder.utils.AssetFactory;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class ContainerVO extends ObjectVO
	{
		
		public var children:ArrayCollection; // array of ContainerVO
		
		override public function clone():ObjectVO
		{
			var clone:ContainerVO = new ContainerVO();
			clone.id = this.id;
			clone.children = new ArrayCollection( children.source );
			return clone;
		}
	}
}