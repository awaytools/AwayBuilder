package awaybuilder.view.scene.controls
{
	import away3d.core.math.MathConsts;
	import away3d.cameras.lenses.PerspectiveOffCenterLens;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.primitives.LineSegment;
	import away3d.entities.SegmentSet;
	import awaybuilder.utils.scene.Scene3DManager;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	import awaybuilder.view.scene.representations.ISceneRepresentation;
	import away3d.primitives.ConeGeometry;
	import away3d.cameras.Camera3D;
	import away3d.materials.ColorMaterial;
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
			
			var geom:ConeGeometry = new ConeGeometry(141, 200, 4, 1, true);
			var mat:Matrix3D = new Matrix3D();
			mat.appendRotation(45, new Vector3D(0, 1, 0));
			mat.appendRotation(-90, new Vector3D(1, 0, 0));
			geom.applyTransformation(mat);
			_representation = new Mesh(geom, new ColorMaterial(0xffffff, 0.2));
			_representation.name = originalCamera.name + "_representation";
			_representation.mouseEnabled = true;
			_representation.pickingCollider = PickingColliderType.AS3_BEST_HIT;
			
			var cameraLines:SegmentSet = new SegmentSet();
			var c:Vector3D = new Vector3D(0, 0, -100);
			cameraLines.addSegment(new LineSegment(new Vector3D(-100, -100, 100), c, 0xffffff, 0xffffff, 0.5));
			cameraLines.addSegment(new LineSegment(new Vector3D( 100, -100, 100), c, 0xffffff, 0xffffff, 0.5));
			cameraLines.addSegment(new LineSegment(new Vector3D(-100,  100, 100), c, 0xffffff, 0xffffff, 0.5));
			cameraLines.addSegment(new LineSegment(new Vector3D( 100,  100, 100), c, 0xffffff, 0xffffff, 0.5));
			cameraLines.addSegment(new LineSegment(new Vector3D(-100, -100, 100), new Vector3D( 100, -100, 100), 0xffffff, 0xffffff, 0.5));
			cameraLines.addSegment(new LineSegment(new Vector3D( 100, -100, 100), new Vector3D( 100,  100, 100), 0xffffff, 0xffffff, 0.5));
			cameraLines.addSegment(new LineSegment(new Vector3D( 100,  100, 100), new Vector3D(-100,  100, 100), 0xffffff, 0xffffff, 0.5));
			cameraLines.addSegment(new LineSegment(new Vector3D(-100,  100, 100), new Vector3D(-100, -100, 100), 0xffffff, 0xffffff, 0.5));
			_representation.addChild(cameraLines);
			
			_representation.transform = originalCamera.transform.clone();
			this.addChild(_representation);
		}

		public function updateRepresentation() : void {
			_representation.transform = sceneObject.sceneTransform.clone();
			var dist:Vector3D = Scene3DManager.camera.scenePosition.subtract(sceneObject.scenePosition);
			_representation.scaleX = _representation.scaleY = _representation.scaleZ = 0.6 * dist.length / 1500;
			
			var cam:Camera3D = sceneObject as Camera3D;
			var perspLens:PerspectiveLens = cam.lens as PerspectiveLens;
			var perspOCLens:PerspectiveOffCenterLens = cam.lens as PerspectiveOffCenterLens;
			if (perspLens) _representation.scaleX = _representation.scaleY *= Math.tan(perspLens.fieldOfView * 0.5 * MathConsts.DEGREES_TO_RADIANS) * 2;
			if (perspOCLens) {
				_representation.scaleX *= Math.tan((perspOCLens.maxAngleX - perspOCLens.minAngleX) * 0.5 * MathConsts.DEGREES_TO_RADIANS) * 2;
				_representation.scaleY *= Math.tan((perspOCLens.maxAngleY - perspOCLens.minAngleY) * 0.5 * MathConsts.DEGREES_TO_RADIANS) * 2;
			}
		}
	}
}