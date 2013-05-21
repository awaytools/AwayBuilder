package awaybuilder.view.scene.controls
{
	import away3d.primitives.PlaneGeometry;
	import away3d.utils.Cast;
	import flash.display.BitmapData;
	import away3d.materials.TextureMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.ConeGeometry;
	import away3d.entities.TextureProjector;
	import awaybuilder.utils.scene.Scene3DManager;
	import away3d.primitives.WireframeCylinder;
	import flash.geom.Vector3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Mesh;
	
	public class TextureProjectorGizmo3D extends ObjectContainer3D
	{
		public var sceneObject : TextureProjector;
		public var representation : Mesh;
		
		public var projectorBitmap:BitmapData;
		
		public function TextureProjectorGizmo3D(projector:TextureProjector, projectorBitmap:BitmapData)
		{
			this.sceneObject = projector;
			this.projectorBitmap = projectorBitmap;
						
			var projectorTexture:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(projectorBitmap));
			projectorTexture.alphaBlending = true;
			projectorTexture.bothSides = true;
			
			representation = new Mesh(new ConeGeometry(100, 200, 4, 1, false), new ColorMaterial(0xffffff, 0.2));
			representation.name = projector.name + "_representation";
			representation.mouseEnabled = true;
			representation.pickingCollider = PickingColliderType.AS3_BEST_HIT;
			
			var cameraLines:WireframeCylinder = new WireframeCylinder(0, 100, 200, 4, 1, 0xffffff, 0.5);
			cameraLines.rotationY = 45;
			representation.addChild(cameraLines);
			
			var projectorTexturePlane:Mesh = new Mesh(new PlaneGeometry(141, 141, 1, 1), projectorTexture);
			projectorTexturePlane.y = -100;
			representation.addChild(projectorTexturePlane);
			this.addChild(representation);
		}

		public function updateRepresentation() : void {
			representation.position = sceneObject.position.clone();
			representation.eulers = sceneObject.eulers.clone();
			var dist:Vector3D = Scene3DManager.camera.scenePosition.subtract(sceneObject.scenePosition);
			representation.scaleX = representation.scaleY = representation.scaleZ = dist.length/1500;
		}
	}
}