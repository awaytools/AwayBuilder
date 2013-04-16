package awaybuilder.model.vo.scene
{
	import away3d.materials.methods.BasicNormalMethod;
	import away3d.textures.Texture2DBase;
	
	import awaybuilder.model.vo.scene.interfaces.IDefaultable;
	import awaybuilder.model.vo.scene.interfaces.ITextured;
	import awaybuilder.utils.AssetFactory;

	[Bindable]
	public class NormalMethodVO extends AssetVO implements IDefaultable,ITextured
	{
		public function NormalMethodVO( name:String, object:BasicNormalMethod )
		{
			super( name, object );
			texture = AssetFactory.GetAsset( object.normalMap ) as TextureVO;
		}
		
		public var texture:TextureVO;
		
		override public function apply():void
		{
			var method:BasicNormalMethod  = linkedObject as BasicNormalMethod;
			if( texture ) 
			{
				method.normalMap = texture.linkedObject as Texture2DBase;
			}
		}
		public function clone():NormalMethodVO
		{
			var vo:NormalMethodVO = new NormalMethodVO( this.name, this.linkedObject as BasicNormalMethod );
			vo.name = this.name;
			vo.isDefault = this.isDefault;
			vo.id = this.id;
			return vo;
		}
		
	}
}
