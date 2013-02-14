package awaybuilder.scene.controls
{
	import away3d.cameras.Camera3D;
	import away3d.containers.View3D;
	import away3d.core.pick.PickingType;
	import away3d.entities.Mesh;
	import away3d.lights.DirectionalLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.CubeGeometry;
	
	import awaybuilder.scene.controllers.CameraManager;
	import awaybuilder.scene.controllers.Scene3DManager;
	import awaybuilder.scene.utils.MathUtils;
	
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	public class OrientationTool extends Sprite
	{
		public var cube:Mesh;
		private var view:View3D;
		
		public function OrientationTool()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);		
		}
		
		protected function handleAddedToStage(event:Event):void
		{
			//Create OrientationView
			view = new View3D();
			view.backgroundAlpha = 0;
			view.antiAlias = 4;
			view.camera.position = new Vector3D(0, 0, -200);
			view.width = 120;
			view.height = 120;			
			view.mousePicker = PickingType.RAYCAST_BEST_HIT;			
			
			//Create light
			var ambientLight:DirectionalLight = new DirectionalLight(-1, -0.5, 1);
			ambientLight.position = new Vector3D(500, 500, 500);
			ambientLight.name = "AmbientLight";
			ambientLight.color = 0xFFFFFF;
			ambientLight.ambient = 1;
			ambientLight.diffuse = 1;
			ambientLight.specular = 1;				
			
			cube = new Mesh(new CubeGeometry(), new ColorMaterial());
			//cube.material.lightPicker = new StaticLightPicker([ambientLight]);
			view.scene.addChild(cube);	
			
			this.addChild(view);
		}
		
		public function update():void
		{
			view.camera.rotationX = Scene3DManager.camera.rotationX;
			view.camera.rotationY = Scene3DManager.camera.rotationY;
			view.camera.rotationZ = Scene3DManager.camera.rotationZ;
			
			var camPos:Vector3D = getCameraPosition(CameraManager.instance.targetProps.xDegree, -CameraManager.instance.targetProps.yDegree);
			view.camera.x = -camPos.x;
			view.camera.y = -camPos.y;
			view.camera.z = -camPos.z;
			
			view.render();			
		}
		
		private function getCameraPosition(xDegree:Number, yDegree:Number):Vector3D
		{
			var cy:Number = Math.cos(MathUtils.convertToRadian(yDegree)) * 200;			
			
			var v:Vector3D = new Vector3D();
			
			v.x = Math.sin(MathUtils.convertToRadian(xDegree)) * cy;
			v.y = Math.sin(MathUtils.convertToRadian(yDegree)) * 200;
			v.z = Math.cos(MathUtils.convertToRadian(xDegree)) * cy;
			
			return v;
		}				
				
	}
}