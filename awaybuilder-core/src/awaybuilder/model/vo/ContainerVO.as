package awaybuilder.model.vo
{
	import away3d.containers.ObjectContainer3D;

	public class ContainerVO extends AssetVO
	{
		public function ContainerVO( item:ObjectContainer3D )
		{
			super( item.name, item );
		}
	}
}