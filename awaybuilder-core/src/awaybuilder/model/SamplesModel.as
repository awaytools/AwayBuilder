package awaybuilder.model
{
	import mx.collections.ArrayList;
	import mx.collections.IList;
	
	import org.robotlegs.mvcs.Actor;
	
	public class SamplesModel extends Actor
	{	
		public function SamplesModel()
		{
			this.samples = new ArrayList(
			[
				//new SampleItem("name", "description", "fileName.ext", EMBEDDED_IMAGE, EMBEDDED_DATA),
			]);
		}
		
		public var samples:IList;
	}
}