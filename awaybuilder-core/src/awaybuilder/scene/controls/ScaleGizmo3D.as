package awaybuilder.scene.controls
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.ConeGeometry;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.CylinderGeometry;
	
	import awaybuilder.scene.controllers.CameraManager;
	import awaybuilder.scene.controllers.Scene3DManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	public class ScaleGizmo3D extends Gizmo3DBase
	{		
		private var xCylinder:Mesh;
		private var yCylinder:Mesh;
		private var zCylinder:Mesh;
		
		private var xCube:Mesh;
		private var yCube:Mesh;
		private var zCube:Mesh;
		
		private var mCube:Mesh;
		
		private var initPosition:Vector3D;
		
		public function ScaleGizmo3D()
		{
			var cubeGeom:CubeGeometry = new CubeGeometry(20, 20, 20, 1, 1, 1, true);
			var cylGeom:CylinderGeometry = new CylinderGeometry(5, 5, 100, 16, 1, true, true, true, false);
			
			mCube = new Mesh(cubeGeom, new ColorMaterial());
			mCube.name = "allAxis";
			mCube.pickingCollider = PickingColliderType.AS3_BEST_HIT;
			mCube.mouseEnabled = true;
			mCube.addEventListener(MouseEvent3D.MOUSE_DOWN, handleMouseDown);
			mCube.addEventListener(MouseEvent3D.MOUSE_UP, handleMouseUp);			
			this.addChild(mCube);							
			
			xCylinder = new Mesh(cylGeom, xAxisMaterial);
			xCylinder.name = "xAxis";
			xCylinder.pickingCollider = PickingColliderType.AS3_BEST_HIT;
			xCylinder.mouseEnabled = true;
			xCylinder.addEventListener(MouseEvent3D.MOUSE_DOWN, handleMouseDown);
			xCylinder.addEventListener(MouseEvent3D.MOUSE_UP, handleMouseUp);
			xCylinder.x = 50;
			xCylinder.rotationY = -90;
			this.addChild(xCylinder);		
			
			xCube = new Mesh(cubeGeom, xAxisMaterial);
			xCube.name = "xAxis";
			xCube.pickingCollider = PickingColliderType.AS3_BEST_HIT;
			xCube.mouseEnabled = true;
			xCube.addEventListener(MouseEvent3D.MOUSE_DOWN, handleMouseDown);
			xCube.addEventListener(MouseEvent3D.MOUSE_UP, handleMouseUp);			
			xCube.rotationY = -90;
			xCube.x = 100 + (cubeGeom.height/2);
			this.addChild(xCube);					
			
			yCylinder = new Mesh(cylGeom, yAxisMaterial);
			yCylinder.name = "yAxis";
			yCylinder.pickingCollider = PickingColliderType.AS3_BEST_HIT;
			yCylinder.mouseEnabled = true;
			yCylinder.addEventListener(MouseEvent3D.MOUSE_DOWN, handleMouseDown);
			yCylinder.addEventListener(MouseEvent3D.MOUSE_UP, handleMouseUp);
			yCylinder.y = 50;
			yCylinder.rotationX = -90;
			this.addChild(yCylinder);			
			
			yCube = new Mesh(cubeGeom, yAxisMaterial);
			yCube.name = "yAxis";
			yCube.pickingCollider = PickingColliderType.AS3_BEST_HIT;
			yCube.mouseEnabled = true;
			yCube.addEventListener(MouseEvent3D.MOUSE_DOWN, handleMouseDown);
			yCube.addEventListener(MouseEvent3D.MOUSE_UP, handleMouseUp);			
			yCube.rotationX = 90;
			yCube.y = 100 + (cubeGeom.height/2);
			this.addChild(yCube);			
			
			zCylinder = new Mesh(cylGeom, zAxisMaterial);
			zCylinder.name = "zAxis";
			zCylinder.pickingCollider = PickingColliderType.AS3_BEST_HIT;
			zCylinder.mouseEnabled = true;
			zCylinder.addEventListener(MouseEvent3D.MOUSE_DOWN, handleMouseDown);
			zCylinder.addEventListener(MouseEvent3D.MOUSE_UP, handleMouseUp);
			zCylinder.z = 50;
			this.addChild(zCylinder);			
			
			zCube = new Mesh(cubeGeom, zAxisMaterial);
			zCube.name = "zAxis";
			zCube.pickingCollider = PickingColliderType.AS3_BEST_HIT;
			zCube.mouseEnabled = true;
			zCube.addEventListener(MouseEvent3D.MOUSE_DOWN, handleMouseDown);
			zCube.addEventListener(MouseEvent3D.MOUSE_UP, handleMouseUp);			
			zCube.rotationX = 180;
			zCube.z = 100 + (cubeGeom.height/2);
			this.addChild(zCube);
			
			
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
					
					xCube.material = highlightMaterial;
					xCylinder.material = highlightMaterial;
					
					break;
				
				case "yAxis":
					
					yCube.material = highlightMaterial;
					yCylinder.material = highlightMaterial;
					
					break;
				
				case "zAxis":
					
					zCube.material = highlightMaterial;
					zCylinder.material = highlightMaterial;
					
					break;		
				
				case "allAxis":
					
					mCube.material = highlightMaterial;
					
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
			
			var trans:Number = ((dx+dy)/2);
			
			var actualMesh:ObjectContainer3D = currentMesh;
			
			if (currentMesh.parent is LightGizmo3D) actualMesh = currentMesh.parent.parent;			
			
			var mScale:Object = new Object();
			mScale.x = actualMesh.scaleX;
			mScale.y = actualMesh.scaleY;
			mScale.z = actualMesh.scaleZ;
			
			switch(currentAxis)
			{
				case "xAxis":
					
					var xv1:Vector3D = Scene3DManager.camera.rightVector;
					var xv2:Vector3D = this.rightVector; 
					xv1.normalize();
					xv2.normalize();
					var ax:Number = xv1.dotProduct(xv2);
					if (ax < 0) trans = -trans;					
					
					mScale.x += trans;
					
					break;
				
				case "yAxis":
					
					var yv1:Vector3D = Scene3DManager.camera.upVector;
					var yv2:Vector3D = this.upVector; 			
					yv1.normalize();
					yv2.normalize();
					var ay:Number = yv1.dotProduct(yv2);
					if (ay < 0) trans = -trans;					
										
					mScale.y += trans;
					
					break;
				
				case "zAxis":
					
					var zv1:Vector3D = Scene3DManager.camera.rightVector;
					var zv2:Vector3D = this.forwardVector; 			
					zv1.normalize();
					zv2.normalize();
					var az:Number = zv1.dotProduct(zv2);
					if (az < 0) trans = -trans;					
					
					mScale.z += trans;
					
					break;				
				
				case "allAxis":
									
					mScale.x += trans;
					mScale.y += trans;
					mScale.z += trans;
					
					break;				
				
				
			}							
			
			actualMesh.scaleX = mScale.x;					
			actualMesh.scaleY = mScale.y;
			actualMesh.scaleZ = mScale.z;
			
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
			
			mCube.material = new ColorMaterial();
			xCube.material = xAxisMaterial;
			xCylinder.material = xAxisMaterial;			
			yCube.material = yAxisMaterial;
			yCylinder.material = yAxisMaterial;			
			zCube.material = zAxisMaterial;
			zCylinder.material = zAxisMaterial;			
		}		
		
	}
}