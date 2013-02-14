package awaybuilder.view.components
{
	import flash.display.CapsStyle;
	import flash.display.LineScaleMode;
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	[Style(name="gridColor",type="uint")]
	
	//TODO: why [ExcludeClass] ?
	
	public class EditorGrid extends UIComponent
	{
		public function EditorGrid()
		{
			super();
			this.mouseEnabled = this.mouseChildren = false;
		}
		
		private var _gridSize:Number = 10;

		[Bindable("gridSizeChange")]
		public function get gridSize():Number
		{
			return this._gridSize;
		}

		public function set gridSize(value:Number):void
		{
			if(this._gridSize == value)
			{
				return;
			}
			this._gridSize = value;
			this.invalidateDisplayList();
			this.dispatchEvent(new Event("gridSizeChange"));
		}

		private var _xOffset:Number = 0;

		[Bindable("xOffsetChange")]
		public function get xOffset():Number
		{
			return this._xOffset;
		}

		public function set xOffset(value:Number):void
		{
			if(this._xOffset == value)
			{
				return;
			}
			this._xOffset = value;
			this.invalidateDisplayList();
			this.dispatchEvent(new Event("xOffsetChange"));
		}
		
		private var _yOffset:Number = 0;

		[Bindable("yOffsetChange")]
		public function get yOffset():Number
		{
			return this._yOffset;
		}

		public function set yOffset(value:Number):void
		{
			if(this._yOffset == value)
			{
				return;
			}
			this._yOffset = value;
			this.invalidateDisplayList();
			this.dispatchEvent(new Event("yOffsetChange"));
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			this.graphics.clear();
			
			const gridColor:uint = this.getStyle("gridColor");
			this.graphics.lineStyle(0, gridColor, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE);
			
			var start:Number = this._xOffset == 0 ? 0 : (this._gridSize - this._xOffset);
			for(var i:int = -this._xOffset; i <= unscaledWidth; i+= this._gridSize)
			{
				this.graphics.moveTo(i, 0);
				this.graphics.lineTo(i, unscaledHeight);
			}
			start = this._yOffset == 0 ? 0 : (this._gridSize - this._yOffset);
			for(i = -this._yOffset; i <= unscaledHeight; i+= this._gridSize)
			{
				this.graphics.moveTo(0, i);
				this.graphics.lineTo(unscaledWidth, i);
			}
		}
	}
}