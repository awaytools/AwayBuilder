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
		public function ContainerVO( item:ObjectContainer3D )
		{
			super( item );
			
			children = new ArrayCollection();
			for (var i:int = 0; i < item.numChildren; i++) 
			{
				children.addItem(AssetFactory.CreateAsset( item.getChildAt(i) ) );
			}
		}
		
		public var children:ArrayCollection; // array of ContainerVO
		
		override public function clone():ObjectVO
		{
			var m:ContainerVO = new ContainerVO( this.linkedObject as ObjectContainer3D );
			m.id = this.id;
			return m;
		}
	}
}