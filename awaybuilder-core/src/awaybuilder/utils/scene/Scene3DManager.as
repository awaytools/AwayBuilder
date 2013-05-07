package awaybuilder.utils.scene
{
	import away3d.tools.utils.Bounds;
	import avmplus.getQualifiedClassName;
	
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
	import away3d.library.AssetLibrary;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.SkyBox;
	import away3d.primitives.WireframePlane;
	
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.utils.MathUtils;
	import awaybuilder.utils.scene.modes.GizmoMode;
	import awaybuilder.view.scene.OrientationTool;
	import awaybuilder.view.scene.controls.ContainerGizmo3D;
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
		public static const instance : Scene3DManager = new Scene3DManager();
		public function Scene3DManager() { if ( instance ) throw new Error("Scene3DManager is a singleton"); }		
		
		public static var active:Boolean = true;

		public static var scope:UIComponent;
		public static var stage:Stage;
		public static var stage3DProxy:Stage3DProxy;
		public static var mode:String;
		public static var view:View3D;
		public static var directionalLightView:View3D;
		public static var gizmoView : View3D;
		public static var scene:Scene3D;
		public static var camera:Camera3D;
		
		public static var selectedObjects:ArrayList = new ArrayList();// TODO: Use vector
		public static var selectedObject:Entity;
		public static var multiSelection:Boolean = false;
		public static var mouseSelection:ObjectContainer3D;
		
		public static var objects:ArrayList = new ArrayList(); // TODO: Use vector
		public static var lights:ArrayList = new ArrayList();// TODO: Use vector
		
		public static var grid:WireframePlane;
		public static var orientationTool:OrientationTool;
		
		public static var currentGizmo:Gizmo3DBase;
		public static var translateGizmo:TranslateGizmo3D;
		public static var rotateGizmo:RotateGizmo3D;
		public static var scaleGizmo:ScaleGizmo3D;
		
		public static var lightGizmos:Vector.<LightGizmo3D> = new Vector.<LightGizmo3D>();
		public static var containerGizmos:Vector.<ContainerGizmo3D> = new Vector.<ContainerGizmo3D>();
		
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
			view.camera.rotationZ = 0;			
			scope.addChild(view);
			Scene3DManager.scene = view.scene;
			Scene3DManager.camera = view.camera;							
			
			directionalLightView = new View3D();
			directionalLightView.shareContext = true;
			directionalLightView.layeredView = true;
			directionalLightView.stage3DProxy = stage3DProxy;	
			directionalLightView.mousePicker = PickingType.RAYCAST_BEST_HIT;
			directionalLightView.camera.lens.near = 1;
			directionalLightView.camera.lens.far = 100000;			
			scope.addChild(directionalLightView);

			//Create OrientationTool			
			orientationTool = new OrientationTool();
			scope.addChild(orientationTool);
			scope.name = "scope";
			orientationTool.name = "orientationTool";
			view.name = "view";

			gizmoView = new View3D();
			gizmoView.shareContext = true;
			gizmoView.stage3DProxy = stage3DProxy;	
			gizmoView.layeredView = true;
			gizmoView.mousePicker = PickingType.RAYCAST_BEST_HIT;
			gizmoView.camera = camera;
			scope.addChild(gizmoView);
			
			//Create Gizmos
			translateGizmo = new TranslateGizmo3D();
			translateGizmo.addEventListener(Gizmo3DEvent.MOVE, handleGizmoAction);
			translateGizmo.addEventListener(Gizmo3DEvent.RELEASE, handleGizmoActionRelease);
			gizmoView.scene.addChild(translateGizmo);
			rotateGizmo = new RotateGizmo3D();
			rotateGizmo.addEventListener(Gizmo3DEvent.MOVE, handleGizmoAction);
			rotateGizmo.addEventListener(Gizmo3DEvent.RELEASE, handleGizmoActionRelease);
			gizmoView.scene.addChild(rotateGizmo);
			scaleGizmo = new ScaleGizmo3D();
			scaleGizmo.addEventListener(Gizmo3DEvent.MOVE, handleGizmoAction);
			scaleGizmo.addEventListener(Gizmo3DEvent.RELEASE, handleGizmoActionRelease);
			gizmoView.scene.addChild(scaleGizmo);	
			
			//assing default gizmo
			currentGizmo = translateGizmo;
						
			
			//Create Grid
			grid = new WireframePlane(10000, 10000, 100, 100, 0x000000, 1, "xz");
			grid.mouseEnabled = false;
			scene.addChild(grid);	
			
			
			//Camera Settings
			CameraManager.init(scope, view);	
			
			
			//handle stage events
			scope.addEventListener(MouseEvent.MOUSE_DOWN, instance.onMouseDown);
			scope.addEventListener(MouseEvent.MOUSE_UP, instance.onMouseUp);			
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
			currentGizmo.update();
			updateLights();
			updateContainerGizmos();
			
			view.render();			
			updateDirectionalLightView();
			orientationTool.update();
			gizmoView.render();
		}

		private function updateDirectionalLightView() : void {
			directionalLightView.camera.eulers = Scene3DManager.camera.eulers;
			
			var camPos:Vector3D = getCameraPosition(CameraManager._xDeg, -CameraManager._yDeg);
			directionalLightView.camera.x = -camPos.x;
			directionalLightView.camera.y = -camPos.y;
			directionalLightView.camera.z = -camPos.z;
			
			directionalLightView.render();						
		}
		private function getCameraPosition(xDegree:Number, yDegree:Number):Vector3D
		{
			var cy:Number = Math.cos(MathUtils.convertToRadian(yDegree)) * Scene3DManager.view.height/2;			
			
			var v:Vector3D = new Vector3D();
			
			v.x = Math.sin(MathUtils.convertToRadian(xDegree)) * cy;
			v.y = Math.sin(MathUtils.convertToRadian(yDegree)) * Scene3DManager.view.height/2;
			v.z = Math.cos(MathUtils.convertToRadian(xDegree)) * cy;
			
			return v;
		}				
		private function updateLights() : void {
			var l:LightGizmo3D;
			var lI:int;
			for (lI=0; lI<lightGizmos.length; lI++) {
				l = lightGizmos[lI];
				l.updateLight();
			}
		}

		private function updateContainerGizmos() : void {
			var c:ContainerGizmo3D;
			var cI:int;
			for (cI=0; cI<containerGizmos.length; cI++) {
				c = containerGizmos[cI];
				c.updateContainer();
			}
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
			
			view.width = directionalLightView.width = gizmoView.width = scope.width;
			view.height = directionalLightView.height = gizmoView.height = scope.height;
		}
		
		// Mouse Events *************************************************************************************************************************************************
				
		private function onMouseDown(e:MouseEvent):void
		{
			
		}			
		
		private function onMouseUp(e:MouseEvent):void
		{
			if (active)
			{
				if (!CameraManager.hasMoved && !multiSelection && !currentGizmo.active && !orientationTool.orientationClicked) deselectAndDispatch();	
			}
			orientationTool.orientationClicked = false;
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
			
			if (selectedObject) {
				var isLightGizmo:LightGizmo3D = selectedObject.parent as LightGizmo3D;
			 	if (!isLightGizmo || 
					(isLightGizmo.type==LightGizmo3D.DIRECTIONAL_LIGHT && Scene3DManager.currentGizmo==rotateGizmo) ||
					(isLightGizmo.type==LightGizmo3D.POINT_LIGHT && Scene3DManager.currentGizmo==translateGizmo))
					currentGizmo.show(selectedObject);			
			}
		}
		
		// Lights Handling *********************************************************************************************************************************************
		
		public static function addLight(light:LightBase):void
		{
			var gizmo:LightGizmo3D = new LightGizmo3D(light); 
			gizmo.cone.addEventListener(MouseEvent3D.CLICK, instance.handleMouseEvent3D);
			lightGizmos.push(gizmo);
			
			if (light is DirectionalLight) Scene3DManager.directionalLightView.scene.addChild(gizmo);
			else scene.addChild(gizmo);
			if (light.parent == null) scene.addChild(light);
			
			if (lights.getItemIndex(light) == -1) lights.addItem(light);
		}
		
		public static function removeLight(light:LightBase):void
		{
			scene.removeChild(light);
			
			for (var i:int=0;i<lights.length;i++)
			{
				if (lights.getItemAt(i) == light)
				{
					lights.removeItemAt(i);
					var lG:LightGizmo3D = lightGizmos[i];
					if (light is DirectionalLight) Scene3DManager.directionalLightView.scene.removeChild(lG);
					else scene.removeChild(lG);
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
			if (currentGizmo) {
				currentGizmo.active = false;
				currentGizmo.hide();
			}
			
			AssetLibrary.removeAllAssets(true);
			
			for each(var o:ObjectContainer3D in objects.source)
			{
				if (o is Mesh)
				{
					if (Mesh(o).material && disposeMaterials) Mesh(o).material.dispose();
				}
				if (o && o.parent) {
					scene.removeChild(o);
					o.dispose();
				}
			}
			
			for each(var lG:LightGizmo3D in lightGizmos)
			{
				if (lG.parent) 
					lG.parent.removeChild(lG);
				lG.dispose();	
			}	
					
			for each(var l:LightBase in lights.source)
			{
				l.dispose();
			}			
			
			lights.removeAll();
			objects.removeAll();
		}
		
		public static function get sceneBounds() : Vector.<Number> {
			
			var min:Vector3D = new Vector3D(Infinity, Infinity, Infinity);
			var max:Vector3D = new Vector3D(-Infinity, -Infinity, -Infinity);
			
			for each(var o:ObjectContainer3D in objects.source) {
				if (!(o is SkyBox)) {
					Bounds.getObjectContainerBounds(o);
			
					if (Bounds.minX < min.x) min.x = Bounds.minX;
					if (Bounds.minY < min.y) min.y = Bounds.minY;
					if (Bounds.minZ < min.z) min.z = Bounds.minZ;
					if (Bounds.maxX > max.x) max.x = Bounds.maxX;
					if (Bounds.maxY > max.y) max.y = Bounds.maxY;
					if (Bounds.maxZ > max.z) max.z = Bounds.maxZ;
				}
			}

			return Vector.<Number>([min.x, min.y, min.z, max.x, max.y, max.z]);
		}
		
		public static function updateDefaultCameraFarPlane() : void {
			var bounds:Vector.<Number> = sceneBounds;
			if (bounds[0]==Infinity || bounds[1]==Infinity || bounds[2]==Infinity || bounds[3]==-Infinity || bounds[4]==-Infinity || bounds[5]==-Infinity)
				camera.lens.far = 100000;
			else {
				var radius:Number = Math.max((bounds[3] - bounds[0]), (bounds[4] - bounds[1]), (bounds[2] - bounds[5])) * 0.55;
				var dist:Number = camera.scenePosition.length + radius + (camera.scenePosition.length / radius);
				camera.lens.far = dist;
			}
		}
		
		public static function addObject(o:ObjectContainer3D):void
		{		
			addMousePicker(o);
			
			scene.addChild(o);
			
			objects.addItem(o);

			attachGizmos(o);
		}
		
		private static function attachGizmos(container:ObjectContainer3D) : void {			
			var childCtr:int = 0;
			while (childCtr < container.numChildren) {
				attachGizmos(container.getChildAt(childCtr++));
			}

			if (getQualifiedClassName(container)=="away3d.containers::ObjectContainer3D" && container.numChildren == 0) {
				var cG:ContainerGizmo3D = new ContainerGizmo3D(container);
				Scene3DManager.containerGizmos.push(cG);
				container.addChild(cG);
			}
		}
		
		public static function removeMesh(mesh:ObjectContainer3D):void
		{
			mesh.parent.removeChild(mesh);
			
			for (var i:int=0;i<objects.length;i++)
			{
				if (objects.getItemAt(i) == mesh)
				{
					objects.removeItemAt(i);
					break;
				}
			}
		}

		public static function removeContainer(container:ObjectContainer3D):void
		{
			container.parent.removeChild(container);
			
			for (var i:int=0;i<objects.length;i++)
			{
				if (objects.getItemAt(i) == container)
				{
					objects.removeItemAt(i);
					break;
				}
			}
		}

		public static function removeSkyBox(skyBox:SkyBox):void
		{
			skyBox.parent.removeChild(skyBox);
			
			for (var i:int=0;i<objects.length;i++)
			{
				if (objects.getItemAt(i) == skyBox)
				{
					objects.removeItemAt(i);
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
				var selectedMesh:ObjectContainer3D = e.target as ObjectContainer3D;
				var mesh:Mesh = toggleMeshBounds(selectedMesh);
				if (selectedMesh.parent is LightGizmo3D) { 
					selectedMesh = (selectedMesh.parent as LightGizmo3D).light;
					mouseSelection = selectedMesh;
				} else {
					mouseSelection = mesh;
				}
				instance.dispatchEvent(new Scene3DManagerEvent(Scene3DManagerEvent.MESH_SELECTED_FROM_VIEW));			
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
		
		public static function unselectAll():Boolean
		{
			var itemsDeselected:Boolean = false;
			for(var i:int=0;i<selectedObjects.length;i++)
			{
				var m:Entity = selectedObjects.getItemAt(i) as Entity;
				m.showBounds = false;
				itemsDeselected = true;
			}
			
			selectedObjects = new ArrayList();
			selectedObject = null;
			currentGizmo.hide();
			return itemsDeselected;
		}
		private static function deselectAndDispatch():void
		{
			if (unselectAll()) instance.dispatchEvent(new Scene3DManagerEvent(Scene3DManagerEvent.MESH_SELECTED));
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
			trace( "unSelectObjectByName" );
			instance.dispatchEvent(new Scene3DManagerEvent(Scene3DManagerEvent.MESH_SELECTED));
		}		
		
		// TODO: Use mesh link instead of name
//		private static function selectObjectByName(meshName:String):void // Must be used internally only, otherwise use "selectObject", event must not be dispatched
//		{		
//			//selectObject( meshName );
//			instance.dispatchEvent(new Scene3DManagerEvent(Scene3DManagerEvent.MESH_SELECTED));
//			//instance.dispatchEvent(new SceneEvent(SceneEvent.SELECT, );
//		}
		
		public static function selectObject(meshName:String):void 
		{			
			if (!multiSelection) unselectAll();
			
			// TODO: Check if object already selected
			for each(var m:ObjectContainer3D in objects.source)
			{
				selectObjectInContainer(m, meshName);
			}
			for each(var l:LightBase in lights.source)
			{
				selectLightInContainer(l, meshName);
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

		private static function selectLightInContainer(o : ObjectContainer3D, meshName : String) : void {

			var l:LightBase = o as LightBase;
			var m:Mesh;
			if (l && l.name == meshName) {
				var lG:LightGizmo3D;
				m = null;
				for each (lG in lightGizmos) {
					if (lG.light == l) {
						m = lG.cone;
	
						m.showBounds = true;
						selectedObjects.addItem(m);						
						selectedObject = m;
						
						if ((lG.type==LightGizmo3D.DIRECTIONAL_LIGHT && Scene3DManager.currentGizmo==rotateGizmo) ||
							(lG.type==LightGizmo3D.POINT_LIGHT && Scene3DManager.currentGizmo==translateGizmo))
							currentGizmo.show(selectedObject);
					}
				}
			} else {
				for (var c:int = 0; c<o.numChildren; c++) {
					var container:ObjectContainer3D = o.getChildAt(c) as ObjectContainer3D;
					selectLightInContainer(container, meshName);
				}
			}
		}
		
		public static function zoomDistanceDelta(delta:Number) : void {
			instance.dispatchEvent(new Scene3DManagerEvent(Scene3DManagerEvent.ZOOM_DISTANCE_DELTA, "", null, new Vector3D(delta, 0, 0)));
		}

		public static function zoomToDistance(distance:Number) : void {
			instance.dispatchEvent(new Scene3DManagerEvent(Scene3DManagerEvent.ZOOM_TO_DISTANCE, "", null, new Vector3D(distance, 0, 0)));
		}
	}
}