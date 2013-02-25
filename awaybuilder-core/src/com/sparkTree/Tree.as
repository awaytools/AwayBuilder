package com.sparkTree
{
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

import mx.collections.IList;
import mx.controls.treeClasses.DefaultDataDescriptor;
import mx.controls.treeClasses.ITreeDataDescriptor2;
import mx.core.ClassFactory;
import mx.core.FlexGlobals;
import mx.core.IVisualElement;
import mx.core.mx_internal;
import mx.events.DragEvent;
import mx.events.FlexEvent;
import mx.styles.CSSStyleDeclaration;

import spark.components.List;

use namespace mx_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when a branch is closed or collapsed.
 */
[Event(name="itemClose", type="com.sparkTree.TreeEvent")]

/**
 *  Dispatched when a branch is opened or expanded.
 */
[Event(name="itemOpen", type="com.sparkTree.TreeEvent")]

/**
 *  Dispatched when a branch open or close is initiated.
 */
[Event(name="itemOpening", type="com.sparkTree.TreeEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  Specifies the icon that is displayed next to a parent item that is open so that its
 *  children are displayed.
 *
 *  The default value is the "TreeDisclosureOpen" symbol in the Assets.swf file.
 */
[Style(name="disclosureOpenIcon", type="Class", format="EmbeddedFile", inherit="no")]

/**
 *  Specifies the icon that is displayed next to a parent item that is closed so that its
 *  children are not displayed (the subtree is collapsed).
 *
 *  The default value is the "TreeDisclosureClosed" symbol in the Assets.swf file.
 */
[Style(name="disclosureClosedIcon", type="Class", format="EmbeddedFile", inherit="no")]
/**
 * Indentation for each tree level, in pixels. The default value is 17.
 */
[Style(name="indentation", type="Number", inherit="no", theme="spark")]

/**
 *  Specifies the folder open icon for a branch item of the tree.
 */
[Style(name="folderOpenIcon", type="Class", format="EmbeddedFile", inherit="no")]

/**
 *  Specifies the folder closed icon for a branch item of the tree.
 */
[Style(name="folderClosedIcon", type="Class", format="EmbeddedFile", inherit="no")]

/**
 *  Specifies the default icon for a leaf item.
 */
[Style(name="defaultLeafIcon", type="Class", format="EmbeddedFile", inherit="no")]

/**
 *  Color of the text when the user rolls over a row.
 */
[Style(name="textRollOverColor", type="uint", format="Color", inherit="yes")]

/**
 *  Color of the text when the user selects a row.
 */
[Style(name="textSelectedColor", type="uint", format="Color", inherit="yes")]
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
		addEventListener(FlexEvent.PREINITIALIZE, preinitializeHandler);
		
		itemRenderer = new ClassFactory(DefaultTreeItemRenderer);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	[Embed("../../../assets/disclosureOpenIcon.png")]
	private var disclosureOpenIcon:Class;
	
	[Embed("../../../assets/disclosureClosedIcon.png")]
	private var disclosureClosedIcon:Class;
	
	[Embed("../../../assets/folderOpenIcon.png")]
	private var folderOpenIcon:Class;
	
	[Embed("../../../assets/folderClosedIcon.png")]
	private var folderClosedIcon:Class;
	
	[Embed("../../../assets/defaultLeafIcon.png")]
	private var defaultLeafIcon:Class;
	
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
		treeItemRenderer.icon = _iconsVisible ? getIcon(data) : null;
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
	
	public function getIcon(item:Object):Class
	{
		var isBranch:Boolean = dataDescriptor.isBranch(item);
		var isOpen:Boolean = isBranch ? _dataProvider.isOpen(item) : false;
		var icon:Class = getOwnItemIcon(item, isOpen, isBranch);
		if (icon)
			return icon;
		
		if (isBranch)
			icon = getStyle(isOpen ? "folderOpenIcon" : "folderClosedIcon");
		else
			icon = getStyle("defaultLeafIcon");
		return icon;
	}
	
	public function getOwnItemIcon(item:Object, isOpen:* = null, isBranch:* = null):Class
	{
		if (isOpen === null)
			isOpen = _dataProvider.isOpen(item);
		if (isBranch === null)
			isBranch = dataDescriptor.isBranch(item);
		
		var icon:Class;
		if (!icon && _iconFunction != null)
			icon = _iconFunction(item, isOpen, isBranch);
		if (icon)
			return icon;
		
		if (isOpen && _iconOpenField)
			icon = item.hasOwnProperty(_iconOpenField) ? item[_iconOpenField] : null;
		else if (!isOpen && _iconField)
			icon = item.hasOwnProperty(_iconField) ? item[_iconField] : null;
		return icon;
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
	
	protected function preinitializeHandler(event:FlexEvent):void
	{
		var mxTreeDeclaration:CSSStyleDeclaration = 
			FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration("mx.controls.Tree");
		if (hasOwnStyles() || !mxTreeDeclaration) {
			// Initialize styles with some defaults to simplify usage.
			if (!getStyle("indentation"))
				setStyle("indentation", 17);
			if (!getStyle("disclosureOpenIcon"))
				setStyle("disclosureOpenIcon", disclosureOpenIcon);
			if (!getStyle("disclosureClosedIcon"))
				setStyle("disclosureClosedIcon", disclosureClosedIcon);
			if (!getStyle("folderOpenIcon"))
				setStyle("folderOpenIcon", folderOpenIcon);
			if (!getStyle("folderClosedIcon"))
				setStyle("folderClosedIcon", folderClosedIcon);
			if (!getStyle("defaultLeafIcon"))
				setStyle("defaultLeafIcon", defaultLeafIcon);
		} 
		else if (mxTreeDeclaration) // MX Tree may not be used in the application
		{
			setStyle("indentation", mxTreeDeclaration.getStyle("indentation"));
			setStyle("disclosureOpenIcon", mxTreeDeclaration.getStyle("disclosureOpenIcon"));
			setStyle("disclosureClosedIcon", mxTreeDeclaration.getStyle("disclosureClosedIcon"));
			setStyle("folderOpenIcon", mxTreeDeclaration.getStyle("folderOpenIcon"));
			setStyle("folderClosedIcon", mxTreeDeclaration.getStyle("folderClosedIcon"));
			setStyle("defaultLeafIcon", mxTreeDeclaration.getStyle("defaultLeafIcon"));
		}
	}
	
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
