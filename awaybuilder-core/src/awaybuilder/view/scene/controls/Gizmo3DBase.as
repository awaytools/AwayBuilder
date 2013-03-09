package awaybuilder.view.scene.controls
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Entity;
	import away3d.entities.Mesh;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	
	import awaybuilder.utils.scene.Scene3DManager;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	public class Gizmo3DBase extends ObjectContainer3D
	{
		public var active:Boolean = false;
		public var hasMoved:Boolean = false;
		
		public var currentMesh:Entity;	
		public var currentAxis:String = "";
		
		protected var content:ObjectContainer3D;
		protected var click:Point = new Point();
		protected var click2:Point = new Point();
		protected var xAxisMaterial:ColorMaterial = new ColorMaterial(0xff0000, 1);
		protected var yAxisMaterial:ColorMaterial = new ColorMaterial(0x00cc00, 1);
		protected var zAxisMaterial:ColorMaterial = new ColorMaterial(0x0033ff, 1);
		protected var highlightMaterial:ColorMaterial = new ColorMaterial(0xffcc00);
		protected var sphereMaterial:ColorMaterial = new ColorMaterial(0xFFFFFF, 0.3);
		protected var sphereHighlightMaterial:ColorMaterial = new ColorMaterial(0xFFFFFF, 0.6);
		
		private var ambientLight:DirectionalLight;
		
		public function Gizmo3DBase()
		{
			content = new ObjectContainer3D();
			this.addChild(content);
			
			ambientLight = new DirectionalLight(1, 1, 1);
			ambientLight.name = "AmbientLight";
			ambientLight.color = 0xFFFFFF;
			ambientLight.ambient = 0.75;
			ambientLight.diffuse = 0.5;
			ambientLight.specular = 0.5;			
			
			var picker:StaticLightPicker = new StaticLightPicker([ambientLight]);
			
			xAxisMaterial.lightPicker = picker;
			yAxisMaterial.lightPicker = picker;
			zAxisMaterial.lightPicker = picker;
			highlightMaterial.lightPicker = picker;
			sphereMaterial.lightPicker = picker;
			sphereHighlightMaterial.lightPicker = picker;			
			
			this.visible = false;
		}
		
		public function update():void
		{			
			var dist:Vector3D = Scene3DManager.camera.scenePosition.subtract(this.scenePosition);
			var scale:Number = dist.length/1000;
			content.scaleX = scale;
			content.scaleY = scale;
			content.scaleZ = scale;
			
			ambientLight.direction = Scene3DManager.camera.forwardVector;
		}			
		
		public function show(mesh:Entity):void
		{
			currentMesh = mesh;
			
			if (currentMesh.parent is LightGizmo3D) 
			{
				this.position = mesh.parent.parent.scenePosition;
				content.rotationX = mesh.parent.parent.rotationX;
				content.rotationY = mesh.parent.parent.rotationY;
				content.rotationZ = mesh.parent.parent.rotationZ;				
			}
			else
			{
				this.position = mesh.scenePosition;
				content.rotationX = mesh.rotationX;
				content.rotationY = mesh.rotationY;
				content.rotationZ = mesh.rotationZ;				
			}
			

			this.visible = true;
		}
		
		public function hide():void
		{
			this.visible = false;
			hasMoved = false;
		}		
	}
}