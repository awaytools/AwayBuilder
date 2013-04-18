package awaybuilder.model.vo.scene
{
	import away3d.materials.MaterialBase;
	import away3d.materials.lightpickers.LightPickerBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.utils.DefaultMaterialManager;

	[Bindable]
	public class MaterialBaseVO extends AssetVO
	{
		
		public var blendMode:String;
		
		public var repeat:Boolean;
		public var bothSides:Boolean;
		public var extra:Object;
		public var lightPicker:LightPickerVO;
		public var light:LightVO;
		public var mipmap:Boolean;
		public var smooth:Boolean;
		
		public var alphaPremultiplied:Boolean;
		
//		override public function apply():void
//		{
//			super.apply();
//			
//			var m:MaterialBase = linkedObject as MaterialBase;
//			m.repeat = repeat;
//			
//			m.alphaPremultiplied = alphaPremultiplied;
//			
//			m.repeat = repeat;
//			
//			m.bothSides = bothSides;
//			m.extra = extra;
//			
//			// TODO: check why we cannot set null
//			if( lightPicker )
//			{
//				m.lightPicker = lightPicker.linkedObject as LightPickerBase;
//			}
//			
//			m.mipmap = mipmap;
//			m.smooth = smooth;
//			m.blendMode = blendMode;
//		}
		
	}
}
