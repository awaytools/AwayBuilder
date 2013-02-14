package awaybuilder.model
{
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Actor;

	public class DesktopObjectPickerModel extends Actor implements IObjectPickerModel
	{	
		public static const CUSTOM_CATEGORY_NAME:String = "Custom";
		
		private var _customViewFactories:ArrayList = new ArrayList();
		
		public var categorizedViewFactories:ArrayList = new ArrayList();

		public function replaceCategories(categories:Object):void
		{
			this._customViewFactories.removeAll();
			this.categorizedViewFactories.source = categories as Array;
		}
	}
}
