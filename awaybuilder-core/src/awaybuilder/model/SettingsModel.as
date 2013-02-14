package awaybuilder.model
{
	import flash.net.SharedObject;
	
	import awaybuilder.events.SettingsEvent;
	import awaybuilder.utils.logging.AwayBuilderLogger;
	
	import org.robotlegs.mvcs.Actor;
	
	public class SettingsModel extends Actor implements ISettingsModel
	{
		private static const SHARED_OBJECT_NAME:String = "SettingsModel1";
		
		public function SettingsModel()
		{
			try
			{
				this._sharedObject = SharedObject.getLocal(SHARED_OBJECT_NAME);
			}
			catch(error:Error)
			{
				AwayBuilderLogger.warn("Unable to access local shared object. Creating temporary replacement.");
				this._sharedObject = null;
				this._temporaryFakeSharedObject =
				{
					data: {},
					flush: function():void {},
					clear: function():void
					{
						this.data = {};
					}
				};
			}
			this.initialize();
		}
		
		private var _sharedObject:SharedObject;
		private var _temporaryFakeSharedObject:Object;
		
		private function get sharedObject():Object
		{
			return this._temporaryFakeSharedObject ? this._temporaryFakeSharedObject : this._sharedObject;
		}

		public function get gridSize():int
		{
			return this.sharedObject.data.gridSize;
		}

		public function set gridSize(value:int):void
		{
			if(this.sharedObject.data.gridSize === value)
			{
				return;
			}
			this.sharedObject.data.gridSize = value;
			this.sharedObject.flush();
			this.dispatch(new SettingsEvent(SettingsEvent.GRID_SIZE_CHANGE));
		}

		public function get snapToGrid():Boolean
		{
			return this.sharedObject.data.snapToGrid;
		}

		public function set snapToGrid(value:Boolean):void
		{
			if(this.sharedObject.data.snapToGrid === value)
			{
				return;
			}
			this.sharedObject.data.snapToGrid = value;
			this.sharedObject.flush();
			this.dispatch(new SettingsEvent(SettingsEvent.SNAP_TO_GRID_CHANGE));
		}
		
		public function get showGrid():Boolean
		{
			return this.sharedObject.data.showGrid;
		}
		
		public function set showGrid(value:Boolean):void
		{
			if(this.sharedObject.data.showGrid === value)
			{
				return;
			}
			this.sharedObject.data.showGrid = value;
			this.sharedObject.flush();
			this.dispatch(new SettingsEvent(SettingsEvent.SHOW_GRID_CHANGE));
		}
		
		public function get showSamplesAtStartup():Boolean
		{
			return this.sharedObject.data.showSamplesAtStartup;
		}
		
		public function set showSamplesAtStartup(value:Boolean):void
		{
			if(this.sharedObject.data.showSamplesAtStartup === value)
			{
				return;
			}
			this.sharedObject.data.showSamplesAtStartup = value;
			this.sharedObject.flush();
		}

		public function get showObjectPicker():Boolean
		{
			return this.sharedObject.data.showObjectPicker;
		}

		public function set showObjectPicker(value:Boolean):void
		{
			if(this.sharedObject.data.showObjectPicker === value)
			{
				return;
			}
			this.sharedObject.data.showObjectPicker = value;
			this.sharedObject.flush();
			this.dispatch(new SettingsEvent(SettingsEvent.SHOW_OBJECT_PICKER_CHANGE));
		}
		
		public function reset():void
		{
			this.initialize(true);
			this.dispatch(new SettingsEvent(SettingsEvent.GRID_SIZE_CHANGE));
			this.dispatch(new SettingsEvent(SettingsEvent.SNAP_TO_GRID_CHANGE));
			this.dispatch(new SettingsEvent(SettingsEvent.SHOW_OBJECT_PICKER_CHANGE));
		}
		
		private function initialize(force:Boolean = false):void
		{
			if(force || this.sharedObject.data.gridSize === undefined)
			{
				this.sharedObject.data.gridSize = 15;
			}
			if(force || this.sharedObject.data.snapToGrid === undefined)
			{
				this.sharedObject.data.snapToGrid = false;
			}
			if(force || this.sharedObject.data.showGrid === undefined)
			{
				this.sharedObject.data.showGrid = true;
			}
			if(force || this.sharedObject.data.showSamplesAtStartup === undefined)
			{
				this.sharedObject.data.showSamplesAtStartup = true;
			}
			if(force || this.sharedObject.data.showObjectPicker === undefined)
			{
				this.sharedObject.data.showObjectPicker = true;
			}
			
			this.sharedObject.flush();
		}

	}
}