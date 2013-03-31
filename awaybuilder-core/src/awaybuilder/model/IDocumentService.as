package awaybuilder.model
{
	import awaybuilder.controller.events.ReadDocumentEvent;
	
	public interface IDocumentService
	{
		function save(data:Object, path:String):void;
		function saveAs(data:Object, defaultName:String):void;
		function open( type:String, event:ReadDocumentEvent ):void;
	}
}