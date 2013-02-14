package awaybuilder.model
{

	public interface IDocumentModel
	{
		function get name():String;
		function set name(value:String):void;
		function get edited():Boolean;
		function set edited(value:Boolean):void;
		function get suppressEdits():Boolean;
		function set suppressEdits(value:Boolean):void;
		function get path():String;
		function set path(value:String):void;
//		function get objects():Vector.<IEditorObjectView>;

//		function addObject(object:IEditorObjectView):void;
//		function removeObject(object:IEditorObjectView):void;

	}
}
