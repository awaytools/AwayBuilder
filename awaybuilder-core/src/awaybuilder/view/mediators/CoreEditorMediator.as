package awaybuilder.view.mediators
{
    import away3d.core.base.Object3D;
    import away3d.entities.Mesh;
    
    import awaybuilder.controller.events.DocumentModelEvent;
    import awaybuilder.controller.events.EditingSurfaceRequestEvent;
    import awaybuilder.controller.events.ReadDocumentDataEvent;
    import awaybuilder.controller.events.SceneEvent;
    import awaybuilder.model.IDocumentModel;
    import awaybuilder.model.vo.DocumentBaseVO;
    import awaybuilder.model.vo.MeshVO;
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
    
    import mx.collections.ArrayCollection;
    import mx.controls.Alert;
    import mx.core.FlexGlobals;
    
    import org.robotlegs.mvcs.Mediator;
    
    import spark.collections.Sort;

    public class CoreEditorMediator extends Mediator
	{
		[Inject]
		public var view:CoreEditor;
		
		[Inject]
		public var document:IDocumentModel;
		
		private var _scenegraphSort:Sort = new Sort();
		private var _scenegraph:ArrayCollection;
		private var _scenegraphSelected:Vector.<Object>;
		
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
			addContextListener(ReadDocumentDataEvent.READ_DOCUMENT_DATA_COMPLETE, context_readDocumentDataHandler, ReadDocumentDataEvent);
			
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
				items.push(ScenegraphItemVO(selectedItems[i]).item.linkedObject);
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
			_scenegraph = new ArrayCollection();
			var branch:ScenegraphGroupItemVO;
			if( document.scene && document.scene.length ) 
			{
				branch = new ScenegraphGroupItemVO( "Scene", ScenegraphGroupItemVO.SCENE_GROUP );
				branch.children = getBranchCildren( document.scene );
				_scenegraph.addItem( branch );
			}
			if( document.materials && document.materials.length ) 
			{
				branch = new ScenegraphGroupItemVO( "Materials", ScenegraphGroupItemVO.MATERIAL_GROUP );
				branch.children = getBranchCildren( document.materials );
				_scenegraph.addItem( branch );
			}
			if( document.animations && document.animations.length ) 
			{
				branch = new ScenegraphGroupItemVO( "Animations", ScenegraphGroupItemVO.ANIMATION_GROUP );
				branch.children = getBranchCildren( document.animations );
				_scenegraph.addItem( branch );
			}
			if( document.geometry && document.geometry.length ) 
			{
				branch = new ScenegraphGroupItemVO( "Geometry", ScenegraphGroupItemVO.GEOMETRY_GROUP );
				branch.children = getBranchCildren( document.geometry );
				_scenegraph.addItem( branch );
			}
			if( document.textures && document.textures.length ) 
			{
				branch = new ScenegraphGroupItemVO( "Textures", ScenegraphGroupItemVO.TEXTURE_GROUP );
				branch.children = getTextureBranchCildren( document.textures );
				_scenegraph.addItem( branch );
			}
			if( document.skeletons && document.skeletons.length ) 
			{
				branch = new ScenegraphGroupItemVO( "Skeletons", ScenegraphGroupItemVO.SKELETON_GROUP );
				branch.children = getBranchCildren( document.skeletons );
				_scenegraph.addItem( branch );
			}
			if( document.lights && document.lights.length ) 
			{
				branch = new ScenegraphGroupItemVO( "Lights", ScenegraphGroupItemVO.LIGHT_GROUP );
				branch.children = getBranchCildren( document.lights );
				_scenegraph.addItem( branch );
			}
			
			
			_scenegraphSort.compareFunction = compareGroupItems;
			_scenegraph.sort = _scenegraphSort;
			_scenegraph.refresh();
			
			view.scenegraph = _scenegraph;
			
			view.tree.expandAll();
			view.expandButton.visible = false;
			view.collapseButton.visible = true;
		}
		
		private function getBranchCildren( objects:ArrayCollection ):ArrayCollection
		{
			var children:ArrayCollection = new ArrayCollection();
			for each( var o:DocumentBaseVO in objects )
			{
				children.addItem( new ScenegraphItemVO( o.name, o ) );
			}
			return children;
		}
		private function getTextureBranchCildren( objects:ArrayCollection ):ArrayCollection
		{
			var children:ArrayCollection = new ArrayCollection();
			for each( var o:DocumentBaseVO in objects )
			{
				children.addItem( new ScenegraphItemVO( "Texture (" + o.name.split("/").pop() +")", o ) );
			}
			return children;
		}
		
		private function compareGroupItems( a:Object, b:Object, fields:Array=null ):int
		{
			var group1:ScenegraphGroupItemVO = a as ScenegraphGroupItemVO;
			var group2:ScenegraphGroupItemVO = b as ScenegraphGroupItemVO;
			if (group1 == null && group2 == null) return 0;
			if (group1 == null)	return 1;
			if (group2 == null)	return -1;
			if (group1.weight < group2.weight) return -1;
			if (group1.weight > group2.weight) return 1;
			return 0;
		}
		
		//----------------------------------------------------------------------
		//
		//	context handlers
		//
		//----------------------------------------------------------------------
		
		
		
		private function context_readDocumentDataHandler(event:ReadDocumentDataEvent):void
		{
			updateScenegraph();
		}
		
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
						selectObjectsScene( event.items[0] as Object3D );
					}
					else {
                        Scene3DManager.unselectAll();
					}
				}
				else
				{
                    Scene3DManager.unselectAll();
				}
			}
			else
			{
                Scene3DManager.unselectAll();
			}
			
		}
		private function selectObjectsScene( o:Object3D ):void
		{
			
			var isSelected:Boolean = false;
			for each( var object:Object3D in Scene3DManager.selectedObjects.source )
			{
				if( object == o )
				{
					isSelected = true;
					continue;
				}
			}
			if( !isSelected ) 
			{
				Scene3DManager.selectObjectByName(o.name);
			}
			
			_scenegraphSelected = new Vector.<Object>();
			updateAllSelectedItems( _scenegraph );
			view.selectedItems = _scenegraphSelected;
			view.callLater( view.tree.ensureIndexIsVisible, [view.tree.selectedIndex] );
		}
		private function updateAllSelectedItems( children:ArrayCollection ):void
		{
			for each( var item:ScenegraphItemVO in children )
			{
				if( item.item )
				{
					if( getItemIsSelected( item.item.linkedObject as Object3D ) )
					{
						_scenegraphSelected.push( item );
					}
				}
				if(  item.children ) {
					updateAllSelectedItems( item.children );
				}
			} 
		}
		private function getItemIsSelected( o:Object3D ):Boolean
		{
			for each( var object:Object3D in Scene3DManager.selectedObjects.source )
			{
				if( object == o )
				{
					return true;
				}
			}
			return false;
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
            var object:MeshVO = document.getSceneObject( event.object ) as MeshVO;
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