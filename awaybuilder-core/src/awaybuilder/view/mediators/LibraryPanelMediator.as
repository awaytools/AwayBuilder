package awaybuilder.view.mediators
{
	import away3d.core.base.Object3D;
	
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.AssetVO;
	import awaybuilder.model.vo.DocumentVO;
	import awaybuilder.model.vo.MeshVO;
	import awaybuilder.model.vo.ScenegraphGroupItemVO;
	import awaybuilder.model.vo.ScenegraphItemVO;
	import awaybuilder.utils.scene.Scene3DManager;
	import awaybuilder.view.components.LibraryPanel;
	import awaybuilder.view.components.events.LibraryPanelEvent;
	
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
			
			addContextListener(SceneEvent.SELECT, context_itemsSelectHandler);
			
			updateScenegraph();
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
			
			this.dispatch(new SceneEvent(SceneEvent.SELECT,items));
		}
		
		private function updateScenegraph():void
		{
			_model = new DocumentVO();
			
			_model.scene = getBranchCildren( document.scene );
			_model.materials = getBranchCildren( document.materials );
			_model.animations = getBranchCildren( document.animations );
			_model.textures = getBranchCildren( document.textures );
			_model.skeletons = getBranchCildren( document.skeletons );
			_model.geometry = getBranchCildren( document.geometry );
			_model.lights = getBranchCildren( document.lights );
			
			view.model = _model;
			
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
			updateAllSelectedItems( _model.scene, event.items );
			updateAllSelectedItems( _model.materials, event.items );
			updateAllSelectedItems( _model.textures, event.items );
			updateAllSelectedItems( _model.geometry, event.items );
			updateAllSelectedItems( _model.animations, event.items );
			updateAllSelectedItems( _model.skeletons, event.items );
			updateAllSelectedItems( _model.lights, event.items );
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