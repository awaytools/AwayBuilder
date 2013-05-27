package awaybuilder.model.vo.scene
{
	import away3d.animators.nodes.AnimationNodeBase;

	[Bindable]
	public class AnimationNodeVO extends AssetVO
	{
		public var type:String;
		
		public var totalDuration:Number = 0;
		
		public var currentPosition:Number = 0;
		
		public var isPlaying:Boolean;
		
		public function clone():AnimationNodeVO
		{
			var vo:AnimationNodeVO = new AnimationNodeVO();
			vo.fillAnimationNode( this );
			return vo;
		}
		
		public function fillAnimationNode( asset:AnimationNodeVO ):void
		{
			this.name = asset.name;
			this.totalDuration = asset.totalDuration;
			this.id = asset.id;
		}
	}
}
