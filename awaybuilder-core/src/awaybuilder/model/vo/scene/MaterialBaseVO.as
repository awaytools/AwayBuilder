package awaybuilder.model.vo.scene
{
	import away3d.materials.MaterialBase;
	import away3d.materials.lightpickers.LightPickerBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.utils.DefaultMaterialManager;

	[Bindable]
	public class MaterialBaseVO extends AssetVO
	{
		
		public static const COLOR:String = "colorType";
		public static const TEXTURE:String = "textureType";
		
		public function MaterialBaseVO( item:MaterialBase )
		{
			super( item.name, item );
			if( item == DefaultMaterialManager.getDefaultMaterial() )
			{
				isDefault = true;
				name = item.name = "Away3D Default";
			}
			
			alphaPremultiplied = item.alphaPremultiplied;
			
			repeat = item.repeat;
			
			bothSides = item.bothSides;
			extra = item.extra;
			if( item.lightPicker ) 
			{
				lightPicker = new LightPickerVO(item.lightPicker as StaticLightPicker);
			}
			mipmap = item.mipmap;
			smooth = item.smooth;
			blendMode = item.blendMode;
			
			trace( item.lightPicker );
		}
		
		public var blendMode:String;
		
		public var repeat:Boolean;
		public var bothSides:Boolean;
		public var extra:Object;
		public var lightPicker:LightPickerVO;
		public var mipmap:Boolean;
		public var smooth:Boolean;
		
		public var alphaPremultiplied:Boolean;
		
		override public function apply():void
		{
			super.apply();
			
			var m:MaterialBase = linkedObject as MaterialBase;
			m.repeat = repeat;
			
			m.alphaPremultiplied = alphaPremultiplied;
			
			m.repeat = repeat;
			
			m.bothSides = bothSides;
			m.extra = extra;
			
			// TODO: check why we cannot set null
			if( lightPicker )
			{
				m.lightPicker = lightPicker.linkedObject as LightPickerBase;
			}
			
			m.mipmap = mipmap;
			m.smooth = smooth;
			m.blendMode = blendMode;
		}
		
	}
}
