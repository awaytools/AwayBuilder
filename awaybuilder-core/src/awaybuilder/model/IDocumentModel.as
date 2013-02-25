package awaybuilder.model
{
	import mx.collections.ArrayCollection;

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
		
		function get scenegraph():ArrayCollection;
		function set scenegraph(value:ArrayCollection):void;

//		function addObject(object:IEditorObjectView):void;
//		function removeObject(object:IEditorObjectView):void;

	}
}
