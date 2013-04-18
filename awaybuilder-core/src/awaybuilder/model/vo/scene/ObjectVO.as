package awaybuilder.model.vo.scene
{
	import away3d.core.base.Object3D;
	import away3d.entities.Entity;

	[Bindable]
	public class ObjectVO extends AssetVO
	{
		
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public var scaleX:Number;
		public var scaleY:Number;
		public var scaleZ:Number;
		
		public var rotationX:Number;
		public var rotationY:Number;
		public var rotationZ:Number;
		
		public function clone():ObjectVO
		{
			throw new Error( "Abstract method");
		}
		
		protected function fill( asset:ObjectVO ):ObjectVO
		{
			asset.x = this.x;
			asset.y = this.y;
			asset.z = this.z;
			asset.scaleX = this.scaleX;
			asset.scaleY = this.scaleY;
			asset.scaleZ = this.scaleZ;
			asset.rotationX = this.rotationX;
			asset.rotationY = this.rotationY;
			asset.rotationZ = this.rotationZ;
			asset.name = this.name;
			asset.id = this.id;
			return asset;
		}
	}
}
