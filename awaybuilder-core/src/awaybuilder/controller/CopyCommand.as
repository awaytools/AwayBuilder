package awaybuilder.controller
{
	import awaybuilder.controller.events.ClipboardEvent;
	import awaybuilder.model.IDocumentModel;
	
	import org.robotlegs.mvcs.Command;

	public class CopyCommand extends Command
	{
		
		[Inject]
		public var document:IDocumentModel;
		
		[Inject]
		public var event:ClipboardEvent;
		
		override public function execute():void
		{
//			const selectedObjects:Vector.<IEditorObjectView> = this.editor.selectedObjects.concat();
//			if(selectedObjects.length == 0)
//			{
//				return;
//			}
//			const copyXMLData:XML = writeXML(selectedObjects, documentNamespace);
//			const copyData:ByteArray = new ByteArray();
//			copyData.writeUTFBytes(copyXMLData.toXMLString());
//			copyData.deflate();
//			
//			Clipboard.generalClipboard.setData(documentNamespace.uri, copyData);
//			
//			if(event.type == ClipboardEvent.CLIPBOARD_CUT)
//			{
//				this.dispatch(new EditingSurfaceRequestEvent(EditingSurfaceRequestEvent.DELETE_OBJECTS, selectedObjects, true));
//			}
		}
	}
}