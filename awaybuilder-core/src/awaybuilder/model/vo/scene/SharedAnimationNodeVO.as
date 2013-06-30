package awaybuilder.model.vo.scene
{
	import awaybuilder.model.vo.scene.interfaces.IShared;

	[Bindable]
	public class SharedAnimationNodeVO extends AnimationNodeVO implements IShared
	{
		
		public function SharedAnimationNodeVO( animationNodeVO:AnimationNodeVO )
		{
			this.fillFromAnimationNode( animationNodeVO );
			this.id = animationNodeVO.id;
			this.linkedAsset = animationNodeVO;
			trace( "SharedAnimationNodeVO" , animationNodeVO.name );
		}
		
		public var linkedAsset:AssetVO;
		
	}
}