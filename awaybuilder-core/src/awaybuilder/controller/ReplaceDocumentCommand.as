package awaybuilder.controller
{
	import awaybuilder.events.DocumentEvent;
	import awaybuilder.events.ReadDocumentDataEvent;
	import awaybuilder.model.IDocumentModel;
	
	import org.robotlegs.mvcs.Command;

	public class ReplaceDocumentCommand extends Command
	{
		[Inject]
		public var document:IDocumentModel;
		
		[Inject]
		public var event:ReadDocumentDataEvent;
		
		override public function execute():void
		{
			this.dispatch(new DocumentEvent(DocumentEvent.NEW_DOCUMENT));
			this.dispatch(new ReadDocumentDataEvent(ReadDocumentDataEvent.READ_DOCUMENT_DATA, this.event.name, this.event.path));
		}
	}
}