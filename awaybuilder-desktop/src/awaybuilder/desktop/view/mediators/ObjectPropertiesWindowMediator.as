package awaybuilder.desktop.view.mediators
{
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindowDisplayState;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import mx.core.IIMESupport;
	import mx.managers.IFocusManagerComponent;
	import mx.skins.ProgrammaticSkin;
	
	import awaybuilder.components.IEditorObjectView;
	import awaybuilder.desktop.utils.ModalityManager;
	import awaybuilder.desktop.view.components.ObjectPropertiesWindow;
	import awaybuilder.controller.events.EditorStateChangeEvent;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.IEditorModel;
	import awaybuilder.model.UndoRedoModel;
	import awaybuilder.view.components.propertyEditors.IObjectPropertyEditor;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class ObjectPropertiesWindowMediator extends Mediator
	{
		[Inject]
		public var window:ObjectPropertiesWindow;
		
		public var propertyEditor:IObjectPropertyEditor;
		
		[Inject]
		public var editor:IEditorModel;
		
		[Inject]
		public var document:DocumentModel;
		
		[Inject]
		public var undoRedo:UndoRedoModel;
		
		[Inject]
		public var mainWindow:AwayBuilderApplication;
		
		private var _hasDisplayedWindow:Boolean = false;
		
		override public function onRegister():void
		{	
			this.eventMap.mapListener(this.eventDispatcher, EditorStateChangeEvent.SELECTION_CHANGE, eventDispatcher_selectionChangeHandler);
			this.eventMap.mapListener(this.eventDispatcher, EditorStateChangeEvent.OBJECT_PROPERTY_CHANGE, eventDispatcher_objectPropertyChangeHandler);
			
			this.eventMap.mapListener(this.window, Event.CLOSING, window_closingHandler);
			this.eventMap.mapListener(NativeApplication.nativeApplication, Event.ACTIVATE, nativeApplication_activateHandler);
			this.eventMap.mapListener(NativeApplication.nativeApplication, Event.DEACTIVATE, nativeApplication_deactivateHandler);
			
			if(!NativeApplication.supportsMenu)
			{
				this.eventMap.mapListener(this.window.stage, KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			}
		}
		
		private function hideWindow():void
		{
			this.window.visible = false;
			this.cleanupOldPropertyEditor();
		}
		
		private function resetWindowPosition():void
		{
			if(this.mainWindow.nativeWindow.displayState == NativeWindowDisplayState.MAXIMIZED)
			{
				this.window.nativeWindow.x = this.mainWindow.nativeWindow.x + this.mainWindow.nativeWindow.width - this.window.nativeWindow.width - 20;
			}
			else
			{
				this.window.nativeWindow.x = this.mainWindow.nativeWindow.x + this.mainWindow.nativeWindow.width - this.window.nativeWindow.width / 2;
			}
			this.window.nativeWindow.y = this.mainWindow.nativeWindow.y + (this.mainWindow.nativeWindow.height - this.window.nativeWindow.height) / 2;
		}
		
		private function cleanupOldPropertyEditor():void
		{
			if(!this.window || !this.propertyEditor)
			{
				return;
			}
			this.window.mxmlContent = null;
			this.propertyEditor = null;
		}
		
		private function eventDispatcher_selectionChangeHandler(event:EditorStateChangeEvent):void
		{
			//empty the contents of the dialog. we're going to add something new.
			if(this.propertyEditor)
			{
				this.cleanupOldPropertyEditor();
			}
			
			const selectedObjects:Vector.<IEditorObjectView> = this.editor.selectedObjects;
			if(selectedObjects.length != 1)
			{
				this.hideWindow();
				return;
			}
			
			var object:IEditorObjectView = selectedObjects[0];
			if(!object.propertyEditor)
			{
				this.hideWindow();
				return;
			}
			
			this.window.title = object.readableType + " Properties";
			
			var PropertyEditorType:Class = object.propertyEditor;
			this.propertyEditor = new PropertyEditorType();
			this.propertyEditor.object = object;
			this.propertyEditor.setStyle("focusSkin", ProgrammaticSkin);
			this.window.mxmlContent = [this.propertyEditor];
			this.window.validateNow();
			this.propertyEditor.setFocus();
			this.window.width = this.window.measuredWidth;
			this.window.height = this.window.measuredHeight;
			
			if(!this._hasDisplayedWindow)
			{
				this.resetWindowPosition();
				this._hasDisplayedWindow = true;
			}
			this.window.visible = true;
		}
		
		private function eventDispatcher_objectPropertyChangeHandler(event:EditorStateChangeEvent):void
		{
			const selectedObjects:Vector.<IEditorObjectView> = this.editor.selectedObjects;
			if(selectedObjects.length != 1)
			{
				return;
			}
			this.propertyEditor.object = null;
			this.propertyEditor.object = selectedObjects[0];
		}
		
		private function window_closingHandler(event:Event):void
		{
			if(!this.mainWindow.closed)
			{
				event.preventDefault();
				this.hideWindow();
			}
		}
		
		private function nativeApplication_activateHandler(event:Event):void
		{
			if(this.propertyEditor)
			{
				this.window.visible = true;
				this.window.orderToFront();
			}
		}
		
		private function nativeApplication_deactivateHandler(event:Event):void
		{
			this.window.visible = false;
		}
		
		private function stage_keyDownHandler(event:KeyboardEvent):void
		{
			const focus:IFocusManagerComponent = this.window.focusManager.getFocus();
			if(focus is IIMESupport || ModalityManager.modalityManager.modalWindowCount > 0)
			{
				//if I can enter text into whatever has focus, then that takes
				//precedence over keyboard shortcuts.
				//if a modal window is open, or the menu is disabled, no
				//keyboard shortcuts are allowed
				return;
			}
			if(event.ctrlKey && !event.shiftKey && String.fromCharCode(event.charCode).toLowerCase() == "z")
			{
				this.undoRedo.undo();
				this.document.edited = true;
			}
			if(event.ctrlKey && event.shiftKey && String.fromCharCode(event.charCode).toLowerCase() == "z")
			{
				this.undoRedo.redo();
				this.document.edited = true;
			}
		}
	}
}