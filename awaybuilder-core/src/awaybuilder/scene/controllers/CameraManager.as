package awaybuilder.scene.controllers
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	
	import awaybuilder.scene.utils.MathUtils;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;

	/**
	 * ...
	 * @author Cornflex
	 */
	public class CameraManager 
	{
		// Singleton instance declaration
		public static const self:CameraManager = new CameraManager();		
		public static function get instance():CameraManager { return self; }	
		
		public function CameraManager() { if ( instance ) throw new Error("CameraManager is a singleton"); }			
		
		// common variables		
		public static var dragSmooth:Number = 1;		
		public static var dragging:Boolean = false;
		public static var hasMoved:Boolean = false;
		private static var _type:String = "free";
		private static var _target:ObjectContainer3D;				
		private static var _active:Boolean = false;		
		
		private var _xDeg:Number = 0;
		private var _yDeg:Number = 0;				
		public var targetProps:Object = { xDegree:0, yDegree:0, radius:0 };		
		private var offset:Vector3D = new Vector3D();
		private var click:Point = new Point();						
		private var pan:Point = new Point();					
		private var altPressed:Boolean = false;
		
		// target mode variables
		public static var wheelSpeed:Number = 10;
		public static var mouseSpeed:Number = 1;	
		public static var locked:Boolean = false;
		public var radius:Number = 0;			
		private var _minRadius:Number = 10;		
		private var lockProps:Object = { xDegree:0, yDegree:0 };		
		
		private var stage:Stage;
		private var camera:Camera3D;
		
		// free mode variables
		public static var stickToTerrain:Boolean = false;
        private var _speed:Number = 5;				
		private var _xSpeed:Number = 0;
        private var _zSpeed:Number = 0;
		private var _targetXSpeed:Number = 0;
		private var _targetZSpeed:Number = 0;
		private var _runMult:Number = 1;
		private var _pause:Boolean = false;
		private var tm:Number;
		private var panning:Boolean = false;
		
		private var poi:ObjectContainer3D;
		
		public static function init(stage:Stage, view:View3D, mode:String="target", speed:Number=10):void
		{			
			instance.stage = stage;
			instance.camera = view.camera;
			CameraManager.speed = speed;
			_type = mode;
			
			instance.poi = new ObjectContainer3D();
			view.scene.addChild(instance.poi);
			
			switch(_type)
			{
				case "free": instance.initFreeMode();
					break;
				case "target": instance.initTargetMode(5, 1000, 0, 15);
					break;
			}			
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, instance.onMouseDown);			
			stage.addEventListener(MouseEvent.MOUSE_UP, instance.onMouseUp);	
			stage.addEventListener(Event.MOUSE_LEAVE, instance.onMouseLeave);	
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, instance.onMouseWheel);
			stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, instance.onMouseMiddleDown);
			stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, instance.onMouseMiddleUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, instance.onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, instance.onKeyUp);					
			
			stage.addEventListener(Event.ENTER_FRAME, instance.loop);
		}
		
		public static function kill():void
		{
			instance.stage.removeEventListener(Event.ENTER_FRAME, instance.loop);
			instance.stage.removeEventListener(MouseEvent.MOUSE_DOWN, instance.onMouseDown);			
			instance.stage.removeEventListener(MouseEvent.MOUSE_UP, instance.onMouseUp);	
			instance.stage.removeEventListener(Event.MOUSE_LEAVE, instance.onMouseLeave);	
			instance.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, instance.onMouseWheel);
			instance.stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, instance.onMouseMiddleDown);
			instance.stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, instance.onMouseMiddleUp);
			instance.stage.removeEventListener(KeyboardEvent.KEY_DOWN, instance.onKeyDown);
			instance.stage.removeEventListener(KeyboardEvent.KEY_UP, instance.onKeyUp);				
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
		
		static public function get type():String { return _type; }		
		static public function set type(value:String):void 
		{
			_type = value;
			
			switch(value)
			{
				case "free": instance.initFreeMode();
				break;
				case "target": instance.initTargetMode(5, 1000, 0, 15);
				break;
			}			
		}
				
		private function loop(e:Event) : void
		{
			if (!_pause)
			{
				switch(type)
				{
					case "free": processFreeMode();
						break;
					case "target": processTargetMode();
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
			if (!locked && dragging) updateMouseRotation();
			
			_xSpeed += (_targetXSpeed * _runMult - _xSpeed) * dragSmooth;
			_zSpeed += (_targetZSpeed * _runMult - _zSpeed) * dragSmooth;
			_xDeg += (targetProps.xDegree - _xDeg) * dragSmooth;
			_yDeg += (targetProps.yDegree - _yDeg) * dragSmooth;	
			
			camera.rotationY = _xDeg % 360;
			camera.rotationX = -_yDeg % 360;
			camera.moveForward(_zSpeed);
			camera.moveRight(_xSpeed);
			
			/*
			if (Away3DWorld.terrainEngine.active)
			{
				var h:Number = Away3DWorld.terrainEngine.terrain.getHeightAt(Away3DWorld.camera.x, Away3DWorld.camera.z) + 185;			
				
				//if (stickToTerrain || h > Away3DWorld.camera.y) free mode but not undergroundaaa 
				if (stickToTerrain) 
				{
					Away3DWorld.camera.y += (h - Away3DWorld.camera.y) * .05;
				}												
			}
			*/
		}
		
		
		
		// TargetMode **********************************************
		
		private function initTargetMode(minRadius:Number=5, radius:Number=NaN, xDegree:Number=NaN, yDegree:Number=NaN):void
		{				
			CameraManager.minRadius = minRadius;
			
			if (!isNaN(xDegree)) instance._xDeg = xDegree;
			if (!isNaN(yDegree)) instance._yDeg = yDegree;				
			
			instance.targetProps.yDegree = instance._yDeg;
			instance.targetProps.xDegree = instance._xDeg;
			
			if (!isNaN(radius)) instance.targetProps.radius = radius;
			else
			{
				instance.targetProps.radius = Vector3D.distance(instance.camera.position, instance.poi.scenePosition);
			}							
			
			var pos:Vector3D = instance.getCameraPosition(instance._xDeg, instance._yDeg);
			
			instance.camera.rotationX = -instance._yDeg % 360;
			instance.camera.rotationY = instance._xDeg % 360;
			instance.camera.position = pos;				
			
			if (type != "target") type = "target";				
			
			active = true;
		}			
		
		public static function focuseTarget(t:ObjectContainer3D):void
		{
			TweenMax.to(instance.poi, 0.5, {x:t.scenePosition.x, y:t.scenePosition.y, z:t.scenePosition.z});
		}		
		
		private function processTargetMode():void
		{			
			this.applyRadius();
			
			if (!locked)
			{
				if (panning) updatePOIPosition();
				if (dragging) updateMouseRotation();		
				
				_xDeg += (targetProps.xDegree - _xDeg) * dragSmooth;
				_yDeg += (targetProps.yDegree - _yDeg) * dragSmooth;						
				
				camera.position = getCameraPosition(_xDeg, -_yDeg);							
				camera.rotationY = _xDeg % 360;			
				camera.rotationX = _yDeg % 360;					
			}
			else
			{
				targetProps.yDegree = (lockProps.yDegree - _target.rotationX);					
				targetProps.xDegree = (lockProps.xDegree + _target.rotationY);
				
				_xDeg += (targetProps.xDegree - _xDeg) * dragSmooth;
				_yDeg += (targetProps.yDegree - _yDeg) * dragSmooth;
				
				camera.position = getCameraPosition(_xDeg, _yDeg);		
				camera.rotationY = _xDeg % 360;			
				camera.rotationX = _yDeg % 360;											
			}
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
			
			if (type == "free") targetProps.yDegree -= dy * mouseSpeed;			
			else targetProps.yDegree += dy * mouseSpeed;			
			
			if (Math.abs(targetProps.yDegree) % 360 >= 90 && Math.abs(targetProps.yDegree) % 360 <= 270)
			{
				targetProps.xDegree -= dx * mouseSpeed;
			}
			else
			{
				targetProps.xDegree += dx * mouseSpeed;
			}						
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
		
		private function applyRadius():void
		{
			radius += (targetProps.radius - radius) * dragSmooth;
			
			if (active && (radius < minRadius)) 
			{
				radius = minRadius;
				targetProps.radius = minRadius;
			}
		}					
		
		
		
		// Lock  ************************************************************************************************************************************
		
		public static function lock(xDegree:Number=0, yDegree:Number=0):void 
		{ 
			instance.lockProps.xDegree = xDegree;
			instance.lockProps.yDegree = yDegree;				
			//instance.targetProps.radius = minRadius;
			_target.rotationX = _target.rotationX % 360;
			_target.rotationY = _target.rotationY % 360;
			locked = true; 				
		}
		
		public static function unlock():void 
		{ 
			locked = false; 
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
			if (active && type == "target")
			{
				targetProps.radius -= event.delta * wheelSpeed;			
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
				
				if (type == "free")
				{
					switch (e.keyCode) 
					{					
						case Keyboard.UP: _targetZSpeed = speed;
							break;
						case Keyboard.DOWN: _targetZSpeed = -speed;
							break;
						case Keyboard.LEFT: _targetXSpeed = -speed;
							break;
						case Keyboard.RIGHT: _targetXSpeed = speed;
							break;
						case Keyboard.SHIFT: _runMult = 3;
							break;
						case Keyboard.SPACE: stickToTerrain = !stickToTerrain;
							break;				
					}				
				}				
				
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			if (active)
			{
				if (e.keyCode == Keyboard.ALTERNATE) altPressed = false;
				
				if (type == "free")
				{
					switch (e.keyCode) 
					{
						case Keyboard.UP: case Keyboard.DOWN: _targetZSpeed = 0;
							break;
						case Keyboard.LEFT: case Keyboard.RIGHT: _targetXSpeed = 0;
							break;
						case Keyboard.SHIFT: _runMult = 1;
							break;
					}				
				}				
			}
		}		
		
	}

}