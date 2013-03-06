package awaybuilder.view.scene.controls
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.lights.LightBase;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.ConeGeometry;
	
	import flash.events.Event;
	
	public class LightGizmo3D extends ObjectContainer3D
	{
		private var light:LightBase;
		public var cone:Mesh;
		
		public function LightGizmo3D(light:LightBase)
		{
			this.light = light;
			
			cone = new Mesh(new ConeGeometry(50, 100, 16, 1, true, false), new ColorMaterial());			
			//cone.name = light.name + "_Gizmo";
			cone.name = light.name;
			cone.mouseEnabled = true;
			cone.pickingCollider = PickingColliderType.AS3_BEST_HIT;
			this.addChild(cone);
		}
	}
}