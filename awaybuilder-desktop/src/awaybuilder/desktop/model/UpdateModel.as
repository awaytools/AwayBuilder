package awaybuilder.desktop.model
{
	import flash.net.SharedObject;
	
	import awaybuilder.utils.logging.AwayBuilderLogger;

	public class UpdateModel
	{
		private static const SHARED_OBJECT_NAME:String = "UpdateModel1";
		private static const MONTH_IN_MILLISECONDS:Number = 86400000 * 30;
		
		public function UpdateModel()
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
		
		public function get isReadyToCheckForUpdate():Boolean
		{
			const now:Number = (new Date()).getTime();
			const lastCheckTime:Number = this.sharedObject.data.lastCheckTime;
			return (now - lastCheckTime) > MONTH_IN_MILLISECONDS;
		}
		
		public function updateLastCheckTime():void
		{
			this.sharedObject.data.lastCheckTime = (new Date()).getTime();
		}
		
		private function initialize():void
		{
			if(this.sharedObject.data.lastCheckTime === undefined)
			{
				this.updateLastCheckTime();
			}
		}
	}
}