package awaybuilder.model.vo.scene
{
	import mx.collections.ArrayCollection;

	[Bindable]
	public class AnimationSetVO extends AssetVO
	{
		
		public var type:String;
		
		public var animations:ArrayCollection = new ArrayCollection();
		
		public function clone():AnimationSetVO
		{
			var vo:AnimationSetVO = new AnimationSetVO();
			vo.fillAnimationSet( this );
			return vo;
		}
		
		public function fillAnimationSet( asset:AnimationSetVO ):void
		{
			this.name = asset.name;
			this.type = asset.type;
			this.animations = new ArrayCollection( asset.animations.source.concat() );
			this.id = asset.id;
		}
	}
}
