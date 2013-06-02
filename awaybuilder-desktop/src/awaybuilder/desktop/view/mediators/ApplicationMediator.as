package awaybuilder.desktop.view.mediators
{

	import awaybuilder.controller.clipboard.events.ClipboardEvent;
	import awaybuilder.controller.clipboard.events.PasteEvent;
	import awaybuilder.controller.events.DocumentEvent;
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.events.DocumentRequestEvent;
	import awaybuilder.controller.events.ErrorLogEvent;
	import awaybuilder.controller.events.SaveDocumentEvent;
	import awaybuilder.controller.events.SettingsEvent;
	import awaybuilder.controller.history.UndoRedoEvent;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.desktop.controller.events.AboutEvent;
	import awaybuilder.desktop.controller.events.OpenFromInvokeEvent;
	import awaybuilder.desktop.controller.events.TextureSizeErrorsEvent;
	import awaybuilder.desktop.utils.ModalityManager;
	import awaybuilder.desktop.view.components.ObjectPropertiesWindow;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.UndoRedoModel;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.ObjectVO;
	import awaybuilder.utils.scene.CameraManager;
	import awaybuilder.utils.scene.Scene3DManager;
	
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowDisplayState;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	
	import mx.core.DragSource;
	import mx.core.IIMESupport;
	import mx.events.AIREvent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	import mx.managers.IFocusManagerComponent;
	
	import org.robotlegs.mvcs.Mediator;
	
	import spark.components.supportClasses.SkinnableTextBase;

	public class ApplicationMediator extends Mediator
	{
		//file
		private static const MENU_NEW:String = "new";
		private static const MENU_OPEN:String = "open";
		private static const MENU_IMPORT:String = "import";
		private static const MENU_SAVE:String = "save";
		private static const MENU_SAVE_AS:String = "saveAs";
		private static const MENU_PRINT:String = "print";
		private static const MENU_EXIT:String = "exit";
		
		//edit
		private static const MENU_UNDO:String = "undo";
		private static const MENU_REDO:String = "redo";
		private static const MENU_CUT:String = "cut";
		private static const MENU_COPY:String = "copy";
		private static const MENU_PASTE:String = "paste";
		private static const MENU_SELECT_ALL:String = "selectAll";
		private static const MENU_SELECT_NONE:String = "selectNone";
		private static const MENU_DELETE:String = "delete";
		private static const MENU_ROTATE_CLOCKWISE:String = "rotateClockwise";
		private static const MENU_ROTATE_COUNTER_CLOCKWISE:String = "rotateCounterClockwise";
		private static const MENU_APPLICATION_SETTINGS:String = "applicationSettings";
		private static const MENU_DOCUMENT_SETTINGS:String = "documentSettings";
		
		//tools
		private static const MENU_FREE_CAMERA:String = "freeCamera";
		private static const MENU_TARGET_CAMERA:String = "targetCamera";
//		private static const MENU_SHOW_OBJECT_PICKER:String = "showObjectPicker";
		private static const TRANSLATE_MODE:String = "translateMode";
		private static const ROTATE_MODE:String = "rotateMode";
		private static const SCALE_MODE:String = "scaleMode";
		
		
		//view
		private static const MENU_ZOOM_IN:String = "zoomIn";
		private static const MENU_ZOOM_OUT:String = "zoomOut";
		private static const FOCUS_SELECTED:String = "focusSelected";
		private static const MENU_SHOW_GRID:String = "showGrid";
		private static const MENU_SNAP_TO_GRID:String = "snapToGrid";
		
		//help
		private static const MENU_SAMPLES:String = "helpSamples";
		private static const MENU_CHECK_UPDATE:String = "checkUpdate";
		private static const MENU_ABOUT:String = "about";
		
		[Inject]
		public var app:AwayBuilderApplication;
		
		[Inject]
		public var documentModel:DocumentModel;
		
		[Inject]
		public var undoRedoModel:UndoRedoModel;
		
		private var _propertiesWindow:ObjectPropertiesWindow;
		
		private var _mainMenu:NativeMenu;
		private var _fileMenuItem:NativeMenuItem;
		private var _editMenuItem:NativeMenuItem;
		private var _viewMenuItem:NativeMenuItem;
		private var _toolsMenuItem:NativeMenuItem;
		private var _helpMenuItem:NativeMenuItem;
		
		private var _macAboutItem:NativeMenuItem;
		private var _macPreferencesItem:NativeMenuItem;
		
		private var _cutItem:NativeMenuItem;
		private var _copyItem:NativeMenuItem;
		private var _rotateClockwiseItem:NativeMenuItem;
		private var _rotateCounterClockwiseItem:NativeMenuItem;

        private var _focusItem:NativeMenuItem;
		private var _deleteItem:NativeMenuItem;

        private var _undoItem:NativeMenuItem;
        private var _redoItem:NativeMenuItem;

		private var _panToolItem:NativeMenuItem;
		private var _selectionToolItem:NativeMenuItem;
		private var _translateItem:NativeMenuItem;
		private var _rotateItem:NativeMenuItem;
		private var _scaleItem:NativeMenuItem;
		private var _showObjectPickerItem:NativeMenuItem;
		private var _snapToGridItem:NativeMenuItem;
		private var _showGridItem:NativeMenuItem;
		
		override public function onRegister():void
		{	
			this._propertiesWindow = new ObjectPropertiesWindow();
			this.mediatorMap.createMediator(this._propertiesWindow);
			
			this.populateMenus();
			this.updateMenus();
			this.updateMenuEnabled();
			
			this.updatePageTitle();
			
			addContextListener( DocumentModelEvent.DOCUMENT_NAME_CHANGED, eventDispatcher_documentNameChangedHandler);
			addContextListener( DocumentModelEvent.DOCUMENT_EDITED, eventDispatcher_documentEditedHandler);
			
            addContextListener( SceneEvent.SELECT, context_itemSelectHandler);

			addContextListener( SettingsEvent.SHOW_GRID_CHANGE, eventDispatcher_showGridChangeHandler);
			addContextListener( SettingsEvent.SNAP_TO_GRID_CHANGE, eventDispatcher_snapToGridChangeHandler);
			addContextListener( SettingsEvent.SHOW_OBJECT_PICKER_CHANGE, eventDispatcher_showObjectPickerChangeHandler);
			
			addContextListener( SceneEvent.SWITCH_CAMERA_TO_FREE, eventDispatcher_switchToFreeCameraHandler);
			addContextListener( SceneEvent.SWITCH_CAMERA_TO_TARGET, eventDispatcher_switchToTargetCameraHandler);
			
			addContextListener( SceneEvent.SWITCH_TRANSFORM_TRANSLATE, eventDispatcher_switchTranslateHandler);
			addContextListener( SceneEvent.SWITCH_TRANSFORM_ROTATE, eventDispatcher_switchRotateHandler);
			addContextListener( SceneEvent.SWITCH_TRANSFORM_SCALE, eventDispatcher_switchScaleCameraHandler);

            addContextListener( UndoRedoEvent.UNDO_LIST_CHANGE, context_undoListChangeHandler);
  
            addContextListener( ErrorLogEvent.LOG_ENTRY_MADE, eventDispatcher_errorLogHandler);
          
			addViewListener( Event.CLOSE, awaybuilder_closeHandler );
			addViewListener( Event.CLOSING, awaybuilder_closingHandler );
			addViewListener( AIREvent.WINDOW_ACTIVATE, awaybuilder_windowActivateHandler );
			addViewListener( AIREvent.WINDOW_ACTIVATE, awaybuilder_windowDeactivateHandler );
			
			addViewListener( DragEvent.DRAG_ENTER, awaybuilder_dragEnterHandler );
			addViewListener( DragEvent.DRAG_DROP, awaybuilder_dragDropHandler );
			
			if(this.app.stage)
			{
				this.addStageListeners();
			}
			else
			{
				this.app.addEventListener(Event.ADDED_TO_STAGE, awaybuilder_addedToStageHandler);
			}
			
			//fix for linux window size bug
			this.app.nativeWindow.height++;
			this.app.nativeWindow.height--;
			
			this._propertiesWindow.open();
			if(this.app.nativeWindow.displayState == NativeWindowDisplayState.MAXIMIZED)
			{
				this._propertiesWindow.nativeWindow.x = this.app.nativeWindow.x + this.app.nativeWindow.width - this._propertiesWindow.nativeWindow.width - 20;
			}
			else
			{
				this._propertiesWindow.nativeWindow.x = this.app.nativeWindow.x + (this.app.nativeWindow.width - this._propertiesWindow.nativeWindow.width) / 2;
			}
			this._propertiesWindow.nativeWindow.y = this.app.nativeWindow.y + (this.app.nativeWindow.height - this._propertiesWindow.nativeWindow.height) / 2;
			
//			if(this.updateModel.isReadyToCheckForUpdate)
//			{
//				this.updateModel.updateLastCheckTime();
//				this.dispatch(new MessageBoxEvent(MessageBoxEvent.SHOW_MESSAGE_BOX,
//					"Update", "Would you like to check for an update?",
//					"Check for Update", updateMessageBox_onCheckForUpdate, "Don't Check"));
//			}
			this.updateMenus();
			this.updateMenuEnabled();
		}

        private function context_undoListChangeHandler(event:UndoRedoEvent):void
        {
            _undoItem.enabled = undoRedoModel.canUndo;
            _redoItem.enabled = undoRedoModel.canRedo;
        }
	
		private function eventDispatcher_errorLogHandler(event:ErrorLogEvent):void {
			this.dispatch(new TextureSizeErrorsEvent(TextureSizeErrorsEvent.SHOW_TEXTURE_SIZE_ERRORS));
		}

		private function updatePageTitle():void
		{
			var newTitle:String = "Away Builder - " + this.documentModel.name;
			if(this.documentModel.edited)
			{
				newTitle += " *";
			}
			this.app.title = newTitle;
		}
		
		private function addStageListeners():void
		{
			this.eventMap.mapListener(this.app.stage, KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
		}
		
//		private function checkForUpdate():void
//		{
//			this.updateModel.updateLastCheckTime();
//			navigateToURL(new URLRequest("http://sample.com/download/?update_from=" + this.version), "_blank");
//		}
		
//		private function updateMessageBox_onCheckForUpdate():void
//		{
//			this.checkForUpdate();
//		}
		
		private function eventDispatcher_documentEditedHandler(event:DocumentModelEvent):void
		{
			this.updatePageTitle();
		}
		
		private function eventDispatcher_documentNameChangedHandler(event:DocumentModelEvent):void
		{
			this.updatePageTitle();
		}
		
		private function eventDispatcher_newDocumentHandler(event:DocumentEvent):void
		{
			this.app.visible = true;
		}
		
		private function context_itemSelectHandler(event:SceneEvent):void
		{
			if( event.items && event.items.length > 0)
			{
				var isSceneItemsSelected:Boolean = true;
				for each( var asset:AssetVO in event.items )
				{
					if( !(asset is ObjectVO) )
						isSceneItemsSelected = false;
				}
				
				_focusItem.enabled = isSceneItemsSelected;
				_deleteItem.enabled = true;
			}
			else 
			{
				_focusItem.enabled = false;
				_deleteItem.enabled = false;
			}
		}
		
		private function eventDispatcher_showGridChangeHandler(event:Event):void
		{
		}
		
		private function eventDispatcher_snapToGridChangeHandler(event:Event):void
		{
		}
		
		private function eventDispatcher_showObjectPickerChangeHandler(event:Event):void
		{
		}
		
		private function eventDispatcher_switchToFreeCameraHandler(event:SceneEvent):void
		{
			this._selectionToolItem.checked = false;
			this._panToolItem.checked = true;
		}
		
		private function eventDispatcher_switchToTargetCameraHandler(event:SceneEvent):void
		{
			this._panToolItem.checked = false;
			this._selectionToolItem.checked = true;
		}
		
		private function eventDispatcher_switchTranslateHandler(event:SceneEvent):void
		{
			this._translateItem.checked = true;
			this._rotateItem.checked = false;
			this._scaleItem.checked = false;
		}
		
		private function eventDispatcher_switchRotateHandler(event:SceneEvent):void
		{
			this._translateItem.checked = false;
			this._rotateItem.checked = true;
			this._scaleItem.checked = false;
		}
		
		private function eventDispatcher_switchScaleCameraHandler(event:SceneEvent):void
		{
			this._translateItem.checked = false;
			this._rotateItem.checked = false;
			this._scaleItem.checked = true;
		}
		
		private function awaybuilder_dragEnterHandler(event:DragEvent):void
		{
			const dragSource:DragSource = event.dragSource;
			if(dragSource.hasFormat("air:file list"))
			{
				var fileList:Array = dragSource.dataForFormat("air:file list") as Array;
				if(fileList.length == 1)
				{
					const extensions:Vector.<String> = new <String>["awd","3ds","obj","md2","png","jpg","atf","dae","md5"];
					for each(var file:File in fileList)
					{
						if(file.exists && extensions.indexOf(file.extension) >= 0)
						{
							DragManager.acceptDragDrop(this.app);
							break;
						}
					}
				}
			}
		}
		
		private function awaybuilder_dragDropHandler(event:DragEvent):void
		{
			var file:File = event.dragSource.dataForFormat("air:file list")[0];
			this.dispatch(new OpenFromInvokeEvent(OpenFromInvokeEvent.OPEN_FROM_INVOKE, file));
		}
		
		private function awaybuilder_closeHandler(event:Event):void
		{
			this._propertiesWindow.close();
			this._propertiesWindow = null;
		}
		
		private function awaybuilder_closingHandler(event:Event):void
		{
			//if any window other than the document or properties window is open
			//cancel this attempt to close.
			for each(var window:NativeWindow in NativeApplication.nativeApplication.openedWindows)
			{
				if(window != this.app.nativeWindow && window != this._propertiesWindow.nativeWindow)
				{
					var child:DisplayObject = window.stage.getChildAt(0);
					//this is a hacky way to detect that the window is the
					//updater UI. I have no intention of using Loader in any
					//other window.
					if(!(child is Loader))
					{
						event.preventDefault();
						return;
					}
				}
			}
			if(this.documentModel.edited)
			{
				event.preventDefault();
				this.dispatch(new DocumentRequestEvent(DocumentRequestEvent.REQUEST_CLOSE_DOCUMENT));
			}
		}
		
		private function awaybuilder_windowActivateHandler(event:Event):void
		{
			this.app.callLater(this.app.callLater, [this.updateMenuEnabled]);
		}
		
		private function propertiesWindow_windowActivateHandler(event:Event):void
		{
			this.app.callLater(this.app.callLater, [this.updateMenuEnabled]);
		}
		
		private function awaybuilder_windowDeactivateHandler(event:Event):void
		{
			this.app.callLater(this.app.callLater, [this.updateMenuEnabled]);
		}
		
		private function awaybuilder_addedToStageHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(Event.ADDED_TO_STAGE, awaybuilder_addedToStageHandler);
			this.addStageListeners();
		}
		
		private function menuItem_selectHandler(event:Event):void
		{	
			if(!this._fileMenuItem.enabled || ModalityManager.modalityManager.modalWindowCount > 0)
			{
				//I'm not sure if a menu item can be triggered when a modal
				//window is open, but better safe than sorry.
				return;
			}
			var item:NativeMenuItem = NativeMenuItem(event.currentTarget);
			var itemData:String = item.data.toString();
			switch(itemData)
			{
				case MENU_NEW:
				{
					this.dispatch(new DocumentRequestEvent(DocumentRequestEvent.REQUEST_NEW_DOCUMENT));
					break;
				}
				case MENU_OPEN:
				{
					this.dispatch(new DocumentRequestEvent(DocumentRequestEvent.REQUEST_OPEN_DOCUMENT));
					break;
				}
				case MENU_IMPORT:
				{
					this.dispatch(new DocumentRequestEvent(DocumentRequestEvent.REQUEST_IMPORT_DOCUMENT));
					break;
				}
				case MENU_SAVE:
				{
					this.dispatch(new SaveDocumentEvent(SaveDocumentEvent.SAVE_DOCUMENT));
					break;
				}
				case MENU_SAVE_AS:
				{
					this.dispatch(new SaveDocumentEvent(SaveDocumentEvent.SAVE_DOCUMENT_AS));
					break;
				}
				case MENU_EXIT:
				{
					this.app.close();
					break;
				}
				//edit
				case MENU_UNDO:
				{
                    this.dispatch(new UndoRedoEvent(UndoRedoEvent.UNDO));
					break;
				}
				case MENU_REDO:
				{
                    this.dispatch(new UndoRedoEvent(UndoRedoEvent.REDO));
					break;
				}
				case MENU_CUT:
				{
					this.dispatch(new ClipboardEvent(ClipboardEvent.CLIPBOARD_CUT));
					break;
				}
				case MENU_COPY:
				{
					this.dispatch(new ClipboardEvent(ClipboardEvent.CLIPBOARD_COPY));
					break;
				}
				case MENU_PASTE:
				{
					this.dispatch(new PasteEvent(PasteEvent.CLIPBOARD_PASTE));
					break;
				}
				case MENU_SELECT_ALL:
				{
					var focus:IFocusManagerComponent = this.app.focusManager.getFocus();
					if(focus is SkinnableTextBase && SkinnableTextBase(focus).selectable)
					{
						SkinnableTextBase(focus).selectAll();
						break;
					}
					this.dispatch(new SceneEvent(SceneEvent.SELECT_ALL, null));
					break;
				}
				case MENU_SELECT_NONE:
				{
					this.dispatch(new SceneEvent(SceneEvent.SELECT_NONE, null));
					break;
				}
				case MENU_DELETE:
				{
					if(this.documentModel.selectedAssets.length > 0)
					{
						this.dispatch(new SceneEvent(SceneEvent.VALIDATE_DELETION));
					}
					break;
				}
				case MENU_DOCUMENT_SETTINGS:
				{
					this.dispatch(new SettingsEvent(SettingsEvent.SHOW_DOCUMENT_SETTINGS));
					break;
				}
				//tools
				case MENU_FREE_CAMERA:
					this.dispatch(new SceneEvent(SceneEvent.SWITCH_CAMERA_TO_FREE, null));
					break;
				case MENU_TARGET_CAMERA:
					this.dispatch(new SceneEvent(SceneEvent.SWITCH_CAMERA_TO_TARGET, null));
					break;
				case TRANSLATE_MODE:
					this.dispatch(new SceneEvent(SceneEvent.SWITCH_TRANSFORM_TRANSLATE, null));
					break;
				case ROTATE_MODE:
					this.dispatch(new SceneEvent(SceneEvent.SWITCH_TRANSFORM_ROTATE, null));
					break;
				case SCALE_MODE:
					this.dispatch(new SceneEvent(SceneEvent.SWITCH_TRANSFORM_SCALE, null));
					break;
				//view
				case MENU_ZOOM_OUT:
				{
					Scene3DManager.zoomDistanceDelta( -CameraManager.ZOOM_DELTA_VALUE );
					break;
				}
				case MENU_ZOOM_IN:
				{
					Scene3DManager.zoomDistanceDelta( CameraManager.ZOOM_DELTA_VALUE );
					break;
				}
				case FOCUS_SELECTED:
				{
					this.dispatch(new SceneEvent(SceneEvent.FOCUS_SELECTION));
                    break;
				}
				//help
				case MENU_ABOUT:
				{
					this.dispatch(new AboutEvent(AboutEvent.SHOW_ABOUT));
					break;
				}
				case MENU_CHECK_UPDATE:
				{
//					this.checkForUpdate();
					break;
				}
				default:
				{
					trace("Menu item not implemented: " + itemData + ".");
				}
			}
		}
		
		private function stage_keyDownHandler(event:KeyboardEvent):void
		{
			const focus:IFocusManagerComponent = this.app.focusManager.getFocus();
			if(!this._fileMenuItem.enabled || focus is IIMESupport || ModalityManager.modalityManager.modalWindowCount > 0)
			{
				//if I can enter text into whatever has focus, then that takes
				//precedence over keyboard shortcuts.
				//if a modal window is open, or the menu is disabled, no
				//keyboard shortcuts are allowed
				return;
			}
			
			if(event.keyCode == Keyboard.F1)
			{
//				this.dispatch(new WebLinkEvent(WebLinkEvent.LINK_ONLINE_HELP));
			}
			else if(String.fromCharCode(event.charCode) == "+" && event.ctrlKey)
			{
				Scene3DManager.zoomDistanceDelta( CameraManager.ZOOM_DELTA_VALUE );
			}
			else if(String.fromCharCode(event.charCode) == "=" && event.ctrlKey)
			{
				Scene3DManager.zoomDistanceDelta( CameraManager.ZOOM_DELTA_VALUE );
			}
			else if(String.fromCharCode(event.charCode) == "-" && event.ctrlKey)
			{
				Scene3DManager.zoomDistanceDelta( -CameraManager.ZOOM_DELTA_VALUE );
			}
			else if((event.keyCode == Keyboard.DELETE) || (event.keyCode == Keyboard.BACKSPACE && event.ctrlKey))
			{
				if(this.documentModel.selectedAssets.length > 0)
				{
					this.dispatch(new SceneEvent(SceneEvent.VALIDATE_DELETION));
				}
			}
		}
		
		private function createMenuItem(text:String, data:Object, addTo:NativeMenu, index:int = -1, keyEquivalent:String = null, modifiers:Array = null):NativeMenuItem
		{
			var item:NativeMenuItem = new NativeMenuItem(text);
			item.data = data;
			if(keyEquivalent)
			{
				item.keyEquivalent = keyEquivalent;
			}
			if(modifiers)
			{
				item.keyEquivalentModifiers = modifiers;
			}
			if(index >= 0)
			{
				addTo.addItemAt(item, index);
			}
			else
			{
				addTo.addItem(item);
			}
			item.addEventListener(Event.SELECT, menuItem_selectHandler);
			return item;
		}
		
		private function populateMenus():void
		{
			var isWin:Boolean = (Capabilities.os.indexOf("Windows") >= 0); 
			var isMac:Boolean = (Capabilities.os.indexOf("Mac OS") >= 0); 
			
			if(NativeApplication.supportsMenu)
			{
				this._mainMenu = NativeApplication.nativeApplication.menu;
				const menuItemCount:int = this._mainMenu.numItems;
				for(var i:int = 1; i < menuItemCount; i++)
				{
					//keep the default first item (the name of the application)
					//but remove all the others.
					this._mainMenu.removeItemAt(1);
				}
				
				var appMenuItem:NativeMenuItem = this._mainMenu.getItemAt(0);
				var appMenu:NativeMenu = appMenuItem.submenu;
				//remove the default quit item
				appMenu.removeItemAt(appMenu.numItems - 1);
				//remove the default about item
				appMenu.removeItemAt(0);
				
				appMenu.addItemAt(new NativeMenuItem("", true), 0);
				this._macAboutItem = this.createMenuItem("About Away Builder", MENU_ABOUT, appMenu, 0);
				this._macPreferencesItem = this.createMenuItem("Preferences...", MENU_APPLICATION_SETTINGS, appMenu);
				appMenu.addItem(new NativeMenuItem("", true));
				//add it again to act like other custom menu items
				this.createMenuItem("Quit", MENU_EXIT, appMenu, -1, "q");
			}
			else
			{
				this._mainMenu = new NativeMenu();
			}
			
			this._fileMenuItem = new NativeMenuItem("File");
			var fileMenu:NativeMenu = new NativeMenu();
			
			this.createMenuItem("New", MENU_NEW, fileMenu, -1, "n");
			this.createMenuItem("Open...", MENU_OPEN, fileMenu, -1, "o");
			fileMenu.addItem(new NativeMenuItem("", true));
			this.createMenuItem("Import...", MENU_IMPORT, fileMenu, -1, "i");
			
			fileMenu.addItem(new NativeMenuItem("", true));
			this.createMenuItem("Save", MENU_SAVE, fileMenu, -1, "s");
			this.createMenuItem("Save As...", MENU_SAVE_AS, fileMenu, -1, "S");
			
			if(!NativeApplication.supportsMenu)
			{
				fileMenu.addItem(new NativeMenuItem("", true));
				this.createMenuItem("Exit", MENU_EXIT, fileMenu);
			}
			this._fileMenuItem.submenu = fileMenu;
			this._mainMenu.addItem(this._fileMenuItem);
			
			this._editMenuItem = new NativeMenuItem("Edit");
			var editMenu:NativeMenu = new NativeMenu();
			_undoItem = createMenuItem("Undo", MENU_UNDO, editMenu, -1, "z");
            _undoItem.enabled = false;
            _redoItem = createMenuItem("Redo", MENU_REDO, editMenu, -1, "y");
            _redoItem.enabled = false;
			editMenu.addItem(new NativeMenuItem("", true));
			this._cutItem = this.createMenuItem("Cut", MENU_CUT, editMenu, -1, "x");
			this._copyItem = this.createMenuItem("Copy", MENU_COPY, editMenu, -1, "c");
			this.createMenuItem("Paste", MENU_PASTE, editMenu, -1, "v");
			editMenu.addItem(new NativeMenuItem("", true));
			if( isWin )
			{
				_deleteItem = createMenuItem("Delete",MENU_DELETE, editMenu, -1, "del", []);
			}
			else
			{
				_deleteItem = createMenuItem("Delete",MENU_DELETE, editMenu);
			}
			
			editMenu.addItem(new NativeMenuItem("", true));
			this.createMenuItem("Select All", MENU_SELECT_ALL, editMenu, -1, "a");
			this.createMenuItem("Select None", MENU_SELECT_NONE, editMenu, -1, "A");
			editMenu.addItem(new NativeMenuItem("", true));
			this.createMenuItem("Document Settings", MENU_DOCUMENT_SETTINGS, editMenu);
			this._editMenuItem.submenu = editMenu;
			this._mainMenu.addItem(this._editMenuItem);
			
			this._viewMenuItem = new NativeMenuItem("View");
			var viewMenu:NativeMenu = new NativeMenu();
			this.createMenuItem("Zoom In", MENU_ZOOM_IN, viewMenu, -1, "+");
			this.createMenuItem("Zoom Out", MENU_ZOOM_OUT, viewMenu, -1, "-");
			viewMenu.addItem(new NativeMenuItem("", true));
			_focusItem = createMenuItem("Focus Selected", FOCUS_SELECTED, viewMenu);
            _focusItem.enabled = false;
//			this._snapToGridItem = this.createMenuItem("Snap To Grid", MENU_SNAP_TO_GRID, viewMenu);
//			this._snapToGridItem.checked = this.settingsModel.snapToGrid;
//			this._showGridItem = this.createMenuItem("Show Grid", MENU_SHOW_GRID, viewMenu);
			this._viewMenuItem.submenu = viewMenu;
			this._mainMenu.addItem(this._viewMenuItem);
			
			this._toolsMenuItem = new NativeMenuItem("Tools");
			var toolsMenu:NativeMenu = new NativeMenu();
			this._selectionToolItem = this.createMenuItem("Target Camera Mode", MENU_TARGET_CAMERA, toolsMenu, -1, "T", []);
			this._selectionToolItem.checked = true;
			this._panToolItem = this.createMenuItem("Free Camera Mode", MENU_FREE_CAMERA, toolsMenu, -1, "F", []);
			this._panToolItem.checked = false;
			toolsMenu.addItem(new NativeMenuItem("", true));
			this._translateItem = this.createMenuItem("Translate Transform Mode", TRANSLATE_MODE, toolsMenu, -1, "t", [Keyboard.ALTERNATE]);
			this._translateItem.checked = true;
			this._rotateItem = this.createMenuItem("Rotate Transform Mode", ROTATE_MODE, toolsMenu, -1, "r",  [Keyboard.ALTERNATE]);
			this._rotateItem.checked = false;
			this._scaleItem = this.createMenuItem("Scale Transform Mode", SCALE_MODE, toolsMenu, -1, "s",  [Keyboard.ALTERNATE]);
			this._scaleItem.checked = false;
//			this._showObjectPickerItem = this.createMenuItem("Show Object Picker", MENU_SHOW_OBJECT_PICKER, toolsMenu);
//			this._showObjectPickerItem.checked = this.settingsModel.showObjectPicker;
			this._toolsMenuItem.submenu = toolsMenu;
			this._mainMenu.addItem(this._toolsMenuItem);
			
			this._helpMenuItem = new NativeMenuItem("Help");
			var helpMenu:NativeMenu = new NativeMenu();
//			this.createMenuItem("Contents...", MENU_HELP_CONTENTS, helpMenu);
//			this.createMenuItem("Report a Bug...", MENU_REPORT_BUG, helpMenu);
			
			if(!NativeApplication.supportsMenu)
			{
				this.createMenuItem("About", MENU_ABOUT, helpMenu);
			}
			this._helpMenuItem.submenu = helpMenu;
			this._mainMenu.addItem(this._helpMenuItem);
			
			if(NativeApplication.supportsMenu)
			{
				NativeApplication.nativeApplication.menu = this._mainMenu;
			}
			else if(NativeWindow.supportsMenu)
			{
				this.app.nativeWindow.menu = this._mainMenu;
			}
		}
		
		private function updateMenuEnabled():void
		{
			var menusEnabled:Boolean = this.app.visible &&
				(this.app.nativeApplication.activeWindow == this.app.nativeWindow || !this.app.nativeApplication.activeWindow);
			this._fileMenuItem.enabled = menusEnabled;
			this._editMenuItem.enabled = menusEnabled;
			this._toolsMenuItem.enabled = menusEnabled;
			this._viewMenuItem.enabled = menusEnabled;
			this._helpMenuItem.enabled = menusEnabled;
			
			//since these have such simple key combos, they may still get triggered
			this._selectionToolItem.enabled = menusEnabled;
			this._panToolItem.enabled = menusEnabled;
			
			//no opening windows if a modal window is open!
			if(this._macAboutItem)
			{
				this._macAboutItem.enabled = menusEnabled;
			}
			if(this._macPreferencesItem)
			{
				this._macPreferencesItem.enabled = menusEnabled;
			}
			
			//notice that the awaybuilder UI is enabled when the properties window
			//is active, but not the menus. this ensures that keyboard shortcuts
			//don't stop input to textareas/textinputs in the properties window
			//but it's okay if the user clicks something in the main window.
//			this.app.enabled = this.app.visible &&
//				(this.app.nativeApplication.activeWindow == this.app.nativeWindow ||
//				this.app.nativeApplication.activeWindow == this._propertiesWindow.nativeWindow ||
//				!this.app.nativeApplication.activeWindow);
		}
		
		private function updateMenus():void
		{
//			this._cutItem.enabled = this.editorModel.selectedObjects.length > 0;
//			this._copyItem.enabled = this.editorModel.selectedObjects.length > 0;
//			this._rotateClockwiseItem.enabled = this.editorModel.selectedObjects.length > 0;
//			this._rotateCounterClockwiseItem.enabled = this.editorModel.selectedObjects.length > 0;
//			this._deleteItem.enabled = this.editorModel.selectedObjects.length > 0;
		}
	}
}