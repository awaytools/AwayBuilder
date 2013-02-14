package awaybuilder.controller
{
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.IEditorModel;
	import awaybuilder.model.IObjectPickerModel;
	import awaybuilder.model.ISettingsModel;
	import awaybuilder.model.UndoRedoModel;
	
	import org.robotlegs.mvcs.Command;

	public class NewDocumentCommand extends Command
	{	
		[Inject]
		public var document:IDocumentModel;
		
		[Inject]
		public var editor:IEditorModel;
		
		[Inject]
		public var undoRedo:UndoRedoModel;

		[Inject]
		public var settings:ISettingsModel;

		[Inject]
		public var objectPickerModel:IObjectPickerModel;

		override public function execute():void
		{
			this.document.name = "Untitled Document 1";
			this.document.edited = false;
			this.document.path = null;

			this.undoRedo.clear();
			
			this.editor.zoom = 1;
			this.editor.panX = 0;
			this.editor.panY = 0;
		}
	}
}