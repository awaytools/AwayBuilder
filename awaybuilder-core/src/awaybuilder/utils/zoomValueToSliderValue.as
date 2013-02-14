package awaybuilder.utils
{
	public function zoomValueToSliderValue(zoomValue:Number):Number
	{
		if(zoomValue < 1)
		{
			return (zoomValue - 0.25) / 0.75;
		}
		return ((zoomValue - 1) / 4) + 1;
	}
}