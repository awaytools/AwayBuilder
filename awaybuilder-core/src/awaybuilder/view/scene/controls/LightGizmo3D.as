package awaybuilder.view.scene.controls
{
	import awaybuilder.utils.scene.Scene3DManager;
	import awaybuilder.utils.scene.CameraManager;
	import flash.display3D.Context3DCompareMode;
	import away3d.primitives.WireframeCylinder;
	import away3d.lights.DirectionalLight;
	import flash.geom.Vector3D;
	import away3d.primitives.PlaneGeometry;
	import away3d.materials.TextureMaterial;
	import away3d.utils.Cast;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Mesh;
	import away3d.lights.LightBase;
	
	public class LightGizmo3D extends ObjectContainer3D
	{
		public static const DIRECTIONAL_LIGHT : String = "directionalLight";
		public static const POINT_LIGHT : String = "pointLight";
		
		[Embed(source="/assets/spritetextures/light_source.png")]
		private var LightSourceImage:Class;

		public var sceneObject : LightBase;
		public var representation : Mesh;
		
		public var type : String;
		
		public function LightGizmo3D(light:LightBase)
		{
			this.sceneObject = light;
			
			type = (light is DirectionalLight) ? DIRECTIONAL_LIGHT : POINT_LIGHT;
				
			var lightTexture:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(new LightSourceImage()));
			lightTexture.alphaBlending = true;
			lightTexture.bothSides = true;
			if (type == DIRECTIONAL_LIGHT) {
				representation = new Mesh(new PlaneGeometry(50, 50, 1, 1), lightTexture);
				representation.y = 150;
				var wC:WireframeCylinder = new WireframeCylinder(100, 100, 300, 8, 1, 0xffff00, 0.25);
				wC.y = -150;
				representation.addChild(wC);
				representation.rotationX = -90;
				representation.pivotPoint = new Vector3D(0, -150, 0);
				representation.material.depthCompareMode = wC.material.depthCompareMode = Context3DCompareMode.ALWAYS;
			} else {
				representation = new Mesh(new PlaneGeometry(100, 100, 1, 1), lightTexture);
			}
			representation.castsShadows=false;
			representation.name = light.name;
			representation.mouseEnabled = true;
			representation.pickingCollider = PickingColliderType.AS3_BEST_HIT;
			this.addChild(representation);
		}

		public function updateRepresentation() : void {
			if (type == DIRECTIONAL_LIGHT) {
				representation.eulers = sceneObject.eulers.clone();
				representation.rotationX -= 90;
			} else {
				representation.eulers = CameraManager.camera.eulers.clone();
				representation.rotationX -= 90;
				representation.rotationY -= 1; // Temporary fix for bounds visiblity
				var dist:Vector3D = Scene3DManager.camera.scenePosition.subtract(representation.scenePosition);
				representation.scaleX = representation.scaleZ = dist.length/1500;
				representation.position = sceneObject.position.clone();
			}
		}
	}
}