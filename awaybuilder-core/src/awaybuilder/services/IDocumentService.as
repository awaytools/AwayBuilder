package awaybuilder.services
{
	public interface IDocumentService
	{
		function save(data:Object, path:String):void;
		function saveAs(data:Object, defaultName:String):void;
		function open():void;
		function importDocument():void;
	}
}