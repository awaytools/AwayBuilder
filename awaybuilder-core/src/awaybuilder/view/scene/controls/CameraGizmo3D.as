package awaybuilder.view.scene.controls
{
	import awaybuilder.utils.scene.Scene3DManager;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	import awaybuilder.view.scene.representations.ISceneRepresentation;
	import away3d.primitives.WireframeCylinder;
	import away3d.primitives.ConeGeometry;
	import away3d.cameras.Camera3D;
	import away3d.materials.ColorMaterial;
	import awaybuilder.utils.scene.CameraManager;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Mesh;
	
	public class CameraGizmo3D extends ObjectContainer3D implements ISceneRepresentation {

		private var _representation : Mesh;
		public function get representation() : Mesh { return _representation; }

		private var _sceneObject : ObjectContainer3D;
		public function get sceneObject() : ObjectContainer3D { return _sceneObject; }
		
		public function CameraGizmo3D(originalCamera:Camera3D)
		{
			_sceneObject = originalCamera as ObjectContainer3D;
			
			var geom:ConeGeometry = new ConeGeometry(100, 200, 4, 1, false);
			var mat:Matrix3D = new Matrix3D();
			mat.appendRotation(45, new Vector3D(0, 1, 0));
			geom.applyTransformation(mat);
			_representation = new Mesh(geom, new ColorMaterial(0xffffff, 0.2));
			_representation.name = originalCamera.name + "_representation";
			_representation.mouseEnabled = true;
			_representation.pickingCollider = PickingColliderType.AS3_BEST_HIT;
			
			var cameraLines:WireframeCylinder = new WireframeCylinder(0, 100, 200, 4, 1, 0xffffff, 0.5);
			cameraLines.rotationY = 45;
			_representation.addChild(cameraLines);

			_representation.transform = originalCamera.transform.clone();
			this.addChild(_representation);
		}

		public function updateRepresentation() : void {
			_representation.position = sceneObject.position.clone();
			_representation.eulers = sceneObject.eulers.clone();
			var dist:Vector3D = Scene3DManager.camera.scenePosition.subtract(sceneObject.scenePosition);
			_representation.scaleX = _representation.scaleY = _representation.scaleZ = dist.length / 1500;
		}
	}
}