package awaybuilder.scene.events
{
	import flash.events.Event;
	
	public class Scene3DManagerEvent extends Event
	{
		public static const READY:String = "Scene3DManagerEventReady";
		
		public function Scene3DManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}