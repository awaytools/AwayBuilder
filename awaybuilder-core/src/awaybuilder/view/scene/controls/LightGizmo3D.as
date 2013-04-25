package awaybuilder.view.scene.controls
{
	import away3d.primitives.WireframeCylinder;
	import away3d.lights.DirectionalLight;
	import flash.geom.Vector3D;
	import away3d.primitives.PlaneGeometry;
	import away3d.cameras.Camera3D;
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

		public var light:LightBase;
		public var cone : Mesh;
		public var camera : Camera3D;
		
		public var type : String;
		
		public function LightGizmo3D(light:LightBase, camera:Camera3D)
		{
			this.light = light;
			this.camera = camera;
			
			type = (light is DirectionalLight) ? DIRECTIONAL_LIGHT : POINT_LIGHT;
				
			var lightTexture:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(new LightSourceImage()));
			lightTexture.alphaBlending = true;
			lightTexture.bothSides = true;
			if (type == DIRECTIONAL_LIGHT) {
				cone = new Mesh(new PlaneGeometry(50, 50, 1, 1), lightTexture);
				cone.y = 150;
				var wC:WireframeCylinder = new WireframeCylinder(100, 100, 300, 8, 1, 0xffff00, 0.5);
				wC.y = -150;
				cone.addChild(wC);
				cone.rotationX = -90;
				cone.pivotPoint = new Vector3D(0, -150, 0);
			} else {
				cone = new Mesh(new PlaneGeometry(100, 100, 1, 1), lightTexture);			
			}
			cone.castsShadows=false;
			cone.name = light.name;
			cone.mouseEnabled = true;
			cone.pickingCollider = PickingColliderType.AS3_BEST_HIT;
			this.addChild(cone);
		}

		public function updateLight() : void {
			if (type == DIRECTIONAL_LIGHT) {
				//TODO: any additional processing per frame
			} else {
				//TODO: any additional processing per frame
			}
		}
	}
}