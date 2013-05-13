package awaybuilder.model
{
	import awaybuilder.controller.history.HistoryEvent;
	
	public interface IDocumentService
	{
		function save(data:Object, path:String):void;
		function saveAs(data:Object, defaultName:String):void;
		function open( type:String, event:HistoryEvent ):void;
		
		function openBitmap( items:Array, property:String ):void;
	}
}