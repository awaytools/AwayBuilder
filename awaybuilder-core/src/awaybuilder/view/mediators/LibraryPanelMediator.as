package awaybuilder.view.mediators
{
	import away3d.core.base.Object3D;
	import away3d.lights.DirectionalLight;
	import away3d.materials.lightpickers.LightPickerBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	
	import awaybuilder.controller.document.events.ImportTextureEvent;
	import awaybuilder.controller.events.DocumentEvent;
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.events.DocumentRequestEvent;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.ScenegraphGroupItemVO;
	import awaybuilder.model.vo.ScenegraphItemVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.DocumentVO;
	import awaybuilder.model.vo.scene.EffectMethodVO;
	import awaybuilder.model.vo.scene.LightPickerVO;
	import awaybuilder.model.vo.scene.LightVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.model.vo.scene.ShadowMethodVO;
	import awaybuilder.utils.AssetFactory;
	import awaybuilder.utils.DataMerger;
	import awaybuilder.utils.ScenegraphFactory;
	import awaybuilder.utils.scene.Scene3DManager;
	import awaybuilder.view.components.LibraryPanel;
	import awaybuilder.view.components.events.LibraryPanelEvent;
	
	import flash.utils.getTimer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import org.robotlegs.mvcs.Mediator;
	
	import spark.collections.Sort;

	public class LibraryPanelMediator extends Mediator
	{
		[Inject]
		public var view:LibraryPanel;
		
		[Inject]
		public var document:IDocumentModel;
		
		private var _model:DocumentVO;
		private var _scenegraphSelected:Vector.<Object>;
		
		override public function onRegister():void
		{
			addViewListener(LibraryPanelEvent.TREE_CHANGE, view_treeChangeHandler);
			addViewListener(LibraryPanelEvent.ADD_LIGHT, view_addLightHandler);
			addViewListener(LibraryPanelEvent.ADD_LIGHTPICKER, view_addLightPickerHandler);
			addViewListener(LibraryPanelEvent.ADD_TEXTURE, view_addTextureHandler);
			addViewListener(LibraryPanelEvent.ADD_SHADOWMETHOD, view_addShadowMethodHandler);
			addViewListener(LibraryPanelEvent.ADD_EFFECTMETHOD, view_addEffectMethodHandler);
			
			addContextListener(DocumentModelEvent.DOCUMENT_UPDATED, eventDispatcher_documentUpdatedHandler);
			addContextListener(DocumentModelEvent.OBJECTS_UPDATED, eventDispatcher_documentUpdatedHandler);
			
			addContextListener(SceneEvent.SELECT, context_itemsSelectHandler);
			
			updateScenegraph();
			
		}
		
		//----------------------------------------------------------------------
		//
		//	view handlers
		//
		//----------------------------------------------------------------------
		
		private function view_addEffectMethodHandler(event:LibraryPanelEvent):void
		{
			var method:EffectMethodVO = AssetFactory.CreateEffectMethod();
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_EFFECT_METHOD, null, method));
			this.dispatch(new SceneEvent(SceneEvent.SELECT,[method]));
		}
		private function view_addShadowMethodHandler(event:LibraryPanelEvent):void
		{
			var availableLight:LightVO;
			for each( var asset:AssetVO in document.lights ) 
			{
				var light:LightVO = asset as LightVO;
				
				if( light && light.castsShadows ) 
				{
					availableLight = light;
					break;
				}
			}
			if( !availableLight )
			{
				Alert.show( "You have to create Light that casts shadow", "Operation Terminated");
				return;
			}
			var method:ShadowMethodVO = AssetFactory.CreateSahdowMapMethod( availableLight );
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_SHADOW_METHOD, null, method));
			this.dispatch(new SceneEvent(SceneEvent.SELECT,[method]));
		}
		private function view_addTextureHandler(event:LibraryPanelEvent):void
		{
			this.dispatch(new ImportTextureEvent(ImportTextureEvent.IMPORT_AND_ADD, null));
		}
		
		private function view_addLightHandler(event:LibraryPanelEvent):void
		{
			var asset:LightVO = AssetFactory.CreateLight();
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_LIGHT,null,asset));
			this.dispatch(new SceneEvent(SceneEvent.SELECT,[asset]));
		}
		
		private function view_addLightPickerHandler(event:LibraryPanelEvent):void
		{
			var asset:LightPickerVO = AssetFactory.CreateLightPicker();
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_LIGHTPICKER,null,asset));
			this.dispatch(new SceneEvent(SceneEvent.SELECT,[asset]));
		}
		
		
		private function view_treeChangeHandler(event:LibraryPanelEvent):void
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
			
			if( items.length == view.selectedItems.length ) // fix: preventing second change event after selectedItems update
			{
				var isSame:Boolean = true;
				for( var j:int=0; j<items.length; j++ )
				{
					if( items[j] != view.selectedItems[j].item )
					{
						isSame = false;
					}
				}
				if( isSame )
				{
					return;
				}
			}
			
			this.dispatch(new SceneEvent(SceneEvent.SELECT,items));
			
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
		
		private function context_itemsSelectHandler(event:SceneEvent):void
		{
			
			_scenegraphSelected = new Vector.<Object>();
			updateAllSelectedItems( view.model.scene, event.items );
			updateAllSelectedItems( view.model.materials, event.items );
			updateAllSelectedItems( view.model.textures, event.items );
			updateAllSelectedItems( view.model.geometry, event.items );
			updateAllSelectedItems( view.model.methods, event.items );
			updateAllSelectedItems( view.model.animations, event.items );
			updateAllSelectedItems( view.model.skeletons, event.items );
			updateAllSelectedItems( view.model.lights, event.items );
			view.selectedItems = _scenegraphSelected;
			
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
		private function updateAllSelectedItems( children:ArrayCollection, selectedItems:Array ):void
		{
			for each( var item:ScenegraphItemVO in children )
			{
				if( item.item )
				{
					if( getItemIsSelected( item.item.id, selectedItems ) )
					{
						_scenegraphSelected.push( item );
					}
				}
				if(  item.children ) {
					updateAllSelectedItems( item.children, selectedItems );
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
			if( !view.model ) 
			{
				view.model = new DocumentVO();
			}
			
			view.model.scene = DataMerger.syncArrayCollections( view.model.scene, ScenegraphFactory.CreateBranch( document.scene ), "item" );
			view.model.materials = DataMerger.syncArrayCollections( view.model.materials, ScenegraphFactory.CreateBranch( document.materials ), "item" );
			view.model.animations = DataMerger.syncArrayCollections( view.model.animations, ScenegraphFactory.CreateBranch( document.animations ), "item" );
			view.model.methods = DataMerger.syncArrayCollections( view.model.methods,  ScenegraphFactory.CreateBranch( document.methods ), "item" );
			view.model.textures = DataMerger.syncArrayCollections( view.model.textures,  ScenegraphFactory.CreateBranch( document.textures ), "item" );
			view.model.skeletons = DataMerger.syncArrayCollections( view.model.skeletons, ScenegraphFactory.CreateBranch( document.skeletons ), "item" );
			view.model.geometry = DataMerger.syncArrayCollections( view.model.geometry, ScenegraphFactory.CreateBranch( document.geometry ), "item" );
			view.model.lights = DataMerger.syncArrayCollections( view.model.lights, ScenegraphFactory.CreateBranch( document.lights ), "item" );
			
			view.sceneTree.expandAll();
		}
		
	}
}