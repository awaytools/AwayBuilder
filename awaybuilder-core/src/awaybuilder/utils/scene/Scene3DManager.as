package awaybuilder.utils.scene
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	import away3d.core.pick.PickingColliderType;
	import away3d.core.pick.PickingType;
	import away3d.entities.Entity;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.events.Stage3DEvent;
	import away3d.lights.LightBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.WireframePlane;
	
	import awaybuilder.utils.scene.modes.GizmoMode;
	import awaybuilder.view.scene.OrientationTool;
	import awaybuilder.view.scene.controls.Gizmo3DBase;
	import awaybuilder.view.scene.controls.LightGizmo3D;
	import awaybuilder.view.scene.controls.RotateGizmo3D;
	import awaybuilder.view.scene.controls.ScaleGizmo3D;
	import awaybuilder.view.scene.controls.TranslateGizmo3D;
	import awaybuilder.view.scene.events.Gizmo3DEvent;
	import awaybuilder.view.scene.events.Scene3DManagerEvent;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import mx.collections.ArrayList;
	import mx.core.UIComponent;
	

	public class Scene3DManager extends EventDispatcher
	{
		// Singleton instance declaration
		public static const instance:Scene3DManager = new Scene3DManager();		
		public function Scene3DManager() { if ( instance ) throw new Error("Scene3DManager is a singleton"); }		
		
		public static var active:Boolean = true;

		public static var scope:UIComponent;
		public static var stage:Stage;
		public static var stage3DProxy:Stage3DProxy;
		public static var mode:String;
		public static var view:View3D;
		public static var scene:Scene3D;
		public static var camera:Camera3D;
		
		public static var selectedObjects:ArrayList = new ArrayList();// TODO: Use vector
		public static var selectedObject:Entity;
		public static var multiSelection:Boolean = false;
		
		public static var objects:ArrayList = new ArrayList(); // TODO: Use vector
		public static var lights:ArrayList = new ArrayList();// TODO: Use vector
		
		public static var grid:WireframePlane;
		public static var orientationTool:OrientationTool;
		
		public static var currentGizmo:Gizmo3DBase;
		public static var translateGizmo:TranslateGizmo3D;
		public static var rotateGizmo:RotateGizmo3D;
		public static var scaleGizmo:ScaleGizmo3D;
		
		private static var lightGizmos:ArrayList = new ArrayList();// TODO: Use vector
		
		public static function init(scope:UIComponent):void
		{
			Scene3DManager.scope = scope;			
			Scene3DManager.stage = scope.stage;
			
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
			view.camera.lens.near = 1;
			view.camera.lens.far = 100000;			
			view.camera.position = new Vector3D(0, 200, -1000);
			view.camera.rotationX = 0;
			view.camera.rotationY = 0;	
			view.camera.rotationZ = 0			
			scope.addChild(view);
			Scene3DManager.scene = view.scene;
			Scene3DManager.camera = view.camera;							
			
			
			//Create Gizmos
			translateGizmo = new TranslateGizmo3D();
			translateGizmo.addEventListener(Gizmo3DEvent.MOVE, handleGizmoAction);
			translateGizmo.addEventListener(Gizmo3DEvent.RELEASE, handleGizmoActionRelease);
			scene.addChild(translateGizmo);
			rotateGizmo = new RotateGizmo3D();
			rotateGizmo.addEventListener(Gizmo3DEvent.MOVE, handleGizmoAction);
			rotateGizmo.addEventListener(Gizmo3DEvent.RELEASE, handleGizmoActionRelease);
			scene.addChild(rotateGizmo);
			scaleGizmo = new ScaleGizmo3D();
			scaleGizmo.addEventListener(Gizmo3DEvent.MOVE, handleGizmoAction);
			scaleGizmo.addEventListener(Gizmo3DEvent.RELEASE, handleGizmoActionRelease);
			scene.addChild(scaleGizmo);	
			
			//assing default gizmo
			currentGizmo = translateGizmo;
			
			
			//Create OrientationTool			
			orientationTool = new OrientationTool();
			scope.addChild(orientationTool);
			scope.name = "scope";
			orientationTool.name = "orientationTool";
			view.name = "view";
			
			
			//Create Grid
			grid = new WireframePlane(10000, 10000, 100, 100, 0x000000, 1, "xz");
			grid.mouseEnabled = false;
			scene.addChild(grid);	
			
			
			//Camera Settings
			CameraManager.init(scope, view);	
			
			
			//handle stage events
			stage.addEventListener(MouseEvent.MOUSE_DOWN, instance.onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, instance.onMouseUp);			
			//scope.addEventListener(MouseEvent.MOUSE_OVER, instance.onMouseOver);
			//scope.addEventListener(MouseEvent.MOUSE_OUT, instance.onMouseOut);
			
			scope.addEventListener(Event.RESIZE, instance.handleScreenSize);
			instance.resize();
			
			stage3DProxy.addEventListener(Event.ENTER_FRAME, instance.loop);		
			
			dispatchEvent(new Scene3DManagerEvent(Scene3DManagerEvent.READY));
		}
		
		private function handleGizmoActionRelease(e:Gizmo3DEvent):void
		{
			dispatchEvent(new Scene3DManagerEvent(Scene3DManagerEvent.TRANSFORM_RELEASE, e.mode, e.object, e.currentValue, e.startValue, e.endValue));
		}
						
		private function handleGizmoAction(e:Gizmo3DEvent):void
		{
			dispatchEvent(new Scene3DManagerEvent(Scene3DManagerEvent.TRANSFORM, e.mode, e.object, e.currentValue, e.startValue, e.endValue));
		}
		
		private function loop(e:Event):void 
		{
			orientationTool.update();
			currentGizmo.update();
			
			view.render();			
		}		
		
		private function handleScreenSize(e:Event=null):void 
		{
//			resize();
			scope.addEventListener(Event.ENTER_FRAME, validateSizeOnNextFrame );
		}	
		private function validateSizeOnNextFrame( e:Event ):void 
		{
			resize();
		}	
		private function resize():void 
		{
			scope.removeEventListener(Event.ENTER_FRAME, validateSizeOnNextFrame );
			orientationTool.x = scope.width - orientationTool.width - 10;
			orientationTool.y = 5;
			
			var position:Point = scope.localToGlobal(new Point(0, 0));
			stage3DProxy.x = position.x;
			stage3DProxy.y = position.y;
			stage3DProxy.width = scope.width;
			stage3DProxy.height = scope.height;			
			
			view.width = scope.width;
			view.height = scope.height;
		}
		
		// Mouse Events *************************************************************************************************************************************************
				
		private function onMouseDown(e:MouseEvent):void
		{
			
		}			
		
		private function onMouseUp(e:MouseEvent):void
		{
			if (active)
			{
				if (!CameraManager.hasMoved && !multiSelection && !currentGizmo.active) unselectAll();	
			}	
		}			
		
		//Change gizmo mode to transform the selected mesh
		public static function setTransformMode(mode:String):void
		{
			currentGizmo.active = false;
			currentGizmo.hide();			
			
			switch (mode) 
			{													
				case GizmoMode.TRANSLATE : currentGizmo = translateGizmo;
					
					break;				
				
				case GizmoMode.ROTATE: currentGizmo = rotateGizmo;
					
					break;				
				
				case GizmoMode.SCALE: currentGizmo = scaleGizmo;
					
					break;													
			}
			
			if (selectedObject) currentGizmo.show(selectedObject);			
		}
		
		// Lights Handling *********************************************************************************************************************************************
		
		public static function addLight(light:LightBase):void
		{
			var gizmo:LightGizmo3D = new LightGizmo3D(light); 
			gizmo.cone.addEventListener(MouseEvent3D.CLICK, instance.handleMouseEvent3D);
			light.addChild(gizmo);
			lightGizmos.addItem(gizmo);
			objects.addItem(light);
			
			scene.addChild(light);
			lights.addItem(light);
		}
		
		public static function removeLight(light:LightBase):void
		{
			scene.removeChild(light);
			
			for (var i:int=0;i<lights.length;i++)
			{
				if (lights.getItemAt(i) == light)
				{
					lights.removeItemAt(i);
					lightGizmos.removeItemAt(i);
					break;
				}
			}
		}	
		
		public static function addLightToMesh(mesh:Mesh, lightName:String):void
		{
			if (mesh.material) 
			{
				if (!mesh.material.lightPicker)	mesh.material.lightPicker = new StaticLightPicker([]);
			
				for each(var l:LightBase in lights.source)
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
			
			for each(var l:LightBase in lights.source)
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
		
		public static function clear(disposeMaterials:Boolean=false):void
		{
			for each(var o:ObjectContainer3D in objects.source)
			{
				if (o is Mesh)
				{
					if (Mesh(o).material && disposeMaterials) Mesh(o).material.dispose();
				}
				scene.removeChild(o);
			}
			
			for each(var l:LightBase in lights.source)
			{
				l.dispose();
			}			
			
			lights.removeAll();
			objects.removeAll();
		}
		
		public static function addObject(o:ObjectContainer3D):void
		{		
			addMousePicker(o);
			
			scene.addChild(o);
			
			objects.addItem(o);
		}
		
		public static function removeMesh(mesh:Mesh):void
		{
			scene.removeChild(mesh);
			
			for (var i:int=0;i<objects.length;i++)
			{
				if (objects.getItemAt(i) == mesh)
				{
					objects.removeItemAt(i);
					//meshes.splice(i, 1);
					break;
				}
			}
		}
		
//		public static function getObjectByName(mName:String):Entity
//		{
//			var mesh:Mesh;
//			
//			for each(var m:Mesh in objects.source)
//			{
//				if (m.name == mName)
//				{
//					mesh = m;
//					break;
//				}
//			}
//			
//			return mesh;
//		}		
		

		private static function addMousePicker(o : ObjectContainer3D) : void
		{
			o.mouseEnabled = true;

			var m:Mesh = o as Mesh;
			if (m) 
				m.pickingCollider = PickingColliderType.PB_BEST_HIT;
			
			var container:ObjectContainer3D;
			for (var c:int = 0; c<o.numChildren; c++) {
				container = o.getChildAt(c) as ObjectContainer3D;
				if (container) addMousePicker(container);
			}
			o.addEventListener(MouseEvent3D.CLICK, instance.handleMouseEvent3D);			
		}
		
		private function handleMouseEvent3D(e:Event):void 
		{
			if (!CameraManager.hasMoved && !currentGizmo.hasMoved && active)
			{
				var mesh:Mesh = toggleMeshBounds(e.target as ObjectContainer3D);
				if (mesh.showBounds) unSelectObjectByName(mesh.name);
				else selectObjectByName(mesh.name);					
			}
		}

		private function toggleMeshBounds(o : ObjectContainer3D) : Mesh {
			var m:Mesh = o as Mesh;
			if (m) return m;

			var container:ObjectContainer3D;
			for (var c:int = 0; c<o.numChildren; c++) {
				container = o.getChildAt(c) as ObjectContainer3D;
				return toggleMeshBounds(container);
			}
			
			return m;
		}
		
		public static function unselectAll():void
		{
			for(var i:int=0;i<selectedObjects.length;i++)
			{
				var m:Entity = selectedObjects.getItemAt(i) as Entity;
				m.showBounds = false;
			}
			
			selectedObjects = new ArrayList();
			selectedObject = null;
			currentGizmo.hide();
		}
		
		public static function unSelectObjectByName(meshName:String):void
		{
			for(var i:int=0;i<selectedObjects.length;i++)
			{
				var m:Entity = selectedObjects.getItemAt(i) as Entity;
				if (m.name == meshName)
				{
					if (m is Mesh) m.showBounds = false;			
					selectedObject = selectedObjects.getItemAt(selectedObjects.length-1) as Entity;
					
					break;
				}
			}	
			
			instance.dispatchEvent(new Scene3DManagerEvent(Scene3DManagerEvent.MESH_SELECTED));
		}		
		
		// TODO: Use mesh link instead of name
		private static function selectObjectByName(meshName:String):void // Must be used internally only, otherwise use "selectObject", event must not be dispatched
		{		
			selectObject( meshName );
			instance.dispatchEvent(new Scene3DManagerEvent(Scene3DManagerEvent.MESH_SELECTED));
		}
		
		public static function selectObject(meshName:String):void 
		{			
			if (!multiSelection) unselectAll();
			
			// TODO: Check if object already selected
			for each(var m:ObjectContainer3D in objects.source)
			{
				selectObjectInContainer(m, meshName);
			}
		}

		private static function selectObjectInContainer(o : ObjectContainer3D, meshName : String) : void {

			var m:Mesh = o as Mesh;
			if (m && m.name == meshName)
			{
				if (!m.showBounds)
				{
					if (m is Mesh) m.showBounds = true;
					selectedObjects.addItem(m);						
					selectedObject = m;
					currentGizmo.show(selectedObject);
				}
			} else {
				for (var c:int = 0; c<o.numChildren; c++) {
					var container:ObjectContainer3D = o.getChildAt(c) as ObjectContainer3D;
					selectObjectInContainer(container, meshName);
				}
			}
		}
		
	}
}