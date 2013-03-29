package awaybuilder.view.mediators
{
	import away3d.core.base.Object3D;
	
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.ScenegraphGroupItemVO;
	import awaybuilder.model.vo.ScenegraphItemVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.DocumentVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.utils.DataMerger;
	import awaybuilder.utils.scene.Scene3DManager;
	import awaybuilder.view.components.LibraryPanel;
	import awaybuilder.view.components.events.LibraryPanelEvent;
	
	import flash.utils.getTimer;
	
	import mx.collections.ArrayCollection;
	
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
			
			addContextListener(DocumentModelEvent.DOCUMENT_UPDATED, eventDispatcher_documentUpdatedHandler);
			addContextListener(DocumentModelEvent.OBJECTS_UPDATED, eventDispatcher_documentUpdatedHandler);
			
			addContextListener(SceneEvent.SELECT, context_itemsSelectHandler);
			
		}
		
		//----------------------------------------------------------------------
		//
		//	view handlers
		//
		//----------------------------------------------------------------------
		
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
				for( var i:int=0; i<items.length; i++ )
				{
					if( items[i] != view.selectedItems[i].item )
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
		
		private function updateScenegraph():void
		{
			if( !view.model ) 
			{
				view.model = new DocumentVO();
			}
			
			view.model.scene = DataMerger.syncArrayCollections( view.model.scene, getBranch( document.scene ), "item" );
			view.model.materials = DataMerger.syncArrayCollections( view.model.materials, getBranch( document.materials ), "item" );
			view.model.animations = DataMerger.syncArrayCollections( view.model.animations, getBranch( document.animations ), "item" );
			view.model.textures = DataMerger.syncArrayCollections( view.model.textures,  getBranch( document.textures ), "item" );
			view.model.skeletons = DataMerger.syncArrayCollections( view.model.skeletons, getBranch( document.skeletons ), "item" );
			view.model.geometry = DataMerger.syncArrayCollections( view.model.geometry, getBranch( document.geometry ), "item" );
			view.model.lights = DataMerger.syncArrayCollections( view.model.lights, getBranch( document.lights ), "item" );
		}
		private function getBranch( objects:ArrayCollection ):ArrayCollection
		{
			var children:ArrayCollection = new ArrayCollection();
			for each( var asste:AssetVO in objects )
			{
				children.addItem( new ScenegraphItemVO( asste.name, asste ) );
			}
			return children;
		}
		private function getTextureBranchCildren( objects:ArrayCollection ):ArrayCollection
		{
			var children:ArrayCollection = new ArrayCollection();
			for each( var asste:AssetVO in objects )
			{
				children.addItem( new ScenegraphItemVO( "Texture (" + asste.name.split("/").pop() +")", asste ) );
			}
			return children;
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
			updateAllSelectedItems( view.model.animations, event.items );
			updateAllSelectedItems( view.model.skeletons, event.items );
			updateAllSelectedItems( view.model.lights, event.items );
			view.selectedItems = _scenegraphSelected;
			
			view.callLater( ensureIndexIsVisible );
			
		}
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
		
	}
}