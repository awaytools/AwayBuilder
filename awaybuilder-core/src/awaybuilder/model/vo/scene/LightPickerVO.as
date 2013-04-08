package awaybuilder.model.vo.scene
{
	import away3d.lights.LightBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	
	import awaybuilder.utils.DataMerger;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class LightPickerVO extends AssetVO
	{
		
		public function LightPickerVO( picker:StaticLightPicker )
		{
			if( !picker.name || (picker.name == "null") ) 
			{
				picker.name = GetUniqueName();
			}
			super( picker.name, picker );
			
			lights = new ArrayCollection();
			for each( var light:LightBase in picker.lights )
			{
				lights.addItem( new LightVO( light ) );
			}
		}
		
		public var lights:ArrayCollection;
		
		override public function apply():void
		{
			super.apply();
			var picker:StaticLightPicker = linkedObject as StaticLightPicker;
			var pickerLights:Array = [];
			for each( var light:LightVO in lights )
			{
				pickerLights.push( light.linkedObject );
			}
			picker.lights = pickerLights;
		}
		
		public function clone():LightPickerVO
		{
			var vo:LightPickerVO = new LightPickerVO( this.linkedObject as StaticLightPicker );
			vo.id = this.id;
			return vo;
		}
		
		private static var count:int = 0;
		private static function GetUniqueName():String
		{
			count++;
			return "Light Picker " + count;
		}
	}
}