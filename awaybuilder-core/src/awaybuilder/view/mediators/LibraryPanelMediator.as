package awaybuilder.view.mediators
{
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.VertexAnimationSet;
	import away3d.animators.VertexAnimator;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import away3d.lights.DirectionalLight;
	import away3d.materials.lightpickers.LightPickerBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.SkyBox;
	
	import awaybuilder.controller.document.events.ImportTextureEvent;
	import awaybuilder.controller.events.DocumentEvent;
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.events.DocumentRequestEvent;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.AssetsModel;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.vo.DeleteStateVO;
	import awaybuilder.model.vo.DocumentVO;
	import awaybuilder.model.vo.DroppedTreeItemVO;
	import awaybuilder.model.vo.LibraryItemVO;
	import awaybuilder.model.vo.scene.AnimationSetVO;
	import awaybuilder.model.vo.scene.AnimatorVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.CameraVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.CubeTextureVO;
	import awaybuilder.model.vo.scene.EffectMethodVO;
	import awaybuilder.model.vo.scene.GeometryVO;
	import awaybuilder.model.vo.scene.LightPickerVO;
	import awaybuilder.model.vo.scene.LightVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.model.vo.scene.ObjectVO;
	import awaybuilder.model.vo.scene.ShadowMapperVO;
	import awaybuilder.model.vo.scene.ShadowMethodVO;
	import awaybuilder.model.vo.scene.SkeletonVO;
	import awaybuilder.model.vo.scene.SkyBoxVO;
	import awaybuilder.model.vo.scene.TextureProjectorVO;
	import awaybuilder.utils.AssetUtil;
	import awaybuilder.utils.DataMerger;
	import awaybuilder.utils.ScenegraphFactory;
	import awaybuilder.utils.scene.Scene3DManager;
	import awaybuilder.view.components.LibraryPanel;
	import awaybuilder.view.components.controls.tree.TreeDataProvider;
	import awaybuilder.view.components.editors.events.PropertyEditorEvent;
	import awaybuilder.view.components.events.LibraryPanelEvent;
	
	import flash.utils.getTimer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.utils.ObjectUtil;
	
	import org.robotlegs.mvcs.Mediator;
	
	import spark.collections.Sort;

	public class LibraryPanelMediator extends Mediator
	{
		
		private var _animations:ArrayCollection;
		private var _geometry:ArrayCollection;
		private var _materials:ArrayCollection;
		private var _scene:ArrayCollection;
		private var _skeletons:ArrayCollection;
		private var _textures:ArrayCollection;
		private var _lights:ArrayCollection;
		private var _methods:ArrayCollection;
		
		[Inject]
		public var view:LibraryPanel;
		
		[Inject]
		public var document:DocumentModel;
		
		[Inject]
		public var assets:AssetsModel;
		
		private var _model:DocumentVO;
		
		private var _selectedSceneItems:Vector.<Object> = new Vector.<Object>();
		private var _selectedMaterialsItems:Vector.<Object> = new Vector.<Object>();
		private var _selectedTexturesItems:Vector.<Object> = new Vector.<Object>();
		private var _selectedGeometryItems:Vector.<Object> = new Vector.<Object>();
		private var _selectedMethodsItems:Vector.<Object> = new Vector.<Object>();
		private var _selectedAnimationsItems:Vector.<Object> = new Vector.<Object>();
		private var _selectedLightsItems:Vector.<Object> = new Vector.<Object>();
		
		override public function onRegister():void
		{
			addViewListener(LibraryPanelEvent.TREE_CHANGE, view_treeChangeHandler);
			addViewListener(LibraryPanelEvent.ADD_DIRECTIONAL_LIGHT, view_addDirectionalLightHandler);
			addViewListener(LibraryPanelEvent.ADD_POINT_LIGHT, view_addPointLightHandler);
			addViewListener(LibraryPanelEvent.ADD_LIGHTPICKER, view_addLightPickerHandler);
			addViewListener(LibraryPanelEvent.ADD_TEXTURE, view_addTextureHandler);
			addViewListener(LibraryPanelEvent.ADD_CUBE_TEXTURE, view_addCubeTextureHandler);
			addViewListener(LibraryPanelEvent.ADD_GEOMETRY, view_addGeometryHandler);
			addViewListener(LibraryPanelEvent.ADD_MESH, view_addMeshHandler);
			addViewListener(LibraryPanelEvent.ADD_CONTAINER, view_addContainerHandler);
			addViewListener(LibraryPanelEvent.ADD_TEXTURE_PROJECTOR, view_addTextureProjectorHandler);
			addViewListener(LibraryPanelEvent.ADD_SKYBOX, view_addSkyBoxHandler);
			addViewListener(LibraryPanelEvent.ADD_EFFECTMETHOD, view_addEffectMethodHandler);
			addViewListener(LibraryPanelEvent.ADD_MATERIAL, view_addMaterialHandler);
			addViewListener(LibraryPanelEvent.ADD_ANIMATOR, view_addAnimatorHandler);
			addViewListener(LibraryPanelEvent.ADD_CAMERA, view_addCameraHandler);
			
			
			addViewListener(LibraryPanelEvent.LIGHT_DROPPED, view_lightDroppedHandler);
			addViewListener(LibraryPanelEvent.SCENEOBJECT_DROPPED, view_sceneObjectDroppedHandler);
			addViewListener(LibraryPanelEvent.ANIMATIONS_DROPPED, view_animationsDroppedHandler);
			
			
			addContextListener(DocumentModelEvent.OBJECTS_UPDATED, eventDispatcher_documentUpdatedHandler);
			addContextListener(DocumentModelEvent.DOCUMENT_CREATED, eventDispatcher_documentCreatedHandler);
			addContextListener(SceneEvent.CHANGE_LIGHTPICKER, eventDispatcher_changeHandler);
			
			addContextListener(SceneEvent.VALIDATE_DELETION, context_validateDeletionHandler);
			
			addContextListener(SceneEvent.SELECT, context_itemsSelectHandler);
			
		}
		
		//----------------------------------------------------------------------
		//
		//	view handlers
		//
		//----------------------------------------------------------------------
		
		
		private function view_animationsDroppedHandler(event:LibraryPanelEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.REPARENT_ANIMATIONS,[], event.data));		
		}
		private function view_sceneObjectDroppedHandler(event:LibraryPanelEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.REPARENT_OBJECTS,[], event.data));		
		}
		private function view_lightDroppedHandler(event:LibraryPanelEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.REPARENT_LIGHTS,[], event.data));
		}
		
		private function itemIsInList( collection:ArrayCollection, asset:AssetVO ):Boolean
		{
			for each( var a:AssetVO in collection )
			{
				if( a.equals( asset ) ) return true;
			}
			return false;
		}
		private function view_addMaterialHandler(event:LibraryPanelEvent):void
		{
			var asset:MaterialVO = assets.CreateMaterial()
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_MATERIAL,[], asset));
			this.dispatch(new SceneEvent(SceneEvent.SELECT,[asset]));
		}
		
		private function view_addCameraHandler(event:LibraryPanelEvent):void
		{
			var asset:CameraVO = assets.CreateCamera();
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_CAMERA,[], asset));
			this.dispatch(new SceneEvent(SceneEvent.SELECT,[asset]));
		}
		private function view_addAnimatorHandler(event:LibraryPanelEvent):void
		{
			var animation:AnimationSetVO
			switch( event.data )
			{
				case "VertexAnimationSet":
					animation = assets.CreateAnimationSet( event.data as String );
					break;
				case "SkeletonAnimationSet":
					animation = assets.CreateAnimationSet( event.data as String );
					break;
			}
			if( animation )
			{
				this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_ANIMATION_SET,[], animation));
				this.dispatch(new SceneEvent(SceneEvent.SELECT,[animation]));
			}
		}
		private function view_addEffectMethodHandler(event:LibraryPanelEvent):void
		{
			if( event.data == "ProjectiveTextureMethod" )
			{
				Alert.show( "To create a ProjectiveTextureMethod, you need TextureProjector", "TextureProjector is missing" );
				return;
			}
			var method:EffectMethodVO = assets.CreateEffectMethod( event.data as String );
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_EFFECT_METHOD, null, method));
			this.dispatch(new SceneEvent(SceneEvent.SELECT,[method]));
		}
		private function view_addTextureHandler(event:LibraryPanelEvent):void
		{
			this.dispatch(new ImportTextureEvent(ImportTextureEvent.IMPORT_AND_ADD, null));
		}
		
		private function view_addGeometryHandler(event:LibraryPanelEvent):void
		{
			var asset:GeometryVO = assets.CreateGeometry( event.data as String );
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_GEOMETRY,null,asset));
			this.dispatch(new SceneEvent(SceneEvent.SELECT,[asset]));
		}
		
		private function view_addSkyBoxHandler(event:LibraryPanelEvent):void
		{
			var asset:SkyBoxVO = assets.CreateSkyBox();
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_SKYBOX,null,asset));
			this.dispatch(new SceneEvent(SceneEvent.SELECT,[asset]));
		}
		
		private function view_addContainerHandler(event:LibraryPanelEvent):void
		{
			var asset:ContainerVO = assets.CreateContainer();
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_CONTAINER,null,asset));
			this.dispatch(new SceneEvent(SceneEvent.SELECT,[asset]));
		}
		private function view_addMeshHandler(event:LibraryPanelEvent):void
		{
			if( !document.geometry.length )
			{
				Alert.show( "To create a Mesh, you need Geometry", "Cancelled" );
				return;
			}
			var asset:MeshVO = assets.CreateMesh( document.geometry.getItemAt(0) as GeometryVO );
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_MESH,null,asset));
			this.dispatch(new SceneEvent(SceneEvent.SELECT,[asset]));
		}
		private function view_addTextureProjectorHandler(event:LibraryPanelEvent):void
		{
			var asset:TextureProjectorVO = assets.CreateTextureProjector();
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_TEXTURE_PROJECTOR,null,asset));
			this.dispatch(new SceneEvent(SceneEvent.SELECT,[asset]));
		}
		
		private function view_addCubeTextureHandler(event:LibraryPanelEvent):void
		{
			var asset:CubeTextureVO = assets.CreateCubeTexture();
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_CUBE_TEXTURE,null,asset));
			this.dispatch(new SceneEvent(SceneEvent.SELECT,[asset]));
		}
		
		
		private function view_addDirectionalLightHandler(event:LibraryPanelEvent):void
		{
			var asset:LightVO = assets.CreateDirectionalLight();
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_LIGHT,null,asset));
			this.dispatch(new SceneEvent(SceneEvent.SELECT,[asset]));
		}
		private function view_addPointLightHandler(event:LibraryPanelEvent):void
		{
			var asset:LightVO = assets.CreatePointLight()
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_LIGHT,null,asset));
			this.dispatch(new SceneEvent(SceneEvent.SELECT,[asset]));
		}
		
		private function view_addLightPickerHandler(event:LibraryPanelEvent):void
		{
			var asset:LightPickerVO = assets.CreateLightPicker();
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_LIGHTPICKER,null,asset));
			this.dispatch(new SceneEvent(SceneEvent.SELECT,[asset]));
		}
		
		private var _doNotUpdate:Boolean = false;
		private function view_treeChangeHandler(event:LibraryPanelEvent):void
		{
			var items:Array = [];
			var selectedItems:Vector.<Object> = event.data as Vector.<Object>;
			
			for (var i:int=0;i<selectedItems.length;i++)
			{
				items.push(LibraryItemVO(selectedItems[i]).asset);
			}
			_doNotUpdate = true;
			this.dispatch(new SceneEvent(SceneEvent.SELECT,items));
			
		}
		
		//----------------------------------------------------------------------
		//
		//	context handlers
		//
		//----------------------------------------------------------------------
		
		private function context_validateDeletionHandler(event:SceneEvent):void
		{
			var states:Vector.<DeleteStateVO> = new Vector.<DeleteStateVO>();
			var item:LibraryItemVO;
			for each( item in view.sceneTree.selectedItems )
			{
				states.push( new DeleteStateVO( item.asset, item.parent?item.parent.asset:null ) );
			}
			for each( item in view.materialTree.selectedItems )
			{
				states.push( new DeleteStateVO( item.asset, item.parent?item.parent.asset:null ) );
			}
			for each( item in view.texturesTree.selectedItems )
			{
				states.push( new DeleteStateVO( item.asset, item.parent?item.parent.asset:null ) );
			}
			for each( item in view.geometryTree.selectedItems )
			{
				states.push( new DeleteStateVO( item.asset, item.parent?item.parent.asset:null ) );
			}
			for each( item in view.methodsTree.selectedItems )
			{
				states.push( new DeleteStateVO( item.asset, item.parent?item.parent.asset:null ) );
			}
			for each( item in view.animationsTree.selectedItems )
			{
				states.push( new DeleteStateVO( item.asset, item.parent?item.parent.asset:null ) );
			}
			for each( item in view.lightsTree.selectedItems )
			{
				states.push( new DeleteStateVO( item.asset, item.parent?item.parent.asset:null ) );
			}
			
			if( states.length )
			{
				this.dispatch(new SceneEvent(SceneEvent.DELETE, null, states));
			}
			
		}
		public function removeAsset( source:ArrayCollection, oddItem:AssetVO ):void
		{
			for (var i:int = 0; i < source.length; i++) 
			{
				if( source[i].id == oddItem.id )
				{
					source.removeItemAt( i );
					i--;
				}
			}
		}
		private function eventDispatcher_changeHandler(event:SceneEvent):void
		{
			updateScenegraph();
		}
		
		private function eventDispatcher_documentCreatedHandler(event:DocumentModelEvent):void
		{
			updateScenegraph();
			view.sceneTree.expandAll();
		}
		
		private function eventDispatcher_documentUpdatedHandler(event:DocumentModelEvent):void
		{
			updateScenegraph();
		}
		
		private function context_itemsSelectHandler(event:SceneEvent):void
		{
			if( _doNotUpdate ) 
			{
				_doNotUpdate = false;
				return;
			}
			
			_selectedSceneItems = new Vector.<Object>();
			_selectedMaterialsItems = new Vector.<Object>();
			_selectedTexturesItems = new Vector.<Object>();
			_selectedGeometryItems = new Vector.<Object>();
			_selectedMethodsItems = new Vector.<Object>();
			_selectedAnimationsItems = new Vector.<Object>();
			_selectedLightsItems = new Vector.<Object>();
			updateAllSelectedItems( view.model.scene, event.items.concat(), _selectedSceneItems  );
			updateAllSelectedItems( view.model.materials, event.items.concat(), _selectedMaterialsItems );
			updateAllSelectedItems( view.model.textures, event.items.concat(), _selectedTexturesItems );
			updateAllSelectedItems( view.model.geometry, event.items.concat(), _selectedGeometryItems );
			updateAllSelectedItems( view.model.methods, event.items.concat(), _selectedMethodsItems );
			updateAllSelectedItems( view.model.animations, event.items.concat(), _selectedAnimationsItems );
			updateAllSelectedItems( view.model.lights, event.items.concat(), _selectedLightsItems, view.lightsTree.selectedItems );
			view.selectedSceneItems = _selectedSceneItems;
			view.selectedMaterialsItems = _selectedMaterialsItems;
			view.selectedTexturesItems = _selectedTexturesItems;
			view.selectedGeometryItems = _selectedGeometryItems;
			view.selectedMethodsItems = _selectedMethodsItems;
			view.selectedAnimationsItems = _selectedAnimationsItems;
			view.selectedLightsItems = _selectedLightsItems;
			view.callLater( ensureIndexIsVisible );
		}
		
		//----------------------------------------------------------------------
		//
		//	private methods
		//
		//----------------------------------------------------------------------
		
		private function ensureIndexIsVisible():void 
		{
			if( view.sceneTree.selectedIndex )
			{
				view.callLater( view.sceneTree.ensureIndexIsVisible, [view.sceneTree.selectedIndex] );	
			}
			if( view.materialTree.selectedIndex )
			{
				view.callLater( view.materialTree.ensureIndexIsVisible, [view.materialTree.selectedIndex] );	
			}
			if( view.texturesTree.selectedIndex )
			{
				view.callLater( view.texturesTree.ensureIndexIsVisible, [view.texturesTree.selectedIndex] );	
			}
			if( view.methodsTree.selectedIndex )
			{
				view.callLater( view.methodsTree.ensureIndexIsVisible, [view.methodsTree.selectedIndex] );	
			}
			
		}
		private function updateAllSelectedItems( children:ArrayCollection, selectedItems:Array, currentSelcted:Vector.<Object>, alreadySelected:Vector.<Object>=null ):void
		{
			if( alreadySelected )
			{
				
				for each( var alreadySelectedItem:LibraryItemVO in alreadySelected )
				{
					for( var i:int = 0; i < selectedItems.length; i++ )
					{
						if( AssetVO(selectedItems[i]).equals( alreadySelectedItem.asset ) )
						{
							currentSelcted.push( alreadySelectedItem );
							selectedItems.splice( i, 1 );
							i--;
						}
					}
				}
			}
			for each( var item:LibraryItemVO in children )
			{
				if( item.asset )
				{
					if( getItemIsSelected( item.asset.id, selectedItems ) )
					{
						currentSelcted.push( item );
					}
				}
				if( item.children ) 
				{
					updateAllSelectedItems( item.children, selectedItems, currentSelcted );
				}
			}
		}
		private function getItemIsSelected( id:String, selectedItems:Array ):Boolean
		{
			for each( var object:AssetVO in selectedItems )
			{
				if( object.id == id )
				{
					return true;
				}
			}
			return false;
		}
		private function updateScenegraph():void
		{
			view.model.scene = DataMerger.syncArrayCollections( view.model.scene, ScenegraphFactory.CreateBranch( document.scene, null ), "asset" );
			view.model.materials = DataMerger.syncArrayCollections( view.model.materials, ScenegraphFactory.CreateBranch( document.materials, null ), "asset" );
			view.model.animations = DataMerger.syncArrayCollections( view.model.animations, ScenegraphFactory.CreateBranch( document.animations, null ), "asset" );
			view.model.methods = DataMerger.syncArrayCollections( view.model.methods,  ScenegraphFactory.CreateBranch( document.methods, null ), "asset" );
			view.model.textures = DataMerger.syncArrayCollections( view.model.textures,  ScenegraphFactory.CreateBranch( document.textures, null ), "asset" );
			view.model.geometry = DataMerger.syncArrayCollections( view.model.geometry, ScenegraphFactory.CreateBranch( document.geometry, null ), "asset" );
			view.model.lights = DataMerger.syncArrayCollections( view.model.lights, ScenegraphFactory.CreateLightsBranch( document.lights ), "asset" );
		}
		
	}
}