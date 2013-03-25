package awaybuilder.view.mediators
{
    import away3d.core.base.Object3D;
    import away3d.entities.Mesh;
    import away3d.materials.utils.DefaultMaterialManager;
    
    import awaybuilder.controller.events.DocumentModelEvent;
    import awaybuilder.controller.scene.events.SceneEvent;
    import awaybuilder.model.IDocumentModel;
    import awaybuilder.model.vo.AssetVO;
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
			
            addContextListener(SceneEvent.SELECT, eventDispatcher_itemsSelectHandler, SceneEvent);
            addContextListener(SceneEvent.FOCUS_SELECTION, eventDispatcher_itemsFocusHandler, SceneEvent);

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

			this.dispatch(new SceneEvent(SceneEvent.SELECT,items));
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
			for each( var o:AssetVO in objects )
			{
				children.addItem( new ScenegraphItemVO( o.name, o ) );
			}
			return children;
		}
		private function getTextureBranchCildren( objects:ArrayCollection ):ArrayCollection
		{
			var children:ArrayCollection = new ArrayCollection();
			for each( var o:AssetVO in objects )
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
					if( event.items[0] is MeshVO )
					{
						var mesh:MeshVO = event.items[0] as MeshVO;
						selectObjectsScene( mesh.mesh );
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
			_scenegraphSelected = new Vector.<Object>();
			updateAllSelectedItems( _scenegraph, event.items );
			view.selectedItems = _scenegraphSelected;
			view.callLater( view.tree.ensureIndexIsVisible, [view.tree.selectedIndex] );
			
			var items:Vector.<AssetVO> = new Vector.<AssetVO>();
			for each( var selectedAsset:AssetVO in event.items ) 
			{
				if( selectedAsset.linkedObject == DefaultMaterialManager.getDefaultMaterial() ) continue;
				if( selectedAsset.linkedObject == DefaultMaterialManager.getDefaultTexture() ) continue;
				items.push( selectedAsset );
			}
			document.selectedObjects = items;
			
		}
		private function selectObjectsScene( o:Object3D ):void
		{
			for each( var object:Object3D in Scene3DManager.selectedObjects.source )
			{
				if( object == o )
				{
					return;
				}
			}
			Scene3DManager.selectObjectByName(o.name);
			
		}
		private function updateAllSelectedItems( children:ArrayCollection, selectedItems:Array ):void
		{
			for each( var item:ScenegraphItemVO in children )
			{
				if( item.item )
				{
					if( getItemIsSelected( item.item.linkedObject, selectedItems ) )
					{
						_scenegraphSelected.push( item );
					}
				}
				if(  item.children ) {
					updateAllSelectedItems( item.children, selectedItems );
				}
			} 
		}
		private function getItemIsSelected( o:Object, selectedItems:Array ):Boolean
		{
			for each( var object:AssetVO in selectedItems )
			{
				if( object.linkedObject == o )
				{
					return true;
				}
			}
			return false;
		}
        private function eventDispatcher_itemsFocusHandler(event:SceneEvent):void
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
			var selected:Array = [];
			for each( var item:Object in Scene3DManager.selectedObjects.source )
			{
				var mesh:Mesh = item as Mesh;
				if( mesh ) {
					selected.push( document.getSceneObject( mesh ) );
				}
			} 
			this.dispatch(new SceneEvent(SceneEvent.SELECT,selected));
		}

        private function scene_transformHandler(event:Scene3DManagerEvent):void
        {
            var vo:MeshVO = document.getSceneObject( event.object ) as MeshVO;
			vo = vo.clone();
            switch( event.gizmoMode ) {
                case GizmoMode.TRANSLATE:
					vo.x = event.endValue.x;
					vo.y = event.endValue.y;
					vo.z = event.endValue.z;
                    break;
                case GizmoMode.ROTATE:
					vo.rotationX = event.endValue.x;
					vo.rotationY = event.endValue.y;
					vo.rotationZ = event.endValue.z;
                    break;
                default:
					vo.scaleX = event.endValue.x;
					vo.scaleY = event.endValue.y;
					vo.scaleZ = event.endValue.z;
                    break;
            }

            this.dispatch(new SceneEvent(SceneEvent.CHANGING,[vo]));
        }

        private function scene_transformReleaseHandler(event:Scene3DManagerEvent):void
        {
			var vo:MeshVO = document.getSceneObject( event.object ) as MeshVO;
            switch( event.gizmoMode ) {
                case GizmoMode.TRANSLATE:
                    this.dispatch(new SceneEvent(SceneEvent.TRANSLATE_OBJECT,[vo], event.endValue));
                    break;
                case GizmoMode.ROTATE:
                    this.dispatch(new SceneEvent(SceneEvent.ROTATE_OBJECT,[vo],event.endValue));
                    break;
                default:
                    this.dispatch(new SceneEvent(SceneEvent.SCALE_OBJECT,[vo],event.endValue));
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