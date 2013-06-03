package awaybuilder.view.scene.controls
{
	import awaybuilder.view.scene.representations.ISceneRepresentation;
	import away3d.primitives.CubeGeometry;
	import away3d.materials.ColorMaterial;
	import flash.geom.Vector3D;
	import away3d.primitives.LineSegment;
	import away3d.entities.SegmentSet;
	import awaybuilder.utils.scene.CameraManager;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Mesh;
	
	public class ContainerGizmo3D extends ObjectContainer3D implements ISceneRepresentation
	{	
		private var _representation : Mesh;
		public function get representation() : Mesh { return _representation; }

		private var _sceneObject : ObjectContainer3D;
		public function get sceneObject() : ObjectContainer3D { return _sceneObject; }
		
		public function ContainerGizmo3D(originalContainer:ObjectContainer3D)
		{
			_sceneObject = originalContainer as ObjectContainer3D;
			
			_representation = new Mesh(new CubeGeometry(10, 10, 10), new ColorMaterial(0x0000ff));
			var axisLines:SegmentSet = new SegmentSet();
			axisLines.addSegment(new LineSegment(new Vector3D(-50, 0, 0), new Vector3D(50, 0, 0), 0x0, 0x0, 0.5));
			axisLines.addSegment(new LineSegment(new Vector3D(0, -50, 0), new Vector3D(0, 50, 0), 0x0, 0x0, 0.5));
			axisLines.addSegment(new LineSegment(new Vector3D(0, 0, -50), new Vector3D(0, 0, 50), 0x0, 0x0, 0.5));
			_representation.name = sceneObject.name + "_representation";
			_representation.mouseEnabled = true;
			_representation.pickingCollider = PickingColliderType.AS3_BEST_HIT;
			_representation.addChild(axisLines);
			this.addChild(_representation);
		}

		public function updateRepresentation() : void {
			_representation.scaleX = _representation.scaleY = _representation.scaleZ = CameraManager.radius / 500;
		}
	}
}