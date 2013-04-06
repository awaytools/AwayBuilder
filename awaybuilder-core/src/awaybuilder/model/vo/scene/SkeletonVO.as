package awaybuilder.model.vo.scene
{
	import away3d.animators.data.Skeleton;

	public class SkeletonVO extends AssetVO
	{
		public function SkeletonVO( item:Skeleton )
		{
			super( item.name, item );
			
		}
		
	}
}
