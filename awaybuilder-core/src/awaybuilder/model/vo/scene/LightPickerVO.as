package awaybuilder.model.vo.scene
{
	import away3d.lights.LightBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	
	import awaybuilder.utils.AssetUtil;
	import awaybuilder.utils.DataMerger;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class LightPickerVO extends AssetVO
	{
		
		public var lights:ArrayCollection = new ArrayCollection();
		
//		override public function apply():void
//		{
//			super.apply();
//			var picker:StaticLightPicker = linkedObject as StaticLightPicker;
//			var pickerLights:Array = [];
//			for each( var light:LightVO in lights )
//			{
//				pickerLights.push( light.linkedObject );
//			}
//			picker.lights = pickerLights;
//		}
//		
		public function clone():LightPickerVO
		{
			var vo:LightPickerVO = new LightPickerVO();
			vo.name = this.name;
			vo.lights = new ArrayCollection( this.lights.source.concat() );
			vo.id = this.id;
			return vo;
		}
		
	}
}