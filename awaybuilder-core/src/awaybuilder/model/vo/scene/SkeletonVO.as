package awaybuilder.model.vo.scene
{
	import away3d.animators.data.Skeleton;

	public class SkeletonVO extends AssetVO
	{
		public function clone():SkeletonVO
		{
			var clone:SkeletonVO = new SkeletonVO();
			clone.fillFromSkeleton( this );
			return clone;
		}
		
		public function fillFromSkeleton( asset:SkeletonVO ):void
		{
			this.id = asset.id;
			this.name = asset.name;
		}
	}
}
