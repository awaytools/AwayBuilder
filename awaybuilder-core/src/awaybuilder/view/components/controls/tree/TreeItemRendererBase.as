package awaybuilder.view.components.controls.tree
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ICollectionView;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.PropertyChangeEvent;
	import mx.styles.IStyleClient;
	
	import spark.components.supportClasses.ItemRenderer;
	
	public class TreeItemRendererBase extends ItemRenderer implements ITreeItemRenderer
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function TreeItemRendererBase()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var tree:Tree;
		
		//--------------------------------------------------------------------------
		//
		//  Overriden properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  data
		//----------------------------------
	
		override public function set data(value:Object):void
		{
			var eventDispatcher:IEventDispatcher = super.data as IEventDispatcher;
			if (eventDispatcher)
				eventDispatcher.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, data_propertyChangeHandler);
			
			super.data = value;
			updateChildren();
			
			eventDispatcher = value as IEventDispatcher;
			if (eventDispatcher)
				eventDispatcher.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, data_propertyChangeHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Implementation of ITreeItemRenderer: properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  level
		//----------------------------------
	
		protected var _level:int = 0;
		
		[Bindable("levelChange")]
		public function get level():int
		{
			return _level;
		}
		
		public function set level(value:int):void
		{
			if (_level == value)
				return;
			
			_level = value;
			dispatchEvent(new Event("levelChange"));
		}
		
		//----------------------------------
		//  parents
		//----------------------------------
	
		protected var _parents:Vector.<Object>;
		
		[Bindable("parentsChange")]
		public function get parents():Vector.<Object>
		{
			return _parents;
		}
		
		public function set parents(value:Vector.<Object>):void
		{
			// do not check on equality
			
			_parents = value;
			dispatchEvent(new Event("parentsChange"));
		}
		
		//----------------------------------
		//  isBranch
		//----------------------------------
	
		protected var _isBranch:Boolean = false;
		
		[Bindable("isBranchChange")]
		public function get isBranch():Boolean
		{
			return _isBranch;
		}
		
		public function set isBranch(value:Boolean):void
		{
			if (_isBranch == value)
				return;
			
			_isBranch = value;
			dispatchEvent(new Event("isBranchChange"));
		}
		
		//----------------------------------
		//  isLeaf
		//----------------------------------
	
		protected var _isLeaf:Boolean = true;
		
		[Bindable("isLeafChange")]
		public function get isLeaf():Boolean
		{
			return _isLeaf;
		}
		
		public function set isLeaf(value:Boolean):void
		{
			if (_isLeaf == value)
				return;
			
			_isLeaf = value;
			dispatchEvent(new Event("isLeafChange"));
		}
		
		//----------------------------------
		//  hasChildren
		//----------------------------------
	
		protected var _hasChildren:Boolean = false;
		
		[Bindable("hasChildrenChange")]
		public function get hasChildren():Boolean
		{
			return _hasChildren;
		}
		
		public function set hasChildren(value:Boolean):void
		{
			if (_hasChildren == value)
				return;
			
			_hasChildren = value;
			dispatchEvent(new Event("hasChildrenChange"));
		}
		
		//----------------------------------
		//  isOpen
		//----------------------------------
		
		protected var _isOpen:Boolean = false;
		
		[Bindable("isOpenChange")]
		public function get isOpen():Boolean
		{
			return _isOpen;
		}
		
		public function set isOpen(value:Boolean):void
		{
			if (_isOpen == value)
				return;
			
			_isOpen = value;
			dispatchEvent(new Event("isOpenChange"));
		}
		
		//----------------------------------
		//  indentation
		//----------------------------------
		
		private var _treeIndentation:Number = 2; 
		
		[Bindable("levelChange")]
		public function get indentation():Number
		{
			if (!owner)
				return 0;
			
			var value:Number = owner ? IStyleClient(owner).getStyle("indentation") : NaN;
			if (!isNaN(value))
				_treeIndentation = value;
			
			return _level * _treeIndentation;
		}
		
		//----------------------------------
		//  disclosureIconVisible
		//----------------------------------
		
		[Bindable("hasBranchChange")]
		[Bindable("hasChildrenChange")]
		public function get disclosureIconVisible():Boolean
		{
			return isBranch && hasChildren;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
	
		protected var _children:ICollectionView;
		
		public function get children():ICollectionView
		{
			return _children;
		}
		
		public function set children(value:ICollectionView):void
		{
			if (_children == value)
				return;
			
			if (_children)
				_children.removeEventListener(CollectionEvent.COLLECTION_CHANGE,
					children_collectionChange);
			
			_children = value;
			
			if (_children)
				_children.addEventListener(CollectionEvent.COLLECTION_CHANGE,
					children_collectionChange);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overriden methods
		//
		//--------------------------------------------------------------------------
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function toggle():void
		{
			tree.expandItem(data, !_isOpen);
		}
		
		private function updateChildren():void
		{
			children = data && tree && tree.dataDescriptor ? 
				tree.dataDescriptor.getChildren(data) : null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
	
		private function addedToStage(event:Event):void
		{
			var container:DisplayObjectContainer = owner;
			while (!(container is Tree) && container)
			{
				container = container.parent;
			}
			tree = Tree(container);
			updateChildren();
		}
		
		private function children_collectionChange(event:CollectionEvent):void
		{
			if (event.kind != CollectionEventKind.UPDATE)
				tree.refreshRenderer(this);
		}
	
		private function data_propertyChangeHandler(event:PropertyChangeEvent):void
		{
			updateChildren();
		}
		
	}
}