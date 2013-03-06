package awaybuilder.controller
{
	import awaybuilder.model.IDocumentModel;

	import org.robotlegs.mvcs.Command;

	public class PasteCommand extends Command
	{
		
		[Inject]
		public var document:IDocumentModel;
		
		override public function execute():void
		{
//			if(!Clipboard.generalClipboard.hasFormat(documentNamespace.uri))
//			{
//				return;
//			}
//			
//			try
//			{
////				const copyData:ByteArray = ByteArray(Clipboard.generalClipboard.getData(documentNamespace.uri, ClipboardTransferMode.CLONE_PREFERRED));
////				this.dispatch(new ReadDocumentDataEvent(ReadDocumentDataEvent.READ_DOCUMENT_COMPRESSED_DATA, copyData, true));
//			}
//			catch(error:Error)
//			{
//				throw new IllegalOperationError("Unable to paste supported format. " + error.toString());
//			}
		}
	}
}