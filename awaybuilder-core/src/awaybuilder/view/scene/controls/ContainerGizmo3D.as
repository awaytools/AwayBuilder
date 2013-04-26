package awaybuilder.view.scene.controls
{
	import awaybuilder.utils.scene.CameraManager;
	import away3d.primitives.PlaneGeometry;
	import away3d.materials.TextureMaterial;
	import away3d.utils.Cast;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Mesh;
	
	public class ContainerGizmo3D extends ObjectContainer3D {
		[Embed(source="/assets/spritetextures/container.png")]
		private var ContainerImage:Class;
		
		private var _containerGizmo : Mesh;
		private var _baseContainer : ObjectContainer3D;
		
		public function ContainerGizmo3D(container:ObjectContainer3D)
		{
			_baseContainer = container;
			
			var containerTexture:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(new ContainerImage()));
			containerTexture.alphaBlending = true;
			containerTexture.bothSides = true;
			_containerGizmo = new Mesh(new PlaneGeometry(100, 100, 1, 1), containerTexture);			
			_containerGizmo.castsShadows=false;
			_containerGizmo.name = container.name + "gizmo";
			_containerGizmo.mouseEnabled = true;
			_containerGizmo.pickingCollider = PickingColliderType.AS3_BEST_HIT;
			this.addChild(_containerGizmo);
		}

		public function updateContainer() : void {
			_containerGizmo.eulers = CameraManager.camera.eulers.clone();
			_containerGizmo.rotationX -= 90;
			_containerGizmo.scaleX = _containerGizmo.scaleZ = CameraManager.radius / 1250;
		}
	}
}