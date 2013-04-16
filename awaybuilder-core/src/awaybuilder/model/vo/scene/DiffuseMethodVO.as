package awaybuilder.model.vo.scene
{
	import away3d.materials.methods.BasicDiffuseMethod;
	import away3d.textures.Texture2DBase;
	
	import awaybuilder.model.vo.scene.interfaces.IDefaultable;
	import awaybuilder.model.vo.scene.interfaces.ITextured;
	import awaybuilder.utils.AssetFactory;
	
	import mx.controls.Text;

	[Bindable]
	public class DiffuseMethodVO extends AssetVO implements IDefaultable, ITextured
	{
		public function DiffuseMethodVO( name:String, object:BasicDiffuseMethod )
		{
			super( name, object );
			texture = AssetFactory.GetAsset( object.texture ) as TextureVO;
			color = object.diffuseColor;
			alpha = object.diffuseAlpha;
			alphaThreshold = object.alphaThreshold;
		}
		
		public var texture:TextureVO;
		public var color:uint;
		public var alpha:Number;
		public var alphaThreshold:Number;
		
		override public function apply():void
		{
			var method:BasicDiffuseMethod = linkedObject as BasicDiffuseMethod;
			if( texture ) 
			{
				method.texture = texture.linkedObject as Texture2DBase;
			}
			method.diffuseColor = this.color;
			method.diffuseAlpha = this.alpha;
			method.alphaThreshold = this.alphaThreshold;
		}
		public function clone():DiffuseMethodVO
		{
			var vo:DiffuseMethodVO = new DiffuseMethodVO( this.name, this.linkedObject as BasicDiffuseMethod );
			vo.isDefault = this.isDefault;
			vo.name = this.name;
			vo.id = this.id;
			return vo;
		}
		
	}
}
