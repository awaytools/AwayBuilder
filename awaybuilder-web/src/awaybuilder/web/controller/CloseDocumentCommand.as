package awaybuilder.web.controller
{
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.ApplicationModel;
	
	import org.robotlegs.mvcs.Command;
	
	public class CloseDocumentCommand extends Command
	{
		
		[Inject]
		public var windowModel:ApplicationModel;
		
		[Inject]
		public var documentModel:DocumentModel;
		
		override public function execute():void
		{
//			if(this.windowModel.isWaitingForClose)
//			{
//				this.documentModel.edited = false;
//			}
//			this.window.close();
		}
	}
}