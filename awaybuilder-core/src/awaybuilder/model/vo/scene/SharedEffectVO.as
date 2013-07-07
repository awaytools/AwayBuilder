package awaybuilder.model.vo.scene
{
	import awaybuilder.model.vo.scene.interfaces.IShared;

	[Bindable]
	public class SharedEffectVO extends EffectVO implements IShared
	{
		
		public function SharedEffectVO( effectVO:EffectVO )
		{
			this.fillFromEffectMethod( effectVO );
			this.id = effectVO.id;
			this.linkedAsset = effectVO;
		}
		
		public var linkedAsset:AssetVO;
		
	}
}