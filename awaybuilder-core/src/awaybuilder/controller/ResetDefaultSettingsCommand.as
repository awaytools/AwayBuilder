package awaybuilder.controller
{
	import awaybuilder.model.ISettingsModel;

	import org.robotlegs.mvcs.Command;

	public class ResetDefaultSettingsCommand extends Command
	{
		[Inject]
		public var settings:ISettingsModel;
		
		override public function execute():void
		{
			this.settings.reset();
		}
	}
}