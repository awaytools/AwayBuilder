package awaybuilder.scene.controls
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.math.Quaternion;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Mesh;
	import away3d.entities.SegmentSet;
	import away3d.events.MouseEvent3D;
	import away3d.primitives.LineSegment;
	import away3d.primitives.SphereGeometry;
	import away3d.primitives.TorusGeometry;
	
	import awaybuilder.scene.controllers.CameraManager;
	import awaybuilder.scene.controllers.Scene3DManager;
	import awaybuilder.scene.utils.MathUtils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	public class RotateGizmo3D extends Gizmo3DBase
	{	
		private var xTorus:Mesh;
		private var yTorus:Mesh;
		private var zTorus:Mesh;
		
		private var sphere:Mesh;
		
		private var freeXAxis:Vector3D = new Vector3D();
		private var freeYAxis:Vector3D = new Vector3D();
		private var freeZAxis:Vector3D = new Vector3D();
		private var lines:SegmentSet;
		private var xLine:LineSegment;
		private var yLine:LineSegment;
		private var zLine:LineSegment;
		
		private var quat:Quaternion = new Quaternion();
		private var t1 : Quaternion = new Quaternion();
		private var t2 : Quaternion = new Quaternion();
		
		public function RotateGizmo3D()
		{
			this.visible = false;
			
			var sphereGeom:SphereGeometry = new SphereGeometry(95, 16, 12, true);
			
			sphere = new Mesh(sphereGeom, sphereMaterial);
			sphere.name = "allAxis";
			sphere.pickingCollider = PickingColliderType.AS3_BEST_HIT;
			sphere.mouseEnabled = true;
			sphere.addEventListener(MouseEvent3D.MOUSE_DOWN, handleMouseDown);
			sphere.addEventListener(MouseEvent3D.MOUSE_UP, handleMouseUp);			
			this.addChild(sphere);
			
			var torusGeometry:TorusGeometry = new TorusGeometry(100, 5, 30, 8, false);
			
			xTorus = new Mesh(torusGeometry, xAxisMaterial);
			xTorus.name = "xAxis";
			xTorus.pickingCollider = PickingColliderType.AS3_BEST_HIT;
			xTorus.mouseEnabled = true;
			xTorus.addEventListener(MouseEvent3D.MOUSE_DOWN, handleMouseDown);
			xTorus.addEventListener(MouseEvent3D.MOUSE_UP, handleMouseUp);
			xTorus.rotationY = 90;
			this.addChild(xTorus);					
			
			yTorus = new Mesh(torusGeometry, yAxisMaterial);
			yTorus.name = "yAxis";
			yTorus.pickingCollider = PickingColliderType.AS3_BEST_HIT;
			yTorus.mouseEnabled = true;
			yTorus.addEventListener(MouseEvent3D.MOUSE_DOWN, handleMouseDown);
			yTorus.addEventListener(MouseEvent3D.MOUSE_UP, handleMouseUp);
			yTorus.rotationX = -90;
			this.addChild(yTorus);				
			
			zTorus = new Mesh(torusGeometry, zAxisMaterial);
			zTorus.name = "zAxis";
			zTorus.pickingCollider = PickingColliderType.AS3_BEST_HIT;
			zTorus.mouseEnabled = true;
			zTorus.addEventListener(MouseEvent3D.MOUSE_DOWN, handleMouseDown);
			zTorus.addEventListener(MouseEvent3D.MOUSE_UP, handleMouseUp);
			this.addChild(zTorus);			
			
			lines = new SegmentSet();	
			
			zLine = new LineSegment(new Vector3D(), new Vector3D(), 0xFFCC00, 0xFFCC00, 3);
			lines.addSegment(zLine);			
			
			xLine = new LineSegment(new Vector3D(), new Vector3D(), 0xFF0000, 0xFF0000, 3);
			lines.addSegment(xLine);
			
			yLine = new LineSegment(new Vector3D(), new Vector3D(), 0xCC99CC, 0xCC99CC, 3);
			lines.addSegment(yLine);			
			
			//Scene3DManager.scene.addChild(lines);
		}
		
		override public function update():void
		{			
			super.update();				
			
			freeXAxis = Scene3DManager.camera.rightVector.clone();							
			freeYAxis = Scene3DManager.camera.downVector.clone();
			freeZAxis = Scene3DManager.camera.forwardVector.clone();							
						
			freeZAxis.scaleBy(100);
			freeXAxis.scaleBy(100);
			freeYAxis.scaleBy(100);					
			
			xLine.end = freeXAxis;
			yLine.end = freeYAxis;			
			zLine.end = freeZAxis;			
		}		
		
		protected function handleMouseDown(e:MouseEvent3D):void
		{
			currentAxis = e.target.name			
							
			click.x = Scene3DManager.stage.mouseX;
			click.y = Scene3DManager.stage.mouseY;
			
			click2.x = Scene3DManager.stage.mouseX;
			click2.y = Scene3DManager.stage.mouseY;			
			
			switch(currentAxis)
			{
				case "xAxis":
					
					xTorus.material = highlightMaterial;
					
					break;
				
				case "yAxis":
					
					yTorus.material = highlightMaterial;
					
					break;
				
				case "zAxis":
					
					zTorus.material = highlightMaterial;
					
					break;				
				
				case "allAxis":				
					
					sphere.material = sphereHighlightMaterial;
					
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
			var dx:Number = (Scene3DManager.stage.mouseX - click.x);
			var dy:Number = -(Scene3DManager.stage.mouseY - click.y);
			
			var rx:Number = (Scene3DManager.stage.mouseX - click2.x);
			var ry:Number = -(Scene3DManager.stage.mouseY - click2.y);			
			
			var trans:Number = (dx+dy)/2;
			
			switch(currentAxis)
			{
				case "xAxis":
					
					var xv1:Vector3D = Scene3DManager.camera.rightVector;
					var xv2:Vector3D = this.rightVector; 
					xv1.normalize();
					xv2.normalize();
					var ax:Number = xv1.dotProduct(xv2);
					if (ax < 0) trans = -trans;							
					
					this.rotate(new Vector3D(1, 0, 0), trans);
					
					break;
				
				case "yAxis":
					
					var yv1:Vector3D = Scene3DManager.camera.downVector;
					var yv2:Vector3D = this.upVector; 			
					yv1.normalize();
					yv2.normalize();
					var ay:Number = yv1.dotProduct(yv2);
					if (ay < 0) trans = -trans;									
					
					this.rotate(new Vector3D(0, 1, 0), trans);				
					
					break;
				
				case "zAxis":
					
					var zv1:Vector3D = Scene3DManager.camera.rightVector;
					var zv2:Vector3D = this.forwardVector; 			
					zv1.normalize();
					zv2.normalize();
					var az:Number = zv1.dotProduct(zv2);
					if (az < 0) trans = -trans;				
					
					this.rotate(new Vector3D(0, 0, 1), trans);					
					
					break;				
				
				case "allAxis":				
									
					//quat.fromAxisAngle(this.upVector, rx);
										
					this.eulers = quat.rotatePoint(new Vector3D(this.eulers.x + dy, this.eulers.y - dx, 0));
					
					break;					
			}					
			
			var actualMesh:ObjectContainer3D = currentMesh;
			
			if (currentMesh.parent is LightGizmo3D) actualMesh = currentMesh.parent.parent;
			
			actualMesh.eulers = this.eulers;
			
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
			
			xTorus.material = xAxisMaterial;		
			yTorus.material = yAxisMaterial;
			zTorus.material = zAxisMaterial;
			sphere.material = sphereMaterial;
		}		
		
		
	}
}