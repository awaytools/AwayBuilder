package awaybuilder.view.mediators
{
	import awaybuilder.controller.events.ClipboardEvent;
	import awaybuilder.controller.events.DocumentEvent;
	import awaybuilder.controller.events.DocumentRequestEvent;
	import awaybuilder.controller.events.EditingSurfaceRequestEvent;
	import awaybuilder.controller.events.EditorStateChangeEvent;
	import awaybuilder.controller.events.SaveDocumentEvent;
	import awaybuilder.controller.events.SettingsEvent;
	import awaybuilder.controller.events.WebLinkEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.UndoRedoModel;
	import awaybuilder.view.components.EditToolBar;
	import awaybuilder.view.components.events.ToolBarEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class EditToolBarMediator extends Mediator
	{
		[Inject]
		public var toolBar:EditToolBar;
		
		[Inject]
		public var document:IDocumentModel;
		
		[Inject]
		public var undoRedo:UndoRedoModel;
		
		override public function onRegister():void
		{	
			this.eventMap.mapListener(this.eventDispatcher, EditorStateChangeEvent.SELECTION_CHANGE, eventDispatcher_selectionChangeHandler);
			this.eventMap.mapListener(this.eventDispatcher, EditingSurfaceRequestEvent.SWITCH_CAMERA_TO_FREE, eventDispatcher_switchToFreeHandler);
			this.eventMap.mapListener(this.eventDispatcher, EditingSurfaceRequestEvent.SWITCH_CAMERA_TO_TARGET, eventDispatcher_switchToTargetHandler);
			
			this.eventMap.mapListener(this.eventDispatcher, EditingSurfaceRequestEvent.SWITCH_TRANSFORM_ROTATE, eventDispatcher_switchToRotateHandler);
			this.eventMap.mapListener(this.eventDispatcher, EditingSurfaceRequestEvent.SWITCH_TRANSFORM_TRANSLATE, eventDispatcher_switchToTranslateHandler);
			this.eventMap.mapListener(this.eventDispatcher, EditingSurfaceRequestEvent.SWITCH_TRANSFORM_SCALE, eventDispatcher_switchToScaleHandler);
			
			this.eventMap.mapListener(this.toolBar, ToolBarEvent.NEW_DOCUMENT, toolBar_newDocumentHandler);
			this.eventMap.mapListener(this.toolBar, ToolBarEvent.OPEN_DOCUMENT, toolBar_openDocumentHandler);
			this.eventMap.mapListener(this.toolBar, ToolBarEvent.SAVE_DOCUMENT, toolBar_saveDocumentHandler);
			this.eventMap.mapListener(this.toolBar, ToolBarEvent.PRINT_DOCUMENT, toolBar_printDocumentHandler);
			
			this.eventMap.mapListener(this.toolBar, ToolBarEvent.UNDO, toolBar_undoHandler);
			this.eventMap.mapListener(this.toolBar, ToolBarEvent.REDO, toolBar_redoHandler);
			
			this.eventMap.mapListener(this.toolBar, ToolBarEvent.HELP, toolBar_helpHandler);
			this.eventMap.mapListener(this.toolBar, ToolBarEvent.APPLICATION_SETTINGS, toolBar_applicationSettingsHandler);
			this.eventMap.mapListener(this.toolBar, ToolBarEvent.DOCUMENT_SETTINGS, toolBar_documentSettingsHandler);
			this.eventMap.mapListener(this.toolBar, ToolBarEvent.REPORT_BUG, toolBar_reportBugHandler);
			
			this.eventMap.mapListener(this.toolBar, ToolBarEvent.CLIPBOARD_CUT, toolBar_clipboardCutHandler);
			this.eventMap.mapListener(this.toolBar, ToolBarEvent.CLIPBOARD_COPY, toolBar_clipboardCopyHandler);
			this.eventMap.mapListener(this.toolBar, ToolBarEvent.CLIPBOARD_PASTE, toolBar_clipboardPasteHandler);
			
			this.eventMap.mapListener(this.toolBar, ToolBarEvent.DELETE_SELECTION, toolBar_deleteSelectionHandler);
			this.eventMap.mapListener(this.toolBar, ToolBarEvent.ROTATE_SELECTION_CLOCKWISE, toolBar_rotateSelectionClockwiseHandler);
			this.eventMap.mapListener(this.toolBar, ToolBarEvent.ROTATE_SELECTION_COUNTER_CLOCKWISE, toolBar_rotateSelectionCounterClockwiseHandler);
			
			this.eventMap.mapListener(this.toolBar, ToolBarEvent.SWITCH_CAMERA_TO_FREE, toolBar_switchMouseToFreeHandler);
			this.eventMap.mapListener(this.toolBar, ToolBarEvent.SWITCH_CAMERA_TO_TARGET, toolBar_switchMouseToTargetHandler);
			
			this.eventMap.mapListener(this.toolBar, ToolBarEvent.TRANSFORM_TRANSLATE, toolBar_switchTranslateHandler);
			this.eventMap.mapListener(this.toolBar, ToolBarEvent.TRANSFORM_SCALE, toolBar_switchScaleHandler);
			this.eventMap.mapListener(this.toolBar, ToolBarEvent.TRANSFORM_ROTATE, toolBar_switchRotateHandler);
		}
		
		private function eventDispatcher_switchToScaleHandler(event:EditingSurfaceRequestEvent):void
		{
			
			this.toolBar.scaleButton.selected = true;
		}
		
		private function eventDispatcher_switchToRotateHandler(event:EditingSurfaceRequestEvent):void
		{
			this.toolBar.rotateButton.selected = true;
		}
		
		private function eventDispatcher_switchToTranslateHandler(event:EditingSurfaceRequestEvent):void
		{
			
			this.toolBar.translateButton.selected = true;
		}
		
		private function eventDispatcher_switchToFreeHandler(event:EditingSurfaceRequestEvent):void
		{
			this.toolBar.freeCameraButton.selected = true;
		}
		
		private function eventDispatcher_switchToTargetHandler(event:EditingSurfaceRequestEvent):void
		{
			this.toolBar.targetCameraButton.selected = true;
		}
		
		private function eventDispatcher_selectionChangeHandler(event:EditorStateChangeEvent):void
		{
//			this.toolBar.objectSelectionCount = this.editor.selectedObjects.length;
		}
		
		private function toolBar_clipboardCutHandler(event:ToolBarEvent):void
		{
			this.dispatch(new ClipboardEvent(ClipboardEvent.CLIPBOARD_CUT));
		}
		
		private function toolBar_clipboardCopyHandler(event:ToolBarEvent):void
		{
			this.dispatch(new ClipboardEvent(ClipboardEvent.CLIPBOARD_COPY));
		}
		
		private function toolBar_clipboardPasteHandler(event:ToolBarEvent):void
		{
			this.dispatch(new ClipboardEvent(ClipboardEvent.CLIPBOARD_PASTE));
		}
		
		private function toolBar_deleteSelectionHandler(event:ToolBarEvent):void
		{
			this.dispatch(new EditingSurfaceRequestEvent(EditingSurfaceRequestEvent.DELETE_SELECTION, null, true));
		}
		
		private function toolBar_rotateSelectionClockwiseHandler(event:ToolBarEvent):void
		{
			this.dispatch(new EditingSurfaceRequestEvent(EditingSurfaceRequestEvent.ROTATE_SELECTION_CLOCKWISE));
		}
		
		private function toolBar_rotateSelectionCounterClockwiseHandler(event:ToolBarEvent):void
		{
			this.dispatch(new EditingSurfaceRequestEvent(EditingSurfaceRequestEvent.ROTATE_SELECTION_COUNTER_CLOCKWISE));
		}
		
		private function toolBar_switchMouseToFreeHandler(event:ToolBarEvent):void
		{
			this.dispatch(new EditingSurfaceRequestEvent(EditingSurfaceRequestEvent.SWITCH_CAMERA_TO_FREE));
		}
		
		private function toolBar_switchMouseToTargetHandler(event:ToolBarEvent):void
		{
			this.dispatch(new EditingSurfaceRequestEvent(EditingSurfaceRequestEvent.SWITCH_CAMERA_TO_TARGET));
		}
		
		
		private function toolBar_switchTranslateHandler(event:ToolBarEvent):void
		{
			this.dispatch(new EditingSurfaceRequestEvent(EditingSurfaceRequestEvent.SWITCH_TRANSFORM_TRANSLATE));
		}
		
		private function toolBar_switchScaleHandler(event:ToolBarEvent):void
		{
			this.dispatch(new EditingSurfaceRequestEvent(EditingSurfaceRequestEvent.SWITCH_TRANSFORM_SCALE));
		}
		
		private function toolBar_switchRotateHandler(event:ToolBarEvent):void
		{
			this.dispatch(new EditingSurfaceRequestEvent(EditingSurfaceRequestEvent.SWITCH_TRANSFORM_ROTATE));
		}
		
		private function toolBar_newDocumentHandler(event:ToolBarEvent):void
		{
			this.dispatch(new DocumentRequestEvent(DocumentRequestEvent.REQUEST_NEW_DOCUMENT));
		}
		
		private function toolBar_openDocumentHandler(event:ToolBarEvent):void
		{
			this.dispatch(new DocumentRequestEvent(DocumentRequestEvent.REQUEST_OPEN_DOCUMENT));
		}
		
		private function toolBar_saveDocumentHandler(event:ToolBarEvent):void
		{
			this.dispatch(new SaveDocumentEvent(SaveDocumentEvent.SAVE_DOCUMENT));
		}
		
		private function toolBar_printDocumentHandler(event:ToolBarEvent):void
		{
			this.dispatch(new DocumentEvent(DocumentEvent.PRINT_DOCUMENT));
		}
		
		private function toolBar_undoHandler(event:ToolBarEvent):void
		{
			this.undoRedo.undo();
			this.document.edited = true;
		}
		
		private function toolBar_redoHandler(event:ToolBarEvent):void
		{
			this.undoRedo.redo();
			this.document.edited = true;
		}
		
		private function toolBar_helpHandler(event:ToolBarEvent):void
		{
			this.dispatch(new WebLinkEvent(WebLinkEvent.LINK_ONLINE_HELP));
		}
		
		private function toolBar_applicationSettingsHandler(event:ToolBarEvent):void
		{
			this.dispatch(new SettingsEvent(SettingsEvent.SHOW_APPLICATION_SETTINGS));
		}
		
		private function toolBar_documentSettingsHandler(event:ToolBarEvent):void
		{
			this.dispatch(new SettingsEvent(SettingsEvent.SHOW_DOCUMENT_SETTINGS));
		}
		
		private function toolBar_reportBugHandler(event:ToolBarEvent):void
		{
			this.dispatch(new WebLinkEvent(WebLinkEvent.LINK_BUG_REPORTS));
		}
	}
}