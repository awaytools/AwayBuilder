package awaybuilder.desktop.controller
{
	import flash.filesystem.File;
	
	import awaybuilder.desktop.events.OpenFromInvokeEvent;
	import awaybuilder.events.ReadDocumentDataEvent;
	import awaybuilder.model.IDocumentModel;
	
	import org.robotlegs.mvcs.Command;
	
	public class OpenFromInvokeCommand extends Command
	{
		[Inject]
		public var document:IDocumentModel;
		
		[Inject]
		public var event:OpenFromInvokeEvent;
		
		override public function execute():void
		{
			const file:File = event.file;
			this.dispatch(new ReadDocumentDataEvent(ReadDocumentDataEvent.REPLACE_DOCUMENT, file.name, file.nativePath));
		}
	}
}