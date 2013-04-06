package awaybuilder.model.vo.scene
{
	import away3d.animators.nodes.AnimationNodeBase;

	public class AnimationNodeVO extends AssetVO
	{
		public function AnimationNodeVO( item:AnimationNodeBase )
		{
			super( item.name, item );
			
		}
		
	}
}
