package awaybuilder.view.mediators
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.ui.Keyboard;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	
	import away3d.entities.Mesh;
	
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.ISettingsModel;
	import awaybuilder.model.vo.ScenegraphItemVO;
	import awaybuilder.utils.ArrayUtil;
	import awaybuilder.utils.scene.CameraManager;
	import awaybuilder.utils.scene.Scene3DManager;
	import awaybuilder.view.components.CoreEditor;
	import awaybuilder.view.components.events.CoreEditorEvent;
	import awaybuilder.view.scene.events.Scene3DManagerEvent;
	
	import org.robotlegs.mvcs.Mediator;

	public class CoreEditorMediator extends Mediator
	{
		[Inject]
		public var view:CoreEditor;
		
		[Inject]
		public var settings:ISettingsModel;
		
		[Inject]
		public var document:IDocumentModel;
		
		override public function onRegister():void
		{
			FlexGlobals.topLevelApplication.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
			
			Scene3DManager.instance.addEventListener(Scene3DManagerEvent.READY, scene_readyHandler);
			Scene3DManager.instance.addEventListener(Scene3DManagerEvent.MESH_SELECTED, scene_meshSelectedHandler);
			Scene3DManager.init( view.scope );
			
            addViewListener(CoreEditorEvent.TREE_CHANGE, view_treeChangeHandler, CoreEditorEvent);

            addContextListener(DocumentModelEvent.DOCUMENT_UPDATED, eventDispatcher_documentUpdatedHandler, DocumentModelEvent);
            addContextListener(SceneEvent.ITEMS_SELECT, eventDispatcher_itemsSelectHandler, SceneEvent);

			view.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			view.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);	
			
			updateScenegraph();
		}
		
		//----------------------------------------------------------------------
		//
		//	view handlers
		//
		//----------------------------------------------------------------------
		
		private function view_treeChangeHandler(event:CoreEditorEvent):void
		{
			var items:Vector.<Object> = new Vector.<Object>();
			var selectedItems:Vector.<Object> = event.data as Vector.<Object>;
			for (var i:int=0;i<selectedItems.length;i++)
			{
				items.push(ScenegraphItemVO(selectedItems[i]).item);
			}
			
			this.dispatch(new SceneEvent(SceneEvent.ITEMS_SELECT,items));
		}
		
		private function keyDownHandler(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ALTERNATE) CameraManager.panning = true;		
			
//			trace( "e.keyCode " + e.keyCode );
			switch (e.keyCode) 
			{					
				case Keyboard.UP: 
					CameraManager.moveForward(CameraManager.speed);
					break;
				case Keyboard.DOWN: 
					CameraManager.moveBackward(CameraManager.speed);
					break;
				case Keyboard.LEFT: 
					CameraManager.moveLeft(CameraManager.speed);
					break;
				case Keyboard.RIGHT: 
					CameraManager.moveRight(CameraManager.speed);
					break;
				case Keyboard.SHIFT: 
					CameraManager.running = true;
					break;
				case Keyboard.F: 
					if (Scene3DManager.selectedObject != null) 
					{
						CameraManager.focusTarget(Scene3DManager.selectedObject);
					}
					break;
				case Keyboard.CONTROL:
					Scene3DManager.multiSelection = true;
					break;	
			}				
			
		}
		
		private function keyUpHandler(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ALTERNATE) CameraManager.panning = false;
			
			switch (e.keyCode) 
			{
				case Keyboard.UP: 
				case Keyboard.DOWN: 
					CameraManager.moveForward(0);
					break;
				case Keyboard.LEFT: 
				case Keyboard.RIGHT: 
					CameraManager.moveLeft(0);
					break;
				case Keyboard.SHIFT: 
					CameraManager.running = false;
					break;
				case Keyboard.CONTROL:
					Scene3DManager.multiSelection = false;
					break;
			}				
			
		}	
		
		private function updateScenegraph():void
		{
			view.scenegraph = document.scenegraph;
			view.tree.expandAll();
			view.expandButton.visible = false;
			view.collapseButton.visible = true;
		}
		//----------------------------------------------------------------------
		//
		//	robotlegs handlers
		//
		//----------------------------------------------------------------------
		
		private function eventDispatcher_documentUpdatedHandler(event:DocumentModelEvent):void
		{
			updateScenegraph();
		}
		
		private function eventDispatcher_itemsSelectHandler(event:SceneEvent):void
		{
			if( event.items.length ) 
			{
				if( event.items.length == 1 ) 
				{
					if( event.items[0] is Mesh ) 
					{
						view.propertiesPanel.visible = true;
						var m:Mesh = event.items[0] as Mesh;
						Scene3DManager.selectObjectByName(m.name);
					}
					else {
						view.propertiesPanel.visible = false;
					}
				}
				else 
				{
					view.propertiesPanel.visible = false;
				}
				
			}
			else 
			{
				view.propertiesPanel.visible = false;
			}
			
		}
		
		//----------------------------------------------------------------------
		//
		//	scene handlers
		//
		//----------------------------------------------------------------------
		
		private function scene_readyHandler(event:Event):void
		{
			
		}	
		
		private function scene_meshSelectedHandler(event:Scene3DManagerEvent):void
		{
			if( ArrayUtil.vectorEqualToArray( document.selectedObjects, Scene3DManager.selectedObjects.source ) )
			{
				return;
			}
				
			var items:Vector.<Object> = new Vector.<Object>();
			for (var i:int=0;i<Scene3DManager.selectedObjects.length;i++)
			{
				items.push(Scene3DManager.selectedObjects.getItemAt(i));
			}
//			trace( items );
			document.selectedObjects = items;
			this.dispatch(new SceneEvent(SceneEvent.ITEMS_SELECT,items));
		}
		
		//----------------------------------------------------------------------
		//
		//	uncaught Error Handler
		//
		//----------------------------------------------------------------------
		
		private function uncaughtErrorHandler(event:UncaughtErrorEvent):void
		{
			event.preventDefault();
			if (event.error is Error)
			{
				var error:Error = event.error as Error;
				Alert.show( error.message, error.name );
			}
			else if (event.error is ErrorEvent)
			{
				var errorEvent:ErrorEvent = event.error as ErrorEvent;
				Alert.show( errorEvent.text, errorEvent.type );
			}
			else
			{
				Alert.show( event.text, event.type );
			}
		}
		
	}
}