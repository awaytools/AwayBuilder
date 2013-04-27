package awaybuilder.desktop.controller
{
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.WindowModel;
	
	import org.robotlegs.mvcs.Command;
	
	public class CloseDocumentCommand extends Command
	{
		[Inject]
		public var window:AwayBuilderApplication;
		
		[Inject]
		public var windowModel:WindowModel;
		
		[Inject]
		public var documentModel:DocumentModel;
		
		override public function execute():void
		{
			if(this.windowModel.isWaitingForClose)
			{
				this.documentModel.edited = false;
			}
			this.window.close();
		}
	}
}