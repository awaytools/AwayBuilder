package awaybuilder.model.vo.scene
{
	[Bindable]
	public class AnimationSetVO extends AssetVO
	{
		
		public var type:String;
		
		public function clone():AnimationSetVO
		{
			var vo:AnimationSetVO = new AnimationSetVO();
			vo.fillAnimationSet( this );
			return vo;
		}
		
		public function fillAnimationSet( asset:AnimationSetVO ):void
		{
			this.name = asset.name;
			this.id = asset.id;
		}
	}
}
