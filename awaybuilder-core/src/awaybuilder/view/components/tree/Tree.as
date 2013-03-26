package awaybuilder.view.components.tree
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.collections.IList;
	import mx.controls.treeClasses.DefaultDataDescriptor;
	import mx.controls.treeClasses.ITreeDataDescriptor2;
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.core.ClassFactory;
	import mx.core.IVisualElement;
	import mx.core.mx_internal;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	
	import spark.components.List;
	
	use namespace mx_internal;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when a branch is closed or collapsed.
	 */
	[Event(name="itemClose", type="awaybuilder.view.components.tree.TreeEvent")]
	
	/**
	 *  Dispatched when a branch is opened or expanded.
	 */
	[Event(name="itemOpen", type="awaybuilder.view.components.tree.TreeEvent")]
	
	/**
	 *  Dispatched when a branch open or close is initiated.
	 */
	[Event(name="itemOpening", type="awaybuilder.view.components.tree.TreeEvent")]
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
	/**
	 * Indentation for each tree level, in pixels. The default value is 17.
	 */
	[Style(name="indentation", type="Number", inherit="no", theme="spark")]
	
	/**
	 * Custom Spark Tree that is based on Spark List. Supports most of MX Tree
	 * features and does not have it's bugs.
	 */
	public class Tree extends List
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Tree()
		{
			super();
			
			// Handle styles when getStyle() will return corrent values.
//			itemRenderer = new ClassFactory(TreeItemRenderer);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var refreshRenderersCalled:Boolean = false;
		
		private var renderersToRefresh:Vector.<ITreeItemRenderer> = new Vector.<ITreeItemRenderer>();
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  dataDescriptor
		//----------------------------------
	
		private var _dataDescriptor:ITreeDataDescriptor2 = new DefaultDataDescriptor();
		
		[Bindable("dataDescriptorChange")]
		public function get dataDescriptor():ITreeDataDescriptor2
		{
			return _dataDescriptor;
		}
		
		public function set dataDescriptor(value:ITreeDataDescriptor2):void
		{
			if (_dataDescriptor == value)
				return;
			
			_dataDescriptor = value;
			if (_dataProvider)
			{
				_dataProvider.dataDescriptor = _dataDescriptor;
				refreshRenderers();
			}
			dispatchEvent(new Event("dataDescriptorChange"));
		}
		
		//----------------------------------
		//  dataProvider
		//----------------------------------
		
		private var _dataProvider:TreeDataProvider;
		
		override public function get dataProvider():IList
		{
			return _dataProvider;
		}
		
		override public function set dataProvider(value:IList):void
		{
			var typedValue:TreeDataProvider;
			if (value)
			{
				typedValue = value is TreeDataProvider ? TreeDataProvider(value) : new TreeDataProvider(value);
				typedValue.dataDescriptor = dataDescriptor;
			}
			
			if (_dataProvider)
			{
				_dataProvider.removeEventListener(TreeEvent.ITEM_CLOSE, dataProvider_someHandler);
				_dataProvider.removeEventListener(TreeEvent.ITEM_OPEN, dataProvider_someHandler);
				_dataProvider.removeEventListener(TreeEvent.ITEM_OPENING, dataProvider_someHandler);
			}
			
			_dataProvider = typedValue;
			super.dataProvider = typedValue;
			
			if (_dataProvider)
			{
				_dataProvider.addEventListener(TreeEvent.ITEM_CLOSE, dataProvider_someHandler);
				_dataProvider.addEventListener(TreeEvent.ITEM_OPEN, dataProvider_someHandler);
				_dataProvider.addEventListener(TreeEvent.ITEM_OPENING, dataProvider_someHandler);
			}
		}
		
		//----------------------------------
		//  iconField
		//----------------------------------
		
		private var _iconField:String = "icon";
		
		[Bindable("iconFieldChange")]
		public function get iconField():String
		{
			return _iconField;
		}
		
		public function set iconField(value:String):void
		{
			if (_iconField == value)
				return;
			
			_iconField = value;
			refreshRenderers();
			dispatchEvent(new Event("iconFieldChange"));
		}
		
		//----------------------------------
		//  iconOpenField
		//----------------------------------
		
		private var _iconOpenField:String = "icon";
		
		[Bindable("iconOpenFieldChange")]
		/**
		 * Field that will be searched for icon when showing open folder item.
		 */
		public function get iconOpenField():String
		{
			return _iconOpenField;
		}
		
		public function set iconOpenField(value:String):void
		{
			if (_iconOpenField == value)
				return;
			
			_iconOpenField = value;
			refreshRenderers();
			dispatchEvent(new Event("iconOpenFieldChange"));
		}
		
		//----------------------------------
		//  iconFunction
		//----------------------------------
		
		private var _iconFunction:Function;
		
		[Bindable("iconFunctionChange")]
		/**
		 * Icon function. Signature <code>function(item:Object, isOpen:Boolean, isBranch:Boolean):Class</code>.
		 */
		public function get iconFunction():Function
		{
			return _iconFunction;
		}
		
		public function set iconFunction(value:Function):void
		{
			if (_iconFunction == value)
				return;
			
			_iconFunction = value;
			refreshRenderers();
			dispatchEvent(new Event("iconFunctionChange"));
		}
		
		//----------------------------------
		//  iconsVisible
		//----------------------------------
		
		private var _iconsVisible:Boolean = true;
		
		[Bindable("iconsVisibleChange")]
		/**
		 * Field that will be searched for icon when showing open folder item.
		 */
		public function get iconsVisible():Boolean
		{
			return _iconsVisible;
		}
		
		public function set iconsVisible(value:Boolean):void
		{
			if (_iconsVisible == value)
				return;
			
			_iconsVisible = value;
			refreshRenderers();
			dispatchEvent(new Event("iconsVisibleChange"));
		}
		
		//----------------------------------
		//  useTextColors
		//----------------------------------
		
		private var _useTextColors:Boolean = true;
		
		[Bindable("useTextColorsChange")]
		/**
		 * MX components use "textRollOverColor" and "textSelectedColor" while Spark
		 * do not. Set this property to <code>true</code> to use them in tree.
		 */
		public function get useTextColors():Boolean
		{
			return _useTextColors;
		}
		
		public function set useTextColors(value:Boolean):void
		{
			if (_useTextColors == value)
				return;
			
			_useTextColors = value;
			refreshRenderers();
			dispatchEvent(new Event("useTextColorsChange"));
		}
	
		//--------------------------------------------------------------------------
		//
		//  Overriden methods
		//
		//--------------------------------------------------------------------------
		
		override public function updateRenderer(renderer:IVisualElement, itemIndex:int, data:Object):void
		{
			itemIndex = _dataProvider.getItemIndex(data);
			
			super.updateRenderer(renderer, itemIndex, data);
			
			var treeItemRenderer:ITreeItemRenderer = ITreeItemRenderer(renderer);
			treeItemRenderer.level = _dataProvider.getItemLevel(data);
			treeItemRenderer.isBranch = true;
			treeItemRenderer.isLeaf = false;
			treeItemRenderer.hasChildren = dataDescriptor.hasChildren(data);
			treeItemRenderer.isOpen = _dataProvider.isOpen(data);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			// refresh all renderers or only some of them
			var n:int;
			var i:int;
			var renderer:ITreeItemRenderer;
			if (refreshRenderersCalled)
			{
				refreshRenderersCalled = false;
				n = dataGroup.numElements;
				for (i = 0; i < n; i++)
				{
					renderer = dataGroup.getElementAt(i) as ITreeItemRenderer;
					if (renderer && renderer.data)
						updateRenderer(renderer, renderer.itemIndex, renderer.data);
				}
			}
			else if (renderersToRefresh.length > 0)
			{
				n = renderersToRefresh.length;
				for (i = 0; i < n; i++)
				{
					renderer = renderersToRefresh[i];
					if (renderer && renderer.data)
						updateRenderer(renderer, renderer.itemIndex, renderer.data);
				}
			}
			if (renderersToRefresh.length > 0)
				renderersToRefresh.splice(0, renderersToRefresh.length);
		}
		
		/**
		 * Handle <code>Keyboard.LEFT</code> and <code>Keyboard.RIGHT</code> as tree
		 * node collapsing and expanding.
		 */
		override protected function adjustSelectionAndCaretUponNavigation(event:KeyboardEvent):void
		{
			super.adjustSelectionAndCaretUponNavigation(event);
			
			if (!selectedItem)
				return;
			
			var navigationUnit:uint = mapKeycodeForLayoutDirection(event);
			if (navigationUnit == Keyboard.LEFT)
			{
				if (_dataProvider.isOpen(selectedItem))
				{
					expandItem(selectedItem, false);
				}
				else
				{
					var parent:Object = _dataProvider.getItemParent(selectedItem);
					if (parent)
						selectedItem = parent;
				}
			}
			else if (navigationUnit == Keyboard.RIGHT)
			{
				expandItem(selectedItem);
			}
		}
			
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Checks if Spark Tree has it's custom styles defined.
		 */
		protected function hasOwnStyles():Boolean
		{
			return getStyle("disclosureOpenIcon") || 
				getStyle("disclosureClosedIcon") || getStyle("folderOpenIcon") ||
				getStyle("folderClosedIcon") || getStyle("defaultLeafIcon");
		}
		
		public function expandAll():void
		{
			for( var i:int = 0; i < dataProvider.length; i++ ) 
			{
				var item:Object = dataProvider.getItemAt( i );
				if (dataDescriptor.hasChildren(item))
				{
					var children:IList = IList(dataDescriptor.getChildren(item));
						_dataProvider.openBranch(children, item, true);
				}
			}
		}
		
		public function collapseAll():void
		{
			for( var i:int = 0; i < dataProvider.length; i++ ) 
			{
				var item:Object = dataProvider.getItemAt( i );
				if (dataDescriptor.hasChildren(item))
				{
					var children:IList = IList(dataDescriptor.getChildren(item));
					_dataProvider.closeBranch(children, item, true);
				}
			}
		}
		
		public function expandItem(item:Object, open:Boolean = true, cancelable:Boolean = true):void
		{
			if (dataDescriptor.hasChildren(item))
			{
				var children:IList = IList(dataDescriptor.getChildren(item));
				if (open)
					_dataProvider.openBranch(children, item, cancelable);
				else
					_dataProvider.closeBranch(children, item, cancelable);
			}
		}
		
		public function refreshRenderers():void
		{
			refreshRenderersCalled = true;
			invalidateDisplayList();
		}
		
		public function refreshRenderer(renderer:ITreeItemRenderer):void
		{
			renderersToRefresh.push(renderer);
			invalidateDisplayList();
		}
		
		override public function ensureIndexIsVisible(index:int):void
		{
			if (!layout)
				return;
			
			var spDelta:Point = dataGroup.layout.getScrollPositionDeltaToElement(index);
			
			if (spDelta)
			{
				dataGroup.horizontalScrollPosition += spDelta.x;
				dataGroup.verticalScrollPosition += spDelta.y;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overriden event handlers
		//
		//--------------------------------------------------------------------------
	
		override protected function dragDropHandler(event:DragEvent):void
		{
			// list does not take in account that removing an open node while drag
			// can cause list to loose more than 1 element. When element is dropped,
			// to big index can be specified in dataProvider.addItemAt()
			if (_dataProvider)
				_dataProvider.allowIncorrectIndexes = true;
			
			super.dragDropHandler(event);
			
			if (_dataProvider)
				_dataProvider.allowIncorrectIndexes = false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function dataProvider_someHandler(event:TreeEvent):void
		{
			var clonedEvent:TreeEvent = TreeEvent(event.clone());
			if (dataGroup)
			{
				// find corresponding item renderer
				var n:int = dataGroup.numElements;
				for (var i:int = 0; i < n; i++)
				{
					var renderer:ITreeItemRenderer = dataGroup.getElementAt(i) as ITreeItemRenderer;
					if (renderer && renderer.data == event.item)
						clonedEvent.itemRenderer = renderer;
				}
			}
			dispatchEvent(clonedEvent);
			if (clonedEvent.isDefaultPrevented())
				event.preventDefault();
		}
		
	}
}
