package awaybuilder.utils
{
	public class ZoomUtil
	{
		private static const ZOOM_PRESETS:Vector.<Number> = new <Number>
		[
			0.25,
			0.33,
			0.5,
			0.67,
			1,
			2,
			3,
			4,
			5
		];
		
		public static function getNextHighestZoomPreset(value:Number):Number
		{
			const presetCount:int = ZOOM_PRESETS.length;
			var presetIndex:int = presetCount - 1;
			for(var i:int = 0; i < presetCount; i++)
			{
				var presetValue:Number = ZOOM_PRESETS[i];
				if((presetValue - 0.01) > value)
				{
					presetIndex = i;
					break;
				}
			}
			
			return ZOOM_PRESETS[presetIndex];
		}
		
		public static function getNextLowestZoomPreset(value:Number):Number
		{
			var presetIndex:int = 0;
			const presetCount:int = ZOOM_PRESETS.length;
			for(var i:int = presetCount - 1; i >= 0; i--)
			{
				var presetValue:Number = ZOOM_PRESETS[i];
				if((presetValue + 0.01) < value)
				{
					presetIndex = i;
					break;
				}
			}
			
			return ZOOM_PRESETS[presetIndex];
		}
	}
}