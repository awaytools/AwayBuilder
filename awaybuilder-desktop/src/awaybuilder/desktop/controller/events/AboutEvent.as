package awaybuilder.desktop.controller.events
{
	import flash.events.Event;
	
	public class AboutEvent extends Event
	{
		public static const SHOW_ABOUT:String = "showAbout";
		public static const HIDE_ABOUT:String = "hideAbout";
		
		public function AboutEvent(type:String)
		{
			super(type, false, false);
		}
		
		override public function clone():Event
		{
			return new AboutEvent(this.type);
		}
	}
}