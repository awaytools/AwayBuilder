package awaybuilder.model
{
	public interface IEditorModel
	{
//		function get selectedObjects():Vector.<IEditorObjectView>;
//		function set selectedObjects(value:Vector.<IEditorObjectView>):void;

		function get zoom():Number
		function set zoom(value:Number):void;

		function get panX():Number;
		function set panX(value:Number):void;

		function get panY():Number;
		function set panY(value:Number):void;
	}
}
