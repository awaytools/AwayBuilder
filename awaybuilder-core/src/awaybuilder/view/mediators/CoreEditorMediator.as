package awaybuilder.view.mediators
{
    import awaybuilder.controller.events.DocumentModelEvent;
import awaybuilder.controller.events.EditingSurfaceRequestEvent;
import awaybuilder.controller.events.SceneEvent;
    import awaybuilder.model.IDocumentModel;
    import awaybuilder.model.vo.MeshItemVO;
import awaybuilder.model.vo.ScenegraphGroupItemVO;
import awaybuilder.model.vo.ScenegraphItemVO;
    import awaybuilder.utils.scene.CameraManager;
    import awaybuilder.utils.scene.Scene3DManager;
    import awaybuilder.utils.scene.modes.GizmoMode;
    import awaybuilder.view.components.CoreEditor;
    import awaybuilder.view.components.events.CoreEditorEvent;
    import awaybuilder.view.scene.events.Scene3DManagerEvent;

    import flash.events.ErrorEvent;
    import flash.events.KeyboardEvent;
    import flash.events.UncaughtErrorEvent;
    import flash.geom.Vector3D;
    import flash.ui.Keyboard;

    import mx.controls.Alert;
    import mx.core.FlexGlobals;

    import org.robotlegs.mvcs.Mediator;

    public class CoreEditorMediator extends Mediator
	{
		[Inject]
		public var view:CoreEditor;
		
		[Inject]
		public var document:IDocumentModel;
		
		override public function onRegister():void
		{
			FlexGlobals.topLevelApplication.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
			
			Scene3DManager.instance.addEventListener(Scene3DManagerEvent.READY, scene_readyHandler);
			Scene3DManager.instance.addEventListener(Scene3DManagerEvent.MESH_SELECTED, scene_meshSelectedHandler);
            Scene3DManager.instance.addEventListener(Scene3DManagerEvent.TRANSFORM, scene_transformHandler);
            Scene3DManager.instance.addEventListener(Scene3DManagerEvent.TRANSFORM_RELEASE, scene_transformReleaseHandler);
			Scene3DManager.init( view.viewScope );
			
            addViewListener(CoreEditorEvent.TREE_CHANGE, view_treeChangeHandler, CoreEditorEvent);

            addContextListener(DocumentModelEvent.DOCUMENT_UPDATED, eventDispatcher_documentUpdatedHandler, DocumentModelEvent);
            addContextListener(SceneEvent.ITEMS_SELECT, eventDispatcher_itemsSelectHandler, SceneEvent);
            addContextListener(EditingSurfaceRequestEvent.FOCUS_SELECTION, eventDispatcher_itemsFocusHandler, EditingSurfaceRequestEvent);


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
			var items:Array = [];
			var selectedItems:Vector.<Object> = event.data as Vector.<Object>;
			for (var i:int=0;i<selectedItems.length;i++)
			{
                var groupItem:ScenegraphGroupItemVO = selectedItems[i] as ScenegraphGroupItemVO;
                if( groupItem ) {
                     continue;
                }
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
                case Keyboard.W:
                case Keyboard.UP:
					CameraManager.moveForward(CameraManager.speed);
					break;
                case Keyboard.S:
				case Keyboard.DOWN: 
					CameraManager.moveBackward(CameraManager.speed);
					break;
                case Keyboard.A:
				case Keyboard.LEFT: 
					CameraManager.moveLeft(CameraManager.speed);
					break;
                case Keyboard.D:
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
                case Keyboard.W:
                case Keyboard.S:
				case Keyboard.UP: 
				case Keyboard.DOWN: 
					CameraManager.moveForward(0);
					break;
                case Keyboard.A:
                case Keyboard.D:
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
		//	context handlers
		//
		//----------------------------------------------------------------------
		
		private function eventDispatcher_documentUpdatedHandler(event:DocumentModelEvent):void
		{
			updateScenegraph();
		}
		
		private function eventDispatcher_itemsSelectHandler(event:SceneEvent):void
		{
//			if( event.items.length )
//			{
//				if( event.items.length == 1 )
//				{
//					if( event.items[0] is Mesh )
//					{
//						var m:Mesh = event.items[0] as Mesh;
//						Scene3DManager.selectObjectByName(m.name);
//					}
//					else {
//                        Scene3DManager.unselectAll();
//					}
//				}
//				else
//				{
//                    Scene3DManager.unselectAll();
//				}
//			}
//			else
//			{
//                Scene3DManager.unselectAll();
//			}
		}
        private function eventDispatcher_itemsFocusHandler(event:EditingSurfaceRequestEvent):void
        {
            CameraManager.focusTarget( Scene3DManager.selectedObject );
        }

		
		//----------------------------------------------------------------------
		//
		//	scene handlers
		//
		//----------------------------------------------------------------------
		
		private function scene_readyHandler(event:Scene3DManagerEvent):void
		{
			
		}	
		
		private function scene_meshSelectedHandler(event:Scene3DManagerEvent):void
		{
//			var items:Vector.<ScenegraphItemVO> = new Vector.<ScenegraphItemVO>();
//			for (var i:int=0;i<Scene3DManager.selectedObjects.length;i++)
//			{
//				items.push(document.getScenegraphItem(Scene3DManager.selectedObjects.getItemAt(i)));
//			}
//			document.selectedObjects = items;
			this.dispatch(new SceneEvent(SceneEvent.ITEMS_SELECT,Scene3DManager.selectedObjects.source.concat()));
		}

        private function scene_transformHandler(event:Scene3DManagerEvent):void
        {
            var object:MeshItemVO = document.getScenegraphItem( event.object ) as MeshItemVO;
            object = object.clone();
            switch( event.gizmoMode ) {
                case GizmoMode.TRANSLATE:
                    object.x = event.endValue.x;
                    object.y = event.endValue.y;
                    object.z = event.endValue.z;
                    break;
                case GizmoMode.ROTATE:
                    object.rotationX = event.endValue.x;
                    object.rotationY = event.endValue.y;
                    object.rotationZ = event.endValue.z;
                    break;
                default:
                    object.scaleX = event.endValue.x;
                    object.scaleY = event.endValue.y;
                    object.scaleZ = event.endValue.z;
                    break;
            }

            this.dispatch(new SceneEvent(SceneEvent.CHANGING,[event.object]));
        }

        private function scene_transformReleaseHandler(event:Scene3DManagerEvent):void
        {
            switch( event.gizmoMode ) {
                case GizmoMode.TRANSLATE:
                    this.dispatch(new SceneEvent(SceneEvent.TRANSLATE_OBJECT,[event.object],event.startValue, event.endValue));
                    break;
                case GizmoMode.ROTATE:
                    this.dispatch(new SceneEvent(SceneEvent.ROTATE_OBJECT,[event.object],event.startValue,event.endValue));
                    break;
                default:
                    this.dispatch(new SceneEvent(SceneEvent.SCALE_OBJECT,[event.object],event.startValue,event.endValue));
                    break;
            }
        }

        private function updateObjectOnChange( gizmoMode:String, endValue:Vector3D, object:Object ):void
        {

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