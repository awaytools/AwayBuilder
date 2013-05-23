package awaybuilder.controller.scene
{
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.vo.scene.AnimationSetVO;

	public class AddNewAnimationSetCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:SceneEvent;
		
		[Inject]
		public var document:DocumentModel;
		
		override public function execute():void
		{
			var oldValue:AnimationSetVO = event.oldValue as AnimationSetVO;
			var newValue:AnimationSetVO = event.newValue as AnimationSetVO;
			
			if( event.isUndoAction )
			{
				document.removeAsset( document.animations, oldValue );
			}
			else 
			{
				document.animations.addItemAt( newValue, 0 );
			}
			
			addToHistory( event );
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
			document.empty = false;
			document.edited = true;
		}
		
	}
}