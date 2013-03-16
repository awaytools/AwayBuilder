package awaybuilder.utils.scene
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.math.Quaternion;
	import away3d.entities.Mesh;
	
	import awaybuilder.utils.MathUtils;
	import awaybuilder.utils.scene.modes.CameraMode;
	
	import com.greensock.TweenMax;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import mx.core.UIComponent;

	/**
	 * ...
	 * @author Cornflex
	 */
	public class CameraManager
	{
		// Singleton instance declaration
		private static const self:CameraManager = new CameraManager();		
		public static function get instance():CameraManager { return self; }			
		public function CameraManager() { if ( instance ) throw new Error("CameraManager is a singleton"); }			
		
		public static var camera:Camera3D;
		
		// common variables	
		public static var dragging:Boolean = false;
		public static var hasMoved:Boolean = false;
		public static var panning:Boolean = false;
		public static var running:Boolean = false;
		public static var runMultiplier:Number = 3;
		
		private static var _mode:String = CameraMode.TARGET;
		private static var _active:Boolean = false;			
		
		public static var _xDeg:Number = 0;
		public static var _yDeg:Number = 0;				
		
		private var offset:Vector3D = new Vector3D();
		private var click:Point = new Point();						
		private var pan:Point = new Point();		
		
		// target mode variables
		public static var wheelSpeed:Number = 10;
		public static var mouseSpeed:Number = 1;		
		public static var radius:Number = 0;
		
		private var _minRadius:Number = 10;								
		private var stage:Stage;
		
		private var scope:UIComponent;
		
		// free mode variables
        private var _speed:Number = 5;				
		private var _xSpeed:Number = 0;
        private var _zSpeed:Number = 0;
		private var _runMultiplier:Number = 3;
		private var _pause:Boolean = false;
		private var tm:Number;
		private var ispanning:Boolean = false;
		
		private var poi:ObjectContainer3D;
		
		private var quat:Quaternion;
		
		public static function init(scope:UIComponent, view:View3D, mode:String=CameraMode.TARGET, speed:Number=10):void
		{			
			instance.scope = scope;
			instance.stage = scope.stage;
			
			camera = view.camera;
			CameraManager.speed = speed;
			_mode = mode;
			
			instance.poi = new ObjectContainer3D();
			view.scene.addChild(instance.poi);
			
			instance.quat = new Quaternion();
			instance.quat.fromMatrix(camera.transform);						
			
			switch(_mode)
			{
				case CameraMode.FREE: instance.initFreeMode();
					break;
				case CameraMode.TARGET: instance.initTargetMode(5, 1000, 0, 15);
					break;
			}			
			
			instance.stage.addEventListener(MouseEvent.MOUSE_DOWN, instance.onMouseDown);			
			instance.stage.addEventListener(MouseEvent.MOUSE_UP, instance.onMouseUp);	
			instance.stage.addEventListener(Event.MOUSE_LEAVE, instance.onMouseLeave);	
			instance.stage.addEventListener(MouseEvent.MOUSE_WHEEL, instance.onMouseWheel);
			instance.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, instance.onMouseMiddleDown);
			instance.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, instance.onMouseMiddleUp);
			
			scope.addEventListener(Event.ENTER_FRAME, instance.loop);
		}
		
		public static function kill():void
		{
			instance.scope.removeEventListener(Event.ENTER_FRAME, instance.loop);
			instance.stage.removeEventListener(MouseEvent.MOUSE_DOWN, instance.onMouseDown);			
			instance.stage.removeEventListener(MouseEvent.MOUSE_UP, instance.onMouseUp);	
			instance.stage.removeEventListener(Event.MOUSE_LEAVE, instance.onMouseLeave);	
			instance.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, instance.onMouseWheel);
			instance.stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, instance.onMouseMiddleDown);
			instance.stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, instance.onMouseMiddleUp);
		}			
		
		static public function get active():Boolean { return _active; }		
		static public function set active(value:Boolean):void 
		{
			_active = value;
			
			if (!_active)
			{
				dragging = false;
			}
		}			
		
		public static function get speed():Number { return instance._speed; }		
		public static function set speed(value:Number):void { instance._speed = value; }				
		
		public static function get minRadius():Number { return instance._minRadius; }		
		public static function set minRadius(value:Number):void 
		{ 
			instance._minRadius = value; 
		}				
		
		static public function get mode():String { return _mode; }		
		static public function set mode(value:String):void 
		{
			_mode = value;
			
			switch(value)
			{
				case CameraMode.FREE: instance.initFreeMode();
				break;
				case CameraMode.TARGET: 
										
					var poiPos:Vector3D = Vector3D(camera.scenePosition);
					instance.poi.position = poiPos;
					instance.poi.eulers = camera.eulers;
					instance.poi.moveForward(300);
					instance.initTargetMode(5, 300, _xDeg, _yDeg);
				break;
			}			
		}
				
		private function loop(e:Event) : void
		{
			if (!_pause)
			{
				switch(mode)
				{
					case CameraMode.FREE: processFreeMode();
						break;
					case CameraMode.TARGET: processTargetMode();
						break;				
				}				
			}				
		}					
		
		
		
		// FreeMode ***************************************************************
		
		private function initFreeMode():void
		{
			TweenMax.killTweensOf(camera);
			active = true;
		}
				
		private function processFreeMode():void
		{			
			if (dragging) updateMouseRotation();
			
			if (running) _runMultiplier = runMultiplier;
			else _runMultiplier = 1;			
			
			camera.moveForward(_zSpeed * _runMultiplier);
			camera.moveRight(_xSpeed * _runMultiplier);
						
			camera.eulers = quat.rotatePoint(new Vector3D(_yDeg, _xDeg, camera.rotationZ));			
		}
		
		
		
		// TargetMode **********************************************
		
		private function initTargetMode(minRadius:Number=5, radius:Number=NaN, xDegree:Number=NaN, yDegree:Number=NaN):void
		{				
			CameraManager.minRadius = minRadius;
			
			if (!isNaN(xDegree)) _xDeg = xDegree;
			if (!isNaN(yDegree)) _yDeg = yDegree;								
			
			if (!isNaN(radius)) CameraManager.radius = radius;
			else
			{
				radius = Vector3D.distance(camera.position, instance.poi.scenePosition);
			}							
			
			camera.position = getCameraPosition(_xDeg, -_yDeg);							
			camera.eulers = quat.rotatePoint(new Vector3D(_yDeg, _xDeg, camera.rotationZ));		
			
			if (mode != CameraMode.TARGET) mode = CameraMode.TARGET;				
			
			active = true;
		}			
		
		private function processTargetMode():void
		{			
			if (ispanning) updatePOIPosition();
			if (dragging) updateMouseRotation();
			
			camera.position = getCameraPosition(_xDeg, -_yDeg);							
			camera.eulers = quat.rotatePoint(new Vector3D(_yDeg, _xDeg, camera.rotationZ));
		}			
		
		
		
		
		public static function focusTarget(t:ObjectContainer3D):void
		{			
			if (t is Mesh)
			{
				var sx:Number = Math.abs(Mesh(t).scaleX);
				var sy:Number = Math.abs(Mesh(t).scaleY);
				var sz:Number = Math.abs(Mesh(t).scaleZ);
				
				var bmax:Vector3D = Mesh(t).bounds.max.clone();
				
				bmax.x *= sx;
				bmax.y *= sy;
				bmax.z *= sz;				
				
				var tr:Number = bmax.length * 2;				
												
				TweenMax.to(CameraManager, 0.5, {radius:tr, onComplete:instance.calculateWheelSpeed, onCompleteParams:[t]});
			}
			
			TweenMax.to(instance.poi, 0.5, {x:t.scenePosition.x, y:t.scenePosition.y, z:t.scenePosition.z});
		}
		
		private function calculateWheelSpeed(t:ObjectContainer3D):void
		{
			//adjust mouseWheel speed according size and scale of the mesh;
			var dist:Vector3D = camera.scenePosition.subtract(t.scenePosition);
			wheelSpeed = dist.length/60; 
		}
		
		
		
		
		
		private function updatePOIPosition():void
		{
			poi.rotationX = camera.rotationX;
			poi.rotationY = camera.rotationY;
			poi.rotationZ = camera.rotationZ;			
			
			var dx:Number = stage.mouseX - pan.x;
			var dy:Number = stage.mouseY - pan.y;
			
			if (dx != 0 || dy != 0) hasMoved = true;
			
			pan.x = stage.mouseX;
			pan.y = stage.mouseY;			
			
			poi.moveUp(dy);
			poi.moveLeft(dx);
		}		
		
		private function updateMouseRotation() : void
		{			
			var dx:Number = stage.mouseX - click.x;
			var dy:Number = stage.mouseY - click.y;
			
			if (dx != 0 || dy != 0) hasMoved = true;
			
			click.x = stage.mouseX;
			click.y = stage.mouseY;
			
			_yDeg += (dy * mouseSpeed);
			_xDeg += (dx * mouseSpeed);
		}		
		
		private function getCameraPosition(xDegree:Number, yDegree:Number):Vector3D
		{
			var cy:Number = Math.cos(MathUtils.convertToRadian(yDegree)) * radius;			
			
			var v:Vector3D = new Vector3D();
			
			v.x = (poi.scenePosition.x + offset.x) - Math.sin(MathUtils.convertToRadian(xDegree)) * cy;
			v.y = (poi.scenePosition.y + offset.y) - Math.sin(MathUtils.convertToRadian(yDegree)) * radius;
			v.z = (poi.scenePosition.z + offset.z) - Math.cos(MathUtils.convertToRadian(xDegree)) * cy;
			
			return v;
		}				
		
		
		
		
		// Mouse Events **********************************************************************************************************************
		
		private function onMouseMiddleDown(e:MouseEvent):void
		{
			pan.x = stage.mouseX;
			pan.y = stage.mouseY;			
			ispanning = true;
		}
		
		private function onMouseMiddleUp(e:MouseEvent):void
		{
			ispanning = false;
		}		
		
		private function onMouseDown(event : MouseEvent) : void
		{			
			if (active)
			{
				click.x = stage.mouseX;
				click.y = stage.mouseY;				
				
				if (panning)
				{
					pan.x = stage.mouseX;
					pan.y = stage.mouseY;
					ispanning = true;
				}
				else dragging = true;				
				hasMoved = false;
			}
		}
		
		private function onMouseUp(event : MouseEvent) : void
		{
			dragging = false;
			ispanning = false;
		}
		
		private function onMouseWheel(event:MouseEvent) : void
		{
			if (active)
			{
				switch(mode)
				{
					case CameraMode.TARGET: radius -= event.delta * wheelSpeed;
						break;
					case CameraMode.FREE: camera.moveForward(speed * event.delta);
						break;						
				}
			}			
		}						
		
		private function onMouseLeave(event:Event) : void
		{
			ispanning = false;			
		}					
		
		
		
		// Free Camera Moves ********************************************************************************************************************************************
		
		public static function moveForward(moveSpeed:Number):void
		{
			if (active && mode == CameraMode.FREE)
			{
				instance._zSpeed = moveSpeed;
			}
		}
		
		public static function moveBackward(moveSpeed:Number):void
		{
			if (active && mode == CameraMode.FREE)
			{
				instance._zSpeed = -moveSpeed;
			}			
		}		
		
		public static function moveLeft(moveSpeed:Number):void
		{
			if (active && mode == CameraMode.FREE)
			{
				instance._xSpeed = -moveSpeed;
			}			
		}
		
		public static function moveRight(moveSpeed:Number):void
		{
			if (active && mode == CameraMode.FREE)
			{
				instance._xSpeed = moveSpeed;
			}			
		}		
		
	}

}