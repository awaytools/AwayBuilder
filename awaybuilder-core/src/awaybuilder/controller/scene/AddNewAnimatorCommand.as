package awaybuilder.controller.scene
{
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.vo.scene.AnimatorVO;

	[Deprecated]
	public class AddNewAnimatorCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:SceneEvent;
		
		override public function execute():void
		{
			var oldValue:AnimatorVO = event.oldValue as AnimatorVO;
			var newValue:AnimatorVO = event.newValue as AnimatorVO;
			
			if( event.isUndoAction )
			{
				document.removeAsset( document.animations, oldValue );
			}
			else 
			{
				document.animations.addItemAt( newValue, 0 );
			}
			
			commitHistoryEvent( event );
		}
		
	}
}