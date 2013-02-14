package awaybuilder.scene.views
{
	import away3d.cameras.Camera3D;
	import away3d.containers.View3D;
	import away3d.core.pick.PickingType;
	import away3d.entities.Mesh;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.utils.Cast;
	
	import awaybuilder.scene.controllers.CameraManager;
	import awaybuilder.scene.controllers.Scene3DManager;
	import awaybuilder.scene.utils.MathUtils;
	
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	public class OrientationTool extends Sprite
	{
		[Embed(source="assets/orientationtool/cube_back.jpg")]
		private var CubeTextureBack:Class;
		
		[Embed(source="assets/orientationtool/cube_front.jpg")]
		private var CubeTextureFront:Class;
		
		[Embed(source="assets/orientationtool/cube_left.jpg")]
		private var CubeTextureLeft:Class;
		
		[Embed(source="assets/orientationtool/cube_right.jpg")]
		private var CubeTextureRight:Class;
		
		[Embed(source="assets/orientationtool/cube_top.jpg")]
		private var CubeTextureTop:Class;
		
		[Embed(source="assets/orientationtool/cube_bottom.jpg")]
		private var CubeTextureBottom:Class;
		
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
			view.shareContext = true;
			view.stage3DProxy = Scene3DManager.stage3DProxy;
			view.antiAlias = 4;
			view.camera.position = new Vector3D(0, 0, -200);
			view.width = 120;
			view.height = 120;			
			view.mousePicker = PickingType.RAYCAST_BEST_HIT;			
			
			//Create light
			var ambientLight:PointLight = new PointLight();
			ambientLight.name = "AmbientLight";
			ambientLight.color = 0xFFFFFF;
			ambientLight.ambient = 0.5;
			ambientLight.diffuse = 1;
			ambientLight.specular = 0.1;				
			
			view.camera.addChild(ambientLight);
			
			var planeGeometry:PlaneGeometry = new PlaneGeometry(100, 100);
			
			var frontMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(CubeTextureFront));
			frontMaterial.lightPicker = new StaticLightPicker([ambientLight]);							
			var frontPlane:Mesh = new Mesh(planeGeometry);
			frontPlane.material = frontMaterial;
			frontPlane.rotationX = -90;
			frontPlane.z = -planeGeometry.width/2;
			view.scene.addChild(frontPlane);
			
			var backMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(CubeTextureBack));
			backMaterial.lightPicker = new StaticLightPicker([ambientLight]);
			var backPlane:Mesh = new Mesh(planeGeometry);
			backPlane.material = backMaterial;
			backPlane.rotationX = 90;
			backPlane.rotationZ = 180;
			backPlane.z = 50;			
			view.scene.addChild(backPlane);
			
			var leftMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(CubeTextureLeft));
			leftMaterial.lightPicker = new StaticLightPicker([ambientLight]);
			var leftPlane:Mesh = new Mesh(planeGeometry);
			leftPlane.material = leftMaterial;
			leftPlane.rotationY = 90;
			leftPlane.rotationZ = 90;
			leftPlane.x = -50;			
			view.scene.addChild(leftPlane);			
				
			var rightMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(CubeTextureRight));
			rightMaterial.lightPicker = new StaticLightPicker([ambientLight]);
			var rightPlane:Mesh = new Mesh(planeGeometry);
			rightPlane.material = rightMaterial;
			rightPlane.rotationY = -90;
			rightPlane.rotationZ = -90;
			rightPlane.x = 50;			
			view.scene.addChild(rightPlane);			
			
			var topMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(CubeTextureTop));
			topMaterial.lightPicker = new StaticLightPicker([ambientLight]);
			var topPlane:Mesh = new Mesh(planeGeometry);
			topPlane.material = topMaterial;
			topPlane.y = 50;			
			view.scene.addChild(topPlane);				
			
			var bottomMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(CubeTextureBottom));
			bottomMaterial.lightPicker = new StaticLightPicker([ambientLight]);
			var bottomPlane:Mesh = new Mesh(planeGeometry);
			bottomPlane.material = bottomMaterial;
			bottomPlane.rotationX = 180;
			bottomPlane.y = -50;			
			view.scene.addChild(bottomPlane);				
			
			
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