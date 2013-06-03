package awaybuilder.view.scene.controls
{
	import flash.geom.Matrix3D;
	import away3d.core.math.Matrix3DUtils;
	import away3d.core.math.Vector3DUtils;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.primitives.ConeGeometry;
	import away3d.primitives.CylinderGeometry;
	
	import awaybuilder.utils.scene.CameraManager;
	import awaybuilder.utils.scene.Scene3DManager;
	import awaybuilder.utils.scene.modes.GizmoMode;
	import awaybuilder.view.scene.events.Gizmo3DEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	public class TranslateGizmo3D extends Gizmo3DBase
	{		
		private var xCylinder:Mesh;
		private var yCylinder:Mesh;
		private var zCylinder:Mesh;
		
		private var xCone:Mesh;
		private var yCone:Mesh;
		private var zCone:Mesh;
		
		private var initPosition:Vector3D;
		
		private var startValue:Vector3D;
		private var endValue:Vector3D;
		
		private var actualMesh:ObjectContainer3D;
		
		public function TranslateGizmo3D()
		{
			type = TRANSLATE_GIZMO;
			
			var coneGeom:ConeGeometry = new ConeGeometry(10, 20, 16, 1, true, false);
			var cylGeom:CylinderGeometry = new CylinderGeometry(5, 5, 100, 16, 1, true, true, true, false);		
			
			xCylinder = new Mesh(cylGeom, xAxisMaterial);			
			xCylinder.name = "xAxis";
			xCylinder.pickingCollider = PickingColliderType.PB_BEST_HIT;
			xCylinder.mouseEnabled = true;
			xCylinder.addEventListener(MouseEvent3D.MOUSE_OVER, handleMouseOver);
			xCylinder.addEventListener(MouseEvent3D.MOUSE_OUT, handleMouseOut);			
			xCylinder.addEventListener(MouseEvent3D.MOUSE_DOWN, handleMouseDown);
			xCylinder.x = 50;
			xCylinder.rotationY = -90;
			content.addChild(xCylinder);		
			
			xCone = new Mesh(coneGeom, xAxisMaterial);
			xCone.name = "xAxis";
			xCone.pickingCollider = PickingColliderType.PB_BEST_HIT;
			xCone.mouseEnabled = true;
			xCone.addEventListener(MouseEvent3D.MOUSE_OVER, handleMouseOver);
			xCone.addEventListener(MouseEvent3D.MOUSE_OUT, handleMouseOut);			
			xCone.addEventListener(MouseEvent3D.MOUSE_DOWN, handleMouseDown);	
			xCone.rotationY = -90;
			xCone.x = 100 + (coneGeom.height/2);
			content.addChild(xCone);					
			
			yCylinder = new Mesh(cylGeom, yAxisMaterial);
			yCylinder.name = "yAxis";
			yCylinder.pickingCollider = PickingColliderType.PB_BEST_HIT;
			yCylinder.mouseEnabled = true;
			yCylinder.addEventListener(MouseEvent3D.MOUSE_OVER, handleMouseOver);
			yCylinder.addEventListener(MouseEvent3D.MOUSE_OUT, handleMouseOut);			
			yCylinder.addEventListener(MouseEvent3D.MOUSE_DOWN, handleMouseDown);
			yCylinder.y = 50;
			yCylinder.rotationX = -90;
			content.addChild(yCylinder);			
			
			yCone = new Mesh(coneGeom, yAxisMaterial);
			yCone.name = "yAxis";
			yCone.pickingCollider = PickingColliderType.PB_BEST_HIT;
			yCone.mouseEnabled = true;
			yCone.addEventListener(MouseEvent3D.MOUSE_OVER, handleMouseOver);
			yCone.addEventListener(MouseEvent3D.MOUSE_OUT, handleMouseOut);			
			yCone.addEventListener(MouseEvent3D.MOUSE_DOWN, handleMouseDown);		
			yCone.rotationX = 90;
			yCone.y = 100 + (coneGeom.height/2);
			content.addChild(yCone);			
			
			zCylinder = new Mesh(cylGeom, zAxisMaterial);
			zCylinder.name = "zAxis";
			zCylinder.pickingCollider = PickingColliderType.PB_BEST_HIT;			
			zCylinder.mouseEnabled = true;
			zCylinder.addEventListener(MouseEvent3D.MOUSE_OVER, handleMouseOver);
			zCylinder.addEventListener(MouseEvent3D.MOUSE_OUT, handleMouseOut);			
			zCylinder.addEventListener(MouseEvent3D.MOUSE_DOWN, handleMouseDown);
			zCylinder.z = 50;
			content.addChild(zCylinder);			
			
			zCone = new Mesh(coneGeom, zAxisMaterial);
			zCone.name = "zAxis";
			zCone.pickingCollider = PickingColliderType.PB_BEST_HIT;
			zCone.mouseEnabled = true;
			zCone.addEventListener(MouseEvent3D.MOUSE_OVER, handleMouseOver);
			zCone.addEventListener(MouseEvent3D.MOUSE_OUT, handleMouseOut);			
			zCone.addEventListener(MouseEvent3D.MOUSE_DOWN, handleMouseDown);		
			zCone.rotationX = 180;
			zCone.z = 100 + (coneGeom.height/2);
			content.addChild(zCone);	
		}
		
		protected function handleMouseOut(event:MouseEvent3D):void
		{
			if (!active) 
			{
				switch(event.target.name)
				{					
					case "xAxis":
						
						xCone.material = xAxisMaterial;
						xCylinder.material = xAxisMaterial;
						
						break;
					
					case "yAxis":
						
						yCone.material = yAxisMaterial;
						yCylinder.material = yAxisMaterial;
						
						break;
					
					case "zAxis":
						
						zCone.material = zAxisMaterial;
						zCylinder.material = zAxisMaterial;
						
						break;								
				}							
			}			
		}
		
		protected function handleMouseOver(event:MouseEvent3D):void
		{
			if (!active) 
			{
				switch(event.target.name)
				{
					case "xAxis":
						
						xCone.material = highlightOverMaterial;
						xCylinder.material = highlightOverMaterial;
						
						break;
					
					case "yAxis":
						
						yCone.material = highlightOverMaterial;
						yCylinder.material = highlightOverMaterial;
						
						break;
					
					case "zAxis":
						
						zCone.material = highlightOverMaterial;
						zCylinder.material = highlightOverMaterial;
						
						break;								
				}							
			}			
		}		
		
		override public function update():void
		{			
			super.update();
		}			
		
		protected function handleMouseDown(e:Event):void
		{
			currentAxis = e.target.name
			
			click.x = Scene3DManager.stage.mouseX;
			click.y = Scene3DManager.stage.mouseY;				
				
			if (currentMesh.parent is LightGizmo3D) actualMesh = (currentMesh.parent as LightGizmo3D).sceneObject;
			else if (currentMesh.parent is ContainerGizmo3D) actualMesh = (currentMesh.parent as ContainerGizmo3D).sceneObject;
			else if (currentMesh.parent is TextureProjectorGizmo3D) actualMesh = (currentMesh.parent as TextureProjectorGizmo3D).sceneObject;
			else actualMesh = currentMesh;
			
			startValue = actualMesh.position;

			switch(currentAxis)
			{
				case "xAxis":
					
					xCone.material = highlightDownMaterial;
					xCylinder.material = highlightDownMaterial;
					
					break;
				
				case "yAxis":
					
					yCone.material = highlightDownMaterial;
					yCylinder.material = highlightDownMaterial;
					
					break;
				
				case "zAxis":
					
					zCone.material = highlightDownMaterial;
					zCylinder.material = highlightDownMaterial;
					
					break;				
			}
			
			hasMoved = true;
			active = true;
			CameraManager.active = false;				
				
			Scene3DManager.stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			Scene3DManager.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
		}
		
		protected function handleMouseMove(e:MouseEvent):void
		{
			var dx:Number = Scene3DManager.stage.mouseX - click.x;
			var dy:Number = -(Scene3DManager.stage.mouseY - click.y);
			
			var trans:Number = (dx+dy) * (CameraManager.radius / 500);
			
			switch(currentAxis)
			{
				case "xAxis":
					
					var xv1:Vector3D = Scene3DManager.camera.rightVector;
					var xv2:Vector3D = content.rightVector; 
					xv1.normalize();
					xv2.normalize();
					var ax:Number = xv1.dotProduct(xv2);
					
					if (ax < 0) trans = -trans;					
					
					this.translate(content.rightVector, trans);
					
					break;
				
				case "yAxis":
					
					var yv1:Vector3D = Scene3DManager.camera.upVector;
					var yv2:Vector3D = content.upVector; 			
					yv1.normalize();
					yv2.normalize();
					var ay:Number = yv1.dotProduct(yv2);
					if (ay < 0) trans = -trans;					
					
					this.translate(content.upVector, trans);
					
					break;
				
				case "zAxis":
					
					var zv1:Vector3D = Scene3DManager.camera.rightVector;
					var zv2:Vector3D = content.forwardVector; 			
					zv1.normalize();
					zv2.normalize();
					var az:Number = zv1.dotProduct(zv2);
					if (az < 0) trans = -trans;					
					
					this.translate(content.forwardVector, trans);						
					
					break;				
			}					
			
			click.x = Scene3DManager.stage.mouseX;
			click.y = Scene3DManager.stage.mouseY;			
			
			var pos:Vector3D = this.position.clone();
			var rad:Number = 180/Math.PI;
			var objectEulers:Vector3D =Vector3DUtils.matrix2euler(actualMesh.parent.transform);
			objectEulers.x *= -rad;
			objectEulers.y *= -rad;
			objectEulers.z *= -rad;
			pos = Vector3DUtils.rotatePoint(pos, objectEulers);
			actualMesh.position = pos;
			
			Scene3DManager.updateDefaultCameraFarPlane();

			dispatchEvent(new Gizmo3DEvent(Gizmo3DEvent.MOVE, GizmoMode.TRANSLATE, actualMesh, actualMesh.position, startValue, actualMesh.position));
		}
		
		protected function handleMouseUp(event:Event):void
		{
			Scene3DManager.stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			Scene3DManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			
			currentAxis = "";
			active = false;
			CameraManager.active = true;
			
			xCone.material = xAxisMaterial;
			xCylinder.material = xAxisMaterial;			
			yCone.material = yAxisMaterial;
			yCylinder.material = yAxisMaterial;			
			zCone.material = zAxisMaterial;
			zCylinder.material = zAxisMaterial;			

			dispatchEvent(new Gizmo3DEvent(Gizmo3DEvent.RELEASE, GizmoMode.TRANSLATE, actualMesh, actualMesh.position, startValue, actualMesh.position.clone()));
		}		
		
	}
}