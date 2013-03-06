package awaybuilder.controller.events
{
	import flash.events.Event;

	public class SceneEvent extends Event
	{
		public static const ITEMS_SELECT:String = "sceneItemSelect";
		
		public function SceneEvent(type:String, items:Vector.<Object>)
		{
			super(type, false, false);
			this.items = items;
		}
		
		public var items:Vector.<Object>;
		
		override public function clone():Event
		{
			return new SceneEvent(this.type, this.items);
		}
	}
}