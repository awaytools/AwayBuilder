package awaybuilder.scene.views
{
	import away3d.containers.View3D;
	import away3d.core.pick.PickingType;
	import away3d.lights.PointLight;
	
	import awaybuilder.scene.controllers.Scene3DManager;
	import awaybuilder.scene.controls.RotateGizmo3D;
	import awaybuilder.scene.controls.ScaleGizmo3D;
	import awaybuilder.scene.controls.TranslateGizmo3D;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	public class GizmoTool extends Sprite
	{		
		public var translateGizmo:TranslateGizmo3D;
		public var rotateGizmo:RotateGizmo3D;
		public var scaleGizmo:ScaleGizmo3D;
		
		private var view:View3D;
		
		public function GizmoTool()
		{
			this.mouseChildren = false;
			this.mouseEnabled = false;
			this.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);		
		}
		
		protected function handleAddedToStage(event:Event):void
		{
			//Create OrientationView
			view = new View3D();			
			view.shareContext = true;
			view.stage3DProxy = Scene3DManager.stage3DProxy;
			view.antiAlias = 4;
			view.camera.position = new Vector3D(0, 0, -200);
			view.mousePicker = PickingType.RAYCAST_BEST_HIT;			
			
			//Create light
			var ambientLight:PointLight = new PointLight();
			ambientLight.name = "AmbientLight";
			ambientLight.color = 0xFFFFFF;
			ambientLight.ambient = 0.5;
			ambientLight.diffuse = 1;
			ambientLight.specular = 0.1;				
			
			view.camera.addChild(ambientLight);
			
			//CreateGizmos
			translateGizmo = new TranslateGizmo3D();
			view.scene.addChild(translateGizmo);
			
			rotateGizmo = new RotateGizmo3D();
			view.scene.addChild(rotateGizmo);
			
			scaleGizmo = new ScaleGizmo3D();
			view.scene.addChild(scaleGizmo);			
			
			this.addChild(view);
		}
		
		public function update():void
		{
			view.camera.rotationX = Scene3DManager.camera.rotationX;
			view.camera.rotationY = Scene3DManager.camera.rotationY;
			view.camera.rotationZ = Scene3DManager.camera.rotationZ;
			
			view.camera.position = Scene3DManager.camera.scenePosition;
			
			view.render();			
		}
		
		public function setSize(w:Number, h:Number):void
		{
			view.width = w;
			view.height = h;
		}
					
	}
}