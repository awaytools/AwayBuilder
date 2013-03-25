package awaybuilder.view.mediators
{
	import away3d.core.base.Object3D;
	
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.AssetVO;
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
		
		private var _scenegraphSort:Sort = new Sort();
		private var _scenegraph:ArrayCollection;
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
			view.expandTreeButton.visible = false;
			view.collapseTreeButton.visible = true;
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
		
		private function context_itemsSelectHandler(event:SceneEvent):void
		{
			_scenegraphSelected = new Vector.<Object>();
			updateAllSelectedItems( _scenegraph, event.items );
			view.selectedItems = _scenegraphSelected;
			view.callLater( view.tree.ensureIndexIsVisible, [view.tree.selectedIndex] );
			
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