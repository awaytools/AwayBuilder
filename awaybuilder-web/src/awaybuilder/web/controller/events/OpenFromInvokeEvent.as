package awaybuilder.web.controller.events
{
	import flash.events.Event;
	
	public class OpenFromInvokeEvent extends Event
	{
		public static const OPEN_FROM_INVOKE:String = "openFromInvoke";
		
		public function OpenFromInvokeEvent(type:String, file:Object)
		{
			super(type, false, false);
			this.file = file;
		}
		
		public var file:Object;
		
		override public function clone():Event
		{
			return new OpenFromInvokeEvent(this.type, this.file);
		}
	}
}