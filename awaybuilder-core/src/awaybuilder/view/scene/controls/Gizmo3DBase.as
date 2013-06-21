package awaybuilder.view.scene.controls
{
	import away3d.containers.ObjectContainer3D;
	import away3d.lights.DirectionalLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	
	import awaybuilder.utils.scene.Scene3DManager;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	public class Gizmo3DBase extends ObjectContainer3D
	{
		protected const BASE_GIZMO:String = "baseGizmo";
		protected const TRANSLATE_GIZMO:String = "translationGizmo";
		protected const ROTATE_GIZMO:String = "rotationGizmo";
		protected const SCALE_GIZMO:String = "scaleGizmo";
		
		public var active:Boolean = false;
		public var hasMoved:Boolean = false;
		
		public var currentMesh:ObjectContainer3D;	
		public var currentAxis:String = "";
		
		protected var content:ObjectContainer3D;
		protected var click:Point = new Point();
		protected var click2:Point = new Point();
		protected var xAxisMaterial:ColorMaterial = new ColorMaterial(0xff0000, 1);
		protected var yAxisMaterial:ColorMaterial = new ColorMaterial(0x00cc00, 1);
		protected var zAxisMaterial:ColorMaterial = new ColorMaterial(0x0033ff, 1);
		protected var highlightOverMaterial:ColorMaterial = new ColorMaterial(0xffcc00);
		protected var highlightDownMaterial:ColorMaterial = new ColorMaterial(0xfff000);
		protected var sphereMaterial:ColorMaterial = new ColorMaterial(0xFFFFFF, 0.3);
		protected var sphereHighlightMaterial:ColorMaterial = new ColorMaterial(0xFFFFFF, 0.6);
		protected var cubeMaterial:ColorMaterial = new ColorMaterial();
		protected var isLightGizmo:LightGizmo3D;
		protected var isContainerGizmo:ContainerGizmo3D;
		protected var isTextureProjectorGizmo:TextureProjectorGizmo3D;
		protected var type : String = BASE_GIZMO;
		
		private var ambientLight : DirectionalLight;
		
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
			highlightOverMaterial.lightPicker = picker;
			highlightDownMaterial.lightPicker = picker;
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

			content.transform = content.transform.clone(); // Force the transform invalidation
			
			ambientLight.direction = Scene3DManager.camera.forwardVector;
		}			
		
		public function show(sceneObject:ObjectContainer3D):void
		{
			currentMesh = sceneObject;
			
			isLightGizmo = currentMesh.parent as LightGizmo3D;
			isContainerGizmo = currentMesh.parent as ContainerGizmo3D;
			isTextureProjectorGizmo = currentMesh.parent as TextureProjectorGizmo3D;

			content.transform.identity();
			this.transform = currentMesh.parent.sceneTransform.clone();
				
			if (isTextureProjectorGizmo) 
			{
				if (type != TRANSLATE_GIZMO) {
					content.rotationX = isTextureProjectorGizmo.sceneObject.rotationX;
					content.rotationY = isTextureProjectorGizmo.sceneObject.rotationY;
					content.rotationZ = isTextureProjectorGizmo.sceneObject.rotationZ;
				} else this.rotationX = this.rotationY = this.rotationZ = 0;
			}
			else if (!isLightGizmo)
 			{
				if (type != TRANSLATE_GIZMO) {
					content.rotationX = (isContainerGizmo) ? isContainerGizmo.parent.rotationX : currentMesh.rotationX;
					content.rotationY = (isContainerGizmo) ? isContainerGizmo.parent.rotationY : currentMesh.rotationY;
					content.rotationZ = (isContainerGizmo) ? isContainerGizmo.parent.rotationZ : currentMesh.rotationZ;
				} else this.rotationX = this.rotationY = this.rotationZ = 0;
			}

			var pivot:Vector3D = currentMesh.sceneTransform.deltaTransformVector(currentMesh.pivotPoint);		
			this.position = (type == TRANSLATE_GIZMO) ? currentMesh.scenePosition.clone() : currentMesh.scenePosition.add(pivot);
			this.visible = true;
			
			update();
		}
		
		public function hide():void
		{
			this.visible = false;
			hasMoved = false;
		}		
	}
}