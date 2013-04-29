package awaybuilder.view.scene.controls
{
	import away3d.primitives.CubeGeometry;
	import away3d.materials.ColorMaterial;
	import flash.geom.Vector3D;
	import away3d.primitives.LineSegment;
	import away3d.entities.SegmentSet;
	import awaybuilder.utils.scene.CameraManager;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Mesh;
	
	public class ContainerGizmo3D extends ObjectContainer3D {
		public var containerGizmo : Mesh;
		public var container : ObjectContainer3D;
		
		public function ContainerGizmo3D(originalContainer:ObjectContainer3D)
		{
			container = originalContainer;
			
			containerGizmo = new Mesh(new CubeGeometry(10, 10, 10), new ColorMaterial(0x0000ff));
			var axisLines:SegmentSet = new SegmentSet();
			axisLines.addSegment(new LineSegment(new Vector3D(-50, 0, 0), new Vector3D(50, 0, 0), 0x0, 0x0, 1));
			axisLines.addSegment(new LineSegment(new Vector3D(0, -50, 0), new Vector3D(0, 50, 0), 0x0, 0x0, 1));
			axisLines.addSegment(new LineSegment(new Vector3D(0, 0, -50), new Vector3D(0, 0, 50), 0x0, 0x0, 1));
			containerGizmo.name = container.name + "_gizmo";
			containerGizmo.mouseEnabled = true;
			containerGizmo.pickingCollider = PickingColliderType.AS3_BEST_HIT;
			containerGizmo.addChild(axisLines);
			this.addChild(containerGizmo);
		}

		public function updateContainer() : void {
			containerGizmo.scaleX = containerGizmo.scaleY = containerGizmo.scaleZ = CameraManager.radius / 500;
		}
	}
}