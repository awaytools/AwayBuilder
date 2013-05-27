package awaybuilder.controller.scene
{
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.vo.scene.EffectMethodVO;

	public class ChangeEffectMethodCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:SceneEvent;
		
		override public function execute():void
		{
			var newAsset:EffectMethodVO = event.newValue as EffectMethodVO;
			
			var vo:EffectMethodVO = event.items[0] as EffectMethodVO;
			
			saveOldValue( event, vo.clone() );
			
			vo.fillFromEffectMethod( newAsset );
			
			commitHistoryEvent( event );
		}
	}
}