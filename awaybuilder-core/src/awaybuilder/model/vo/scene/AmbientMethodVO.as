package awaybuilder.model.vo.scene
{
	import away3d.materials.methods.BasicAmbientMethod;
	import away3d.materials.methods.EnvMapAmbientMethod;
	import away3d.textures.Texture2DBase;
	
	import awaybuilder.model.vo.scene.interfaces.IDefaultable;
	import awaybuilder.model.vo.scene.interfaces.ITextured;
	import awaybuilder.utils.AssetFactory;

	[Bindable]
	public class AmbientMethodVO extends AssetVO implements IDefaultable,ITextured
	{
		public function AmbientMethodVO( name:String, object:BasicAmbientMethod )
		{
			super( name, object );
			texture = AssetFactory.GetAsset( object.texture ) as TextureVO;
			color = object.ambientColor;
			ambient = object.ambient;
		}
		
		public var ambient:Number;
		
		public var color:Number;
		
		public var texture:TextureVO;
		
		override public function apply():void
		{
			var method:BasicAmbientMethod = linkedObject as BasicAmbientMethod;
			method.ambient = this.ambient;
			method.ambientColor = this.color;
			if( texture ) 
			{
				method.texture = texture.linkedObject as Texture2DBase;
			}
		}
		public function clone():AmbientMethodVO
		{
			var vo:AmbientMethodVO = new AmbientMethodVO( this.name, this.linkedObject as BasicAmbientMethod );
			vo.name = this.name;
			vo.isDefault = this.isDefault;
			vo.id = this.id;
			return vo;
		}
		
	}
}
