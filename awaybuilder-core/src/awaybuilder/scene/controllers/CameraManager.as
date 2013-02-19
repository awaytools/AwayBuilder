package awaybuilder.scene.controllers
{
	import com.greensock.TweenMax;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	import mx.core.UIComponent;
	
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.math.Quaternion;
	
	import awaybuilder.scene.modes.CameraMode;
	import awaybuilder.scene.utils.MathUtils;

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
		
		private static var _mode:String = CameraMode.TARGET;
		private static var _active:Boolean = false;		
		
		public static var _xDeg:Number = 0;
		public static var _yDeg:Number = 0;				
		
		private var offset:Vector3D = new Vector3D();
		private var click:Point = new Point();						
		private var pan:Point = new Point();					
		private var altPressed:Boolean = false;
		
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
		private var _runMult:Number = 1;
		private var _pause:Boolean = false;
		private var tm:Number;
		private var panning:Boolean = false;
		
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
			
			scope.addEventListener(MouseEvent.MOUSE_DOWN, instance.onMouseDown);			
			scope.addEventListener(MouseEvent.MOUSE_UP, instance.onMouseUp);	
			instance.stage.addEventListener(Event.MOUSE_LEAVE, instance.onMouseLeave);	
			scope.addEventListener(MouseEvent.MOUSE_WHEEL, instance.onMouseWheel);
			scope.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, instance.onMouseMiddleDown);
			scope.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, instance.onMouseMiddleUp);
			scope.addEventListener(KeyboardEvent.KEY_DOWN, instance.onKeyDown);
			scope.addEventListener(KeyboardEvent.KEY_UP, instance.onKeyUp);					
			
			scope.addEventListener(Event.ENTER_FRAME, instance.loop);
		}
		
		public static function kill():void
		{
			instance.scope.removeEventListener(Event.ENTER_FRAME, instance.loop);
			instance.scope.removeEventListener(MouseEvent.MOUSE_DOWN, instance.onMouseDown);			
			instance.scope.removeEventListener(MouseEvent.MOUSE_UP, instance.onMouseUp);	
			instance.stage.removeEventListener(Event.MOUSE_LEAVE, instance.onMouseLeave);	
			instance.scope.removeEventListener(MouseEvent.MOUSE_WHEEL, instance.onMouseWheel);
			instance.scope.removeEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, instance.onMouseMiddleDown);
			instance.scope.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, instance.onMouseMiddleUp);
			instance.scope.removeEventListener(KeyboardEvent.KEY_DOWN, instance.onKeyDown);
			instance.scope.removeEventListener(KeyboardEvent.KEY_UP, instance.onKeyUp);				
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
				case CameraMode.TARGET: instance.initTargetMode(5, 1000, 0, 15);
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
			
			camera.moveForward(_zSpeed);
			camera.moveRight(_xSpeed);
						
			camera.eulers = quat.rotatePoint(new Vector3D(_yDeg, _xDeg, camera.rotationZ));				
			
			/*
			if (terrain)
			{
				var h:Number = terrain.getHeightAt(camera.x, camera.z) + 185;			
				
				//if (stickToTerrain || h > camera.y) free mode but not undergroundaaa 
				if (stickToTerrain) 
				{
					camera.y += (h - camera.y) * .05;
				}												
			}
			*/
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
			if (panning) updatePOIPosition();
			if (dragging) updateMouseRotation();
			
			camera.position = getCameraPosition(_xDeg, -_yDeg);							
			camera.eulers = quat.rotatePoint(new Vector3D(_yDeg, _xDeg, camera.rotationZ));
		}			
		
		
		
		
		public static function focusTarget(t:ObjectContainer3D):void
		{
			TweenMax.to(instance.poi, 0.5, {x:t.scenePosition.x, y:t.scenePosition.y, z:t.scenePosition.z});
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
			panning = true;
		}
		
		private function onMouseMiddleUp(e:MouseEvent):void
		{
			panning = false;
		}		
		
		private function onMouseDown(event : MouseEvent) : void
		{			
			if (active)
			{
				click.x = stage.mouseX;
				click.y = stage.mouseY;				
				
				if (altPressed)
				{
					pan.x = stage.mouseX;
					pan.y = stage.mouseY;
					panning = true;
				}
				else dragging = true;				
				hasMoved = false;
			}
		}
		
		private function onMouseUp(event : MouseEvent) : void
		{
			dragging = false;
			panning = false;
		}
		
		private function onMouseWheel(event:MouseEvent) : void
		{
			if (active && mode == CameraMode.TARGET)
			{
				radius -= event.delta * wheelSpeed;			
			}			
		}						
		
		private function onMouseLeave(event:Event) : void
		{
			panning = false;			
		}					
		
		
		// Keyboard Events ******************************************************************************************************************************************
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			if (active)
			{
				if (e.keyCode == Keyboard.ALTERNATE) altPressed = true;		
				
				if (mode == CameraMode.FREE)
				{
					switch (e.keyCode) 
					{					
						case Keyboard.UP: _zSpeed = speed;
							break;
						case Keyboard.DOWN: _zSpeed = -speed;
							break;
						case Keyboard.LEFT: _xSpeed = -speed;
							break;
						case Keyboard.RIGHT: _xSpeed = speed;
							break;
						case Keyboard.SHIFT: _runMult = 3;
							break;
					}				
				}				
				
				_zSpeed *= _runMult;
				_xSpeed *= _runMult;
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			if (active)
			{
				if (e.keyCode == Keyboard.ALTERNATE) altPressed = false;
				
				if (mode == CameraMode.FREE)
				{
					switch (e.keyCode) 
					{
						case Keyboard.UP: case Keyboard.DOWN: _zSpeed = 0;
							break;
						case Keyboard.LEFT: case Keyboard.RIGHT: _xSpeed = 0;
							break;
						case Keyboard.SHIFT: _runMult = 1;
							break;
					}				
				}				
			}
		}		
		
	}

}