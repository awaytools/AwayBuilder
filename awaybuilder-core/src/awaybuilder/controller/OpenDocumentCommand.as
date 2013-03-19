package awaybuilder.controller
{
	import flash.utils.setTimeout;
	
	import awaybuilder.services.IDocumentService;
	
	import org.robotlegs.mvcs.Command;
	
	public class OpenDocumentCommand extends Command
	{
		[Inject]
		public var fileService:IDocumentService;
		
		override public function execute():void
		{
			//this hack exists because AIR apparently won't display an open
			//dialog immediately following the closing of another window.
			//weird, I know. 10ms isn't noticeable, so rock on!
//			setTimeout(this.fileService.open, 10);
			this.fileService.open();
		}
	}
}