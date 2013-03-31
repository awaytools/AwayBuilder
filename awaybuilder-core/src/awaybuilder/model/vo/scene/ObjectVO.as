package awaybuilder.model.vo.scene
{
	import away3d.core.base.Object3D;
	import away3d.entities.Entity;

	[Bindable]
	public class ObjectVO extends AssetVO
	{
		public function ObjectVO( item:Object3D )
		{
			super( item.name, item );
			x = item.x;
			y = item.y;
			z = item.z;
			scaleX = item.scaleX;
			scaleY = item.scaleY;
			scaleZ = item.scaleZ;
			rotationX = item.rotationX;
			rotationY = item.rotationY;
			rotationZ = item.rotationZ;
		}
		
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public var scaleX:Number;
		public var scaleY:Number;
		public var scaleZ:Number;
		
		public var rotationX:Number;
		public var rotationY:Number;
		public var rotationZ:Number;
		
		override public function apply():void
		{
			super.apply();
			var o:Object3D = Object3D( linkedObject );
			o.x = x;
			o.y = y;
			o.z = z;
			
			o.scaleX = scaleX;
			o.scaleY = scaleY;
			o.scaleZ = scaleZ;
			
			o.rotationX = rotationX;
			o.rotationY = rotationY;
			o.rotationZ = rotationZ;
		}
		public function clone():ObjectVO
		{
			throw new Error( "Abstract method");
		}
	}
}
