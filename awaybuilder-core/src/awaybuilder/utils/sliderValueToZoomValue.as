package awaybuilder.utils
{
	public function sliderValueToZoomValue(sliderValue:Number):Number
	{
		var zoomValue:Number;
		if(sliderValue < 1)
		{
			zoomValue = 0.25 + 0.75 * sliderValue;
		}
		else
		{
			zoomValue = 1 + 4 * (sliderValue - 1);
		}
		return int(zoomValue * 100) / 100;
	}
}