package com.sparkTree
{
import flash.display.DisplayObjectContainer;
import flash.events.Event;

import spark.skins.spark.DefaultGridItemRenderer;

public class DefaultADGItemRenderer extends DefaultGridItemRenderer
{
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	public function DefaultADGItemRenderer()
	{
		super();
		
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	private var dataGrid:AdvancedDataGrid;
	
	//--------------------------------------------------------------------------
	//
	//  Overriden properties
	//
	//--------------------------------------------------------------------------
	
	override public function prepare(willBeRecycled:Boolean):void
	{
		super.prepare(willBeRecycled);
		
		if (dataGrid)
			setStyle("color", dataGrid.getTextColor(this));
	}
	
	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------
	
	protected function addedToStageHandler(event:Event):void
	{
		var container:DisplayObjectContainer = owner;
		while (!(container is AdvancedDataGrid) && container)
		{
			container = container.parent;
		}
		dataGrid = AdvancedDataGrid(container);
		prepare(false);
	}
	
}
}