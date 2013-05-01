package awaybuilder.model.vo.scene
{
	[Bindable]
	public class TextureProjectorVO extends ObjectVO
	{
		public var aspectRatio:Number;
		
		public var fov:Number;
		
		public var texture:TextureVO;

		override public function clone():ObjectVO
		{
			var clone:TextureProjectorVO = new TextureProjectorVO()
			clone.fillFromTextureProjector( this );
			return clone;
		}
		
		public function fillFromTextureProjector( asset:TextureProjectorVO ):void
		{
			this.fillFromObject( asset );
		}
		
	}
}