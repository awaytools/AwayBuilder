package awaybuilder.scene.controllers
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	import away3d.core.pick.PickingColliderType;
	import away3d.core.pick.PickingType;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.events.Stage3DEvent;
	import away3d.lights.LightBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.WireframePlane;
	
	import awaybuilder.scene.controls.LightGizmo3D;
	import awaybuilder.scene.events.Scene3DManagerEvent;
	import awaybuilder.scene.views.GizmoTool;
	import awaybuilder.scene.views.OrientationTool;
	
	public class Scene3DManager extends EventDispatcher
	{
		// Singleton instance declaration
		public static const instance:Scene3DManager = new Scene3DManager();		
		public function Scene3DManager() { if ( instance ) throw new Error("Scene3DManager is a singleton"); }		
		
		public static var stage:Stage;
		public static var stage3DProxy:Stage3DProxy;
		public static var mode:String;
		public static var view:View3D;
		public static var scene:Scene3D;
		public static var camera:Camera3D;
		
		public static var selectedMeshes:Array = new Array();
		public static var selectedMesh:Mesh;
		public static var multiSelection:Boolean = false;
		
		public static var meshes:Array = new Array();
		public static var lights:Array = new Array();
		
		public static var grid:WireframePlane;
		public static var orientationTool:OrientationTool;
		public static var gizmo:GizmoTool;
		
		private static var lightGizmos:Array = new Array();
		
		private static var layer:int = 0;
		
		public static function init(stage:Stage, layer:int):void
		{
			Scene3DManager.stage = stage;
			Scene3DManager.layer = layer;
			
			stage3DProxy = Stage3DManager.getInstance(stage).getFreeStage3DProxy();			
			stage3DProxy.antiAlias = 4;
			stage3DProxy.color = 0x333333;
			stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, instance.onContextCreated);	
		}
		
		private function onContextCreated(e:Stage3DEvent):void 
		{
			//Create view3D, camera and add to stage
			view = new View3D();
			view.shareContext = true;
			view.stage3DProxy = stage3DProxy;	
			view.mousePicker = PickingType.RAYCAST_BEST_HIT;
			view.camera.lens.near = 10;
			view.camera.lens.far = 10000;			
			view.camera.position = new Vector3D(0, 200, -1000);
			view.camera.rotationX = 0;
			view.camera.rotationY = 0;	
			view.camera.rotationZ = 0			
			stage.addChildAt(view, layer);		
			
			Scene3DManager.scene = view.scene;
			Scene3DManager.camera = view.camera;							
			
			
			//Create Gizmo
			gizmo = new GizmoTool();
			stage.addChildAt(gizmo, layer+1);
			
			
			//Create OrientationTool			
			orientationTool = new OrientationTool();
			stage.addChildAt(orientationTool, layer+2);
			
			
			//Create Grid
			grid = new WireframePlane(10000, 10000, 100, 100, 0x000000, 1, "xz");
			scene.addChild(grid);	
			
			
			//Camera Settings
			CameraManager.init(stage, view, "target", 10);	
			
			
			//handle stage events
			stage.addEventListener(KeyboardEvent.KEY_DOWN, instance.onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, instance.onKeyUp);			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, instance.onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, instance.onMouseUp);
			
			stage.addEventListener(Event.RESIZE, instance.handleScreenSize);
			instance.handleScreenSize();
			
			stage3DProxy.addEventListener(Event.ENTER_FRAME, instance.loop);
			//stage.addEventListener(Event.ENTER_FRAME, instance.loop);					
			
			dispatchEvent(new Scene3DManagerEvent(Scene3DManagerEvent.READY));
		}
		
		private function loop(e:Event):void 
		{
			orientationTool.update();
			gizmo.update();
			
			view.render();			
		}		
		
		private function handleScreenSize(e:Event=null):void 
		{
			orientationTool.x = stage.stageWidth - orientationTool.width - 10;
			orientationTool.y = 5;
			
			gizmo.setSize(stage.stageWidth, stage.stageHeight);
			
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
		}	
		
		
		
		// Mouse Events *************************************************************************************************************************************************
		
		private function onMouseDown(e:MouseEvent):void
		{
			
		}			
		
		private function onMouseUp(e:MouseEvent):void
		{
			if (!CameraManager.hasMoved && !multiSelection) unselectAllMeshes();
		}			
		
		
		
		// Keyboard Events ************************************************************************************************************************************************
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			switch (e.keyCode) 
			{					
				case Keyboard.F: 
					
					if (selectedMesh != null) CameraManager.focuseTarget(selectedMesh);
					
					break;
				
				case Keyboard.C:
					
					if (CameraManager.type == "target") CameraManager.type = "free"
					else CameraManager.type = "target";
					
					break;
				
				case Keyboard.CONTROL:
					
					multiSelection = true;
					
					break;
			}				
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			switch (e.keyCode) 
			{									
				case Keyboard.CONTROL:
					
					multiSelection = false;
					
					break;
			}	
		}			
		
		
		
		// Fog Handling *********************************************************************************************************************************************
		
		public static function addFogToMesh(mesh:Mesh, minDistance:Number, maxDistance:Number, fogColor:Number=0x808080):void
		{
			if (mesh.material && mesh.material is TextureMaterial) 
			{

			}
		}			
		
		
		// Lights Handling *********************************************************************************************************************************************
		
		public static function addLight(light:LightBase):void
		{
			var gizmo:LightGizmo3D = new LightGizmo3D(light); 
			gizmo.cone.addEventListener(MouseEvent3D.CLICK, instance.handleMouseEvent3D);
			light.addChild(gizmo);
			lightGizmos.push(gizmo);
			meshes.push(gizmo.cone);
			
			scene.addChild(light);
			lights.push(light);
		}
		
		public static function removeLight(light:LightBase):void
		{
			scene.removeChild(light);
			
			for (var i:int=0;i<lights.length;i++)
			{
				if (lights[i] == light)
				{
					lights.splice(i, 1);
					lightGizmos.splice(i, 1);
					break;
				}
			}
		}	
		
		public static function addLightToMesh(mesh:Mesh, lightName:String):void
		{
			if (mesh.material) 
			{
				if (!mesh.material.lightPicker)	mesh.material.lightPicker = new StaticLightPicker([]);
			
				for each(var l:LightBase in lights)
				{
					if (l.name == lightName)
					{
						var meshLights:Array = StaticLightPicker(mesh.material.lightPicker).lights;
						meshLights.push(l);
						StaticLightPicker(mesh.material.lightPicker).lights = meshLights;
						break;
					}
				}			
			}
		}		
		
		public static function removeLightFromMesh(mesh:Mesh, lightName:String):void
		{
			if (mesh.material) 
			{
				if (mesh.material.lightPicker)
				{
					var meshLights:Array = StaticLightPicker(mesh.material.lightPicker).lights;
					
					for(var i:int=0;i<meshLights.length;i++)
					{
						if (meshLights[i].name == lightName)
						{
							meshLights.splice(i, 1);
							StaticLightPicker(mesh.material.lightPicker).lights = meshLights;
							break;
						}
					}
				}	
			}
		}			
		
		public static function getLightByName(lightName:String):LightBase
		{
			var light:LightBase;
			
			for each(var l:LightBase in lights)
			{
				if (l.name == lightName)
				{
					light = l;
					break;
				}
			}
			
			return light;
		}			
		
		
		// Meshes Handling *********************************************************************************************************************************************
		
		public static function addMesh(mesh:Mesh):void
		{			
			mesh.mouseEnabled = true;
			mesh.pickingCollider = PickingColliderType.AS3_BEST_HIT;
			mesh.addEventListener(MouseEvent3D.CLICK, instance.handleMouseEvent3D);			
			
			scene.addChild(mesh);
			
			meshes.push(mesh);
		}		
		
		public static function removeMesh(mesh:Mesh):void
		{
			scene.removeChild(mesh);
			
			for (var i:int=0;i<meshes.length;i++)
			{
				if (meshes[i] == mesh)
				{
					meshes.splice(i, 1);
					break;
				}
			}
		}
		
		public static function getMeshByName(meshName:String):Mesh
		{
			var mesh:Mesh;
			
			for each(var m:Mesh in meshes)
			{
				if (m.name == meshName)
				{
					mesh = m;
					break;
				}
			}
			
			return mesh;
		}		
		
		private function handleMouseEvent3D(e:Event):void 
		{
			if (!CameraManager.hasMoved)
			{
				if (Mesh(e.target).showBounds) unSelectMeshByName(e.target.name);
				else selectMeshByName(e.target.name);		
				
				trace("SELECTED MESHES");
				for each(var m:Mesh in selectedMeshes) trace(m.name);
				trace("---");
			}
		}					
		
		public static function unselectAllMeshes():void
		{
			for each(var m:Mesh in meshes)
			{
				m.showBounds = false;
			}
			
			selectedMeshes = new Array();
			selectedMesh = null;
		}
		
		public static function unSelectMeshByName(meshName:String):void
		{
			for(var i:int=0;i<selectedMeshes.length;i++)
			{
				var m:Mesh = selectedMeshes[i];
				if (m.name == meshName)
				{
					m.showBounds = false;
					selectedMeshes.splice(i, 1);			
					selectedMesh = selectedMeshes[selectedMeshes.length-1];
					
					break;
				}
			}			
		}		
		
		public static function selectMeshByName(meshName:String):void
		{
			for each(var m:Mesh in meshes)
			{
				if (m.name == meshName)
				{
					if (!m.showBounds)
					{
						m.showBounds = true;
						selectedMeshes.push(m);						
						selectedMesh = m;
					}

					break;
				}
			}			
		}
		
	}
}