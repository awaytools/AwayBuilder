package awaybuilder.controller.events
{
	import flash.events.Event;
	
	public class HelpEvent extends Event
	{
		public static const SHOW_WELCOME:String = "showWelcome";
		public static const HIDE_WELCOME:String = "hideWelcome";
		
		public function HelpEvent(type:String)
		{
			super(type, false, false);
		}
		
		override public function clone():Event
		{
			return new HelpEvent(this.type);
		}
	}
}