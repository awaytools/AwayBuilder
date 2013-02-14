package awaybuilder.events
{
	import flash.events.Event;
	
	public class HelpEvent extends Event
	{
		public static const SHOW_SAMPLES:String = "showSamples";
		public static const HIDE_SAMPLES:String = "hideSamples";
		
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