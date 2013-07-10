package awaybuilder.web.view.mediators
{

	import awaybuilder.controller.clipboard.events.ClipboardEvent;
	import awaybuilder.controller.events.DocumentEvent;
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.events.ErrorLogEvent;
	import awaybuilder.controller.events.TextureSizeErrorsEvent;
	import awaybuilder.controller.history.UndoRedoEvent;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.ApplicationModel;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.UndoRedoModel;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.ObjectVO;
	import awaybuilder.utils.enumerators.EMenuItem;
	import awaybuilder.view.mediators.BaseApplicationMediator;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	import mx.controls.menuClasses.MenuItemRenderer;
	import mx.core.DragSource;
	import mx.core.IIMESupport;
	import mx.events.DragEvent;
	import mx.events.MenuEvent;
	import mx.managers.IFocusManagerComponent;
	import mx.rpc.events.InvokeEvent;
	
	import org.robotlegs.mvcs.Mediator;

	public class ApplicationMediator extends BaseApplicationMediator
	{
		
		[Inject]
		public var app:AwayBuilderApplication;
		
		[Inject]
		public var documentModel:DocumentModel;
		
		[Inject]
		public var undoRedoModel:UndoRedoModel;
		
		[Inject]
		public var applicationModel:ApplicationModel;
		
		private var _menuCache:Dictionary;
		
		[PostConstruct] 
		public function initialize():void
		{ 
			applicationModel.webRestrictionsEnabled = true;
		}
		
		override public function onRegister():void
		{	
			applicationModel.webRestrictionsEnabled = true;
			
			_menuCache = new Dictionary();
			
			app.menu.addEventListener(MenuEvent.ITEM_CLICK, menu_itemClickHandler );
			
			this.updatePageTitle();
			
			addContextListener( DocumentModelEvent.DOCUMENT_NAME_CHANGED, eventDispatcher_documentNameChangedHandler);
			addContextListener( DocumentModelEvent.DOCUMENT_EDITED, eventDispatcher_documentEditedHandler);
			
			addContextListener( SceneEvent.SELECT, context_itemSelectHandler);
			addContextListener( SceneEvent.SWITCH_CAMERA_TO_FREE, eventDispatcher_switchToFreeCameraHandler);
			addContextListener( SceneEvent.SWITCH_CAMERA_TO_TARGET, eventDispatcher_switchToTargetCameraHandler);
			addContextListener( SceneEvent.SWITCH_TRANSFORM_TRANSLATE, eventDispatcher_switchTranslateHandler);
			addContextListener( SceneEvent.SWITCH_TRANSFORM_ROTATE, eventDispatcher_switchRotateHandler);
			addContextListener( SceneEvent.SWITCH_TRANSFORM_SCALE, eventDispatcher_switchScaleCameraHandler);
			
			addContextListener( ClipboardEvent.CLIPBOARD_COPY, context_copyHandler);
			addContextListener( UndoRedoEvent.UNDO_LIST_CHANGE, context_undoListChangeHandler);
			addContextListener( ErrorLogEvent.LOG_ENTRY_MADE, eventDispatcher_errorLogHandler);
			
			this.eventMap.mapListener(this.app.stage, KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			
			getItemByValue( EMenuItem.UNDO ).enabled = undoRedoModel.canUndo;
			getItemByValue( EMenuItem.REDO ).enabled = undoRedoModel.canRedo;
			getItemByValue( EMenuItem.FOCUS ).enabled = false;
			getItemByValue( EMenuItem.DELETE ).enabled = false;
			getItemByValue( EMenuItem.CUT ).enabled = false;
			getItemByValue( EMenuItem.COPY ).enabled = false;
			getItemByValue( EMenuItem.PASTE ).enabled = false;
			
		}
		
		private function getItemByValue( value:String ):Object
		{
			if( _menuCache[value] ) return _menuCache[value];
			_menuCache[value] = findItem( value, app.menuProvider );
			return _menuCache[value];
		}
		private function findItem( value:String, items:Array ):Object
		{
			for each( var item:Object in items )
			{
				if( item.value == value ) return item;
				if( item.children )
				{
					var nativeMenuItem:Object = findItem( value, item.children );
					if( nativeMenuItem ) return nativeMenuItem;
				}
			}
			return null;
		}
		
		private function context_undoListChangeHandler(event:UndoRedoEvent):void
		{
			getItemByValue( EMenuItem.UNDO ).enabled = undoRedoModel.canUndo;
			getItemByValue( EMenuItem.REDO ).enabled = undoRedoModel.canRedo;
		}
		
		private function eventDispatcher_errorLogHandler(event:ErrorLogEvent):void {
			this.dispatch(new TextureSizeErrorsEvent(TextureSizeErrorsEvent.SHOW_TEXTURE_SIZE_ERRORS));
		}
		
		private function updatePageTitle():void
		{
//			var newTitle:String = "Away Builder - " + this.documentModel.name;
//			if(this.documentModel.edited)
//			{
//				newTitle += " *";
//			}
//			this.app.title = newTitle;
		}
		
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
				
				getItemByValue( EMenuItem.FOCUS ).enabled = isSceneItemsSelected;
				getItemByValue( EMenuItem.DELETE ).enabled = true;
				getItemByValue( EMenuItem.COPY ).enabled = isSceneItemsSelected;
				getItemByValue( EMenuItem.CUT ).enabled = isSceneItemsSelected;
			}
			else 
			{
				getItemByValue( EMenuItem.FOCUS ).enabled = false;
				getItemByValue( EMenuItem.DELETE ).enabled = false;
				getItemByValue( EMenuItem.COPY ).enabled = false;
				getItemByValue( EMenuItem.CUT ).enabled = false;
			}
		}
		
		private function eventDispatcher_switchToFreeCameraHandler(event:SceneEvent):void
		{
			getItemByValue( EMenuItem.TARGET_CAMERA ).toggled = false;
			getItemByValue( EMenuItem.FREE_CAMERA ).toggled = true;
		}
		
		private function eventDispatcher_switchToTargetCameraHandler(event:SceneEvent):void
		{
			getItemByValue( EMenuItem.TARGET_CAMERA ).toggled = true;
			getItemByValue( EMenuItem.FREE_CAMERA ).toggled = false;
		}
		
		private function eventDispatcher_switchTranslateHandler(event:SceneEvent):void
		{
			getItemByValue( EMenuItem.TRANSLATE_MODE ).toggled = true;
			getItemByValue( EMenuItem.ROTATE_MODE ).toggled = false;
			getItemByValue( EMenuItem.SCALE_MODE ).toggled = false;
		}
		
		private function eventDispatcher_switchRotateHandler(event:SceneEvent):void
		{
			getItemByValue( EMenuItem.TRANSLATE_MODE ).toggled = false;
			getItemByValue( EMenuItem.ROTATE_MODE ).toggled = true;
			getItemByValue( EMenuItem.SCALE_MODE ).toggled = false;
		}
		
		private function eventDispatcher_switchScaleCameraHandler(event:SceneEvent):void
		{
			getItemByValue( EMenuItem.TRANSLATE_MODE ).toggled = false;
			getItemByValue( EMenuItem.ROTATE_MODE ).toggled = false;
			getItemByValue( EMenuItem.SCALE_MODE ).toggled = true;
		}
		
		private function context_copyHandler(event:ClipboardEvent):void
		{
			getItemByValue( EMenuItem.PASTE ).enabled = true;
			getItemByValue( EMenuItem.CUT ).enabled = true;
		}
		
		private function menu_itemClickHandler(event:MenuEvent):void
		{	
			onItemSelect( event.item.value );
		}
		
		private function stage_keyDownHandler(event:KeyboardEvent):void
		{
			const focus:IFocusManagerComponent = this.app.focusManager.getFocus();
			if( focus is IIMESupport)
			{
				//if I can enter text into whatever has focus, then that takes
				//precedence over keyboard shortcuts.
				//if a modal window is open, or the menu is disabled, no
				//keyboard shortcuts are allowed
				return;
			}
			onKeyDown( event );
			
		}
	}
}