package awaybuilder.model.vo
{
	import awaybuilder.model.vo.scene.AssetVO;
	
	import flash.events.Event;
	
	public class ScenegraphItemEvent extends Event
	{
		public function ScenegraphItemEvent(type:String, assets:Array, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.assets = assets;
		}
		
		public var assets:Array;
	}
}