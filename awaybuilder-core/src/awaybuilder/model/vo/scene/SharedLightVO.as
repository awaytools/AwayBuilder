package awaybuilder.model.vo.scene
{
	import awaybuilder.model.vo.scene.interfaces.IShared;

	[Bindable]
	public class SharedLightVO extends LightVO implements IShared
	{
		
		public function SharedLightVO( light:LightVO )
		{
			this.fillFromLight( light );
			this.id = light.id;
			this.linkedAsset = light;
		}
		
		public var linkedAsset:AssetVO;
		
	}
}