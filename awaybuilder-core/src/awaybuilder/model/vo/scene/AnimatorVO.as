package awaybuilder.model.vo.scene
{
	
	[Bindable]
	public class AnimatorVO extends AssetVO
	{

		public var type:String;
		
		public var animationSet:AnimationSetVO;
		
		public var skeleton:SkeletonVO;
		
		public function clone():AnimatorVO
		{
			var vo:AnimatorVO = new AnimatorVO();
			vo.fillAnimator( this );
			return vo;
		}
		
		public function fillAnimator( asset:AnimatorVO ):void
		{
			this.name = asset.name;
			this.id = asset.id;
		}
	}
}
