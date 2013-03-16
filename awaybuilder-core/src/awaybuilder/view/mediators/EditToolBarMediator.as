package awaybuilder.view.mediators
{
	import awaybuilder.controller.events.ClipboardEvent;
	import awaybuilder.controller.events.DocumentEvent;
	import awaybuilder.controller.events.DocumentRequestEvent;
	import awaybuilder.controller.events.EditingSurfaceRequestEvent;
	import awaybuilder.controller.events.EditorStateChangeEvent;
	import awaybuilder.controller.events.SaveDocumentEvent;
import awaybuilder.controller.events.SceneEvent;
import awaybuilder.controller.events.SettingsEvent;
	import awaybuilder.controller.events.WebLinkEvent;
import awaybuilder.controller.history.UndoRedoEvent;
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
//            addContextListener( EditorStateChangeEvent.SELECTION_CHANGE, eventDispatcher_selectionChangeHandler);
            addContextListener( EditingSurfaceRequestEvent.SWITCH_CAMERA_TO_FREE, eventDispatcher_switchToFreeHandler);
            addContextListener( EditingSurfaceRequestEvent.SWITCH_CAMERA_TO_TARGET, eventDispatcher_switchToTargetHandler);

            addContextListener( EditingSurfaceRequestEvent.SWITCH_TRANSFORM_ROTATE, eventDispatcher_switchToRotateHandler);
            addContextListener( EditingSurfaceRequestEvent.SWITCH_TRANSFORM_TRANSLATE, eventDispatcher_switchToTranslateHandler);
            addContextListener( EditingSurfaceRequestEvent.SWITCH_TRANSFORM_SCALE, eventDispatcher_switchToScaleHandler);

            addContextListener( SceneEvent.ITEMS_SELECT, context_itemSelectHandler);
            addContextListener( UndoRedoEvent.UNDO_LIST_CHANGE, context_undoListChangeHandler);


            addViewListener( ToolBarEvent.NEW_DOCUMENT, toolBar_newDocumentHandler);
            addViewListener( ToolBarEvent.OPEN_DOCUMENT, toolBar_openDocumentHandler);
            addViewListener( ToolBarEvent.SAVE_DOCUMENT, toolBar_saveDocumentHandler);
            addViewListener( ToolBarEvent.PRINT_DOCUMENT, toolBar_printDocumentHandler);

            addViewListener( ToolBarEvent.UNDO, toolBar_undoHandler);
            addViewListener( ToolBarEvent.REDO, toolBar_redoHandler);

            addViewListener( ToolBarEvent.HELP, toolBar_helpHandler);
            addViewListener( ToolBarEvent.APPLICATION_SETTINGS, toolBar_applicationSettingsHandler);
            addViewListener( ToolBarEvent.DOCUMENT_SETTINGS, toolBar_documentSettingsHandler);
            addViewListener( ToolBarEvent.REPORT_BUG, toolBar_reportBugHandler);

            addViewListener( ToolBarEvent.CLIPBOARD_CUT, toolBar_clipboardCutHandler);
            addViewListener( ToolBarEvent.CLIPBOARD_COPY, toolBar_clipboardCopyHandler);
            addViewListener( ToolBarEvent.CLIPBOARD_PASTE, toolBar_clipboardPasteHandler);

            addViewListener( ToolBarEvent.DELETE_SELECTION, toolBar_deleteSelectionHandler);
            addViewListener( ToolBarEvent.ROTATE_SELECTION_CLOCKWISE, toolBar_rotateSelectionClockwiseHandler);

            addViewListener( ToolBarEvent.FOCUS_OBJECT, toolBar_focusObjectHandler);

            addViewListener( ToolBarEvent.SWITCH_CAMERA_TO_FREE, toolBar_switchMouseToFreeHandler);
            addViewListener( ToolBarEvent.SWITCH_CAMERA_TO_TARGET, toolBar_switchMouseToTargetHandler);

            addViewListener( ToolBarEvent.TRANSFORM_TRANSLATE, toolBar_switchTranslateHandler);
            addViewListener( ToolBarEvent.TRANSFORM_SCALE, toolBar_switchScaleHandler);
            addViewListener( ToolBarEvent.TRANSFORM_ROTATE, toolBar_switchRotateHandler);

            toolBar.undoButton.enabled = undoRedo.canUndo;
            toolBar.redoButton.enabled = undoRedo.canRedo;
		}

        private function context_undoListChangeHandler(event:UndoRedoEvent):void
        {
            this.toolBar.undoButton.enabled = undoRedo.canUndo;
            this.toolBar.redoButton.enabled = undoRedo.canRedo;
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
		
		private function context_itemSelectHandler(event:SceneEvent):void
		{
            if( event.items && event.items.length > 0)
            {
                this.toolBar.deleteButton.enabled = true;
                this.toolBar.focusButton.enabled = true;
            }
            else {
                this.toolBar.deleteButton.enabled = false;
                this.toolBar.focusButton.enabled = false;
            }
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
		
		private function toolBar_focusObjectHandler(event:ToolBarEvent):void
		{
			this.dispatch(new EditingSurfaceRequestEvent(EditingSurfaceRequestEvent.FOCUS_SELECTION));
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
            this.dispatch(new UndoRedoEvent(UndoRedoEvent.UNDO));
		}
		
		private function toolBar_redoHandler(event:ToolBarEvent):void
		{
            this.dispatch(new UndoRedoEvent(UndoRedoEvent.REDO));
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