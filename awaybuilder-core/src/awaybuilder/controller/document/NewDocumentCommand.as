package awaybuilder.controller.document
{
	import awaybuilder.utils.scene.CameraManager;
	import away3d.library.AssetLibrary;
	
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.model.AssetsModel;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.UndoRedoModel;
	import awaybuilder.utils.AssetUtil;
	import awaybuilder.utils.scene.Scene3DManager;
	
	import org.robotlegs.mvcs.Command;

	public class NewDocumentCommand extends Command
	{	
		[Inject]
		public var document:DocumentModel;
		
		[Inject]
		public var assets:AssetsModel;
		
		[Inject]
		public var undoRedo:UndoRedoModel;

		override public function execute():void
		{
			assets.Clear();
			undoRedo.clear();
			Scene3DManager.clear();
			document.clear();
			
			document.name = "Untitled Library " + AssetUtil.GetNextId("document");
			document.edited = false;
			document.path = null;
			
			if (Scene3DManager.scene) CameraManager.focusTarget();
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_CREATED));
		}
		
	}
}