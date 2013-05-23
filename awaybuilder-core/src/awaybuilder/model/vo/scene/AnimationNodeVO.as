package awaybuilder.model.vo.scene
{
	import away3d.animators.nodes.AnimationNodeBase;

	[Bindable]
	public class AnimationNodeVO extends AssetVO
	{
		public var type:String;
		
		public function clone():AnimationNodeVO
		{
			var vo:AnimationNodeVO = new AnimationNodeVO();
			vo.fillAnimationNode( this );
			return vo;
		}
		
		public function fillAnimationNode( asset:AnimationNodeVO ):void
		{
			this.name = asset.name;
			this.id = asset.id;
		}
	}
}
