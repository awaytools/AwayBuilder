package awaybuilder.model.vo.scene
{
	import awaybuilder.model.vo.scene.interfaces.IDefaultable;
	
	import flash.display.BitmapData;

	[Bindable]
	public class CubeTextureVO extends AssetVO implements IDefaultable
	{
		
		public var positiveX:BitmapData;
		public var negativeX:BitmapData;
		public var positiveY:BitmapData;
		public var negativeY:BitmapData;
		public var positiveZ:BitmapData;
		public var negativeZ:BitmapData;
		
		public function clone():CubeTextureVO
		{
			var vo:CubeTextureVO = new CubeTextureVO();
			vo.isDefault = this.isDefault;
			vo.id = this.id;
			vo.name = this.name;
			vo.positiveX = this.positiveX;
			vo.negativeX = this.negativeX;
			vo.positiveY = this.positiveY;
			vo.negativeY = this.negativeY;
			vo.positiveZ = this.positiveZ;
			vo.negativeZ = this.negativeZ;
			return vo;
		}
		
	}
}