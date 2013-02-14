package awaybuilder.services
{
	public interface IDocumentService
	{
		function save(data:XML, path:String):void;
		function saveAs(data:XML, defaultName:String):void;
		function open():void;
	}
}