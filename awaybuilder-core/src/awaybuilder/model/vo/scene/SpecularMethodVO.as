package awaybuilder.model.vo.scene
{
	import away3d.materials.methods.BasicSpecularMethod;
	import away3d.textures.Texture2DBase;
	
	import awaybuilder.model.vo.scene.interfaces.IDefaultable;
	import awaybuilder.model.vo.scene.interfaces.ITextured;
	import awaybuilder.utils.AssetFactory;
	
	[Bindable]
	public class SpecularMethodVO extends AssetVO implements IDefaultable,ITextured
	{
		public function SpecularMethodVO( name:String, object:BasicSpecularMethod )
		{
			super( name, object );
			texture = AssetFactory.GetAsset( object.texture ) as TextureVO;
			color = object.specularColor;
			specular = object.specular;
			gloss = object.gloss;
		}
		
		public var gloss:Number;
		public var specular:Number;
		public var color:uint;
		public var texture:TextureVO;
		
		override public function apply():void
		{
			var method:BasicSpecularMethod = linkedObject as BasicSpecularMethod;
			method.specular = this.specular;
			method.specularColor = this.color;
			if( texture ) 
			{
				method.texture = texture.linkedObject as Texture2DBase;
			}
		}
		public function clone():SpecularMethodVO
		{
			var vo:SpecularMethodVO = new SpecularMethodVO( this.name, this.linkedObject as BasicSpecularMethod );
			vo.name = this.name;
			vo.isDefault = this.isDefault;
			vo.id = this.id;
			return vo;
		}
		
	}
}
