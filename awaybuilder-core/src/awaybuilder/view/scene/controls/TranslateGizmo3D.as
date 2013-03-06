package awaybuilder.view.scene.controls
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.lights.PointLight;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.ConeGeometry;
	import away3d.primitives.CylinderGeometry;
	
	import awaybuilder.utils.scene.CameraManager;
	import awaybuilder.utils.scene.Scene3DManager;
	
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
		
		public function TranslateGizmo3D()
		{
			var coneGeom:ConeGeometry = new ConeGeometry(10, 20, 16, 1, true, false);
			var cylGeom:CylinderGeometry = new CylinderGeometry(5, 5, 100, 16, 1, true, true, true, false);		
			
			xCylinder = new Mesh(cylGeom, xAxisMaterial);			
			xCylinder.name = "xAxis";
			xCylinder.pickingCollider = PickingColliderType.PB_BEST_HIT;
			xCylinder.mouseEnabled = true;
			xCylinder.addEventListener(MouseEvent3D.MOUSE_DOWN, handleMouseDown);
			xCylinder.addEventListener(MouseEvent3D.MOUSE_UP, handleMouseUp);
			xCylinder.x = 50;
			xCylinder.rotationY = -90;
			this.addChild(xCylinder);		
			
			xCone = new Mesh(coneGeom, xAxisMaterial);
			xCone.name = "xAxis";
			xCone.pickingCollider = PickingColliderType.PB_BEST_HIT;
			xCone.mouseEnabled = true;
			xCone.addEventListener(MouseEvent3D.MOUSE_DOWN, handleMouseDown);
			xCone.addEventListener(MouseEvent3D.MOUSE_UP, handleMouseUp);			
			xCone.rotationY = -90;
			xCone.x = 100 + (coneGeom.height/2);
			this.addChild(xCone);					
			
			yCylinder = new Mesh(cylGeom, yAxisMaterial);
			yCylinder.name = "yAxis";
			yCylinder.pickingCollider = PickingColliderType.PB_BEST_HIT;
			yCylinder.mouseEnabled = true;
			yCylinder.addEventListener(MouseEvent3D.MOUSE_DOWN, handleMouseDown);
			yCylinder.addEventListener(MouseEvent3D.MOUSE_UP, handleMouseUp);
			yCylinder.y = 50;
			yCylinder.rotationX = -90;
			this.addChild(yCylinder);			
			
			yCone = new Mesh(coneGeom, yAxisMaterial);
			yCone.name = "yAxis";
			yCone.pickingCollider = PickingColliderType.PB_BEST_HIT;
			yCone.mouseEnabled = true;
			yCone.addEventListener(MouseEvent3D.MOUSE_DOWN, handleMouseDown);
			yCone.addEventListener(MouseEvent3D.MOUSE_UP, handleMouseUp);			
			yCone.rotationX = 90;
			yCone.y = 100 + (coneGeom.height/2);
			this.addChild(yCone);			
			
			zCylinder = new Mesh(cylGeom, zAxisMaterial);
			zCylinder.name = "zAxis";
			zCylinder.pickingCollider = PickingColliderType.PB_BEST_HIT;
			zCylinder.mouseEnabled = true;
			zCylinder.addEventListener(MouseEvent3D.MOUSE_DOWN, handleMouseDown);
			zCylinder.addEventListener(MouseEvent3D.MOUSE_UP, handleMouseUp);
			zCylinder.z = 50;
			this.addChild(zCylinder);			
			
			zCone = new Mesh(coneGeom, zAxisMaterial);
			zCone.name = "zAxis";
			zCone.pickingCollider = PickingColliderType.PB_BEST_HIT;
			zCone.mouseEnabled = true;
			zCone.addEventListener(MouseEvent3D.MOUSE_DOWN, handleMouseDown);
			zCone.addEventListener(MouseEvent3D.MOUSE_UP, handleMouseUp);			
			zCone.rotationX = 180;
			zCone.z = 100 + (coneGeom.height/2);
			this.addChild(zCone);
			
				
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
				
			switch(currentAxis)
			{
				case "xAxis":
					
					xCone.material = highlightMaterial;
					xCylinder.material = highlightMaterial;
					
					break;
				
				case "yAxis":
					
					yCone.material = highlightMaterial;
					yCylinder.material = highlightMaterial;
					
					break;
				
				case "zAxis":
					
					zCone.material = highlightMaterial;
					zCylinder.material = highlightMaterial;
					
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
			
			var trans:Number = ((dx+dy)/2) * (this.scaleX+1);
			
			switch(currentAxis)
			{
				case "xAxis":
					
					var xv1:Vector3D = Scene3DManager.camera.rightVector;
					var xv2:Vector3D = this.rightVector; 
					xv1.normalize();
					xv2.normalize();
					var ax:Number = xv1.dotProduct(xv2);
					if (ax < 0) trans = -trans;					
					
					this.translate(this.rightVector, trans);
					
					break;
				
				case "yAxis":
					
					var yv1:Vector3D = Scene3DManager.camera.upVector;
					var yv2:Vector3D = this.upVector; 			
					yv1.normalize();
					yv2.normalize();
					var ay:Number = yv1.dotProduct(yv2);
					if (ay < 0) trans = -trans;					
					
					this.translate(this.upVector, trans);
					
					break;
				
				case "zAxis":
					
					var zv1:Vector3D = Scene3DManager.camera.rightVector;
					var zv2:Vector3D = this.forwardVector; 			
					zv1.normalize();
					zv2.normalize();
					var az:Number = zv1.dotProduct(zv2);
					if (az < 0) trans = -trans;					
					
					this.translate(this.forwardVector, trans);						
					
					break;				
			}					
			
			var actualMesh:ObjectContainer3D = currentMesh;
			
			if (currentMesh.parent is LightGizmo3D) actualMesh = currentMesh.parent.parent;
			
			actualMesh.position = this.position;					
			
			click.x = Scene3DManager.stage.mouseX;
			click.y = Scene3DManager.stage.mouseY;			
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
		}		
		
	}
}