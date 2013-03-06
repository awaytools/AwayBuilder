package awaybuilder.controller.events
{
	import flash.events.Event;
	
	public class NudgeEvent extends Event
	{
		public static const NUDGE_SELECTION:String = "nudgeSelection";
		
		public function NudgeEvent(type:String, xOffset:Number, yOffset:Number)
		{
			super(type, false, false);
			this.xOffset = xOffset;
			this.yOffset = yOffset;
		}
		
		public var xOffset:Number;
		public var yOffset:Number;
		
		override public function clone():Event
		{
			return new NudgeEvent(this.type, this.xOffset, this.yOffset);
		}
	}
}