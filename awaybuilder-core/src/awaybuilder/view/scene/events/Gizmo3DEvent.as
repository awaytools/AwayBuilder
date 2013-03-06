package awaybuilder.view.scene.events
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	public class Gizmo3DEvent extends Event
	{
		public static const MOVE:String = "Gizmo3DEventMove";
		
		public var position:Vector3D;
		
		public function Gizmo3DEvent(type:String, position:Vector3D, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.position = position;
			super(type, bubbles, cancelable);
		}
	}
}